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

<!-- Rewriting of links -->
<!-- fim #cf links always open in same tab -->
<xsl:template match="a" >

    <xsl:copy>
        <xsl:copy-of select="@*" />

        <xsl:choose>
             <!--  Prevent switching to safari in webapp mode -->
            <xsl:when test="@href and not(@onclick)">
                <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                <xsl:copy-of select="node()" />
            </xsl:when>

            <!-- links without href are just anchors -->
            <xsl:otherwise>
                <xsl:copy-of select="node()" />
            </xsl:otherwise>
        </xsl:choose>

    </xsl:copy>
</xsl:template>

    <!-- fim #cf: adjusting image responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/@width" />

    <xsl:template match="td[@class='ilc_Mob']/img/@width" />
    <xsl:template match="td[@class='ilc_Mob']/img/@height"/>

    <xsl:template match="td[@class='ilc_Mob']/img" >
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
    <!-- preparing inner frame -->
    <xsl:template match="td[@class='ilc_Mob']/object/embed" >
        <xsl:copy>
            <xsl:attribute name="style">position: absolute; top: 0; left: 0; width: 100%; height: 100%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- doing outer frame -->
    <xsl:template match="td[@class='ilc_Mob']" >
        <xsl:copy>
            <xsl:attribute name="width"><xsl:value-of select="object/@width" />px</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
            <xsl:if test="*/embed[@type='application/x-shockwave-flash']">
                <div style="position: relative; padding-bottom: 56.25%; padding-top: 0px; height: 0; overflow: hidden;">
                    <xsl:copy-of select="@*|node()" />
                </div>
            </xsl:if>
        </xsl:copy>
    </xsl:template>

    <!-- deleting old object-frame -->
    <xsl:template match="td[@class='ilc_Mob']/object" />

    <!-- don't use mediaelement player -->
    <xsl:template match="script[contains(@src,'mediaelement')]" />

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
-->    <!-- no inner header
    <xsl:template match="div[@class='media il_HeaderInner']" />
    -->

    <!-- no free space at bottom
    <xsl:template match="div[@id='minheight']" />
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

    <!-- making a "picture to video" function-->
    <xsl:template match="table[@class='ilc_media_cont_MediaContainer']" >
        <xsl:choose>
            <xsl:when test="//img[contains(@src, 'enlarge.svg')]">
                <xsl:copy>
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

    <!-- Close-Icon of Glossary term in LM z-index changed
        not working, done in delos.css:354
    -->

    <!-- reducing mainspacekeeper - geht nicht
    geändert in delos.css 11487 von 40 auf 0
    <xsl:template match="div[@id='mainspacekeeper']" >
        <xsl:copy>
            <xsl:attribute name="style">margin-top:5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    -->
    <!-- questionlayout change
        ging nicht:
        - Aussenabstand des Submit-Buttons im Content-Style geändert
        Text padding-bottom im Content Style geändert
    -->

</xsl:stylesheet>