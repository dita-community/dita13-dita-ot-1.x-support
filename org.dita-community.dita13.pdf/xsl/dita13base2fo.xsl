<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <xsl:template match="*[contains(@class, ' topic/div ')]" priority="-1"
    >
<!--    <xsl:message> + [DEBUG] base template for topic/div: <xsl:value-of select="concat(name(..), '/', name(.))"/></xsl:message>-->
    
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
<!-- Add support the DITA 1.3 table @orient attribute. -->
  
  <!-- org.dita-community: This new attribute-set defines the page rotation behavior. -->
  <xsl:attribute-set name="rotate-page-content">
    <xsl:attribute name="break-before">page</xsl:attribute>
    <xsl:attribute name="break-after">page</xsl:attribute>
    <xsl:attribute name="reference-orientation">90</xsl:attribute>
    <xsl:attribute name="start-indent">0</xsl:attribute>
    <xsl:attribute name="end-indent">0</xsl:attribute>
    <xsl:attribute name="width">auto</xsl:attribute>
  </xsl:attribute-set>
  
  <!-- Override the table template found in org.dita.pdf2/xsl/fo/tables.xsl.
       This override implements rotated table support for @orient="land"
       
       Beware that if you integrate the org.dita-community.dita13.pdf plugin
       with your own customization, and that customization overrides the table template,
       you will need to merge the changes here into your version of the table template.
       This is true because of XSLT template precedence rules.       
  -->
  <xsl:template match="*[contains(@class, ' topic/table ')]">
    <xsl:variable name="scale">
      <xsl:call-template name="getTableScale"/>
    </xsl:variable>
    <!-- org.dita-community: This xsl:choose does not appear in the tables.xsl
         version of this template. The xsl:choose wraps the table fo markup
         inside of a fo:block-container whenerver @orient = "land". The remaining
         fo markup for building the table was factored out into a new template
         called processTable. This was done to avoid repeating the same code twice
         within the xsl:choose.
    -->
    <xsl:choose>
      <xsl:when test="@orient = 'land'">
        <fo:block-container xsl:use-attribute-sets="rotate-page-content">
          <xsl:call-template name="processTable">
            <xsl:with-param name="scale" select="$scale"/>
          </xsl:call-template>
        </fo:block-container>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="processTable">
          <xsl:with-param name="scale" select="$scale"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- org.dita-community: New template used in conjunction with the table template. -->
  <xsl:template name="processTable">
    <xsl:param name="scale"/>
    <fo:block xsl:use-attribute-sets="table">
      <xsl:call-template name="commonattributes"/>
      <xsl:if test="not(@id)">
        <xsl:attribute name="id">
          <xsl:call-template name="get-id"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="not($scale = '')">
        <xsl:attribute name="font-size">
          <xsl:value-of select="concat($scale, '%')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:template>
  
  <!-- org.dita-community: End of table modifications. -->

</xsl:stylesheet>