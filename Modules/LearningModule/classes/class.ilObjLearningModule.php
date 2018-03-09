<?php

/* Copyright (c) 1998-2011 ILIAS open source, Extended GPL, see docs/LICENSE */

require_once("./Modules/LearningModule/classes/class.ilObjContentObject.php");

/**
* Class ilObjLearningModule
*
* @author Alex Killing <alex.killing@gmx.de>
* @version $Id$
*
* @ingroup ModulesIliasLearningModule
*/
class ilObjLearningModule extends ilObjContentObject
{

	/**
	* Constructor
	* @access	public
	*/
	function ilObjLearningModule($a_id = 0,$a_call_by_reference = true)
	{
		$this->type = "lm";
		parent::ilObjContentObject($a_id, $a_call_by_reference);
	}

// fim: [app] functions for preview image
	/**
	 * Get the preview image directory
	 * @param $obj_id
	 * @return string
	 */
	public static function getPreviewImageDirectory($obj_id)
	{
		require_once('Services/Utilities/classes/class.ilUtil.php');
		return ilUtil::getWebspaceDir()."/lm_data/lm_" .$obj_id;
	}


	/**
	 * Get the path of a preview image file
	 */
	public static function getPreviewImageFile($obj_id)
	{
		$directory = self::getPreviewImageDirectory($obj_id);
		foreach (glob($directory . '/preview.*') as $file)
		{
			return $file;
		}

		return "";
	}

	/**
	 * Get the URL of a preview image fine
	 */
	public static function getPreviewImageUrl($obj_id)
	{
		$directory = self::getPreviewImageDirectory($obj_id);
		foreach (glob($directory . '/preview.*') as $file)
		{
			return ILIAS_HTTP_PATH . '/data/'. CLIENT_ID . '/lm_data/lm_'. $obj_id .'/'. basename($file);
		}

		return "";
	}

	/**
	 * Delete the preview image(s) of a learning module
	 * @param $obj_id
	 */
	public static function deletePreviewImage($obj_id)
	{
		$directory = self::getPreviewImageDirectory($obj_id);
		foreach (glob($directory . '/preview.*') as $file)
		{
			@unlink($file);
		}
	}
// fim.
}

?>
