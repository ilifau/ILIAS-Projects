<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:output method="html" version="4.0" encoding="UTF-8"/>

<!-- Variables -->
<xsl:variable name="skinDirectory" select="php:function('ilSkinTransformer::getSkinDirectory','')" />

    <!--  Basic rule: copy everything not specified and process the childs -->
    <xsl:template match="@*|node()">
        <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
    </xsl:template>

    <!-- No head and list actions -->
    <xsl:template match="div[@class='ilHeadAction']"  />

    <!-- hide mail function -->
    <xsl:template match="ul[@id='ilTopBarNav']/li[3]" />

    <!-- hide mail to members in membergallery -->
    <xsl:template match="a[contains(@href,'ilmailmembersearchgui')]" />

    <!-- hide mail settings in user settings -->
    <xsl:template match="li[@id='tab_mail_settings']" />

    <!-- ONLY FOR REGISTRATION VIA CODE: regCodes - looks smoother -->
    <xsl:template match="div[@id='il_prop_cont_usr_registration_code']" >
        <xsl:copy>
            <xsl:attribute name="style">padding-top: 10px; </xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>