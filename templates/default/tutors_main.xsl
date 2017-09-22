<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
    <xsl:output method="html" version="4.0" encoding="UTF-8"/>

    <!-- Variables -->
    <xsl:variable name="skinDirectory" select="php:function('ilSkinTransformer::getSkinDirectory','')" />

    <!--  Basic rule: copy everything not specified and process the childs -->
    <xsl:template match="@*|node()">
        <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
    </xsl:template>

    <!--
           Main transformations
    -->

    <!-- Webapp style with zoom -->
    <!--
    <xsl:template match="meta[@name='viewport']">
        <meta name="viewport" content="initial-scale=500, user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    </xsl:template>
    -->

    <!-- remove scroll  -->
    <xsl:template match="body[@class='std']" >
        <xsl:copy>
            <xsl:attribute name="style">height: 0;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- PNG logo in the top bar -->
    <xsl:template match="div[@id='ilTopBar']//div[@class='row']" >
        <xsl:copy>
            <xsl:attribute name="style">border-bottom: 5px solid #F59C00; margin-bottom: 5px; </xsl:attribute>
            <xsl:apply-templates select="@*" />
            <div class="ilTopTitle" style="height: 100px">
                <a onClick="window.location='index.php?';return false;">
                    <img alt="Logo" src="templates/default/images-custom/HeaderIcon.svg" height="100%"/>
                </a>
            </div>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>


    <!-- "Back" and "Overview" button beneath the user drop down -->
    <xsl:template match="ul[@id='ilTopBarNav']" >
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <!-- if user is logged in -->
            <xsl:if test="li[@id='userlog']">
                <li>
                    <a onclick="history.back();return false;">
                          &#9664;
                    </a>
                </li>
                <li>
                    <a onclick="window.location='index.php?';return false;">
                        <!--  <xsl:value-of select="php:function('ilSkinTransformer::getTxt','content')" />
                      -->
                        <span style="font-weight: bold;">
                            Übersicht
                        </span>
                    </a>
                </li>
                <!-- Nonsense for multiple courses
                <li>
                    <a onclick="window.location='index.php?';return false;">
                        <xsl:value-of select="php:function('ilSkinTransformer::getTxt','forum')" />
                    </a>
                </li>
                -->
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide right col on overview startpage -->
    <xsl:template match="div[@id='il_right_col']" />

    <!-- hide course and group memberships settings
    <xsl:template match="button[@id='ilAdvSelListAnchorText_block_dd_pditems_0']" />
    -->

    <!-- adjust buttons in personal profile -->
    <xsl:template match="span[@class='input-group-btn']" >
        <xsl:copy>
            <xsl:attribute name="style">padding-right: 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide email function in upper bar and some more things...-->
    <!-- <xsl:template match="ul[@id='ilTopBarNav']/li[1]" /> -->
    <!-- <xsl:template match="li[@id='tab_fold']" /> -->
    <xsl:template match="li[@id='tab_mail_addressbook']" />
    <!-- <xsl:template match="li[@id='tab_options']" />
    <xsl:template match="div[@id='il_prop_cont_m_type____']" /> -->
    <!-- <xsl:template match="div[@class='container-fluid']" /> -->
    <!-- shows mailentry; delete in Mailsettings user ticks or profile gets lost by "/li[1]" -->

    <!-- No main header, no main menu
    <xsl:template match="nav[@id='ilTopNav']" /> -->
    <xsl:template match="div[contains(@class,'ilMainMenu')]" />
    <xsl:template match="div[contains(@class,'ilMainHeader')]" >
        <xsl:copy>
            <xsl:attribute name="style">background-color: #F0F0F0;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- Empty headline (keep space) -->
    <xsl:template match="div[contains(@class,'media il_HeaderInner')]/div[@id='il_head_action']" />
    <xsl:template match="div[contains(@class,'media il_HeaderInner')]/img" />
    <xsl:template match="div[contains(@class,'media il_HeaderInner')]/div[@class='media-body']" />
    <xsl:template match="div[contains(@class,'media il_HeaderInner')]/h1" >
        <xsl:copy>
            <xsl:attribute name="style">text-align: center;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- No locator, No tree view -->
    <xsl:template match="ol[@class='breadcrumb hidden-print']" />
    <!--<xsl:template match="a[@class='ilTreeView']" /> -->
    <xsl:template match="a[@id='imgtree']"/>
    <xsl:template match="div[@id='left_nav']" />

    <!-- Hide some tabs menus completely, identified by one tab -->
    <xsl:template match="ul[./li/@id='tab_personal_data']" />
    <xsl:template match="ul[./li/@id='tab_password']" />
    <xsl:template match="ul[./li/@id='tab_info_short']" />

    <!-- Adjust menu of learning modules -->
    <xsl:template match="li[@id='subtab_content']" />
    <xsl:template match="li[@id='subtab_cont_print_view']" />
    <xsl:template match="li[@id='subtab_info_short']" />

    <!-- adjust menu of course -->
    <xsl:template match="li[@id='subtab_view_content']" />
    <xsl:template match="li[@id='subtab_manage']" />
    <xsl:template match="li[@id='subtab_ordering']" />
    <!--<xsl:template match="li[@id='subtab_crs_member_administration']" />
    --><xsl:template match="li[@id='subtab_crs_members_groups']" />

    <!-- hide survey container, especially heading
    <xsl:template match="div[@id='bl_cntr_4']" />
    -->

    <!-- Show "ilTab" and hide some not needed -->
    <xsl:template match="ul[@id='ilTab']">
        <xsl:copy>
            <xsl:attribute name="style">border: 0px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="li[@id='tab_view_content']" />
    <xsl:template match="li[@id='tab_info_short']" />
    <xsl:template match="li[@id='tab_settings']" />
    <xsl:template match="li[@id='tab_meta_data']" />
    <xsl:template match="li[@id='tab_export']" />
    <xsl:template match="li[@id='tab_crs_unsubscribe']" />
    <xsl:template match="li[@id='nontab_members_view']" />

    <xsl:template match="div[@class='ilNewObjectSelector']" />

    <!-- change member view for tutors-->
    <xsl:template match="form[contains(@action,'ilrepositorysearchgui')]" />
    <xsl:template match="form[contains(@action,'ilobjcoursegui')]/div[@class='ilTableOuter'][1]" />
    <xsl:template match="form[contains(@action,'ilobjcoursegui')]/div[@class='ilTableHeaderTitle'][1]" />
    <xsl:template match="form[contains(@action,'ilobjcoursegui')]/div[@class='ilTableNav'][1]" />
    <xsl:template match="form[contains(@action,'ilobjcoursegui')]/div[@class='ilTableNav yui-skin-sam'][1]" />

    <xsl:template match="select[@name='selected_cmd']/option[@value='editParticipants']" />
    <xsl:template match="select[@name='selected_cmd']/option[@value='confirmDeleteParticipants']" />
    <xsl:template match="select[@name='selected_cmd']/option[@value='addToClipboard']" />
    <xsl:template match="select[@name='selected_cmd2']/option[@value='editParticipants']" />
    <xsl:template match="select[@name='selected_cmd2']/option[@value='confirmDeleteParticipants']" />
    <xsl:template match="select[@name='selected_cmd2']/option[@value='addToClipboard']" />

    <!--
    <xsl:template match="a[contains(@href, 'cmd=editMember')]" />
    <xsl:template match="a[@class='ilContainerItemCommand2']" />
    <xsl:template match="td[@class='std']" />
-->
    <!-- Hide personal startpage in user settings -->
    <xsl:template match="div[@id='il_prop_cont_usr_start']" />

    <!-- Prevent collapsing of the navbar -->
    <xsl:template match="button[@class='navbar-toggle']" />
    <xsl:template match="div[contains(@class,'navbar-collapse')]">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="class">navbar-collapse collapse in</xsl:attribute>
            <xsl:copy-of select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- adjusting table of content -->
    <xsl:template match="div[@id='il_center_col']">
        <xsl:copy>
            <xsl:attribute name="style">font-size: 20px; font-weight: normal</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@id='il_center_col']//ul">
        <xsl:copy>
            <xsl:attribute name="style">padding-top:10px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- adjusting LM display
    <xsl:template match="div[@id='ilLMPageContent']">
        <xsl:copy>
            <xsl:attribute name="style">font-size: 20px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    -->

    <!-- hide learning progress -->
    <!-- <xsl:template match="li[@id='subtab_trac_matrix']" /> -->
    <xsl:template match="li[@id='subtab_trac_summary']" />
    <xsl:template match="li[@id='subtab_trac_settings']" />
    <xsl:template match="li[@id='tab_learning_progress']" />

    <!-- No head and list actions -->
    <!-- <xsl:template match="div[@class='ilHeadAction']"  /> -->
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']"  />

    <!-- reduce personal settings -->
    <xsl:template match="li[@id='tab_general_settings']"  />
    <!-- <xsl:template match="li[@id='tab_mail_settings']"  /> -->

    <!-- Profile adjustment layout
    <xsl:template match="table">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="width">100%</xsl:attribute>
            <xsl:copy-of select="node()" />
        </xsl:copy>
    </xsl:template>
-->
    <!-- No footer -->
    <xsl:template match="footer" />

    <!-- Rewriting of links -->
    <xsl:template match="a" >

        <xsl:copy>

            <xsl:choose>
                <!-- rename settings link in user dropdown -->
                <xsl:when test="contains(@href,'jumpToProfile')">
                    <xsl:copy-of select="@*" />
                    <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                    <xsl:value-of select="php:function('ilSkinTransformer::getTxt','personal_data')" />
                </xsl:when>

                <!-- change settings link to password in user dropdown -->
                <xsl:when test="contains(@href,'jumpToSettings')">
                    <xsl:copy-of select="@*" />
                    <xsl:attribute name="onclick">window.location='ilias.php?cmd=jumpToPassword&amp;baseClass=ilPersonalDesktopGUI';return false;</xsl:attribute>
                    <xsl:value-of select="php:function('ilSkinTransformer::getTxt','chg_password')" />
                </xsl:when>

                <!--  Prevent switching to safari in webapp mode -->
                <!-- fim: #cf not necessary, but destroys external links
                <xsl:when test="@href">
                    <xsl:attribute name="onclick">
                        window.location=this.getAttribute("href");return false;
                    </xsl:attribute>
                    <xsl:copy-of select="node()" />
                </xsl:when> -->

                <!-- hide public link -->
                <xsl:when test="contains(@href,'index.php')">
                </xsl:when>

                <!-- links without href are just anchors -->
                <xsl:otherwise>
                    <xsl:copy-of select="@*" />
                    <xsl:copy-of select="node()" />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:copy>
    </xsl:template>

    <!-- hide subtab - seite gestalten -->
    <xsl:template match="li[@id='subtab_page_editor']" />

    <!-- hide some email functions -->
    <xsl:template match="button[@name='cmd[searchUsers]']" />
    <xsl:template match="button[@name='cmd[searchGroupsTo]']" />
    <xsl:template match="button[@name='cmd[searchMailingListsTo]']" />
    <xsl:template match="li[@class='ilToolbarGroup']"/>

    <!-- hide some member functions -->
    <xsl:template match="input[@name='cmd[editMembers]']" />
    <xsl:template match="input[@name='cmd[deleteMembers]']" />
    <xsl:template match="input[@name='blocked[]']" />

    <!-- hide some forum functions -->
    <xsl:template match="option[@value='makesticky']" />
    <xsl:template match="option[@value='unmakesticky']" />
    <xsl:template match="option[@value='editThread']" />
    <xsl:template match="option[@value='close']" />
    <xsl:template match="option[@value='reopen']" />
    <xsl:template match="option[@value='move']" />
    <xsl:template match="option[@value='html']" />
    <xsl:template match="option[@value='confirmDeleteThreads']" />
    <xsl:template match="option[@value='merge']" />

    <!-- getting a gap in questions between markspot and answertext-->
    <xsl:template match="span[@class='answertext']" >
        <xsl:copy>
            <xsl:attribute name="style">padding-left: 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- assuring some space between pictures and text, looks nicer -->
    <xsl:template match="td[@class='ilc_Mob']" >
        <xsl:copy>
            <xsl:attribute name="style">padding-left: 10px; </xsl:attribute>
            <xsl:if test="not(../..//div[@class='ilc_media_caption_MediaCaption'])">
                <xsl:attribute name="style">padding-left: 10px; padding-bottom: 10px</xsl:attribute>
            </xsl:if>

            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fixing text under picture -->
    <xsl:template match="div[@class='ilc_media_caption_MediaCaption']" >
        <xsl:copy>
            <xsl:attribute name="style">margin-left: 10px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- adjusting look of tabs and subtabs -->
    <xsl:template match="li[@id='tab_members']//a" >
        <xsl:copy>
            <xsl:attribute name="style">color: #FFF; background-color: #0D406E; font-size: 14px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="li[@id='subtab_crs_member_administration']//a" >
        <xsl:copy>
            <xsl:attribute name="style">color: #FFF; background-color: #0D406E; font-size: 12px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="li[@id='subtab_crs_members_gallery']//a" >
        <xsl:copy>
            <xsl:attribute name="style">color: #FFF; background-color: #0D406E; font-size: 12px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- minheight -->
    <xsl:template match="div[@id='minheight']" >
        <xsl:copy>
            <xsl:attribute name="style">height: 25px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide "back to magazin"-button after survey -->
    <xsl:template match="nav[@id='2']" >
        <xsl:if test="not(..//a[contains(@href,'cmd=exitSurvey')])">
            <xsl:apply-templates select="node()" />
        </xsl:if>
    </xsl:template>

    <!-- hide advertising buttons in bottom bar -->
    <xsl:template match="div[@id='ilLMPageContent']//div[@class='btn-group']" />
    <!-- <xsl:template match="div[@div='ilFooterContainer']//div[@class='btn-group']" />-->

    <!-- hide LM menu -->
    <xsl:template match="div[@class='row ilContainerBlockHeader']//div[@class='btn-group']" />

    <!-- hide perma link below LM -->
    <xsl:template match="label[@for='current_perma_link']" />
    <xsl:template match="input[@id='current_perma_link']" />

    <!-- hide printview in general for LMs -->
    <xsl:template match="li[@id='tab_cont_print_view']" />

    <!-- hide search function -->
    <xsl:template match="li[@id='ilMMSearch']" />

    <!--  -->
    <xsl:template match="input[@id='usr_email']/@style" />
    <xsl:template match="input[@id='usr_email_retype']/@style" />

    <!-- nicer profil picture upload screen -->
    <xsl:template match="div[@id='il_prop_cont_userfile']//div[@class='input-group']">
        <input id="userfile" name="userfile" type="file" />
    </xsl:template>

    <!-- hide public Area Links
    <xsl:template match="p[@class='ilStartupSection']/a[2]" />
    <xsl:template match="div[@class='ilStartupSection']//a[2]" />
    -->

    <!-- change fontsize LM subtab -->
    <xsl:template match="ul[@id='ilTab']/li/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <!-- change fontsize LM subtab -->
    <xsl:template match="ul[@id='ilSubTab']/li/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide Itemproperties -->
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_ItemProperties']" />
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_Description']" />

    <!--
    work in progress
        <xsl:template match="div[@class='il_ContainerListItem']" >
            <xsl:if test="not(..//div[@class='ilListItemSection il_ItemProperties'][contains(text,'verfügbar')])">
                <xsl:apply-templates select="node()" />
            </xsl:if>
        </xsl:template>
    -->

</xsl:stylesheet>