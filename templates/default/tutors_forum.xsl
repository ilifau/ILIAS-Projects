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

    <!-- hide Tabs
    <xsl:template match="ul[@id='ilTab']" />
    -->
    <xsl:template match="ul[@id='ilTab']//li[1]" />
    <xsl:template match="li[@id='tab_frm_moderators']" />

    <!-- adjusting position of all topics button -->
    <xsl:template match="div[@id='tb-collapse-1']" >
        <xsl:copy>
            <xsl:attribute name="style">margin-left: -5px;</xsl:attribute>
            <xsl:apply-templates select="@*|node()" />
        </xsl:copy>
    </xsl:template>

    <!-- Hide the right column -->
    <xsl:template match="div[@id='il_right_col']" />

    <!-- Hide post related action (print) -->
    <xsl:template match="div[@class='ilFrmPostCommands']//a[contains(@href, 'ilforumexportgui')]" />

    <!-- Hide the quote button in the reply form-->
    <xsl:template match="input[@name='cmd[quotePost]']" />

    <!-- make subject invisible in reply form -->
    <xsl:template match="form[not(contains(@action,'addThread'))]//div[@id='il_prop_cont_subject']">
        <input name="subject" id="subject" type="hidden" value="Reply" required="required" />
    </xsl:template>

    <!-- Show the thread title above the posts instead of in the posts -->
    <xsl:template match="//div[@class='ilFrmPostTitle']" />
    <!--
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
-->
<!--     BROKEN tries to upload a file that extends size?!
    <xsl:template match="div[@id='il_prop_cont_userfile']" />
-->

    <!-- Adjust the thread toolbar -->
    <xsl:template match="ul[contains(@class,'ilToolbarStickyItems')]" />
    <xsl:template match="ul[contains(@class,'ilToolbarItems')]" >
        <xsl:variable name="reply_link" select="//a[contains(@href,'action=showreply')][last()]" />
        <xsl:variable name="back_link" select="//ul[@id='ilTab']/li[1]/a" />
        <xsl:variable name="createthread_link" select="//a[contains(@href, 'cmd=createThread')]" />

        <xsl:copy>
            <xsl:copy-of select="@*" />

            <!-- show create thread only on forums level -->
            <xsl:choose>
                <xsl:when test="$createthread_link">
                    <li>
                        <div class="navbar-form">
                            <button class="btn btn-default" type="button" onclick="location.href='{$createthread_link/@href}'">
                                <xsl:value-of select ="$createthread_link/text()" />
                            </button>
                        </div>
                    </li>
                </xsl:when>
            </xsl:choose>

            <!-- show only thread level, caution: checks the chreathread_link! -->
            <xsl:choose>
                <xsl:when test="not($createthread_link)">
                    <li>
                        <div class="navbar-form">
                            <button class="btn btn-default" type="button" onclick="location.href='{$back_link/@href}'">
                                <xsl:value-of select ="$back_link/text()" />
                            </button>
                        </div>
                    </li>
                </xsl:when>
            </xsl:choose>

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

</xsl:stylesheet>