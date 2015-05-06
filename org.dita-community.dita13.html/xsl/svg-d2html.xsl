<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:svg="http://www.w3.org/2000/svg"
  exclude-result-prefixes="xs"
  >
  
  <xsl:template match="*[contains(@class, ' svg-d/svg_container ')]">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class, ' svg-d/svgref ')]" priority="100">
    <!--    <xsl:message> + [DEBUG] svg-d/svgref, href=<xsl:value-of select="@href"/></xsl:message>-->
    <!-- NOTE: For now, not worrying about keyref, although it is allowed -->
    <xsl:variable name="href" select="@href" as="xs:string?"/>
    <xsl:variable name="xtrf" select="(ancestor-or-self::*[@xtrf])[last()]/@xtrf" as="xs:string?"/>
    <xsl:variable name="refContextNode" as="node()?"
      select="if ($xtrf) then document($xtrf) else ."
    />
    <xsl:choose>
      <xsl:when test="not($href)">
        <xsl:message> - [WARN] svgref: No value for @href attribute.</xsl:message>
      </xsl:when>
      <xsl:otherwise>
        
        <xsl:variable name="resourcePart" as="xs:string"
          select="if (contains($href, '#')) then substring-before($href, '#') else $href"
        />
        <!--        <xsl:message> + [DEBUG] svgref: Resource part = "<xsl:value-of select="$resourcePart"/>"</xsl:message>-->
        <xsl:variable name="fragmentId" as="xs:string"
          select="if (contains($href, '#')) then substring-after($href, '#') else ''"
        />
        <!--        <xsl:message> + [DEBUG] svgref: fragmentId = "<xsl:value-of select="$fragmentId"/>"</xsl:message>-->
        <xsl:variable name="svgDoc" as="document-node()?"
          select="document($resourcePart, $refContextNode)"
        />
        <xsl:choose>
          <xsl:when test="not($svgDoc)">
            <xsl:message> - [WARN] svgref: Failed to resolve URI "<xsl:value-of select="$resourcePart"/> to a document.</xsl:message>
          </xsl:when>
          <xsl:otherwise>
            <xsl:choose>
              <xsl:when test="$fragmentId = ''">
                <!-- Root of target document should be an SVG  svg:svg element -->
                <xsl:message> + [INFO] svgref: Processing root of document <xsl:value-of select="document-uri($svgDoc)"/>...</xsl:message>
                <xsl:apply-templates select="$svgDoc/*[1]" mode="validate-svgdoc"/>
              </xsl:when>
              <xsl:otherwise>
                <!-- Fragment ID should be an element ID and should be the ID 
                     of an m:math element:
                  -->
                <xsl:variable name="targetElem" as="element()*" select="$svgDoc//*[@id = $fragmentId]"/>
                <xsl:choose>
                  <xsl:when test="not($targetElem)">
                    <xsl:message> - [WARN] mathmlref: Failed to find element with ID "<xsl:value-of select="$fragmentId"/> in document "<xsl:value-of select="document-uri($svgDoc)"/>"</xsl:message>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:if test="count($targetElem) > 1">
                      <xsl:message> - [WARN] mathmlref: Found <xsl:value-of select="count($targetElem)"/> elements with ID "<xsl:value-of select="$fragmentId"/> in document "<xsl:value-of select="document-uri($svgDoc)"/>". There should be at most one. Using first found.</xsl:message>
                    </xsl:if>
                    <xsl:message> + [INFO] mathmlref: Processing element with ID "<xsl:value-of select="$fragmentId"/>" in document <xsl:value-of select="document-uri($svgDoc)"/>...</xsl:message>
                    <xsl:apply-templates mode="validate-svgdoc" select="$targetElem[1]"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template mode="validate-svgdoc" match="svg:svg" priority="10">
    <!-- Must be good, apply templates in normal mode -->
    <xsl:apply-templates mode="#default" select="."/>
  </xsl:template>
  
  <xsl:template mode="validate-svgdoc" match="*">
    <xsl:message> - [WARN] validate-svgdoc: element <xsl:sequence select="name(.)"/> with ID "<xsl:value-of select="@id"/>" is not an SVG &lt;svg&gt; element. &lt;svgref&gt; must resolve to an &lt;svg&gt; element.</xsl:message>
  </xsl:template>
  
  <xsl:template mode="validate-svgdoc" match="/*" priority="5">
    <xsl:message> - [WARN] validate-svgdoc: Root element <xsl:sequence select="name(.)"/> is not an SVG &lt;svg&gt; element. &lt;svgref&gt; must resolve to an &lt;svg&gt; element.</xsl:message>
  </xsl:template>
    
  <xsl:template match="svg:svg">
    <svg xmlns="http://www.w3.org/2000/svg"      
      >
      <xsl:apply-templates mode="svg"/>
    </svg>
  </xsl:template>
    
  <xsl:template mode="svg" match="*" xmlns="http://www.w3.org/2000/svg">
    <xsl:element name="{local-name(.)}">
      <xsl:apply-templates select="@*, node()" mode="#current"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template mode="svg" match="@*">
    <xsl:sequence select="."/>
  </xsl:template>
  
</xsl:stylesheet>
