<?php
/**
 * Copyright (c) 2015 Institut fuer Lern-Innovation, Friedrich-Alexander-Universitaet Erlangen-Nuernberg
 * GPLv3, see docs/LICENSE
 */

/**
 * service endpoint for SenApp app
 *
 * @author Fred Neumann <fred.neumann@fau.de>
 * @version $Id$
 */

include_once "Services/Context/classes/class.ilContext.php";
ilContext::init(ilContext::CONTEXT_RSS_AUTH);

require_once("Services/Init/classes/class.ilInitialisation.php");
ilInitialisation::initILIAS();

require_once("Customizing/classes/class.ilAppService.php");
$service = new ilAppService;
$service->handleRequest();
?>
