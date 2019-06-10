<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>  
  
  <!-- ROOT -->
  <xsl:template match="Document">
    <xsl:element name="RadiantDocument">
	  <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
	  <xsl:attribute name="Name">Org Hierarchy Import</xsl:attribute>
	  <xsl:attribute name="Version"><xsl:value-of select="//Document/@Version"/></xsl:attribute>
      <xsl:attribute name="CreationTimestamp"><xsl:value-of select="//Document/@CreationTimestamp"/></xsl:attribute>
      <xsl:call-template name="OrgHierarchyList"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Org Hierarchy Nodes -->
  <xsl:template name="OrgHierarchyList">
    <OrgHierarchyList>
      <xsl:for-each select="//Document/RawXMLRow">
      <OrgHierarchy>
        <xsl:attribute name="Name"><xsl:value-of select="Name"/></xsl:attribute>
        <xsl:attribute name="LongName"><xsl:value-of select="LongName"/></xsl:attribute>
        <xsl:attribute name="ParentOrgHierarchyName"><xsl:value-of select="ParentOrgHierarchyName"/></xsl:attribute>
        <xsl:attribute name="OrgHierarchyLevelName"><xsl:value-of select="OrgHierarchyLevelName"/></xsl:attribute>
       </OrgHierarchy>
      </xsl:for-each>
    </OrgHierarchyList>
  </xsl:template>
  
</xsl:stylesheet>