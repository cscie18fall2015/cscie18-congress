<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:cscie18="http://cscie18.dce.harvard.edu" exclude-result-prefixes="xs cscie18" version="2.0">
    <xsl:variable name="sitetitle">United States Congress</xsl:variable>
    <xsl:variable name="pagetitle"/>
    <xsl:template match="/">
        <html lang="en">
            <head>
                <meta charset="utf-8"/>
                <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
                <meta name="viewport" content="width=device-width, initial-scale=1"/>
                <xsl:comment>The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags</xsl:comment>
                <title>
                    <xsl:value-of select="concat($sitetitle, ' ', $pagetitle)"/>
                </title>
                <xsl:comment>Bootstrap</xsl:comment>
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css"/>
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap-theme.min.css"/>
                <xsl:comment>HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries</xsl:comment>
                <xsl:comment>WARNING: Respond.js doesn't work if you view the page via file://</xsl:comment>
                <xsl:comment>[if lt IE 9]&gt;
      &lt;script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"&gt;&lt;/script&gt;
      &lt;script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"&gt;&lt;/script&gt;
    &lt;![endif]</xsl:comment>
            </head>
            <body>
                <div class="container-fluid">
                    <h1>
                        <xsl:value-of select="$sitetitle"/>
                    </h1>
                    <xsl:call-template name="breadcrumb"/>
                    <h2>
                        <xsl:value-of select="$pagetitle"/>
                    </h2>
                    <xsl:call-template name="view_options"/>
                    <xsl:apply-templates/>
                </div><!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
                <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js">
                    <xsl:text/>
                </script><!-- Include all compiled plugins (below), or include individual files as needed -->
                <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js">
                    <xsl:text/>
                </script>
            </body>
        </html>
    </xsl:template>
    <xsl:template name="breadcrumb">
        <ol class="breadcrumb">
            <li class="active">Home</li>
        </ol>
    </xsl:template>
    <xsl:template name="view_options"/>
    <xsl:function name="cscie18:expand">
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
    <xsl:function name="cscie18:changeview">
        <xsl:param name="qs"/>
        <xsl:param name="myview"/>
        <xsl:choose>
            <xsl:when test="matches($qs,'view=[^&amp;]*')">
                <xsl:value-of select="replace($qs,'view=[^&amp;]*',concat('view=',$myview))"/>
            </xsl:when>
            <xsl:when test="matches($qs,'view=?')">
                <xsl:value-of select="replace($qs,'view=?',concat('view=',$myview))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($qs,'&amp;view=',$myview)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
</xsl:stylesheet>