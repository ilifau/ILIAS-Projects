<#1>
<?php
/**
 * fim: [badges] add keywords to test questions
 */
if( !$ilDB->tableColumnExists('qpl_questions', 'keywords'))
{
    $ilDB->addTableColumn('qpl_questions', 'keywords',
        array('type' => 'text', 'length' => 4000, 'notnull'	=> false, 'default'	=> null)
    );
}
?>