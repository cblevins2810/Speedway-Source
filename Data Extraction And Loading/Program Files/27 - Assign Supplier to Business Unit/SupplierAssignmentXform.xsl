<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

  <!-- ROOT -->
  <xsl:template match="Document">
  <InterfaceDocument InterfaceName="SupplierAssignmentImport"  Mode="Update" >
	<RetailerReference ClientIdentifierType="ClientID" ClientIdentifier="10000001"/>
	<OrgUnitIdentification OrgUnitType="BusinessUnit" OrgUnitLookupValue="Code"/>
	<AssignmentIdentification SupplierAssignmentLookupValue="XRefID"/>
    <xsl:call-template name="OrgUnitList"/>
  </InterfaceDocument>
  </xsl:template>

  <!-- Supplier Assignment Nodes -->
  <xsl:template name="OrgUnitList">
    <OrgUnitList>
      <xsl:for-each select="//Document/RawXMLRow">
       <OrgUnit>
	   <xsl:attribute name="OrgUnitIdentifier"><xsl:value-of select="BusinessUnitName"/></xsl:attribute>
		<AssignmentList>
			<xsl:for-each select="./Assignment">		
				<Assignment >
					<xsl:attribute name="Value"><xsl:value-of select="SupplierXRefID"/></xsl:attribute>
					<xsl:attribute name="Assign">
                  <xsl:choose>
                    <xsl:when test="normalize-space(Action)">
                      <xsl:value-of select="Action"/>
                    </xsl:when>
                  </xsl:choose>
				  </xsl:attribute>	
				</Assignment>
			</xsl:for-each>
		</AssignmentList>
       </OrgUnit>
      </xsl:for-each>
    </OrgUnitList>
  </xsl:template>
</xsl:stylesheet>
