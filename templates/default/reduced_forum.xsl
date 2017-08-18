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
       Forum transformations
    -->

    <!-- Hide post related actions -->
    <!-- <xsl:template match="div[@class='ilFrmPostCommands']" /> -->
    <!--<xsl:template match="div[@class='ilFrmPostCommands']//span[@class='split-btn-default']" />-->

    <!-- Hide table navigation settings (e.g. changing of displayed rows)
    <xsl:template match="div[contains(@class,'ilTableNav')]//td[contains(@class,'ilRight')]" />
-->
    <!-- Hide thread commands
    <xsl:template match="div[contains(@class,'ilTableCommandRow')]" />
    <xsl:template match="div[contains(@class,'ilTableSelectAll')]" />
    <xsl:template match="input[contains(@id,'thread_ids')]" />
    -->

    <!-- Hide the quote button in the reply form -->
    <xsl:template match="input[@name='cmd[quoteTopLevelPost]']" />
    <xsl:template match="div[@id='il_prop_cont_userfile']" />

<!-- Reduce the visit card -->
    <xsl:template match="div[./div/@class='ilProfile']">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="div[@class='ilProfile']" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@class='ilProfile']//a[@class='il_ContainerItemCommand']" />

</xsl:stylesheet>