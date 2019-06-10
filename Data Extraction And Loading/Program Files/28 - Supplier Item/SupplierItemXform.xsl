<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="/">
    <RadiantDocument>
	  <xsl:attribute name="Name">RadiantSupplierCatalog</xsl:attribute>
      <xsl:call-template name="SupplierCatalog"/>
    </RadiantDocument>
  </xsl:template>

  <xsl:template name="SupplierCatalog">
  <CatalogReference>
      <xsl:attribute name="Mode">
        <xsl:choose>
          <xsl:when test="normalize-space(Mode)"><xsl:value-of select="//Document/RawXMLRow/Mode"/></xsl:when>
          <xsl:otherwise>Update</xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <SupplierReference>
        <xsl:attribute name="SupplierName"><xsl:value-of select="//Document/RawXMLRow/SupplierName"/></xsl:attribute>
        <xsl:attribute name="SupplierIdentifierType">XRefID</xsl:attribute>
        <xsl:attribute name="SupplierIdentifier"><xsl:value-of select="//Document/RawXMLRow/SupplierID"/></xsl:attribute>
      </SupplierReference>
      <RetailerReference>
        <xsl:attribute name="ClientName">Client</xsl:attribute>
        <xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
        <xsl:attribute name="ClientIdentifier">
          <xsl:choose>
            <xsl:when test="normalize-space(ClientID)"><xsl:value-of select="//Document/RawXMLRow/ClientID"/></xsl:when>
            <xsl:otherwise>10000001</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
      </RetailerReference>
    </CatalogReference>
    <SupplierItemList>
      <xsl:for-each select="//Document/RawXMLRow">
		<xsl:if test="normalize-space(Name)">		   
        <SupplierItem>
          <xsl:attribute name="Name"><xsl:value-of select="normalize-space(Name)"/></xsl:attribute>
          <xsl:attribute name="ProductCode"><xsl:value-of select="normalize-space(ProductCode)"/></xsl:attribute>
          <xsl:attribute name="XRefID"><xsl:value-of select="normalize-space(XRefID)"/></xsl:attribute>
          <xsl:if test="normalize-space(InventoryItemExternalID)">
			<xsl:attribute name="InventoryItemExternalID"><xsl:value-of select="normalize-space(InventoryItemExternalID)"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="Status">
            <xsl:choose>
              <xsl:when test="normalize-space(Status)"><xsl:value-of select="Status"/></xsl:when>
              <xsl:otherwise>a</xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:if test="normalize-space(Description)">
            <xsl:attribute name="Description"><xsl:value-of select="normalize-space(Description)"/></xsl:attribute>
          </xsl:if>
          <xsl:attribute name="SupplierItemGroupName"><xsl:value-of select="SupplierItemGroupName"/></xsl:attribute>
          <xsl:attribute name="SupplierPackageUOM">
            <xsl:variable name="spuom" select="substring-before(SupplierPackageUOM, 'PK')"/>
            <xsl:choose>
              <xsl:when test="SupplierPackageUOM = 1">Each</xsl:when>
              <xsl:when test="SupplierPackageUOM = 'Each'">Each</xsl:when>
              <xsl:when test="contains(SupplierPackageUOM, 'PK')">
                <xsl:value-of select="SupplierPackageUOM"/>
              </xsl:when>
              <xsl:otherwise><xsl:value-of select="concat(SupplierPackageUOM, '')"/></xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:attribute name="QuantityFactor"><xsl:value-of select="QuantityFactor"/></xsl:attribute>
          <xsl:if test="normalize-space(AvailabilityStartDate)">
            <xsl:attribute name="AvailabilityStartDate"><xsl:value-of select="AvailabilityStartDate"/></xsl:attribute>
          </xsl:if>
          <!--<xsl:if test="normalize-space(Number)">-->
		<xsl:if test="normalize-space(./Barcode)">		   
		  <BarcodeList>
			<xsl:for-each select="./Barcode">
               <Barcode>
                <xsl:attribute name="TypeCode">
                  <xsl:choose>
                    <xsl:when test="normalize-space(TypeCode)">
                      <xsl:value-of select="TypeCode"/>
                    </xsl:when>
                    <xsl:otherwise>u</xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
                <xsl:attribute name="Number">
                  <xsl:choose>
                    <!-- Check to see if the first char is a single quote.  If so grab the 2nd char til end -->
                    <xsl:when test='substring(Number,1,1) = "&apos;" '>
                      <xsl:value-of select="normalize-space(substring(Number,2))"/>
                    </xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="normalize-space(Number)"/>
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:attribute>
				</Barcode>
			</xsl:for-each>
		</BarcodeList>
		</xsl:if>
		<xsl:if test="normalize-space(./Cost)">		   
			<CostList>
				<xsl:for-each select="./Cost">
					<xsl:if test="normalize-space(CostLevel)">
						<Cost>
							<xsl:attribute name="CostLevel"><xsl:value-of select="CostLevel"/></xsl:attribute>
							<xsl:attribute name="PackageCost"><xsl:value-of select="PackageCost"/></xsl:attribute>
							<xsl:if test="normalize-space(Allowance)">
								<xsl:attribute name="Allowance"><xsl:value-of select="Allowance"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="normalize-space(CostStartDate)">
							<xsl:attribute name="CostStartDate"><xsl:value-of select="CostStartDate"/></xsl:attribute>
							</xsl:if>
							<xsl:if test="normalize-space(CostEndDate)">
							<xsl:attribute name="CostEndDate"><xsl:value-of select="CostEndDate"/></xsl:attribute>
							</xsl:if>
						</Cost>
					</xsl:if>  
				</xsl:for-each>			
			</CostList>
		</xsl:if>
	  </SupplierItem>
	  </xsl:if>
      </xsl:for-each>
    </SupplierItemList>
  </xsl:template>
</xsl:stylesheet>