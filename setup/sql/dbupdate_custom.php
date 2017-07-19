<#1>
<?php
/**
 * fau: regCodes - extend the settings of registration codes.
 */
if( !$ilDB->tableColumnExists('reg_registration_codes', 'title'))
{
    $ilDB->addTableColumn('reg_registration_codes', 'title',
        array('type' => 'text', 'length' => 250, 'notnull'	=> false, 'default'	=> null)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'description',
        array('type' => 'text', 'length' => 4000, 'notnull'	=> false, 'default'	=> null)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'use_limit',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 1)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'use_count',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 0)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'login_generation_type',
        array('type' => 'text', 'length' => 20, 'notnull' => true, 'default' => 'guestlistener')
    );
    $ilDB->addTableColumn('reg_registration_codes', 'password_generation',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 0)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'captcha_required',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 0)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'email_verification',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 0)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'email_verification_time',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 600)
    );
    $ilDB->addTableColumn('reg_registration_codes', 'notification_users',
        array('type' => 'text', 'length' => 250, 'notnull' => false, 'default' => null)
    );
}
?>

<#2>
<?php
if( $ilDB->tableColumnExists('reg_registration_codes', 'title')) {
    $ilDB->addTableColumn('reg_registration_codes', 'code_startref',
        array('type' => 'integer', 'length' => 4, 'notnull' => true, 'default' => 600)
    );
}
?>