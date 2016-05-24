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
    <!-- <xsl:template match="ul[@id='ilTab']" /> -->

    <!-- Hide the right column -->
    <xsl:template match="div[@id='block_objectsearch_0']" />

    <!-- Hide post related actions -->
    <xsl:template match="li[contains(.//button/@onclick,'print_thread')]" />
    <xsl:template match="a[contains(@href,'print_post')]" />
    <!-- <xsl:template match="a[contains(@href,'action=showreply')]" />
    -->

<!--
    <xsl:template match="ul[contains(@class, 'ilToolbarItems nav navbar-nav')]" >
        <button class="btn btn-default" type="button" onclick="href='#frm_page_top'">
        <xsl:text> Seitenanfang </xsl:text>
        </button>
        <button class="btn btn-default" type="button" onclick="href='#frm_page_top'">
            <xsl:text> Seitenanfang </xsl:text>
        </button>
    </xsl:template>

       <xsl:template match="div[contains(@class, 'navbar-header')]" >
           <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="node()" />
           </xsl:copy>
           <button class="btn btn-default" type="button" onclick="href='#frm_page_top'">
               <xsl:text> Seitenanfang </xsl:text>
           </button>
        </xsl:template>
-->
  <!--  <xsl:template match="a[contains(@href,'markPostUnread')]" />
   <xsl:template match="a[contains(@href,'markPostRead')]" />
-->
    <!-- Hide table navogation settings (e.g. changing of displayed rows) -->
    <!--<xsl:template match="div[contains(@class,'ilTableNav')]//td[contains(@class,'ilRight')]" />
-->
    <!-- Hide thread commands -->
   <xsl:template match="div[contains(@class,'ilTableCommandRow')]" />
   <xsl:template match="div[contains(@class,'ilTableSelectAll')]" />
   <xsl:template match="input[contains(@id,'thread_ids')]" />

    <!--<xsl:template match="nav[contains(@id, '1')]" />
 -->


    <!-- Hide "new reply" splitbutton and separator -->
    <xsl:template match="button[contains(@class, 'btn-primary')]" />
    <xsl:template match="a[contains(@class, 'btn-primary')]" />
    <xsl:template match="li[contains(@class, 'ilToolbarSeparator')]" />

   <!-- <xsl:template match="span[@class='split-btn-default']" />
-->
   <!-- <xsl:template match="a[@class='btn btn-default']" />
    -->
    <!-- Show only link back to forum -->
    <xsl:template match="li[@id='tab_order_by_date']" />
    <xsl:template match="li[@id='tab_sort_by_posts']" />
   <!-- <xsl:template match="div[@class='ilFrmPostCommands']//span[contains(@class, 'split-btn-default')]" />
-->
    <!--<xsl:template match="input[@value='Zitieren']" /> -->
    <!-- <xsl:template match="div[contains(@class, 'navbar-form')]" />
 -->
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
            <xsl:if test="$title">
                <h3><xsl:value-of select="$title" /></h3>
            </xsl:if>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>

    <!-- Adjust the thread toolbar -->
    <!--<xsl:template match="div[contains(@class,'ilTableCommandRowTop')]" /> -->
   <!-- <xsl:template match="li[contains(.//button/@onclick,'mark_read')]" >

             <xsl:variable name="reply_link" select="//a[contains(@href,'action=showreply')][last()]" />
           <xsl:variable name="back_link" select="//ul[@id='ilTab']/li[1]/a" />
           <li>
              <div class="navbar-form">
                  <button class="btn btn-default" type="button" onclick="location.href='{$back_link/@href}'">
                      <xsl:value-of select ="$back_link/text()" />
                  </button>
              </div>
          </li>

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
    </xsl:template>
-->
    <!-- Reduce the visit card
    <xsl:template match="div[./div/@class='ilProfile']">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="div[@class='ilProfile']" />
        </xsl:copy>
    </xsl:template>
    <xsl:template match="div[@class='ilProfile']//a[@class='il_ContainerItemCommand']" />
-->
</xsl:stylesheet>