<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>  
  
  <!-- ROOT -->
  <xsl:template match="/">
    <xsl:element name="RadiantDocument">
	  <xsl:attribute name="Name">RADSupplierInfo</xsl:attribute>
	  <xsl:attribute name="ClientID">10000001</xsl:attribute>
	  <xsl:attribute name="LocalizationCodeName">US</xsl:attribute>
	  <xsl:attribute name="Version"><xsl:value-of select="//Document/@Version"/></xsl:attribute>
	  <xsl:attribute name="Batch">99999999</xsl:attribute>
	  <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
      <xsl:attribute name="CreationTimestamp"><xsl:value-of select="//Document/@CreationTimestamp"/></xsl:attribute>
  	<xsl:call-template name="SupplierList"/>
    </xsl:element>
  </xsl:template>
  
  <!-- Suppliers -->
  <xsl:template name="SupplierList">
      <xsl:for-each select="//Document/RawXMLRow">
      <Supplier>
	  
	    <xsl:attribute name="XRefCode"><xsl:value-of select="XRefCode"/></xsl:attribute>
        <xsl:attribute name="Name"><xsl:value-of select="Name"/></xsl:attribute>
        <xsl:attribute name="Description"><xsl:value-of select="Description"/></xsl:attribute>
        <xsl:attribute name="StatusCode"><xsl:value-of select="StatusCode"/></xsl:attribute>
        <xsl:attribute name="SupplierType"><xsl:value-of select="SupplierType"/></xsl:attribute>
        <xsl:if test="VendorAPCode != ''">
          <xsl:attribute name="VendorAPCode"><xsl:value-of select="VendorAPCode"/></xsl:attribute>
        </xsl:if>
        <xsl:if test="EDINumber != ''">
          <xsl:attribute name="EDINumber"><xsl:value-of select="EDINumber"/></xsl:attribute>
        </xsl:if>
        <xsl:attribute name="CatalogReviewFlag"><xsl:value-of select="CatalogReviewFlag"/></xsl:attribute>
		<Address>
		<xsl:attribute name="AddressLine1"><xsl:value-of select="AddressLine1"/></xsl:attribute>
          <xsl:if test="normalize-space(AddressLine2)">
			<xsl:attribute name="AddressLine2"><xsl:value-of select="AddressLine2"/></xsl:attribute>
	      </xsl:if>		
          <xsl:attribute name="City"><xsl:value-of select="City"/></xsl:attribute>
          <xsl:attribute name="State"><xsl:value-of select="State"/></xsl:attribute>
          <xsl:attribute name="PostalCode"><xsl:value-of select="PostalCode"/></xsl:attribute>
          <xsl:attribute name="CountryCode"><xsl:value-of select="CountryCode"/></xsl:attribute>
          <xsl:if test="normalize-space(Phone)">
            <xsl:attribute name="Phone"><xsl:value-of select="Phone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(CellPhone)">
            <xsl:attribute name="CellPhone"><xsl:value-of select="CellPhone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(Fax)">
            <xsl:attribute name="Fax"><xsl:value-of select="Fax"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(Pager)">
            <xsl:attribute name="Pager"><xsl:value-of select="Pager"/></xsl:attribute>
          </xsl:if>
		</Address>	
        <xsl:if test="normalize-space(TermsAndConditions)">
		<TermsAndConditions>
        <xsl:value-of select="TermsAndConditions"/>
	       </TermsAndConditions>
	    </xsl:if>
      </Supplier>
      </xsl:for-each>
  </xsl:template>
 
</xsl:stylesheet>