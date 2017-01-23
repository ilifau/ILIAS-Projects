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

<!-- TESTING -->
    <!-- PNG logo in the top bar -->
    <xsl:template match="div[@id='ilTopBar']//div[@class='row']" >
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <div class="ilTopTitle">
                <img alt="Logo" src="templates/default/images-ehlssa/HeaderIcon.svg" height="40"/>
            </div>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- "Back" and "Overview" button beneath the user drop down -->
    <xsl:template match="ul[@id='ilTopBarNav']" >
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <!-- if user is logged in -->
            <xsl:if test="li[@id='userlog']">
                <li>
                    <a onclick="history.back();return false;">
                        &#9664;
                    </a>
                </li>
                <li>
                    <a onclick="window.location='index.php?senappHome=1';return false;">
                        <xsl:value-of select="php:function('ilSkinTransformer::getTxt','content')" />
                    </a>
                </li>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- No main header, no main menu -->
    <xsl:template match="nav[@id='ilTopNav']" />
    <xsl:template match="div[contains(@class,'ilMainHeader')]" />
    <xsl:template match="div[contains(@class,'ilMainMenu')]" />

    <!-- No locator, No tree view -->
    <xsl:template match="ol[@class='breadcrumb']" />
    <xsl:template match="a[@class='ilTreeView']" />
    <xsl:template match="div[@class='ilLeftNav']" />

    <!-- no (Forum) heading, image -->
    <xsl:template match="div[@class='ilHeaderAlert']" />
    <xsl:template match="img[@id='headerimage']" />
    <xsl:template match="h1[@class='media-heading ilHeader']" />
    <xsl:template match="option[@value='html']" />

    <!-- No footer -->
    <xsl:template match="footer" />

    <!-- Rewriting of links -->
    <xsl:template match="a" >

        <xsl:copy>
            <xsl:copy-of select="@*" />

            <xsl:choose>
                <!-- rename settings link in user dropdown -->
                <xsl:when test="contains(@href,'jumpToProfile')">
                    <xsl:attribute name="onclick">window.location=this.getAttribute("href");return false;</xsl:attribute>
                    <xsl:value-of select="php:function('ilSkinTransformer::getTxt','personal_data')" />
                </xsl:when>

                <!-- change settings link to password in user dropdown -->
                <xsl:when test="contains(@href,'jumpToSettings')">
                    <xsl:attribute name="onclick">window.location='ilias.php?cmd=jumpToPassword&amp;baseClass=ilPersonalDesktopGUI';return false;</xsl:attribute>
                    <xsl:value-of select="php:function('ilSkinTransformer::getTxt','chg_password')" />
                </xsl:when>

                <!-- links without href are just anchors -->
                <xsl:otherwise>
                    <xsl:copy-of select="node()" />
                </xsl:otherwise>
            </xsl:choose>

        </xsl:copy>
    </xsl:template>
    <!-- TESTING END -->

    <!-- Hide the tabs -->
    <xsl:template match="ul[@id='ilTab']" />

    <!-- Hide the right column -->
     <xsl:template match="div[@id='il_right_col']" />

    <!-- Hide post related actions -->
    <!-- <xsl:template match="div[@class='ilFrmPostCommands']" /> -->
    <!--<xsl:template match="div[@class='ilFrmPostCommands']//span[@class='split-btn-default']" />-->
    <xsl:template match="div[@class='ilFrmPostCommands']//a[contains(@href, 'ilforumexportgui')]" />

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

    <!-- make subject invisible in reply form -->
    <xsl:template match="form[not(contains(@action,'addThread'))]//div[@id='il_prop_cont_subject']">
        <input name="subject" type="hidden" value="Reply" />
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

<!-- Reduce the visit card -->
    <xsl:template match="div[./div/@class='ilProfile']">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="div[@class='ilProfile']" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@class='ilProfile']//a[@class='il_ContainerItemCommand']" />

</xsl:stylesheet>