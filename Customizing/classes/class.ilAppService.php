<?php
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

	/**
	 * @var ilObjUser
	 */
	protected $userObj = null;

    /**
    * Handle an incoming request
    */
    public function handleRequest()
    {
        try
        {
            if (!$this->initUser($_POST['username'], $_POST['password']))
			{
				$this->respondFailure(self::ERROR_UNAUTHORIZED);
				return;
            }

			if (!$this->userObj->getActive())
			{
				$this->respondFailure(self::ERROR_FORBIDDEN);
				return;
			}

            switch($cmd = $_POST['command'])
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

		$root_id = 1;
		require_once 'Services/User/classes/class.ilUserUtil.php';
		if (ilUserUtil::getPersonalStartingPoint($this->userObj) == ilUserUtil::START_REPOSITORY_OBJ)
		{
			$root_id = ilUserUtil::getPersonalStartingObject($this->userObj);
		}

		$modules = array();
		$root_node = $tree->getNodeData($root_id);
		$nodes = $tree->getSubTree($root_node, true, $a_type = 'htlm');
		foreach ($nodes as $node)
		{
			if ($ilAccess->checkAccessOfUser($this->userObj->getId(), 'read', '', $node['child'], $node['type'], $node['obj_id'], $tree->getTreeId()))
			{
				$icon = ilObject::_getIcon($node['obj_id'],'big',$node['type'], false);
				if (substr($icon,0,1) == '.')
				{
					$icon= substr($icon,1);
				}
				$modules[] = array(
					'id' => $node['child'],
					'title' => $node['title'],
					'description' => $node['description'],
					'icon' => ILIAS_HTTP_PATH.$icon
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

		$ref_id = $_POST['id'];
		if (ilObject::_lookupType($ref_id, true) != 'htlm' or ilObject::_isInTrash($ref_id))
		{
			$this->respondFailure(self::ERROR_NOT_FOUND);
			return;
		}

		if (!$ilAccess->checkAccessOfUser($this->userObj->getId(), 'read', '', $ref_id))
		{
			$this->respondFailure(self::ERROR_FORBIDDEN);
			return;
		}

		$modObj = ilObjectFactory::getInstanceByRefId($ref_id);

		$contents = array();
		$list = ilUtil::rList($modObj->getDataDirectory(), '');
		foreach ($list as $file)
		{
			$parts = pathinfo($file);
			if (strtolower($parts['extension']) != 'zip')
			{
				$contents[] = $file;
			}
		}

		$datadir = $modObj->getDataDirectory();
		if (substr($datadir,0,1) == '.')
		{
			$datadir= substr($datadir,1);
		}
		$this->respondSuccess(array(
			'basedir'=> ILIAS_HTTP_PATH.$datadir,
			'startpage'=> $modObj->getStartFile(),
			'contents'=> $contents
		));

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
					'link' =>  ILIAS_HTTP_PATH.'/login.php?target=frm_'.$node['child'].'&username='.urlencode($_POST['username']).'&password='.urlencode($_POST['password'])
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
}
