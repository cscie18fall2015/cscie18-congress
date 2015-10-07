<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cscie18="http://cscie18.dce.harvard.edu" exclude-result-prefixes="xs cscie18" version="2.0">
    <xsl:import href="common.xsl"/>
    <xsl:output method="html" doctype-system="about:legacy-compat"/>
    <xsl:param name="view" select="'table'"/>
    <xsl:param name="querystring"/>
    <xsl:variable name="pagetitle">
        <xsl:for-each select="/congress/filters/filter[@value ne '*']/@value">
            <xsl:choose>
                <xsl:when test="../@display">
                    <xsl:value-of select="../@display"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="cscie18:expand(.)"/>
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
    </xsl:variable>
    <xsl:template name="breadcrumb">
        <ol class="breadcrumb">
            <li>
                <a href="./index">Home</a>
            </li>
            <li class="active">People</li>
        </ol>
    </xsl:template>
    <xsl:template name="view_options">
        <ul class="nav nav-tabs" style="margin-bottom: 5px;">
            <li class="{if ($view eq 'table') then 'active' else ''}">
                <a href="?{cscie18:changeview($querystring,'table')}">Table</a>
            </li>
            <li class="{if ($view eq 'grid') then 'active' else ''}">
                <a href="?{cscie18:changeview($querystring,'grid')}">Photos</a>
            </li>
        </ul>
    </xsl:template>
    <xsl:template match="congress">
        <xsl:apply-templates select="facets"/>
        <xsl:call-template name="view_options"/>
        <xsl:choose>
            <xsl:when test="$view eq 'grid'">
                <xsl:apply-templates select="." mode="grid"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="table"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xsl:template match="congress" mode="table">
        <div class="row">
            <div class="col-md-12">
                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>State</th>
                            <th>House</th>
                            <th>Party</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="person" mode="#current">
                            <xsl:sort select="name/last"/>
                            <xsl:sort select="name/first"/>
                        </xsl:apply-templates>
                    </tbody>
                </table>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="congress" mode="grid">
        <xsl:apply-templates select="person" mode="#current">
            <xsl:sort select="name/last"/>
            <xsl:sort select="name/first"/>
        </xsl:apply-templates>
    </xsl:template>
    <xsl:template match="person" mode="grid">
        <xsl:variable name="current_term" select="terms/term[@current = true()]"/>
        <div class="col-sm-6 col-md-3 col-lg-2">
            <div class="thumbnail">
                <img src="http://cscie18.dce.harvard.edu/govtrack/photos/{id/govtrack}-200px.jpeg" alt="{name/official_full}"/>
                <div class="caption">
                    <p class="text-center">
                        <small>
                            <strong>
                                <xsl:value-of select="name/official_full"/>
                            </strong>
                            <br/>
                            <xsl:value-of select="cscie18:expand($current_term/state)"/>
                            <br/>
                            <xsl:value-of select="cscie18:expand($current_term/type)"/>
                            <br/>
                            <xsl:value-of select="cscie18:expand($current_term/party)"/>
                        </small>
                    </p>
                </div>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="person" mode="table">
        <xsl:variable name="current_term" select="terms/term[@current = true()]"/>
        <tr>
            <td>
                <xsl:apply-templates select="name"/>
            </td>
            <td>
                <xsl:value-of select="cscie18:expand($current_term/state)"/>
            </td>
            <td>
                <xsl:value-of select="cscie18:expand($current_term/type)"/>
            </td>
            <td>
                <xsl:value-of select="cscie18:expand($current_term/party)"/>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="name">
        <xsl:value-of select="last"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="first"/>
    </xsl:template>
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
            <h3>
                <xsl:value-of select="@title"/>
            </h3>
            <ul class="list-inline">
                <xsl:for-each select="item">
                    <xsl:variable name="selected">
                        <xsl:choose>
                            <xsl:when test="@code  = /congress/filters/filter/@value">
                                <xsl:value-of select="true()"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="false()"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <li>
                        <a class="btn btn-{if ($selected = true()) then 'primary' else 'default'} btn-xs" style="margin-bottom: 3px;" href="{concat('?',                             if ($selected = true()) then cscie18:remove-qs-parameter(concat(../@name,'=',@code))                             else cscie18:add-qs-parameter(../@name,@code))                             }">
                            <xsl:value-of select="."/>
                        </a>
                    </li>
                </xsl:for-each>
            </ul>
        </div>
    </xsl:template>
    <xsl:function name="cscie18:add-qs-parameter">
        <xsl:param name="myparam"/>
        <xsl:param name="myvalue"/>
        <xsl:value-of select="concat($querystring,'&amp;',$myparam,'=',$myvalue)"/>
    </xsl:function>
    <xsl:function name="cscie18:remove-qs-parameter">
        <xsl:param name="mypv"/>
        <xsl:value-of select="replace($querystring,$mypv,'')"/>
    </xsl:function>
</xsl:stylesheet>