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
        <meta name="viewport" content="initial-scale=1.5, user-scalable=0" />
        <meta name="apple-mobile-web-app-capable" content="yes" />
        <meta name="apple-mobile-web-app-status-bar-style" content="black" />
    </xsl:template>
    -->

    <!-- PNG logo in the top bar -->
    <xsl:template match="div[@id='ilTopBar']//div[@class='row']" >
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <div class="ilTopTitle">
                <img alt="Logo" src="templates/default/images-ehlssa/HeaderIcon.svg" height="40"/>
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
                    <a onclick="window.location='index.php?senappHome=1';return false;">
                        <xsl:value-of select="php:function('ilSkinTransformer::getTxt','content')" />
                    </a>
                </li>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide email function in upper bar and some more things...-->
     <xsl:template match="ul[@id='ilTopBarNav']/li[1]" />
    <!-- <xsl:template match="li[@id='tab_fold']" /> -->
    <xsl:template match="li[@id='tab_mail_addressbook']" />
    <!-- <xsl:template match="li[@id='tab_options']" />
    <xsl:template match="div[@id='il_prop_cont_m_type____']" /> -->
    <!-- <xsl:template match="div[@class='container-fluid']" /> -->
    <!-- shows mailentry; delete in Mailsettings user ticks or profile gets lost by "/li[1]" -->

    <!-- No main header, no main menu -->
    <xsl:template match="nav[@id='ilTopNav']" />
    <xsl:template match="div[contains(@class,'ilMainHeader')]" />
    <xsl:template match="div[contains(@class,'ilMainMenu')]" />

    <!-- Empty headline (keep space) -->
    <xsl:template match="div[contains(@class,'il_HeaderInner')]">
        <div class="il_HeaderInner"></div>
    </xsl:template>

    <!-- No locator, No tree view -->
    <xsl:template match="ol[@class='breadcrumb']" />
    <xsl:template match="a[@class='ilTreeView']" />
    <xsl:template match="div[@class='ilLeftNav']" />

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
        <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
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

    <!-- hide learning progress -->
    <xsl:template match="li[@id='subtab_trac_summary']" />
    <xsl:template match="li[@id='subtab_trac_matrix']" />
    <xsl:template match="li[@id='subtab_trac_settings']" />

    <!-- No head and list actions -->
    <xsl:template match="div[@class='ilHeadAction']"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']"  />

    <!-- cf: reduce personal settings -->
    <xsl:template match="li[@id='tab_general_settings']"  />
    <!-- <xsl:template match="li[@id='tab_mail_settings']"  /> -->

    <!-- hide some forum functions -->
    <xsl:template match="option[@value='html']" />

    <!-- getting a gap in questions between markspot and answertext-->
    <xsl:template match="span[@class='answertext']" >
        <xsl:copy>
            <xsl:attribute name="style">padding: 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- No footer -->
    <xsl:template match="footer" />

    <!-- Rewriting of links -->
    <xsl:template match="a" >

        <xsl:copy>
            <xsl:copy-of select="@*" />

            <xsl:choose>
                <!-- rename settings link in user dropdown -->
                <xsl:when test="contains(@href,'jumpToProfile')">
                    <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                    <xsl:value-of select="php:function('ilSkinTransformer::getTxt','personal_data')" />
                </xsl:when>

                <!-- change settings link to password in user dropdown -->
                <xsl:when test="contains(@href,'jumpToSettings')">
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

                <!-- links without href are just anchors -->
                <xsl:otherwise>
                    <xsl:copy-of select="node()" />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:copy>
    </xsl:template>

    <!-- hide subtab seite gestalten -->
    <xsl:template match="li[@id='subtab_page_editor']" />

</xsl:stylesheet>