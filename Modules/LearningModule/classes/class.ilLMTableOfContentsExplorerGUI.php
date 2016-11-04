<?php
/* Copyright (c) 1998-2013 ILIAS open source, Extended GPL, see docs/LICENSE */

include_once("./Modules/LearningModule/classes/class.ilLMTOCExplorerGUI.php");

/**
 * LM presentation (separate toc screen) explorer GUI class
 *
 * @author	Alex Killing <alex.killing@gmx.de>
 * @version	$Id$
 *
 * @ingroup ModulesLearningModule
 */
class ilLMTableOfContentsExplorerGUI extends ilLMTOCExplorerGUI
{
	/**
	 * Constructor
	 *
	 * @param object $a_parent_obj parent gui object
	 * @param string $a_parent_cmd parent cmd
	 * @param ilLMPresentationGUI $a_lm_pres learning module presentation gui object
	 * @param string $a_lang language
	 */
	function __construct($a_parent_obj, $a_parent_cmd, ilLMPresentationGUI $a_lm_pres, $a_lang = "-")
	{
		parent::__construct($a_parent_obj, $a_parent_cmd, $a_lm_pres, $a_lang);
		include_once("./Modules/LearningModule/classes/class.ilLMObject.php");
		$chaps = ilLMObject::_getAllLMObjectsOfLM($this->lm->getId(), $a_type = "st");
		foreach ($chaps as $c)
		{
			$this->setNodeOpen($c);
		}
	}

// fim: [app] new function getOfflineStructure
	/**
	 * Get the content structure of the offline generated lm
	 * @return array
	 */
	public function getOfflineStructure()
	{
		require_once('Services/Object/classes/class.ilObjectTranslation.php');
		$this->translation = ilObjectTranslation::getInstance($this->lm->getId());

		return $this->getOfflineNodes($this->getRootNode());
	}
// fim.

// fim [app] new function getOfflineNodes

	/**
	 * Get an array of node properties for a start node and his childs
	 * @param array 	$a_node		node data
	 * @return array				properties of node and its childs
	 */
	protected function getOfflineNodes($a_node)
	{
		$this->setTypeWhiteList(array('du','st','pg'));
		$this->setTypeBlackList(array());

		$child_data = array();
		$childs = $this->getChildsOfNode($this->getNodeId($a_node));
		foreach($childs as $child)
		{
			$child_data[] = $this->getOfflineNodes($child);
		}

		$data = array();
		$data['id'] = $this->getNodeId($a_node);
		$data['type'] = $this->getOfflineType($a_node);
		$data['title'] = $this->getNodeContent($a_node);
		if ($data['type'] == 'module')
		{
			$languages = $this->translation->getLanguages();
			$data['description'] = (string) $languages[$this->lm_pres->lang]['description'];
			if (empty($data['description']))
			{
				$data['description'] = $this->lm->getDescription();
			}
		}

		if ($data['type'] == 'page')
		{
			$data['href'] = $this->getNodeHref($a_node);

			include_once('Services/COPage/classes/class.ilPCQuestion.php');
			$qlang = $this->lm_pres->lang == $this->translation->getMasterLanguage() ? '-' :  $this->lm_pres->lang;
			$qdata = ilPCQuestion::_getQuestionDataForPage('lm',$data['id'], $qlang);

			$data['questions'] = array();
			foreach ($qdata as $row)
			{
				$question = array();
				$question['id'] = $row['question_id'];
				$question['title'] = $row['title'];
				$question['keywords'] = empty($row['keywords']) ? array() : (array) unserialize($row['keywords']);
				$data['questions'][] = $question;
			}
		}
		else
		{
			if (!empty($childs))
			{
				$data['href'] = $child_data[0]['href'];
			}

			$data['childs'] = $child_data;
		}

		return $data;
	}
// fim.

// fim: [app] new function getOfflineType

	/**
	 * Get the offline type of a node
	 * This translates the short type ids to meaningful names
	 * @param 	array 	$a_node
	 * @return	string
	 */
	protected function getOfflineType($a_node)
	{
		switch ($a_node['type'])
		{
			case 'du': return 'module';
			case 'st': return 'chapter';
			case 'pg': return 'page';
			default: return '';
		}
	}
//fim.
}

?>
