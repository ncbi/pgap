<?xml version="1.0" encoding="UTF-8"?>
<!--
        
        asndisc/asnvalidate summary -> proc_annot_stats
        
        proc_annot_stats format of XML is a format that serves as a standard input
        for subsequent loading to ProkRefseqTracking..ProcessAnnotationStats table
        the latter XML format is used as a template for classes under valres C++ namespace
        top element corresponding to ncbi::objects::valres::CValidationResults
        
    -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="yes" encoding="UTF-8"/>
    <xsl:variable name="smallcase" select="'abcdefghijklmnopqrstuvwxyz'" />
    <xsl:variable name="uppercase" select="'ABCDEFGHIJKLMNOPQRSTUVWXYZ'" />

    <xsl:template match="ValidationErrors|DiscrepancyCounts">
    <validation-results>
        <xsl:attribute name="result">pass</xsl:attribute>
        <xsl:variable name="application">
            <xsl:if test="name(.) = 'ValidationErrors'">asnval</xsl:if>
            <xsl:if test="name(.) = 'DiscrepancyCounts'">asndisc</xsl:if>
        </xsl:variable>
        <xsl:for-each select="Counts/Total">
            <xsl:element name="stat">
                <xsl:attribute name="key"><xsl:value-of select="$application"/></xsl:attribute>
                <xsl:attribute name="subkey"><xsl:value-of select='translate(../@Severity, $uppercase , $smallcase)'/></xsl:attribute>
                <xsl:attribute name="value"><xsl:value-of select="text()"/></xsl:attribute>
                <xsl:attribute name="result">pass</xsl:attribute>
            </xsl:element>
        </xsl:for-each>
        <xsl:for-each select="Counts/Subcount">
                <xsl:element name="stat">
                    <xsl:attribute name="key"><xsl:value-of select="$application"/><xsl:text> </xsl:text><xsl:value-of 
                        select='translate(../@Severity, $uppercase , $smallcase)'/></xsl:attribute>
                    <xsl:attribute name="subkey"><xsl:value-of select="@Code"/></xsl:attribute>
                    <xsl:attribute name="value"><xsl:value-of select="text()"/></xsl:attribute>
                    <xsl:attribute name="result">pass</xsl:attribute>
                </xsl:element>
        </xsl:for-each>
    </validation-results>
    </xsl:template>
</xsl:stylesheet>