<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:m="http://www.w3.org/1998/Math/MathML"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:local="urn:namespace:functions:local"

  exclude-result-prefixes="xs m local"
  >
  <!-- MathML elements to HTML -->
  
  <xsl:template match="*[contains(@class, ' mathml-d/mathml ')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' mathml-d/mathmlref ')]" priority="100">
    <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
        
    <xsl:variable name="doDebug" as="xs:boolean" select="true()"/>    
    <xsl:if test="$doDebug">
      <xsl:message> + [DEBUG] #default: <xsl:value-of select="concat(name(..), '/', name(.))"/>: Handling mathmlref...</xsl:message>
    </xsl:if>
    
    <xsl:choose>
      <xsl:when test="not(@href) and not(@keyref)">
        <xsl:message> - [WARN] mathmlref: No value for @href or @keyref attribute.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:variable name="mathmlDoc" as="document-node()?"
          select="local:resolveRefToDocument(.)"
        />
        <xsl:variable name="fragmentId" as="xs:string?"
          select="local:getFragmentIDForXRef(.)"
        />

        <xsl:choose>
          <xsl:when test="$fragmentId = ''">
            <!-- Root of target document should be a MathML m:math element -->
            <xsl:message> + [INFO] mathmlref: Processing root of document <xsl:value-of select="document-uri($mathmlDoc)"/>...</xsl:message>
            <xsl:apply-templates select="$mathmlDoc/*[1]" mode="validate-mathmldoc"/>
          </xsl:when>
          <xsl:otherwise>
            <!-- Fragment ID should be an element ID and should be the ID 
                 of an m:math element:
              -->
            <xsl:variable name="targetElem" as="element()*" select="$mathmlDoc//*[@id = $fragmentId]"/>
            <xsl:choose>
              <xsl:when test="not($targetElem)">
                <xsl:message> - [WARN] mathmlref: Failed to find element with ID "<xsl:value-of select="$fragmentId"/> in document "<xsl:value-of select="document-uri($mathmlDoc)"/>"</xsl:message>
              </xsl:when>
              <xsl:otherwise>
                <xsl:if test="count($targetElem) > 1">
                  <xsl:message> - [WARN] mathmlref: Found <xsl:value-of select="count($targetElem)"/> elements with ID "<xsl:value-of select="$fragmentId"/> in document "<xsl:value-of select="document-uri($mathmlDoc)"/>". There should be at most one. Using first found.</xsl:message>
                </xsl:if>
                <xsl:message> + [INFO] mathmlref: Processing element with ID "<xsl:value-of select="$fragmentId"/>" in document <xsl:value-of select="document-uri($mathmlDoc)"/>...</xsl:message>
                <xsl:apply-templates mode="validate-mathmldoc" select="$targetElem[1]"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="validate-mathmldoc" match="m:math" priority="10">
    <!-- Must be good, apply templates in normal mode -->
    <xsl:apply-templates mode="#default" select="."/>
  </xsl:template>
  
  <xsl:template mode="validate-mathmldoc" match="*">
    <xsl:message> - [WARN] validate-mathmldoc: element <xsl:sequence select="name(.)"/> with ID "<xsl:value-of select="@id"/>" is not a MathML &lt;math&gt; element. &lt;mathmlref&gt; must resolve to a &lt;math&gt; element.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="validate-mathmldoc" match="/*" priority="5">
    <xsl:message> - [WARN] validate-mathmldoc: Root element <xsl:sequence select="name(.)"/> is not a MathML &lt;math&gt; element. &lt;mathmlref&gt; must resolve to a &lt;math&gt; element.</xsl:message>
  </xsl:template>
  
    <xsl:template match="m:math">
    <xsl:param name="blockOrInline" as="xs:string" tunnel="yes" select="'inline'"/>
    <fo:instream-foreign-object>
      <m:math      
        >
        <xsl:if test="$blockOrInline = 'block'">
          <xsl:attribute name="display" select="'block'"/>
        </xsl:if>
        <xsl:sequence select="node()"/><!-- Just copy the math to the output -->
      </m:math>
    </fo:instream-foreign-object>
  </xsl:template>
  
  
</xsl:stylesheet>
