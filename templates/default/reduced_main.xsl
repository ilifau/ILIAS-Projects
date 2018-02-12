<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:php="http://php.net/xsl">
<xsl:output method="html" version="4.0" encoding="UTF-8"/>

<!-- Variables -->
<xsl:variable name="skinDirectory" select="php:function('ilSkinTransformer::getSkinDirectory','')" />

    <!--  Basic rule: copy everything not specified and process the childs -->
    <xsl:template match="@*|node()">
        <xsl:copy><xsl:apply-templates select="@*|node()" /></xsl:copy>
    </xsl:template>

    <!-- hide left_nav -->
    <xsl:template match="div[@id='left_nav']" />
    <xsl:template match="ul[@id='ilTab']//li[@id='tab_sort_by_posts']"/>
    <xsl:template match="ul[@id='ilTab']//li[@id='tab_order_by_date']"/>

    <!-- hide mail function topmenu, membergallery, publicprofile, settings in usersettings -->
    <xsl:template match="ul[@id='ilTopBarNav']/li[3]" />
    <xsl:template match="a[contains(@href,'ilmailmembersearchgui')]" />
    <xsl:template match="div[@class='ilProfile']/div[1]" />
    <xsl:template match="li[@id='tab_mail_settings']" />

</xsl:stylesheet>