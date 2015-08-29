<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  xmlns:relpath="http://dita2indesign/functions/relpath"
  exclude-result-prefixes="xs xd relpath"
  version="2.0">
  
  <!-- Test of the document-uri() function under OS X and Windows -->  
  
  <xsl:import href="relpath_util.xsl"/>
  
  <xsl:output indent="yes"/>
  
  <xsl:param name="tempdir" as="xs:string" select="'tempdir-not-set'"/>
  
  <xsl:template match="/">
    <xsl:variable name="keydefsPath" as="xs:string" 
      select="relpath:newFile(relpath:toUrl($tempdir), 'keydef.xml')"
    />
    <xsl:message> + [DEBUG] keydefsPath="<xsl:value-of select="$keydefsPath"/>"</xsl:message>
    <xsl:variable name="keydefsDoc" as="document-node()?"
      select="document(relpath:toUrl($keydefsPath))"
    />
    <xsl:variable name="document-uri-result" as="xs:string"
      select="if (boolean($keydefsDoc)) then document-uri($keydefsDoc) else 'Keydefs doc not loaded'"
    />
    <result>
      <item>keydefsPath="<xsl:value-of select="$keydefsPath"/>"</item>
      <item>keydefsDoc exists="<xsl:value-of select="boolean($keydefsDoc)"/></item>
      <item>document-uri-result="<xsl:value-of select="$document-uri-result"/>"</item>
    </result>
  </xsl:template>
  
</xsl:stylesheet>