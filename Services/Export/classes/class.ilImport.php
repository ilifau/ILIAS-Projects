<?php
/* Copyright (c) 1998-2009 ILIAS open source, Extended GPL, see docs/LICENSE */

/**
 * Import class
 *
 * @author Alex Killing <alex.killing@gmx.de>
 * @version $Id$
 * @ingroup ServicesExport
 */
class ilImport
{
	protected $install_id = "";
	protected $install_url = "";
	protected $entities = "";

	/**
	 * Constructor
	 *
	 * @param
	 * @return
	 */
	function __construct()
	{
		include_once("./Services/Export/classes/class.ilImportMapping.php");
		$this->mapping = new ilImportMapping();
	}

	/**
	 * Set entity types
	 *
	 * @param	array	entity types
	 */
	final function setEntityTypes($a_val)
	{
		$this->entity_types = $a_val;
	}
	
	/**
	 * Get entity types
	 *
	 * @return	array	entity types
	 */
	final function getEntityTypes()
	{
		return $this->entity_types;
	}
	
	/**
	 * Set currrent dataset
	 *
	 * @param	object	currrent dataset
	 */
	function setCurrentDataset($a_val)
	{
		$this->current_dataset = $a_val;
	}
	
	/**
	 * Get currrent dataset
	 *
	 * @return	object	currrent dataset
	 */
	function getCurrentDataset()
	{
		return $this->current_dataset;
	}
	
	/**
	 * After entity types are parsed
	 */
	function afterEntityTypes()
	{
		$this->getCurrentDataset()->setImport($this);
	}

	/**
	 * After entity types are parsed
	 *
	 * @param
	 */
	function importRecord($a_entity, $a_types, $a_record)
	{
		$this->getCurrentDataset()->importRecord($a_entity, $a_types, $a_record);
	}
	
	
	/**
	 * Import repository object export file
	 *
	 * @param	string		absolute filename of temporary upload file
	 */
	final function importObject($a_new_obj, $a_tmp_file, $a_filename, $a_type)
	{
		global $objDefinition, $tpl;

		$comp = $objDefinition->getComponentForType($a_type);
		$class = $objDefinition->getClassName($a_type);

		$this->comp = $comp;

		// get import class
		$success = true;
		
		// create temporary directory
		$tmpdir = ilUtil::ilTempnam();
		ilUtil::makeDir($tmpdir);

		// move import file into temporary directory
//$a_filename = basename($a_tmp_file);
//copy($a_tmp_file, $tmpdir."/".$a_filename);
		ilUtil::moveUploadedFile($a_tmp_file, $a_filename, $tmpdir."/".$a_filename);

		// unzip file
		ilUtil::unzip($tmpdir."/".$a_filename);
		$dir = $tmpdir."/".substr($a_filename, 0, strlen($a_filename) - 4);

		// process manifest file
		include_once("./Services/Export/classes/class.ilManifestParser.php");
		$parser = new ilManifestParser($dir."/manifest.xml");
		$this->mapping->setInstallUrl($parser->getInstallUrl());
		$this->mapping->setInstallId($parser->getInstallId());

		// process export files
		$expfiles = $parser->getExportFiles();
		include_once("./Services/Export/classes/class.ilExportFileParser.php");
		$all_components = array();
		foreach ($expfiles as $expfile)
		{
			$comp = $expfile["component"];
			$all_components[$comp] = $comp;
			$comp_arr = explode("/", $comp);
			$import_class_file = "./".$comp."/classes/class.il".$comp_arr[1]."Importer.php";
			$class = "il".$comp_arr[1]."Importer";
			include_once($import_class_file);
			$this->importer = new $class();
			$this->importer->setImportDirectory($dir);
			$this->importer->init();

			$parser = new ilExportFileParser($dir."/".$expfile["path"],
				$this, "processItemXml");
		}

		// final processing
		foreach ($all_components as $c)
		{
			$comp_arr = explode("/", $c);
			$import_class_file = "./".$c."/classes/class.il".$comp_arr[1]."Importer.php";
			$class = "il".$comp_arr[1]."Importer";
			include_once($import_class_file);
			$this->importer = new $class();
			$this->importer->setImportDirectory($dir);
			$this->importer->init();
			$this->importer->finalProcessing($this->mapping);
		}


		// we should only get on mapping here
		$top_mapping = $this->mapping->getMappingsOfEntity($this->comp, $a_type);
		$new_id = (int) current($top_mapping);
		// delete temporary directory
		ilUtil::delDir($tmpdir);
//echo "end of ilImport::importObject()."; exit;
		return $new_id;
	}

	/**
	 * Process item xml
	 *
	 * @param
	 * @return
	 */
	function processItemXml($a_entity, $a_schema_version, $a_id, $a_xml,
		$a_install_id, $a_install_url)
	{
		$this->importer->setInstallId($a_install_id);
		$this->importer->setInstallUrl($a_install_url);
		$this->importer->setSchemaVersion($a_schema_version);

		$new_id = $this->importer->importXmlRepresentation($a_entity, $a_id, $a_xml, $this->mapping);
		if ($new_id != "")
		{
			$this->mapping->addMapping($this->comp ,$a_entity, $a_id, $new_id);
		}
	}
	
}
?>