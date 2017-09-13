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

    <!-- move/resize login button -->
    <xsl:template match="div[@class='ilStartupSection']//div[@class='col-sm-6 ilFormCmds']" >
        <xsl:copy>
            <xsl:attribute name="style">width: 100%; text-align: center</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@class='ilStartupSection']//input[@name='cmd[doStandardAuthentication]']" >
        <xsl:copy>
            <xsl:attribute name="style">width: 50%;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- nicer login page -->
    <xsl:template match="div[@class='ilStartupSection']//form[@name='formlogin']/div" >
        <xsl:copy>
            <xsl:attribute name="style">width:65%; position: center; margin-left: auto; margin-right: auto;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- nicer login page -->
    <xsl:template match="form[@name='formlogin']//span[@class='asterisk']" />
    <xsl:template match="form[@name='formlogin']//div[@class='col-sm-6 ilFormRequired']" />

    <!-- hide left nav (for bot_center_area)
    <xsl:template match="div[@id='left_nav']" />
    -->

</xsl:stylesheet>