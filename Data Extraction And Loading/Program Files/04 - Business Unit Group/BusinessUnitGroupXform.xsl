<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="Document">
  <EnterpriseDocument InterfaceName="BusinessUnitGroupImport" >
      <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
      <xsl:attribute name="Version">1.0</xsl:attribute>
      <xsl:attribute name="CreationTimestamp">2007-02-04T00:00:00</xsl:attribute>
  <xsl:call-template name="BusinessUnitGroupList"/>
  </EnterpriseDocument>
  </xsl:template>

  <!-- Supplier Assignment Nodes -->
  <xsl:template name="BusinessUnitGroupList">
    <BusinessUnitGroupList >
      <xsl:for-each select="//Document/RawXMLRow">
       <BusinessUnitGroup>
	   		<xsl:attribute name="groupCode"><xsl:value-of select="GroupCode"/></xsl:attribute>
			<xsl:attribute name="groupName"><xsl:value-of select="GroupName"/></xsl:attribute>
			<xsl:if test="normalize-space(Description)">	
				<xsl:attribute name="groupDescription"><xsl:value-of select="normalize-space(Description)"/></xsl:attribute>
			</xsl:if>
			<xsl:attribute name="groupTypeCode"><xsl:value-of select="TypeCode"/></xsl:attribute>
			<xsl:attribute name="transferGroupFlag"><xsl:value-of select="TransferFlag"/></xsl:attribute>
			<BusinessUnitList>
			<xsl:for-each select="./BusinessUnit">		
				<BusinessUnit>
					<xsl:attribute name="BUIdentifier"><xsl:value-of select="BusinessUnitCode"/></xsl:attribute>
					<xsl:attribute name="Assign"><xsl:value-of select="Action"/></xsl:attribute>
				</BusinessUnit>
			</xsl:for-each>
		</BusinessUnitList>
       </BusinessUnitGroup>
      </xsl:for-each>
    </BusinessUnitGroupList>
  </xsl:template>
</xsl:stylesheet>
