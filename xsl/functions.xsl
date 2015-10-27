<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://cscie18.dce.harvard.edu/congress" exclude-result-prefixes="xs" version="2.0">
    <xsl:function name="local:expand">
        <xsl:param name="myshortname"/>
        <xsl:variable name="doc_abbr" select="'../data/abbreviations.xml'"/>
        <xsl:choose>
            <xsl:when test="exists(document($doc_abbr)/abbreviations/abbr[@short eq $myshortname]/@long)">
                <xsl:value-of select="document($doc_abbr)/abbreviations/abbr[@short eq $myshortname]/@long"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$myshortname"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:changeview">
        <xsl:param name="qs"/>
        <xsl:param name="myview"/>
        <xsl:choose>
            <xsl:when test="matches($qs,'view=[^&amp;]*')">
                <xsl:value-of select="replace($qs,'view=[^&amp;]*',concat('view=',$myview))"/>
            </xsl:when>
            <xsl:when test="matches($qs, 'view=?')">
                <xsl:value-of select="replace($qs, 'view=?', concat('view=', $myview))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($qs,'&amp;view=',$myview)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:pdflink">
        <xsl:param name="qs"/>
        <xsl:value-of select="concat('people.pdf?',$qs)"/>
    </xsl:function><!-- calculates age in years from a birthdate -->
    <xsl:function name="local:age">
        <xsl:param name="mybday"/>
        <xsl:variable name="now" select="current-date()"/>
        <xsl:choose>
            <xsl:when test="month-from-date($now) &gt; month-from-date($mybday) or month-from-date($now) = month-from-date($mybday) and day-from-date($now) &gt;= day-from-date($mybday)">
                <xsl:value-of select="year-from-date($now) - year-from-date($mybday)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="year-from-date($now) - year-from-date($mybday) - 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    <xsl:function name="local:add-qs-parameter">
        <xsl:param name="querystring"/>
        <xsl:param name="myparam"/>
        <xsl:param name="myvalue"/>
        <xsl:value-of select="concat($querystring,'&amp;',$myparam,'=',$myvalue)"/>
    </xsl:function>
    <xsl:function name="local:remove-qs-parameter">
        <xsl:param name="querystring"/>
        <xsl:param name="mypv"/>
        <xsl:value-of select="replace(replace($querystring,$mypv,''),'&amp;&amp;','&amp;')"/>
    </xsl:function>
</xsl:stylesheet>