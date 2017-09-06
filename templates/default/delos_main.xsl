<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:output method="html" version="4.0" encoding="UTF-8"/>

<!--  Basic rule: copy everything not specified and process the childs -->
<xsl:template match="@*|node()">
	<xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
</xsl:template>

<!--
   Main transformations
-->
    <!-- getting a gap in questions between markspot and answertext-->
    <xsl:template match="span[@class='answertext']" >
        <xsl:copy>
            <xsl:attribute name="style">padding: 5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- Rewriting of links -->
    <!-- fim #cf links always open in same tab
        REMOVED due to a bug with block editing - linking to an object in ILIAS -->

    <!-- EDIT OF LOGINPAGE -->
    <!-- resize elements startpage -->
    <xsl:template match="p[@class='ilStartupSection']" >
        <xsl:copy>
            <xsl:attribute name="style">font-size: 20px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- delete public area -->
    <xsl:template match="p[@class='ilStartupSection']/a[2]" />

    <!-- move login-button -->
    <xsl:template match="div[@class='ilFormFooter clearfix']/div[@class='col-sm-6 ilFormCmds']" >
        <xsl:copy>
            <xsl:attribute name="style">width: 45%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>