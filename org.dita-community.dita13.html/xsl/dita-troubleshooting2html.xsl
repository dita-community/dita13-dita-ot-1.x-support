<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  exclude-result-prefixes="xs"
  >
 <!--  HTML output support for the DITA 1.3 Troubleshooting topic type and troubleshooting
       domain.
   -->
   
   <xsl:template match="*[contains(@class, ' topic/note ')][@type = 'trouble']" mode="process.note">
    <xsl:apply-templates select="." mode="process.note.common-processing">
  
  <xsl:with-param name="type" select="string(@type)"/>
    </xsl:apply-templates>
  </xsl:template>
  
  <!-- org.dita-community: If you integrate the org.dita-community.dita13.xhtml plugin
       with your own xhtml customization, and that customization overrides
       process.note.common-processing, you will need to merge the changes in the following
       template into your version of process.note.common-processing.
       This is true because of XSLT template precedence rules. -->
  <xsl:template match="*" mode="process.note.common-processing">
    <xsl:param name="type" select="@type"/>
    <xsl:param name="title">
      <xsl:call-template name="getString">
        <!-- For the parameter, turn "note" into "Note", caution => Caution, etc -->
        <xsl:with-param name="stringName"
          select="
            concat(translate(substring($type, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'),
            substring($type, 2))"
        />
      </xsl:call-template>
    </xsl:param>
    <div class="{$type}">
    
    <xsl:call-template name="commonattributes">
        <xsl:with-param name="default-output-class" select="$type"/>
  </xsl:call-template>
      <xsl:call-template name="setidaname"/>
      <!-- Normal flags go before the generated title; revision flags only go on the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/prop" mode="ditaval-outputflag"/>
      <!-- org.dita-community: Hard-code notetitle as a fallback to troubletitle. If you use the CSS DITA-OT extension
           you can add a style rule for the troubletitle class. -->
      <span class="{$type}title notetitle">
    <xsl:value-of select="$title"/>
    <!-- org.dita-community: Suppress the ColonSymbol for "trouble" -->
  <xsl:if test="not($type = 'trouble')">
          <xsl:call-template name="getString">
            <xsl:with-param name="stringName" select="'ColonSymbol'"/>
          </xsl:call-template>
        </xsl:if>
      </span>
<xsl:text> </xsl:text>
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-startprop ')]/revprop"
        mode="ditaval-outputflag"/>
      <xsl:apply-templates/>
      <!-- Normal end flags and revision end flags both go out after the content. -->
      <xsl:apply-templates select="*[contains(@class, ' ditaot-d/ditaval-endprop ')]" mode="out-of-line"/>
    </div>

</xsl:template>

<!-- *** Templates for troubleshooting topic *** -->

  <!-- No autogenerated title for steps or steps-unordered when either is a child of remedy -->
  <xsl:template
    match="*[contains(@class, ' troubleshooting/remedy ')]
    /*[contains(@class, ' task/steps ') or contains(@class, ' task/steps-unordered ')]"
    mode="common-processing-within-steps">
    <xsl:param name="step_expand"/>
    <xsl:param name="list-type">
      <xsl:choose>
        <xsl:when test="contains(@class, ' task/steps ')">ol</xsl:when>
        <xsl:otherwise>ul</xsl:otherwise>
      </xsl:choose>
    </xsl:param>
    <!-- org.dita-community: generate-task-label processing has been removed from here. -->
    <xsl:choose>
      <xsl:when test="*[contains(@class, ' task/step ')] and not(*[contains(@class, ' task/step ')][2])">
        <!-- Single step. Process any stepsection before the step (cannot appear after). -->
        <xsl:apply-templates select="*[contains(@class, ' task/stepsection ')]"/>
        <xsl:apply-templates select="*[contains(@class, ' task/step ')]" mode="onestep">
          <xsl:with-param name="step_expand" select="$step_expand"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="not(*[contains(@class, ' task/stepsection ')])">
        <xsl:apply-templates select="." mode="step-elements-with-no-stepsection">
          <xsl:with-param name="step_expand" select="$step_expand"/>
          <xsl:with-param name="list-type" select="$list-type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when
        test="*[1][contains(@class, ' task/stepsection ')] and not(*[contains(@class, ' task/stepsection ')][2])">
        <!-- Stepsection is first, no other appearances -->
        <xsl:apply-templates select="*[contains(@class, ' task/stepsection ')]"/>
        <xsl:apply-templates select="." mode="step-elements-with-no-stepsection">
          <xsl:with-param name="step_expand" select="$step_expand"/>
          <xsl:with-param name="list-type" select="$list-type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:otherwise>
        <!-- Stepsection elements mixed in with steps -->
        <xsl:apply-templates select="." mode="step-elements-with-stepsection">
          <xsl:with-param name="step_expand" select="$step_expand"/>
          <xsl:with-param name="list-type" select="$list-type"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- Suppress responsibleParty -->
  <xsl:template match="*[contains(@class, ' troubleshooting/responsibleParty ')]" priority="1">
    <!-- suppress it -->
  </xsl:template>

  <!-- *** Template for task-related troubleshooting *** -->

  <!-- This template renders tasktroubleshooting and steptroubleshooting
       as if they were note type="trouble".
  -->
  <xsl:template
    match="
      *[contains(@class, ' task/steptroubleshooting ')
      or contains(@class, ' task/tasktroubleshooting ')]"
    priority="5">
    <xsl:apply-templates select="." mode="process.note.common-processing">
      <xsl:with-param name="type" select="'trouble'"/>
    </xsl:apply-templates>
  </xsl:template>

</xsl:stylesheet>
