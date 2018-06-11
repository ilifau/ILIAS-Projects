<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
    <xsl:output method="html" version="4.0" encoding="UTF-8"/>

    <!--  Basic rule: copy everything not specified and process the childs -->
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!--
       Main transformations
    -->

    <!-- Add scaling for the app, content type will automatically be re-added when putput is written-->
    <xsl:template match="meta[@http-equiv='Content-Type']">
        <meta name="viewport" content="initial-scale=1, user-scalable=0" />
    </xsl:template>

    <!-- Rewriting of links -->
    <!-- fim #cf links always open in same tab -->
    <xsl:template match="a" >
        <xsl:copy>
            <xsl:copy-of select="@*" />

            <xsl:choose>
                <!--  Prevent switching to safari in webapp mode -->
                <xsl:when test="@href and not(@onclick)">
                    <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                    <xsl:apply-templates select="node()" />
                </xsl:when>

                <!-- links without href are just anchors -->
                <xsl:otherwise>
                    <xsl:copy-of select="node()" />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting image responsive size -->
    <xsl:template match="td[@class='ilc_Mob']" >
        <xsl:copy>
            <xsl:choose>
                <xsl:when test="object/embed">
                    <!-- all attributes needed for youtube videos -->
                    <xsl:copy-of select="@*" />
                </xsl:when>
                <xsl:otherwise>
                    <!-- width will be removed for other media -->
                    <xsl:apply-templates select="@*" />
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="td[@class='ilc_Mob']/@width" />

    <xsl:template match="td[@class='ilc_Mob']/img/@width" />
    <xsl:template match="td[@class='ilc_Mob']/img/@height"/>

    <xsl:template match="td[@class='ilc_Mob']/img" >
        <xsl:copy>
            <xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- responsive images with links
    <xsl:template match="td[@class='ilc_Mob']/a"/> -->
    <xsl:template match="td[@class='ilc_Mob']/a/img/@width"/>
    <xsl:template match="td[@class='ilc_Mob']/a/img/@height"/>
    <xsl:template match="td[@class='ilc_Mob']/a/img" >
        <xsl:copy>
            <xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting image (embeded) responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/embed/@height"/>
    <xsl:template match="td[@class='ilc_Mob']/embed" >
        <xsl:copy>
            <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting iframes responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/iframe" >
        <xsl:copy>
            <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting video responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/video/@width" />
    <xsl:template match="td[@class='ilc_Mob']/video/@height"/>
    <xsl:template match="td[@class='ilc_Mob']/video/object" />
    <xsl:template match="td[@class='ilc_Mob']/video" >
        <xsl:copy>
            <xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting video responsive size, for youtube embeds - better, not good -->
    <!-- http://www.holgerkoenemann.de/ein-vimeo-oder-youtube-video-responsive-einbinden/ -->
    <!-- doing outer frame -->
    <xsl:template match="td[@class='ilc_Mob']/object" >
        <div style="position: relative; padding-bottom: 56.25%; padding-top: 0px; height: 0; overflow: hidden;">
            <xsl:copy>
                <!--<xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute> -->
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </div>
    </xsl:template>
    <!-- preparing inner frame -->
    <xsl:template match="td[@class='ilc_Mob']/object/embed" >
        <xsl:copy>
            <xsl:attribute name="style">position: absolute; top: 0; left: 0; width:100%; height: 100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- using iframe-html-code in text section -->
    <xsl:template match="div[@class='ilc_Paragraph ilc_text_block_Standard']" >
        <xsl:copy>
            <xsl:if test="iframe">
                <xsl:attribute name="style">position: relative; padding-bottom: 56.25%; padding-top: 0px; height: 0; overflow: hidden;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <xsl:template match="div[@class='ilc_Paragraph ilc_text_block_Standard']/iframe" >
        <xsl:copy>
            <xsl:attribute name="style">position: absolute; top: 0; left: 0; width:100%; height: 100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- don't use mediaelement player
    <xsl:template match="script[contains(@src,'mediaelement')]" />
    -->

    <!-- fim #cf: linebreaks the text beneath the picture (not nice) -->
    <xsl:template match="div[@class='ilc_media_caption_MediaCaption']" >
        <xsl:copy>
            <xsl:if test="../../../tr/td/img">
                <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            </xsl:if>

            <xsl:if test="../../../tr/td/embed">
                <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- exclude for git/ilias -->
    <!-- no margin-left, margin-right in LEs = full space use
    <xsl:template match="div[@id='mainspacekeeper']" >
        <xsl:copy>
            <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
-->

    <!-- no ilLeftNav
    <xsl:template match="div[@id='left_nav']" />
    <xsl:template match="div[@class='iLLeftNav']" />
 -->
    <!-- no breadcrumbs
    <xsl:template match="ol[@class='breadcrumb']" />
-->
    <!-- no inner header
    <xsl:template match="div[@class='media il_HeaderInner']" />
-->
    <!-- no free space at bottom
    <xsl:template match="div[@id='minheight']" />
-->
    <!-- scale background image for videos, backup if offline - video block
        <xsl:template match="div[@class='ilc_section_Videoblock']">
            <xsl:copy>
                <xsl:attribute name="style">background-size: 100% 100%</xsl:attribute>
                <xsl:apply-templates select="@*|node()" />
            </xsl:copy>
        </xsl:template>
-->

    <!-- changed fontsize for LM navigation-->
    <xsl:template match="a[@class='ilc_page_rnavlink_RightNavigationLink']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size:125%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="a[@class='ilc_page_lnavlink_LeftNavigationLink']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size:125%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <!-- hiding ilSubTab, to minimize space above LM-Content
    <xsl:template match="ul[@id='ilSubTab']" />
-->
    <!-- _end exclude for git/ilias -->

    <!-- getting a gap in questions between markspot and answertext-->
    <xsl:template match="span[@class='answertext']" >
        <xsl:copy>
            <xsl:attribute name="style">padding: 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- scale background image for videos, backup if offline - mediacontainer
    <xsl:template match="table[@class='ilc_media_cont_MediaContainer']">
        <xsl:copy>
            <xsl:attribute name="style">background-size: 100% 100%</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
-->

    <!-- making a "picture to video" function -->
    <xsl:template match="table[@class='ilc_media_cont_MediaContainer']" >
        <xsl:choose>
            <xsl:when test=".//img[contains(@src, 'enlarge.svg')]">
                <xsl:copy>
                    <!-- <xsl:attribute name="onclick">$.colorbox({maxWidth:'100%', maxHeight:'60%', width:window.innerWidth-100, height:window.innerHeight-100, iframe:true, href:'<xsl:value-of select=".//a/@href" />'});return false</xsl:attribute> -->
                    <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                    <xsl:attribute name="href"><xsl:value-of select=".//a/@href" /></xsl:attribute>
                    <xsl:apply-templates select="@*|node()" />
                </xsl:copy>
            </xsl:when>

            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*|node()" />
                </xsl:copy>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <!-- no magnifying glass -->
    <xsl:template match="table[@class='ilc_media_cont_MediaContainer']//div/a" />

    <!-- nicer linebreak for footnotes -->
    <xsl:template match="div[@class='ilc_page_fn_Footnote']" >
        <xsl:copy>
            <xsl:attribute name="style">word-wrap: break-word;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- nicer linebreak for headings (in glossary) -->
    <xsl:template match="h1[@class='ilc_page_title_PageTitle']" >
        <xsl:copy>
            <xsl:attribute name="style">word-wrap: break-word;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- hide border in bot_center_area -->
    <xsl:template match="div[@class='ilc_page_cont_PageContainer']" >
        <xsl:copy>
            <xsl:attribute name="style">border: hidden; padding-top: 10px; padding-bottom: 10px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- making more space for content -->
    <xsl:template match="div[@class='ilInvisibleBorder']" >
        <xsl:copy>
            <xsl:attribute name="style">padding: 0px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- removed due to an email 22.06. honert
    <xsl:template match="div[@class='ilc_page_frame_PageFrame']" >
        <xsl:copy>
            <xsl:attribute name="style">padding-left: 0px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    -->
    <!-- enlarged space to answer questions in LM, compare to test-object
    <xsl:template match="div[@class='ilc_qanswer_Answer']//input" >
        <xsl:copy>
            <xsl:apply-templates select="@*|node()" />
            <xsl:for-each select=".">
                <xsl:attribute name="id"><xsl:value-of select="@value" /></xsl:attribute>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
 -->

    <!-- try to make the text of an answer also triggering the marked event
        <xsl:template match="span[@class='answertext']" >
             <label>
                 <xsl:attribute name="for">answer_fix_0<xsl:value-of select="../input/@id" /></xsl:attribute>
                 <xsl:copy>
                     <xsl:apply-templates select="@*|node()" />
                 </xsl:copy>
             </label>
        </xsl:template>
    -->

    <!-- questionlayout change:
         Aussenabstand des Submit-Buttons im Content-Style geändert
         Text padding-bottom im Content Style geändert
    -->

    <!-- changes in delos.css
         Close-Icon of Glossary term in LM z-index changed :354
         reducing mainspacekeeper - von 40 auf 0 :11487
         Glossar in LM fixing - closebutton with z-index :10124
         bot_center_area fix - left: 0px !important; width: 100% !important; z-index: 101; :7230
         ilAreaClose    - z-index: 9; padding: 5px; :10122
                        - top: 30px; /* 0 */
                        - right: 15px; /* 32px; */ /* left: 0px */
                        - font-size: 20px; /* 26 */
                        - position: relative;
                        - float: right;

         several settings for div#bot_center_area :7221 :10127
         background-color: #FFFFFF; /* f0f0f0 */ :986

    -->

</xsl:stylesheet>