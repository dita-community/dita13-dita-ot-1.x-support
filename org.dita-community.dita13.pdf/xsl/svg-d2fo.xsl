<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  exclude-result-prefixes="xs"
>  
    
 <!-- ======================================================= 
   
      FO output support for the DITA 1.3 SVG domain
   
      ======================================================= -->
   
  <xsl:template match="*[contains(@class, ' svg-d/svg_container ')]">
    <xsl:apply-templates/>
  </xsl:template>  
  
  
  <xsl:template match="svg:svg">
    <fo:instream-foreign-object>
      <xsl:apply-templates mode="copy-svg" select="."/>
    </fo:instream-foreign-object>    
  </xsl:template>
  
  <xsl:template mode="copy-svg" match="svg:*">
    <xsl:copy>
      <xsl:apply-templates select="@*,node()" mode="#current"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="copy-svg" match="*" priority="-1">
    <!-- Suppress non-SVG elements within the SVG content. This may not
         be 100% appropriate but it's good enough for now.
      -->
  </xsl:template>
  
  <xsl:template mode="copy-svg" match="@* | processing-instruction() | text()">
    <xsl:sequence select="."/>
  </xsl:template>

  
</xsl:stylesheet>
