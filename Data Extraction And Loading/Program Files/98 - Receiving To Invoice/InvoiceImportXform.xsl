<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="/">
    <RadiantDocument>
      <xsl:call-template name="InvoiceList"/>
    </RadiantDocument>
  </xsl:template>

  <xsl:template name="InvoiceList">
    <InvoiceList>
      <xsl:for-each select="//Document/RawXMLRow">
        <Invoice>
			<xsl:attribute name="InvoiceNumber"><xsl:value-of select="invoiceRefNumber"/></xsl:attribute>
			<xsl:attribute name="InvoiceDate"><xsl:value-of select="invoiceDate"/></xsl:attribute>
			<SupplierData>
				<xsl:attribute name="SupplierEDINumber"><xsl:value-of select="supplierEDINumber"/></xsl:attribute>
			</SupplierData>
			<ItemList>
			<xsl:for-each select="./ItemList">
				<Item>
					<xsl:attribute name="ProductCode"><xsl:value-of select="ProductCode"/></xsl:attribute>
					<xsl:attribute name="Quantity"><xsl:value-of select="Quantity"/></xsl:attribute>
					<xsl:attribute name="Cost"><xsl:value-of select="Cost"/></xsl:attribute>
				</Item>	
			</xsl:for-each>
			</ItemList>
        </Invoice>
      </xsl:for-each>
    </InvoiceList>
  </xsl:template>
 </xsl:stylesheet>