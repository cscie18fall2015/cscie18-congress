<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:myapp="http://cscie18.dce.harvard.edu/apps/cscie18-trycongress" exclude-result-prefixes="xs" version="2.0">
    <xsl:import href="common.xsl"/>
    <xsl:template match="facets">
        <div class="row">
            <xsl:apply-templates select="facet[@name eq 'state']">
                <xsl:with-param name="columns" select="8"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="facet[@name ne 'state']">
                <xsl:with-param name="columns" select="4"/>
            </xsl:apply-templates>
        </div>
    </xsl:template>
    <xsl:template match="facet">
        <xsl:param name="columns" select="4"/>
        <div class="col-md-{$columns}">
            <h2>
                <xsl:value-of select="@title"/>
            </h2>
            <ul class="list-inline">
                <xsl:for-each select="item">
                    <li>
                        <a class="btn btn-default btn-sm" style="margin-bottom: 7px;" href="{concat('people','?',../@name,'=',@code)}">
                            <xsl:value-of select="."/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
</xsl:stylesheet>