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

<!-- Hide the tabs -->
<xsl:template match="ul[@id='ilTab']" />

<!-- Hide the right column -->
<xsl:template match="div[@id='il_right_col']" />

<!-- Hide post related actions -->
<xsl:template match="div[@class='ilFrmPostCommands']" />

<!-- Hide table navogation settings (e.g. changing of displayed rows) -->
<xsl:template match="div[contains(@class,'ilTableNav')]//td[contains(@class,'ilRight')]" />

<!-- Hiden thread commands -->
<xsl:template match="div[contains(@class,'ilTableCommandRow')]" />
<xsl:template match="div[contains(@class,'ilTableSelectAll')]" />
<xsl:template match="input[contains(@id,'thread_ids')]" />

<!-- Hide the quote button in the reply form -->
<xsl:template match="input[@name='cmd[quotePost]']" />
<xsl:template match="div[@id='il_prop_cont_userfile']" />
<xsl:template match="form[not(contains(@action,'addThread'))]//div[@id='il_prop_cont_subject']">
    <input name="subject" type="hidden" value="{.//input/@value}" />
</xsl:template>

<!-- Show the thread title above the posts instead of in the posts -->
<xsl:template match="//div[@class='ilFrmPostTitle']" />
<xsl:template match="div[@id='il_center_col']">
    <xsl:variable name="title" select="//div[@class='ilFrmPostTitle'][1]" />
    <xsl:copy>
        <xsl:copy-of select="@*" />
        <xsl:attribute name="class">col-sm-12</xsl:attribute>
        <xsl:if test="$title">
            <h3><xsl:value-of select="$title" /></h3>
        </xsl:if>
        <xsl:apply-templates select="node()" />
    </xsl:copy>
</xsl:template>

<!-- Adjust the thread toolbar -->
<xsl:template match="ul[contains(@class,'ilToolbarStickyItems')]" />
<xsl:template match="ul[contains(@class,'ilToolbarItems')]" >
    <xsl:variable name="reply_link" select="//a[contains(@href,'action=showreply')][last()]" />
    <xsl:variable name="back_link" select="//ul[@id='ilTab']/li[1]/a" />

    <xsl:copy>
        <xsl:copy-of select="@*" />


        <li>
            <div class="navbar-form">
                <button class="btn btn-default" type="button" onclick="location.href='{$back_link/@href}'">
                    <xsl:value-of select ="$back_link/text()" />
                </button>
            </div>
        </li>

        <xsl:if test="$reply_link and not(//textarea)">
            <li>
                <div class="navbar-form">
                    <button class="btn btn-default" type="button" onclick="location.href='{$reply_link/@href}'">
                        <xsl:value-of select ="$reply_link/text()" />
                    </button>
                </div>
            </li>
        </xsl:if>

        <xsl:copy-of select="li" />
    </xsl:copy>
</xsl:template>


<!-- Reduce the visit card -->
<xsl:template match="div[./div/@class='ilProfile']">
    <xsl:copy>
        <xsl:copy-of select="@*" />
        <xsl:apply-templates select="div[@class='ilProfile']" />
    </xsl:copy>
</xsl:template>
<xsl:template match="div[@class='ilProfile']//a[@class='il_ContainerItemCommand']" />

</xsl:stylesheet>