<?php
/* Copyright (c) 1998-2009 ILIAS open source, Extended GPL, see docs/LICENSE */

/**
* ilias.php. main script.
*
* If you want to use this script your base class must be declared
* within modules.xml.
*
* @author Alex Killing <alex.killing@gmx.de>
* @version $Id$
*
*/

require_once("Services/Init/classes/class.ilInitialisation.php");
ilInitialisation::initILIAS();

global $ilCtrl, $ilBench;

// fim: [webapp] remember GET requests for web app restart
//	if ($_SERVER['REQUEST_METHOD'] == "GET")
//	{
//		if (!empty($_GET['ref_id']))
//		{
//			if (ilObject::_lookupType($_GET['ref_id'], true) !== 'htlm')
//			{
//				$_SESSION['senapp.lastRequest'] = $_SERVER['PHP_SELF'].'?'.$_SERVER['QUERY_STRING'];
//			}
//		}
//	}
// fim.

$ilCtrl->setTargetScript("ilias.php");
$ilCtrl->callBaseClass();
$ilBench->save();

?>
