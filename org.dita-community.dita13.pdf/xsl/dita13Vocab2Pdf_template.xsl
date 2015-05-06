<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
  exclude-result-prefixes="xs xd"
  version="2.0">
  <!-- =====================================================
       Top-level XSLT Module for DITA 1.3 FO support
       
       Copyright (c) DITA Community
       ===================================================== -->
  
  <xsl:include href="dita13base2fo.xsl"/>
  <xsl:include href="dita-troubleshooting2fo.xsl"/>
  <xsl:include href="equation-d2fo.xsl"/>
  <xsl:include href="learning2domain2fo.xsl"/>
  <xsl:include href="mathml-d2fo.xsl"/>
  <xsl:include href="svg-d2fo.xsl"/>
  <xsl:include href="xml-d2fo.xsl"/>
  
  <dita:extension id="xsl.dita13pdf" 
    behavior="org.dita.dost.platform.ImportXSLAction" 
    xmlns:dita="http://dita-ot.sourceforge.net"/>

</xsl:stylesheet>