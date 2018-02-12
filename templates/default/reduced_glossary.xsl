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
	   Glossary transformations
	-->

	<!-- Hide the tabs -->
	<xsl:template match="ul[@id='ilTab']" />

	<!-- Hide table navigation settings (e.g. changing of displayed rows) -->
	<xsl:template match="div[@class='ilTableFilterSec']" />
	<xsl:template match="div[contains(@class,'ilTableNav')]//td[contains(@class,'ilRight')]" />

	<!-- Hide the locator - Link to the side -->
	<xsl:template match="div[@class='il_info']" />

	<!-- hide Resourcelinks in Glossary term -->
	<xsl:template match="div[@id='ilGloContent']//p"/>
	<xsl:template match="div[@id='ilGloContent']//div[@class='ilc_BacklinkTitle']"/>

</xsl:stylesheet>