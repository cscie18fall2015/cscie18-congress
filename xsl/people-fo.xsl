<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://cscie18.dce.harvard.edu/congress" version="2.0">
    <xsl:import href="functions.xsl"/>
    <xsl:output method="xml" indent="yes"/><!-- define variables for row backgrounds -->
    <xsl:variable name="oddrowbackground">#ffffff</xsl:variable>
    <xsl:variable name="evenrowbackground">#eeeeee</xsl:variable>
    <xsl:variable name="pagetitle">
        <xsl:for-each select="/congress/filters/filter[@value ne '*']/@value">
            <xsl:choose>
                <xsl:when test="../@display">
                    <xsl:value-of select="../@display"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="local:expand(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="position() = last()"/>
                <xsl:when test="position() = last() - 1">
                    <xsl:text> and </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>, </xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:variable><!-- parameters -->
    <xsl:param name="view" select="'table'"/><!-- Attribute Sets -->
    <xsl:attribute-set name="tableheader">
        <xsl:attribute name="font-family">'Times New Roman', Times, serif</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">#ffffff</xsl:attribute>
        <xsl:attribute name="background-color">#666666</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="normal">
        <xsl:attribute name="font-family">'Times New Roman', Times, serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="line-height">16pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="header">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="text-align">end</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="footer">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="text-align">end</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="toc">
        <xsl:attribute name="font-family">'Times New Roman', Times, serif</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="line-height">14pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="bold">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="title">
        <xsl:attribute name="font-family">'Times New Roman', Times, serif</xsl:attribute>
        <xsl:attribute name="font-size">24pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="padding">0.25em</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="subtitle">
        <xsl:attribute name="font-family">'Times New Roman', Times, serif</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="padding">0.25em</xsl:attribute>
    </xsl:attribute-set>
    <xsl:variable name="title" select="'United States Congress'"/>
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="main" page-height="11in" page-width="8.5in" margin-top="0.5in" margin-bottom="0.5in" margin-left="1in" margin-right="1in">
                    <fo:region-body margin-top="0.5in" margin-bottom="0.5in"/>
                    <fo:region-before extent="0.5in"/>
                    <fo:region-after extent="0.5in"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="main"><!-- fo:static-content for header -->
                <fo:static-content flow-name="xsl-region-before">
                    <fo:block xsl:use-attribute-sets="normal header">
                        <xsl:value-of select="$title"/>
                    </fo:block>
                </fo:static-content><!-- fo:static-content for footer -->
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block xsl:use-attribute-sets="normal footer">
                        <xsl:text>Page </xsl:text>
                        <fo:page-number/>
                        <xsl:text> of </xsl:text>
                        <fo:page-number-citation ref-id="EndOfDoc"/>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body"><!-- This is the "main" content --><!-- title -->
                    <fo:block>
                        <fo:block xsl:use-attribute-sets="title">
                            <xsl:value-of select="$title"/>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="subtitle">
                            <xsl:value-of select="$pagetitle"/>
                        </fo:block><!-- main content through apply-templates -->
                        <xsl:apply-templates/>
                    </fo:block><!-- give empty block at end a known id
            go get total page numbers -->
                    <fo:block id="EndOfDoc"/>
                </fo:flow>
            </fo:page-sequence>
        </fo:root>
    </xsl:template><!-- "congress" is root element -->
    <xsl:template match="congress">
        <xsl:choose>
            <xsl:when test="$view eq 'table'">
                <xsl:apply-templates select="." mode="table"/>
            </xsl:when>
            <xsl:when test="$view eq 'grid'">
                <xsl:apply-templates select="." mode="grid"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="table"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="congress" mode="table"><!-- put in search parameters here --><!-- main content of congress members by state -->
        <fo:table border-style="solid" border-width="0.5pt" border-color="#dddddd" table-layout="fixed" width="100%">
            <fo:table-column column-width="2.125in"/>
            <fo:table-column column-width="1.5in"/>
            <fo:table-column column-width="1.875in"/>
            <fo:table-column column-width="1.0in"/>
            <fo:table-header xsl:use-attribute-sets="tableheader">
                <fo:table-row>
                    <fo:table-cell padding-left="0.0625in">
                        <fo:block> Name </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block> State </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block> House </fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                        <fo:block> Party </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-header>
            <fo:table-body><!-- use mode for table row content -->
                <xsl:apply-templates select="person" mode="tablerow">
                    <xsl:sort select="                             index-of(('sen',                             'rep'), terms/term[@current eq 'true']/type)"/>
                    <xsl:sort select="name/last"/>
                    <xsl:sort select="name/first"/>
                </xsl:apply-templates>
            </fo:table-body>
        </fo:table>
    </xsl:template>
    <xsl:template match="person" mode="tablerow">
        <xsl:variable name="curterm" select="terms/term[@current eq 'true']"/>
        <fo:table-row background-color="{if (position() mod 2 &gt; 0) then $oddrowbackground else $evenrowbackground}">
            <fo:table-cell padding-left="0.0625in">
                <fo:block padding-left="0.0625in" xsl:use-attribute-sets="normal bold">
                    <xsl:apply-templates select="name" mode="lnf"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block xsl:use-attribute-sets="normal">
                    <xsl:value-of select="local:expand($curterm/state)"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block xsl:use-attribute-sets="normal">
                    <xsl:value-of select="local:expand($curterm/type)"/>
                </fo:block>
            </fo:table-cell>
            <fo:table-cell>
                <fo:block xsl:use-attribute-sets="normal">
                    <xsl:value-of select="$curterm/party"/>
                </fo:block>
            </fo:table-cell>
        </fo:table-row>
    </xsl:template>
    <xsl:template match="name" mode="lnf">
        <xsl:value-of select="last"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="first"/>
        <xsl:if test="middle">
            <xsl:text/>
            <xsl:value-of select="middle"/>
        </xsl:if>
    </xsl:template>
    <xsl:template match="congress" mode="grid">
        <xsl:apply-templates select="person" mode="grid"/>
    </xsl:template>
    <xsl:template match="person" mode="grid">
        <fo:block>
            <fo:block>TO BE IMPLEMENTED</fo:block>
            <fo:block>
                <xsl:apply-templates select="name" mode="lnf"/>
            </fo:block>
        </fo:block>
    </xsl:template>
</xsl:stylesheet>