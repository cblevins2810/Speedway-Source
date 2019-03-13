<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="/">
    <EnterpriseDocument>
      <xsl:attribute name="InterfaceName">RetailPriceChangeImport</xsl:attribute>
	  <xsl:attribute name="Version">1.0</xsl:attribute>
      <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
      <xsl:attribute name="CreationTimestamp">2018-07-29</xsl:attribute>
      <xsl:call-template name="PriceEvent"/>
    </EnterpriseDocument>
  </xsl:template>

  <xsl:template name="PriceEvent">
    <RetailerReference>
      <xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
      <xsl:attribute name="ClientIdentifier">10000001</xsl:attribute>
    </RetailerReference>
	<EventReference>
		<xsl:attribute name="eventName"><xsl:value-of select="//Document/RawXMLRow/eventName"/></xsl:attribute>
		<xsl:attribute name="startDate"><xsl:value-of select="//Document/RawXMLRow/startDate"/></xsl:attribute>
		<xsl:if test="normalize-space(endDate)">
			<xsl:attribute name="endDate"><xsl:value-of select="//Document/RawXMLRow/endDate"/></xsl:attribute>
		</xsl:if>	
	</EventReference>
    <ItemList>
      <xsl:for-each select="//Document/RawXMLRow">
        <Item>
			<xsl:attribute name="itemXRefID"><xsl:value-of select="itemXRefID"/></xsl:attribute>
			<xsl:attribute name="retailStrategy"><xsl:value-of select="retailStrategy"/></xsl:attribute>
			<RetailModifiedItemList>
			<xsl:for-each select="./RetailModifiedItem">
				<RetailModifiedItem>
					<xsl:attribute name="XRefID"><xsl:value-of select="XRefID"/></xsl:attribute>
					<xsl:attribute name="retailLevelGroup"><xsl:value-of select="retailLevelGroup"/></xsl:attribute>
					<RetailLevelList>
					<xsl:for-each select="./RetailLevel">
						<RetailLevel>
							<xsl:attribute name="retailLevelName"><xsl:value-of select="retailLevelName"/></xsl:attribute>
							<xsl:attribute name="retailType"><xsl:value-of select="retailType"/></xsl:attribute>
							<xsl:attribute name="listRetail"><xsl:value-of select="listRetail"/></xsl:attribute>
						</RetailLevel>
					</xsl:for-each>
					</RetailLevelList>
				</RetailModifiedItem>
			</xsl:for-each>
			</RetailModifiedItemList>
        </Item>
      </xsl:for-each>
    </ItemList>
  </xsl:template>
 </xsl:stylesheet>