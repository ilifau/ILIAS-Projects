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
    <xsl:template match="div[@class='ilTopTitle']" />
    <xsl:template match="div[@id='ilTopBar']//div[@class='row']" >
        <xsl:copy>
            <xsl:attribute name="style">border-bottom: 5px solid #BCD14D; 50px; max-height: 100px; </xsl:attribute>
            <xsl:apply-templates select="@*" />
            <div class="ilTopTitle" style="height: 100px; background-color: #F0F0F0; padding-right: 60px; border-bottom: 5px solid #BCD14D;" >
                <a onClick="window.location='index.php?';return false;">
                    <img alt="Logo" src="templates/default/images-custom/grandexperts_ohne.png"  height="90%" style="padding-top: 2%"/>
                </a>
            </div>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div[@class='row']//a[@class='navbar-brand']" />

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
                    <a onclick="window.location='index.php?';return false;" style="font-weight: 600">
                        <xsl:value-of select="php:function('ilSkinTransformer::getTxt','content')" />
                        <!--  <span style="font-weight: bold;">
                              Übersicht
                          </span> -->
                    </a>
                </li>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- TEMP english
    <xsl:template match="a[@id='il_mhead_t_focus']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 30px; font-weight: bold;</xsl:attribute>
            <xsl:value-of select="php:function('ilSkinTransformer::getTxt','groupings_assigned_obj_crs')" />
        </xsl:copy>
    </xsl:template>-->

    <!-- hide email function in upper bar and some more things...-->
    <xsl:template match="li[@id='tab_mail_addressbook']" />
    <xsl:template match="li[@id='ilMMSearch']" />
    <xsl:template match="li[@class='ilOnScreenChatMenuDropDown']" />

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
            <xsl:attribute name="style">border-bottom: 0px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="li[@id='tab_view_content']" />
    <xsl:template match="li[@id='tab_info_short']" />
    <!--    <xsl:template match="li[@id='tab_settings']" /> -->
    <xsl:template match="li[@id='tab_meta_data']" />
    <xsl:template match="li[@id='tab_export']" />
    <xsl:template match="li[@id='tab_crs_unsubscribe']" />
    <xsl:template match="li[@id='nontab_members_view']" />

    <!-- no need in forum -->
    <xsl:template match="li[@id='tab_sort_by_posts']" />
    <xsl:template match="li[@id='tab_order_by_date']" />

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
            <xsl:attribute name="style">font-size: 20px; font-weight: normal; width: 100%</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@id='il_center_col']//ul">
        <xsl:copy>
            <xsl:attribute name="style">padding-top:10px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- only show delete for LMs -->
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']" >
        <xsl:choose>
            <xsl:when test="../../..//img[contains(@title, 'Module')]">
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" />
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[1]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[2]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[3]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[4]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[6]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[7]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[8]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[9]"  />
    <xsl:template match="div[@class='il_ContainerListItem']/div[@class='ilFloatRight']//li[10]"  />

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
    <xsl:template match="ul[@id='ilTab']//li[@id='tab_members']/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%; border-radius: 5px 5px 5px 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ul[@id='ilSubTab']/li/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%; border-radius: 5px 5px 5px 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="ul[@id='ilTab']/li/a" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 130%; border-radius: 5px 5px 5px 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide Itemproperties -->
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_ItemProperties']" />
    <xsl:template match="div[@class='il_ContainerListItem']//div[@class='ilListItemSection il_Description']" />

    <xsl:template match="div[@id='accordion__1']//div[@class='il_VAccordionInnerContainer'][2]"/>
    <xsl:template match="div[@id='accordion__1']//div[@class='il_VAccordionInnerContainer'][3]"/>

    <xsl:template match="div[@class='ilNewObjectSelector']//li[@class='dropdown-header ']"/>

    <!-- hide experts LM settings not needed -->
    <xsl:template match="li[@id='tab_questions']" />
    <xsl:template match="li[@id='tab_meta']" />
    <xsl:template match="li[@id='subtab_internal_links']" />
    <xsl:template match="li[@id='subtab_link_check']" />
    <xsl:template match="li[@id='subtab_history']" />
    <xsl:template match="li[@id='subtab_maintenance']" />
    <xsl:template match="li[@id='subtab_srt_files']" />
    <xsl:template match="li[@id='subtab_cont_lm_menu']" />
    <xsl:template match="li[@id='subtab_import']" />
    <xsl:template match="li[@id='subtab_obj_multilinguality']" />

    <!-- adjust creating modul layout -->
    <xsl:template match="div[@class='il_VAccordionHead']" />

    <!-- extract new module creation -->
    <xsl:template match="div[@class='ilNewObjectSelector']" >
        <xsl:copy>
            <ul id="ilTopBarNav" class="" style="">
                <li>
                <xsl:attribute name="style">float: right</xsl:attribute>
                    <a >
                        <xsl:attribute name="href"><xsl:value-of select="//a[@id='lm']/@href" /></xsl:attribute>
                        <xsl:value-of select="php:function('ilSkinTransformer::getTxt','cntr_add_new_item')" />
                    </a>
                </li>
            </ul>
        </xsl:copy>
    </xsl:template>

    <!-- hide experts LM settings in settings not needed -->
    <xsl:template match="li[@id='subtab_public_section']" />
    <xsl:template match="form[contains(@action, 'ilLMEditorGUI')]//div[@class='ilFormHeader']" />
    <xsl:template match="div[@id='subtab_public_section']" />
    <xsl:template match="div[@id='il_prop_cont_rating_pages']" />
    <xsl:template match="div[@id='il_prop_cont_rating']" />
    <xsl:template match="div[@id='il_prop_cont_cobj_user_comment']" />
    <xsl:template match="div[@id='il_prop_cont_restrict_forw_nav']" />
    <xsl:template match="div[@id='il_prop_cont_progr_icons']" />
    <xsl:template match="div[@id='il_prop_cont_cobj_act_number']" />
    <xsl:template match="div[@id='il_prop_cont_layout_per_page']" />
    <xsl:template match="div[@id='il_prop_cont_lm_layout']" />
    <xsl:template match="div[@id='il_prop_cont_toc_mode']" />
    <xsl:template match="div[@id='il_prop_cont_lm_pg_header']" />
    <xsl:template match="div[@id='il_prop_cont_lm_pg_header']" />

    <!-- hide experts LMpage settings not needed -->
    <xsl:template match="li[@id='tab_content_preview']" />
    <xsl:template match="li[@id='tab_history']" />
    <xsl:template match="li[@id='tab_clipboard']" />
    <xsl:template match="li[@id='tab_cont_activation']" />
    <xsl:template match="button[@id='ilAdvSelListAnchorText_copage_act']" />
    <xsl:template match="button[@id='ilAdvSelListAnchorText_copage_ed_mode']" />
    <xsl:template match="div[@class='ilFloatRight']//a[@class='il_ContainerItemCommand']" />

    <!-- create content on page settings -->
    <xsl:template match="a[contains(@onclick,'insert_flst')]" />
    <xsl:template match="a[contains(@onclick,'insert_dtab')]" />
    <xsl:template match="a[contains(@onclick,'insert_tab')]" />
    <xsl:template match="a[contains(@onclick,'insert_list')]" />
    <xsl:template match="a[contains(@onclick,'insert_iim')]" />
    <xsl:template match="a[contains(@onclick,'insert_src')]" />
    <xsl:template match="a[contains(@onclick,'insert_incl')]" />
    <xsl:template match="a[contains(@onclick,'insert_sec')]" />

    <!-- insert text -->
    <xsl:template match="i[@class='mce-ico']" />

    <!-- background of selection menus -->
    <xsl:template match="div[@class='form-horizontal']" >
        <xsl:copy>
            <xsl:attribute name="style">background-color: #F0F0F0</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@id='ilPageEditLegend']" >
        <xsl:copy>
            <xsl:attribute name="style">background-color: #F0F0F0</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@id='subform_standard_type_File']" >
        <xsl:copy>
            <xsl:attribute name="style">background-color: #F0F0F0</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@class='col-sm-9 il_file']" >
        <xsl:copy>
            <xsl:attribute name="style">background-color: #F0F0F0</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>