<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt">
  <xsl:output omit-xml-declaration="no" />

  <xsl:key name="BUIdentifierGrouping" match="RawXMLRow" use="BUIdentifier" />
  
  <xsl:template match="Document">
  
  <EnterpriseDocument>
      <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
      <xsl:attribute name="Version">1.0</xsl:attribute>
	  <xsl:attribute name="InterfaceName">Business Unit Retail Price Import</xsl:attribute>
	  <xsl:attribute name="CreationTimestamp">2018-08-10T21:00:00</xsl:attribute>
      	
      <xsl:call-template name="Item"/>
	  
		<BusinessUnitList>

			<!-- Now, we need to iterate on the BUIdentifiers, This can be done by iterating on the first XML Row item 
				 for each BUIdentifier. We will do that by create a node  for the current Row item (.) and the first 
				 item in the Key of the Current item  BUIdentifier. Then we check the count to see is it 1 or 2.. 
				 If 1, So we've the same item in the node set; We have a new BUIdentifier.-->
			<xsl:for-each select="RawXMLRow[count(. | key('BUIdentifierGrouping', BUIdentifier)[1]) = 1]">
				<xsl:sort select="BUIdentifier" />
			  
				<BusinessUnit>
					<xsl:attribute name="BUIdentifierType">BUCode</xsl:attribute> 
					<xsl:attribute name="BUIdentifier"><xsl:value-of select="BUIdentifier"/></xsl:attribute>       
				
						<!-- Now loop on the items of this BUIdentifier, 
						We get them from the Key we defined -->
							<RetailPriceList>
							<xsl:for-each select="key('BUIdentifierGrouping', BUIdentifier)">
								<xsl:sort select="BUIdentifier" />
									<xsl:call-template name="RetailPriceList"/>
							</xsl:for-each>
							</RetailPriceList>
				</BusinessUnit>

			</xsl:for-each>
	
		</BusinessUnitList>
	</EnterpriseDocument>
  </xsl:template>
  
  <!-- Client Info -->
  <xsl:template name="Item">
    <RetailerReference>
	  <xsl:attribute name="ClientIdentifier">10000001</xsl:attribute>
      <xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
    </RetailerReference>
  </xsl:template>
	
<!-- Retail Price List -->
<xsl:template name="RetailPriceList" match="BUIdentifier">
    <ListRetail>
		<xsl:attribute name="retailPrice"><xsl:value-of select="retailPrice"/></xsl:attribute>
		<xsl:attribute name="itemName"><xsl:value-of select="itemName"/></xsl:attribute>
		<xsl:attribute name="itemRetailPackXRefID"><xsl:value-of select="itemRetailPackXRefID"/></xsl:attribute>
		<xsl:attribute name="startDate"><xsl:value-of select="startDate"/></xsl:attribute>
		<xsl:if test="endDate != ''">
			<xsl:attribute name="endDate"><xsl:value-of select="endDate"/></xsl:attribute>
		</xsl:if>
	</ListRetail>	
</xsl:template>

</xsl:stylesheet>