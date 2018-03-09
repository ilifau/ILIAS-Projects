<?php
// fim: [app] service for retrieving app contents.

/**
 * Copyright (c) 2015 Institut fuer Lern-Innovation, Friedrich-Alexander-Universitaet Erlangen-Nuernberg
 * GPLv3, see docs/LICENSE
 */

/**
 * Server for external App
 *
 * @author Fred Neumann <fred.neumann@fau.de>
 * @version $Id$
 */
class ilAppService
{
	const ERROR_BAD_REQUEST = 400;
	const ERROR_UNAUTHORIZED = 401;
	const ERROR_FORBIDDEN = 403;
	const ERROR_NOT_FOUND = 404;
	const ERROR_INTERNAL = 500;
	const ERROR_NOT_IMPLEMENTED = 501;

	/** @var array request data */
	protected $request = array();

	/** @var ilObjUser */
	protected $userObj = null;

    /**
    * Handle an incoming request
    */
    public function handleRequest()
    {
		$this->readRequestParams();

		//only for development!!
		$this->logRequest();
		
        try
        {
            if (!$this->initUser($this->request['username'], $this->request['password']))
			{
				$this->respondFailure(self::ERROR_UNAUTHORIZED);
				return;
            }

			if (!$this->userObj->getActive())
			{
				$this->respondFailure(self::ERROR_FORBIDDEN);
				return;
			}

            switch($cmd = $this->request['command'])
            {
                case 'getModules':
				case 'getModuleContents':
				case 'getForums':
                    $this->$cmd();
                    break;

                default:
                    $this->respondFailure(self::ERROR_NOT_IMPLEMENTED);
                    break;
            }
        }
        catch (Exception $exception)
        {
            $this->respondFailure(self::ERROR_INTERNAL, $exception->getMessage());
        }
    }

	/**
	 * Read the request params either from POST or from json input
	 */
	protected function readRequestParams()
	{
		$this->request = array();

		if (!empty($_POST))
		{
			$this->request = $_POST;
			return;
		}

		$json = json_decode(file_get_contents('php://input'), true);
		if (isset($json))
		{
			$this->request = $json;
			return;
		}
	}


	/**
	 * Initialize the user object
	 *
	 * @param string	$username
	 * @param string	$password
	 * @return bool		user is found and authentified
	 */
	protected function initUser($username, $password)
	{
		require_once 'Services/User/classes/class.ilObjUser.php';
		if (!($user_id = ilObjUser::_loginExists($username)))
		{
			return false;
		}
		$this->userObj = new ilObjUser($user_id);

		require_once 'Services/User/classes/class.ilUserPasswordManager.php';
		return ilUserPasswordManager::getInstance()->verifyPassword($this->userObj, $password);
	}

	/**
	 * Get the readable learning modules
	 */
	protected function getModules()
	{
		global $ilAccess, $tree;

		require_once('Modules/LearningModule/classes/class.ilObjLearningModule.php');
		require_once('Services/Object/classes/class.ilObjectTranslation.php');

		$root_id = 1;
		require_once 'Services/User/classes/class.ilUserUtil.php';
		if (ilUserUtil::getPersonalStartingPoint($this->userObj) == ilUserUtil::START_REPOSITORY_OBJ)
		{
			$root_id = ilUserUtil::getPersonalStartingObject($this->userObj);
		}

		$modules = array();
		$root_node = $tree->getNodeData($root_id);
		$nodes = $tree->getSubTree($root_node, true, $a_type = array('lm', 'htlm'));
		foreach ($nodes as $node)
		{
			if ($ilAccess->checkAccessOfUser($this->userObj->getId(), 'read', '', $node['child'], $node['type'], $node['obj_id'], $tree->getTreeId()))
			{
				if ($node['type'] == 'lm' and !$this->checkIliasModuleOfflinePublished($node['obj_id']))
				{
					continue;
				}

				$icon = ilObject::_getIcon($node['obj_id'],'big',$node['type'], false);
				if (substr($icon,0,1) == '.')
				{
					$icon= substr($icon,1);
				}

				switch ($node['type'])
				{
					case 'lm':
						$ot = ilObjectTranslation::getInstance($node['obj_id']);
						$basedir = $this->getIliasModuleOfflineDirectory($node['obj_id']);
						$data = $this->getIliasModuleData($node['child'], $ot);
						$preview_image = ilObjLearningModule::getPreviewImageUrl($node['obj_id']);
						break;
					case 'htlm':
						$basedir = $this->getHtmlModuleOfflineDirectory($node['obj_id']);
						$data = array(
							'titles' => array('en' => $node['title']),
							'descriptions' => array('en' => $node['description'])
						);
						$preview_image = "";
				}
				$files = $this->getWebspaceContents($basedir);
				$sizes = $this->getFileSizes($basedir,$files);
				$total = array_sum($sizes) / 1000000;

				$time = $this->getModuleLastUpdate($node['obj_id'], $node['type']);
				$modules[] = array(
					'id' => $node['child'],
					'type' => $node['type'] == 'lm' ? 'ilias' : 'html',
					'title' => $data['titles'],
					'description' => $data['descriptions'],
					'icon' => ILIAS_HTTP_PATH . $icon,
					'time' => $time->get(IL_CAL_DATETIME),
					'timestamp' => $time->get(IL_CAL_UNIX),
					'size' => sprintf('%.2f MB',$total),
					'preview_image' => $preview_image
				);
			}
		}

		$this->respondSuccess(array('modules' => $modules));
	}

	/**
	 * Get the contents of a learning module
	 */
	protected function getModuleContents()
	{
		global $ilAccess;

		$ref_id = $this->request['id'];
		$type = ilObject::_lookupType($ref_id, true);

		if (!in_array($type, array('lm','htlm')) or ilObject::_isInTrash($ref_id))
		{
			$this->respondFailure(self::ERROR_NOT_FOUND);
			return false;
		}

		if (!$ilAccess->checkAccessOfUser($this->userObj->getId(), 'read', '', $ref_id))
		{
			$this->respondFailure(self::ERROR_FORBIDDEN);
			return false;
		}

		switch ($type)
		{
			case 'lm':
				return $this->getIliasModuleOfflineContents($ref_id);
			case 'htlm':
				return $this->getHtmlModuleContents($ref_id);
		}
	}

	/**
	 * Get the timestamp of the module's last update
	 * @param integer	$a_obj_id
	 * @param string	$a_type
	 * @return ilDateTime
	 */
	protected function getModuleLastUpdate($a_obj_id, $a_type)
	{
		if ($a_type == 'lm')
		{
			return new ilDateTime(filemtime($this->getIliasModuleOfflineDirectory($a_obj_id)."/structure.json"), IL_CAL_UNIX);
		}
		else
		{
			return new ilDateTime(ilObject::_lookupLastUpdate($a_obj_id), IL_CAL_DATETIME);
		}
	}

	/**
	 * Get the translated titles of the ILIAS learning module
	 * @param int $ref_id
	 * @param ilObjectTranslation $ot
	 * @return array
	 */
	protected function getIliasModuleData($ref_id, $ot)
	{
		global $ilUser;

		$old_lang = $ilUser->getLanguage();

		$ot_langs = $ot->getLanguages();
		$titles = array();
		$descriptions = array();
		foreach ($ot_langs as $otl)
		{
			$lang = $otl["lang_code"];
			$ilUser->setLanguage($lang);
			$ilUser->setCurrentLanguage($lang);

			$lm = new ilObjLearningModule($ref_id, true);
			$titles[$lang] = $lm->getTitle();
			$descriptions[$lang] = $lm->getDescription();
		}

		$ilUser->setLanguage($old_lang);
		$ilUser->setCurrentLanguage($old_lang);

		return array('titles' => $titles, 'descriptions' => $descriptions);
	}

	/**
	 * Check if an ILIAS module has offline files published
	 * @param	integer	$a_obj_id;
	 * @return 	boolean
	 */
	protected function checkIliasModuleOfflinePublished($a_obj_id)
	{
		return file_exists($this->getIliasModuleOfflineDirectory($a_obj_id)."/structure.json");
	}

	/**
	 * Get the offline directory of an Ilias learning module (may not exist)
	 * @param integer 	$a_obj_id
	 * @return string
	 */
	protected function getIliasModuleOfflineDirectory($a_obj_id)
	{
		return ilUtil::getWebspaceDir()."/lm_data/lm_$a_obj_id/export_app/lm_$a_obj_id";
	}

	/**
	 * Get the offline directory of an HTML learning module
	 * @param integer 	$a_obj_id
	 * @return string
	 */
	protected function getHtmlModuleOfflineDirectory($a_obj_id)
	{
		return ilUtil::getWebspaceDir()."/lm_data/lm_$a_obj_id";
	}


	/**
	 * Get the offline contents of an ILIAS learning module
	 */
	protected function getIliasModuleOfflineContents($a_ref_id)
	{
		$obj_id = ilObject::_lookupObjId($a_ref_id);
		$dir = $this->getIliasModuleOfflineDirectory($obj_id);

		$structure = (array) json_decode(file_get_contents($dir.'/structure.json'));

		$contents = $this->getWebspaceContents($dir);
		$sizes = $this->getFileSizes(ILIAS_ABSOLUTE_PATH.substr($dir, 1), $contents);

		$this->respondSuccess(array(
			'basedir'=> ILIAS_HTTP_PATH . substr($dir, 1), // '.' removed
			'startpage'=> $structure['href'],
			'total_size' => array_sum($sizes),
			'contents'=> $this->getWebspaceContents($dir),
			'structure' => $structure,
			'sizes' => $sizes
		));
		return true;
	}

	/**
	 * Get the contents of an html learning module
	 */
	protected function getHtmlModuleContents($a_ref_id)
	{
		$modObj = ilObjectFactory::getInstanceByRefId($a_ref_id);
		$dir = $modObj->getDataDirectory();

		if (is_file($dir.'/structure.json'))
		{
			$structure = (array) json_decode(file_get_contents($dir.'/structure.json'));
		}
		else
		{
			$structure = array(
				'id' => 1,
				'type' => 'module',
				'title' => $modObj->getTitle(),
				'href' => $modObj->getStartFile(),
				'childs' => array()
			);

			file_put_contents($dir.'/structure.json', json_encode($structure, JSON_PRETTY_PRINT));
		}

		$contents = $this->getWebspaceContents($dir);
		$sizes = $this->getFileSizes(ILIAS_ABSOLUTE_PATH.substr($dir, 1), $contents);

		$this->respondSuccess(array(
			'basedir'=> ILIAS_HTTP_PATH . substr($dir, 1), // '.' removed
			'startpage'=> $modObj->getStartFile(),
			'total_size' => array_sum($sizes),
			'contents'=> $this->getWebspaceContents($dir),
			'structure' => $structure,
			'sizes' => $sizes
		));
		return true;
	}

	/**
	 * Get the contents of a web space directory
	 * @param 	string		$a_path		url path relative to ILIAS base directory
	 * @return	array					list of files with relative url paths
	 */
	protected function getWebspaceContents($a_path)
	{
		$contents = array();
		$list = ilUtil::rList($a_path, '');
		foreach ($list as $file)
		{
			$parts = pathinfo($file);
			if (strtolower($parts['extension']) != 'zip')
			{
				$contents[] = $file;
			}
		}
		return $contents;
	}

	/**
	 * Get the file sizes of the web space contents
	 * @param string	$a_basedir	absolute path ob base dir
	 * @param array		$a_files	list of files with relative url paths
	 * @return array				file => size (bytes)
	 */
	protected function getFileSizes($a_basedir, $a_files)
	{
		$sizes = array();
		foreach ($a_files as $file)
		{
			$sizes[$file] = filesize($a_basedir.'/'.$file);
		}

		arsort($sizes);
		return $sizes;
	}

	/**
	 * Get a link to the course forum
	 */
	protected function getForums()
	{
		global $ilAccess, $tree;

		$root_id = 1;
		require_once 'Services/User/classes/class.ilUserUtil.php';
		if (ilUserUtil::getPersonalStartingPoint($this->userObj) == ilUserUtil::START_REPOSITORY_OBJ)
		{
			$root_id = ilUserUtil::getPersonalStartingObject($this->userObj);
		}

		$forums = array();
		$root_node = $tree->getNodeData($root_id);
		$nodes = $tree->getSubTree($root_node, true, $a_type = 'frm');
		foreach ($nodes as $node)
		{
			if ($ilAccess->checkAccessOfUser($this->userObj->getId(), 'read', '', $node['child'], $node['type'], $node['obj_id'], $tree->getTreeId()))
			{
				$icon = ilObject::_getIcon($node['obj_id'],'big',$node['type'], false);
				if (substr($icon,0,1) == '.')
				{
					$icon= substr($icon,1);
				}
				$forums[] = array(
					'id' => $node['child'],
					'title' => $node['title'],
					'description' => $node['description'],
					'icon' => ILIAS_HTTP_PATH.$icon,
					'link' =>  ILIAS_HTTP_PATH.'/login.php?target=frm_'.$node['child'].'&username='.urlencode($this->request['username']).'&password='.urlencode($this->request['password'])
				);
			}
		}

		$this->respondSuccess(array('forums' => $forums));
	}


	/**
	 * Send a successful response
	 *
	 * @param array	response data
	 */
	protected function respondSuccess($data)
	{
		$data['success'] = true;
		echo json_encode($data);
	}


    /**
     * Send a failure response
     * @param string  response message
     */
    protected function respondFailure($error, $message = null)
    {
        switch ($error)
        {
            case self::ERROR_BAD_REQUEST: $text = 'Bad Request'; break;
            case self::ERROR_UNAUTHORIZED: $text = 'Unauthorized'; break;
            case self::ERROR_FORBIDDEN: $text = 'Forbidden'; break;
            case self::ERROR_NOT_FOUND: $text = 'Not Found'; break;
            case self::ERROR_NOT_IMPLEMENTED: $text = 'Not Implemented'; break;
			case self::ERROR_INTERNAL: default: $text = 'Internal Server Error'; break;
        }

		$data = array(
			'success' => false,
			'error' => $error,
			'message' => isset($message) ? $message : $text
		);

		echo json_encode($data);
    }

	/**
	 * Log the data of the last request (only for testing purposes)
	 */
	protected function logRequest()
	{
		$logfile = 'data/'.CLIENT_ID.'/applog.html';

		$log = "<pre>\n";
		$log .='Get Parameters='. print_r($_GET,true)."\n";
		$log .='Request data:'.print_r($this->request, true)."\n";
		$log .='Cookies:'. print_r($_COOKIE,true)."\n";
		$log .= '</pre>';

		file_put_contents($logfile, $log);
	}
}
