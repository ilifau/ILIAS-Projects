<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:output method="html" version="4.0" encoding="UTF-8"/>

<!--  Basic rule: copy everything not specified and process the childs -->
<xsl:template match="node()">
    <xsl:copy>
        <xsl:copy-of select="@*" />
        <xsl:apply-templates select="node()" />
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
            <xsl:copy-of select="@*" />
            <xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting image (embeded) responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/embed/@height"/>
    <xsl:template match="td[@class='ilc_Mob']/embed" >
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting video responsive size -->
    <xsl:template match="td[@class='ilc_Mob']/video/@width" />
    <xsl:template match="td[@class='ilc_Mob']/video/@height"/>
    <xsl:template match="td[@class='ilc_Mob']/video/object" />
    <xsl:template match="td[@class='ilc_Mob']/video" >
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="style">width:<xsl:value-of select="@width" />px;max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- fim #cf: adjusting video responsive size, for youtube embeds - better, not good -->
    <xsl:template match="embed[@type='application/x-shockwave-flash']" >
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- don't use mediaelement player -->
    <xsl:template match="script[contains(@src,'mediaelement')]" />

    <!-- fim #cf: linebreaks the text beneath the picture (not nice) -->
    <xsl:template match="div[@class='ilc_media_caption_MediaCaption']" >
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:if test="../../../tr/td/img">
                <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            </xsl:if>

            <xsl:if test="../../../tr/td/embed">
                <xsl:attribute name="style">max-width:100%;</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

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
    <!-- changed fontsize for LM navigation
    <xsl:template match="a[@class='ilc_page_rnavlink_RightNavigationLink']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size:200%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="a[@class='ilc_page_lnavlink_LeftNavigationLink']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size:200%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
-->

</xsl:stylesheet>