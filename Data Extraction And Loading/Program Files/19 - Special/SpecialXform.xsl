<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

<!-- ROOT -->
<xsl:template match="/">
	<EnterpriseDocument>
		<xsl:attribute name="InterfaceName">ManageSpecialsImport</xsl:attribute>
		<xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
		<xsl:attribute name="Version"><xsl:value-of select="//Document/@Version"/></xsl:attribute>
		<xsl:attribute name="CreationTimestamp"><xsl:value-of select="//Document/@CreationTimestamp"/></xsl:attribute>
		<xsl:call-template name="Special"/>
    </EnterpriseDocument>
</xsl:template>

<xsl:template name="Special">
	<RetailerReference>
		<xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
		<xsl:attribute name="ClientIdentifier">10000001</xsl:attribute>
    </RetailerReference>
    <SpecialList>
		<xsl:for-each select="//Document/RawXMLRow[specialName != '']">
			<Special>
				<xsl:attribute name="specialName"><xsl:value-of select="specialName"/></xsl:attribute>
				<xsl:attribute name="specialXRefID"><xsl:value-of select="specialXRefID"/></xsl:attribute>
				<xsl:attribute name="specialReceiptText"><xsl:value-of select="specialReceiptText"/></xsl:attribute>
				<xsl:attribute name="priorityRanking"><xsl:value-of select="priorityRanking"/></xsl:attribute>
				<xsl:attribute name="startDate"><xsl:value-of select="startDate"/></xsl:attribute>
				<xsl:if test="normalize-space(endDate)">
					<xsl:attribute name="endDate"><xsl:value-of select="endDate"/></xsl:attribute>
				</xsl:if>
				<QualifierList>
				<xsl:for-each select="./Qualifier">
					<Qualifier>
						<xsl:attribute name="retailItemGroupName"><xsl:value-of select="retailItemGroupName"/></xsl:attribute>
						<xsl:attribute name="minimumIdentifier"><xsl:value-of select="minimumIdentifier"/></xsl:attribute>
						<xsl:attribute name="minimumValue"><xsl:value-of select="minimumValue"/></xsl:attribute>
						<xsl:attribute name="discountType"><xsl:value-of select="discountType"/></xsl:attribute>
						<xsl:attribute name="discountValue"><xsl:value-of select="discountValue"/></xsl:attribute>
						<xsl:attribute name="taxReduced"><xsl:value-of select="taxReduced"/></xsl:attribute>
					</Qualifier>
				</xsl:for-each>

				</QualifierList>	  
			</Special>
		</xsl:for-each>
    </SpecialList>
 </xsl:template>
 </xsl:stylesheet>