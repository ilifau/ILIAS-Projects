<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
    <xsl:output method="html" version="4.0" encoding="UTF-8"/>

    <!-- Variables -->
    <xsl:variable name="skinDirectory" select="php:function('ilSkinTransformer::getSkinDirectory','')" />

    <!--  Basic rule: copy everything not specified and process the childs -->
    <xsl:template match="@*|node()">
        <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
    </xsl:template>

<!-- Main transformations -->

    <!-- remove scroll -->
    <xsl:template match="body[@class='std']" >
        <xsl:copy>
            <xsl:attribute name="style">height: 0;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- PNG logo in the top bar AND border beneath topbar -->
    <xsl:template match="div[@id='ilTopBar']//div[@class='row']" >
        <xsl:copy>
            <xsl:attribute name="style">border-bottom: 5px solid #F59C00; margin-bottom: 5px; max-height: 100px; background-image: url('https://course.lernhaus.odl.org/ilias/data/lernhaus-v2/sty/sty_3975/images/newsletter_zeichnung_small_for_bg_grau_3.png'); background-repeat: repeat-x; </xsl:attribute>
            <xsl:apply-templates select="@*" />
            <div class="ilTopTitle" style="height: 100px; background-color: #E5E5E5; padding-right: 60px; border-bottom: 5px solid #F59C00;" >
                <a onClick="window.location='index.php?';return false;">
                    <img alt="Logo" src="templates/default/images-custom/HeaderIcon.svg"  height="100%"/>
                </a>
            </div>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- "Back" and "Overview" button beneath the user drop down -->
    <xsl:template match="ul[@id='ilTopBarNav']" >
        <xsl:copy>
            <xsl:attribute name="style"></xsl:attribute>
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
                        <!--<xsl:value-of select="php:function('ilSkinTransformer::getTxt','content')" /> -->
                        <span style="font-weight: bold;">
                            Übersicht
                        </span>
                    </a>
                </li>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide email function in upper bar and some more things...-->
    <xsl:template match="li[@id='tab_mail_addressbook']" />
    <xsl:template match="li[@id='ilMMSearch']" />

    <!-- No main header, no main menu -->
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

    <!-- No locator, No tree view (Navigation and LM) -->
    <xsl:template match="ol[@class='breadcrumb hidden-print']" />
    <xsl:template match="a[@id='imgtree']"/>
    <xsl:template match="div[@id='left_nav']" />

    <!-- Hide some tabs menus completely, identified by one tab -->
    <xsl:template match="ul[./li/@id='tab_personal_data']" />
    <xsl:template match="ul[./li/@id='tab_password']" />
    <xsl:template match="ul[./li/@id='tab_info_short']" />

    <!-- Adjust menu of learning modules -->
    <xsl:template match="li[@id='subtab_content']" />
    <xsl:template match="li[@id='subtab_info_short']" />

    <!-- adjust menu of course -->
    <xsl:template match="li[@id='subtab_view_content']" />
    <xsl:template match="li[@id='subtab_manage']" />
    <xsl:template match="li[@id='subtab_ordering']" />
    <xsl:template match="li[@id='subtab_crs_members_groups']" />

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

    <!-- change member view for tutors -->
    <xsl:template match="form[contains(@action,'ilrepositorysearchgui')]" />
    <xsl:template match="option[@value='confirmDeleteParticipants']" />
    <xsl:template match="option[@value='addToClipboard']" />
    <xsl:template match="option[@value='editParticipants']" />

    <!-- Hide personal startpage in user settings -->
    <xsl:template match="div[@id='il_prop_cont_usr_start']" />
    <!-- nicer profil picture upload screen -->
    <xsl:template match="div[@id='il_prop_cont_userfile']//div[@class='input-group']">
        <input id="userfile" name="userfile" type="file" />
    </xsl:template>

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

    <!-- No head and list actions -->
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']"  />

    <!-- reduce personal settings -->
    <xsl:template match="li[@id='tab_general_settings']"  />

    <xsl:template match="div[@class='ilFormCmds']//input[contains(@name, 'cmd[savePersonalData]')]">
        <xsl:copy>
            <xsl:attribute name="style">margin-top: -15px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

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

                <!-- hide public area link -->
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

    <!-- hide some email functions -->
    <xsl:template match="button[@name='cmd[searchUsers]']" />

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

    <!-- fixing textspace under picture -->
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

    <!-- hide LM menu -->
    <xsl:template match="div[@class='row ilContainerBlockHeader']//div[@class='btn-group']" />

    <!-- hide perma link below LM -->
    <xsl:template match="label[@for='current_perma_link']" />
    <xsl:template match="input[@id='current_perma_link']" />

    <xsl:template match="div[@class='ilStartupSection']/p[2]/a[2]" />

    <!-- change fontsize LM Tab/Subtab -->
    <xsl:template match="ul[@id='ilTab']/li/a" >
        <xsl:if test="../..//li[@id='tab_members']">
            <xsl:copy>
                <xsl:attribute name="style">font-size: 130%; border-radius: 5px 5px 5px 5px;</xsl:attribute>
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    <xsl:template match="ul[@id='ilSubTab']/li/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%; border-radius: 5px 5px 5px 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide Itemproperties -->
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_ItemProperties']" />
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_Description']" />

</xsl:stylesheet>