<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0" xmlns:msxsl="urn:schemas-microsoft-com:xslt" exclude-result-prefixes="msxsl">
<xsl:output omit-xml-declaration="yes"/>

<!-- ROOT -->
<xsl:template match="/">
	<EnterpriseDocument>
		<xsl:attribute name="InterfaceName">ItemImport</xsl:attribute>
		<xsl:attribute name="CreationSource">Speedway Default</xsl:attribute>
		<xsl:attribute name="Version"><xsl:value-of select="//Document/@Version"/></xsl:attribute>
		<xsl:attribute name="CreationTimestamp"><xsl:value-of select="//Document/@CreationTimestamp"/></xsl:attribute>
		<xsl:call-template name="Item"/>
    </EnterpriseDocument>
</xsl:template>

<xsl:template name="Item">
	<RetailerReference>
		<xsl:attribute name="ClientIdentifierType">ClientID</xsl:attribute>
		<xsl:attribute name="ClientIdentifier">10000001</xsl:attribute>
    </RetailerReference>
    <ItemList>
		<xsl:for-each select="//Document/RawXMLRow[ItemName != '']">
			<Item>
				<xsl:attribute name="SoldAs"><xsl:value-of select="SoldAs"/></xsl:attribute>
				<xsl:attribute name="ItemExternalID"><xsl:value-of select="ItemExternalID"/></xsl:attribute>
				<xsl:attribute name="ItemName"><xsl:value-of select="ItemName"/></xsl:attribute>
				<xsl:if test="normalize-space(ItemDescription)">
					<xsl:attribute name="ItemDescription"><xsl:value-of select="ItemDescription"/></xsl:attribute>
				</xsl:if>
				<xsl:attribute name="Category"><xsl:value-of select="Category"/></xsl:attribute>
				<xsl:attribute name="BaseUOMClass"><xsl:value-of select="BaseUOMClass"/></xsl:attribute>
				<xsl:if test="normalize-space(ReportedInUOM)">
					<xsl:attribute name="ReportedInUOM"><xsl:value-of select="ReportedInUOM"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(Brand)">
					<xsl:attribute name="Brand"><xsl:value-of select="Brand"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(Manufacturer)">
					<xsl:attribute name="Manufacturer"><xsl:value-of select="Manufacturer"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(SKUNumber)">
					<xsl:attribute name="SKUNumber"><xsl:value-of select="SKUNumber"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(Taxability)">
					<xsl:attribute name="Taxability"><xsl:value-of select="Taxability"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(StandardCost)">
					<xsl:attribute name="StandardCost"><xsl:value-of select="StandardCost"/></xsl:attribute>
				</xsl:if>
				<xsl:if test="normalize-space(ConvertFromUOMName1)">
				<UOMConversionList>
					<xsl:if test="normalize-space(ConvertFromUOMName1)">
						<UOMConversion>
							<xsl:attribute name="ConvertFromUOMName"><xsl:value-of select="ConvertFromUOMName1"/></xsl:attribute>
							<xsl:attribute name="ConvertFromUOMQty"><xsl:value-of select="ConvertFromUOMQty1"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMClass"><xsl:value-of select="ConvertToUOMClass1"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMName"><xsl:value-of select="ConvertToUOMName1"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMQty"><xsl:value-of select="ConvertToUOMQty1"/></xsl:attribute>
						</UOMConversion>
					</xsl:if>
					<xsl:if test="normalize-space(ConvertFromUOMName2)">
						<UOMConversion>
							<xsl:attribute name="ConvertFromUOMName"><xsl:value-of select="ConvertFromUOMName2"/></xsl:attribute>
							<xsl:attribute name="ConvertFromUOMQty"><xsl:value-of select="ConvertFromUOMQty2"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMClass"><xsl:value-of select="ConvertToUOMClass2"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMName"><xsl:value-of select="ConvertToUOMName2"/></xsl:attribute>
							<xsl:attribute name="ConvertToUOMQty"><xsl:value-of select="ConvertToUOMQty2"/></xsl:attribute>
						</UOMConversion>
					</xsl:if>
				</UOMConversionList>
				</xsl:if>
				<Tracking>
					<xsl:if test="normalize-space(Active)">
						<xsl:attribute name="Active"><xsl:value-of select="Active"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(Track)">
						<xsl:attribute name="Track"><xsl:value-of select="Track"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(ExpenseUponReceiving)">
						<xsl:attribute name="ExpenseUponReceiving"><xsl:value-of select="ExpenseUponReceiving"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(AllowFractionalQuantities)">
						<xsl:attribute name="AllowFractionalQuantities"><xsl:value-of select="AllowFractionalQuantities"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(SetVarianceToZero)">
						<xsl:attribute name="SetVarianceToZero"><xsl:value-of select="SetVarianceToZero"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(WasteTolerence)">
						<xsl:attribute name="WasteTolerence"><xsl:value-of select="WasteTolerence"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(DefaultAdjustmentUOM)">
						<xsl:attribute name="DefaultAdjustmentUOM"><xsl:value-of select="DefaultAdjustmentUOM"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(DefaultTransferUOM)">
						<xsl:attribute name="DefaultTransferUOM"><xsl:value-of select="DefaultTransferUOM"/></xsl:attribute>
					</xsl:if>
				</Tracking>
				<!-- Added for Item Group -->
				<xsl:if test="normalize-space(ItemGroup1)">
				<ItemGroupList>
					<xsl:if test="normalize-space(ItemGroup1)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup1"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup2)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup2"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup3)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup3"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup4)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup4"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup5)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup5"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup6)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup6"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup7)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup7"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup8)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup8"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup9)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup9"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
					<xsl:if test="normalize-space(ItemGroup10)">
					<ItemGroup>
						<xsl:attribute name="GroupName"><xsl:value-of select="ItemGroup10"/></xsl:attribute>
						<xsl:attribute name="ItemGroupAction">Add</xsl:attribute>
					</ItemGroup>
					</xsl:if>
				</ItemGroupList>
				</xsl:if>
				<!-- End for Item Group -->
				
				<xsl:if test="normalize-space(./RetailPack)">				
				
				<RetailPacks>
					<xsl:if test="normalize-space(RetailStrategy)">
						<xsl:attribute name="RetailStrategy"><xsl:value-of select="RetailStrategy"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(PromptForQtyAtPOS)">
						<xsl:attribute name="PromptForQtyAtPOS"><xsl:value-of select="PromptForQtyAtPOS"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(AutoQueueShelfLabels)">
						<xsl:attribute name="AutoQueueShelfLabels"><xsl:value-of select="AutoQueueShelfLabels"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(RequiresSwipeAtPOS)">
						<xsl:attribute name="RequiresSwipeAtPOS"><xsl:value-of select="RequiresSwipeAtPOS"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(CreditCategoryCode)">
						<xsl:attribute name="CreditCategoryCode"><xsl:value-of select="CreditCategoryCode"/></xsl:attribute>
					</xsl:if>
					<xsl:if test="normalize-space(./RetailPack)">
						<RetailPackList>
							<xsl:for-each select="./RetailPack">
								<RetailPack>
									<xsl:if test="normalize-space(PackName)">
										<xsl:attribute name="PackName"><xsl:value-of select="PackName"/></xsl:attribute>
									</xsl:if>
									<xsl:if test="normalize-space(PackQty)">
										<xsl:attribute name="PackQty"><xsl:value-of select="PackQty"/></xsl:attribute>
									</xsl:if>	
									<xsl:if test="normalize-space(RetailLevelGroup)">
										<xsl:attribute name="RetailLevelGroup"><xsl:value-of select="RetailLevelGroup"/></xsl:attribute>
									</xsl:if>	

									<xsl:if test="normalize-space(RetailItemPackExternalID)">
										<xsl:attribute name="RetailItemPackExternalID"><xsl:value-of select="RetailItemPackExternalID"/></xsl:attribute>
									</xsl:if>
									<xsl:if test="normalize-space(./Barcode)">
									<BarcodeList>
										<xsl:for-each select="./Barcode">
											<xsl:if test="normalize-space(BarcodeNumber)">
												<Barcode>
													<xsl:attribute name="BarcodeTypeCode">
														<xsl:choose>
															<xsl:when test="normalize-space(BarcodeTypeCode)">
																<xsl:value-of select="BarcodeTypeCode"/>
															</xsl:when>
															<xsl:otherwise>u</xsl:otherwise>
														</xsl:choose>
													</xsl:attribute>
													<xsl:attribute name="BarcodeNumber">
														<xsl:choose>
														<!-- Check to see if the first char is a single quote.  If so grab the 2nd char til end -->
															<xsl:when test='substring(Number,1,1) = "&apos;" '>
																<xsl:value-of select="normalize-space(substring(BarcodeNumber,2))"/>
															</xsl:when>
															<xsl:otherwise>
																<xsl:value-of select="normalize-space(BarcodeNumber)"/>
															</xsl:otherwise>
														</xsl:choose>
														</xsl:attribute>
												</Barcode>
											</xsl:if>
										</xsl:for-each>
									</BarcodeList>						
									</xsl:if>
									<xsl:if test="normalize-space(CustomAttribute1)">
									<CustomAttributeList>
										<xsl:if test="normalize-space(CustomAttribute1)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute1"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value1"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute2)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute2"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value2"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute3)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute3"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value3"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute4)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute4"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value4"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute5)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute5"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value5"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute6)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute6"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value6"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute7)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute7"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value7"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute8)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute8"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value8"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute9)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute9"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value9"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute10)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute10"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value10"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute11)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute11"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value11"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute12)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute12"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value12"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute13)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute13"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value13"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute14)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute14"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value14"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute15)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute15"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value15"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute16)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute16"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value16"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute17)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute17"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value17"/></xsl:attribute>
											</Attribute>
										</xsl:if>
											<xsl:if test="normalize-space(CustomAttribute18)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute18"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value18"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute19)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute19"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value19"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute20)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute20"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value20"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute21)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute21"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value21"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute22)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute22"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value22"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute23)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute23"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value23"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute24)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute24"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value24"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute25)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute25"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value25"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute26)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute26"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value26"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute27)">  
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute27"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value27"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute28)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute28"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value28"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute29)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute29"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value19"/></xsl:attribute>
											</Attribute>
										</xsl:if>
										<xsl:if test="normalize-space(CustomAttribute30)">
											<Attribute>
												<xsl:attribute name="Name"><xsl:value-of select="CustomAttribute30"/></xsl:attribute>
												<xsl:attribute name="Value"><xsl:value-of select="Value30"/></xsl:attribute>
											</Attribute>
										</xsl:if>	
									</CustomAttributeList>
									</xsl:if>
									<RetailPrice>
										<xsl:if test="normalize-space(ListRetail)">
											<xsl:attribute name="ListRetail"><xsl:value-of select="ListRetail"/></xsl:attribute>
										</xsl:if>
									</RetailPrice>
								</RetailPack>
							</xsl:for-each>
						</RetailPackList>
					</xsl:if>	
				</RetailPacks>	 

				</xsl:if>	
				
			</Item>
		</xsl:for-each>
    </ItemList>
 </xsl:template>
 </xsl:stylesheet>