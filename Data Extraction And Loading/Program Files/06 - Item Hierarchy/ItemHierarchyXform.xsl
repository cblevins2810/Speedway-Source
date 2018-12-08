<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="Document">
  <InterfaceDocument Mode="Complete" InterfaceName="ItemCategoryImport">
	      <xsl:call-template name="ItemHierarchyList"/>
  </InterfaceDocument>
  </xsl:template>

  <!-- Item Hierarchy Nodes -->
  <xsl:template name="ItemHierarchyList">
    <RetailerReference>
      <xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
      <xsl:attribute name="ClientIdentifier">1000102</xsl:attribute>
    </RetailerReference>
    <ItemCategoryList>
      <xsl:for-each select="//Document/RawXMLRow">
      <ItemCategory>
        <xsl:attribute name="ExternalID"><xsl:value-of select="ExternalID"/></xsl:attribute>
        <xsl:attribute name="CategoryName"><xsl:value-of select="CategoryName"/></xsl:attribute>
        <xsl:attribute name="CategoryLevel"><xsl:value-of select="CategoryLevel"/></xsl:attribute>
        <xsl:attribute name="ParentCategoryExternalID"><xsl:value-of select="ParentCategoryExternalID"/></xsl:attribute>
		<xsl:attribute name="NonTaxable"><xsl:value-of select="NonTaxable"/></xsl:attribute>
       </ItemCategory>
      </xsl:for-each>
    </ItemCategoryList>
  </xsl:template>
  
</xsl:stylesheet>