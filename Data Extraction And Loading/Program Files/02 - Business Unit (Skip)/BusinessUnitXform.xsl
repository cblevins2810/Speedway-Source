<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>  
  
  <!-- ROOT -->
  <xsl:template match="/">
    <xsl:element name="RadiantDocument">
	  <xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
	  <xsl:attribute name="Name">BU Import</xsl:attribute>
	  <xsl:attribute name="Version"><xsl:value-of select="//Document/@Version"/></xsl:attribute>
      <xsl:attribute name="CreationTimestamp"><xsl:value-of select="//Document/@CreationTimestamp"/></xsl:attribute>
  	<xsl:call-template name="BusinessUnitList"/>
    </xsl:element>
  </xsl:template>
  
  <!-- BusinessUnits -->
  <xsl:template name="BusinessUnitList">
    <BusinessUnitList>
      <xsl:for-each select="//Document/RawXMLRow">
      <BusinessUnit>
        <xsl:attribute name="Name"><xsl:value-of select="Name"/></xsl:attribute>
        <xsl:attribute name="LongName"><xsl:value-of select="LongName"/></xsl:attribute>
        <xsl:attribute name="Status"><xsl:value-of select="Status"/></xsl:attribute>
        <xsl:attribute name="TimeZoneId"><xsl:value-of select="TimeZoneId"/></xsl:attribute>
        <xsl:attribute name="StartDate"><xsl:value-of select="StartDate"/></xsl:attribute>
		<xsl:attribute name="WorkdayProfileName"><xsl:value-of select="WorkdayProfileName"/></xsl:attribute>
        <xsl:if test="EDINumber != ''">
          <xsl:attribute name="EDINumber"><xsl:value-of select="EDINumber"/></xsl:attribute>
        </xsl:if>
        <MailingAddress>
          <xsl:attribute name="AddressLine1"><xsl:value-of select="MailingAddressLine1"/></xsl:attribute>
          <xsl:if test="normalize-space(MailingAddressLine2)">
			<xsl:attribute name="AddressLine2"><xsl:value-of select="MailingAddressLine2"/></xsl:attribute>
	      </xsl:if>		
          <xsl:attribute name="City"><xsl:value-of select="MailingCity"/></xsl:attribute>
          <xsl:attribute name="StateCode"><xsl:value-of select="MailingStateCode"/></xsl:attribute>
          <xsl:attribute name="PostalCode"><xsl:value-of select="MailingPostalCode"/></xsl:attribute>
          <xsl:attribute name="CountryCode"><xsl:value-of select="MailingCountryCode"/></xsl:attribute>
          <xsl:if test="normalize-space(MailingHomePhone)">
            <xsl:attribute name="HomePhone"><xsl:value-of select="MailingHomePhone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(MailingWorkPhone)">
            <xsl:attribute name="WorkPhone"><xsl:value-of select="MailingWorkPhone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(MailingFaxNumber)">
            <xsl:attribute name="FaxNumber"><xsl:value-of select="MailingFaxNumber"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(MailingEMail)">
            <xsl:attribute name="EMail"><xsl:value-of select="MailingEMail"/></xsl:attribute>
          </xsl:if>
        </MailingAddress>
	    <BillingAddress>
          <xsl:attribute name="AddressLine1"><xsl:value-of select="BillingAddressLine1"/></xsl:attribute>
          <xsl:if test="normalize-space(BillingAddressLine2)">
			<xsl:attribute name="AddressLine2"><xsl:value-of select="BillingAddressLine2"/></xsl:attribute>
	      </xsl:if>		
          <xsl:attribute name="City"><xsl:value-of select="BillingCity"/></xsl:attribute>
          <xsl:attribute name="StateCode"><xsl:value-of select="BillingStateCode"/></xsl:attribute>
          <xsl:attribute name="PostalCode"><xsl:value-of select="BillingPostalCode"/></xsl:attribute>
          <xsl:attribute name="CountryCode"><xsl:value-of select="BillingCountryCode"/></xsl:attribute>
          <xsl:if test="normalize-space(BillingHomePhone)">
            <xsl:attribute name="HomePhone"><xsl:value-of select="BillingHomePhone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(BillingWorkPhone)">
            <xsl:attribute name="WorkPhone"><xsl:value-of select="BillingWorkPhone"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(BillingFaxNumber)">
            <xsl:attribute name="FaxNumber"><xsl:value-of select="BillingFaxNumber"/></xsl:attribute>
          </xsl:if>
          <xsl:if test="normalize-space(BillingEMail)">
            <xsl:attribute name="EMail"><xsl:value-of select="BillingEMail"/></xsl:attribute>
          </xsl:if>
        </BillingAddress>
      </BusinessUnit>
      </xsl:for-each>
    </BusinessUnitList>
  </xsl:template>
</xsl:stylesheet>