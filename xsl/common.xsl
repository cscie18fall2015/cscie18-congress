<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:local="http://cscie18.dce.harvard.edu/congress" exclude-result-prefixes="xs local" version="2.0">
    <xsl:import href="functions.xsl"/>
    <xsl:variable name="sitetitle">United States Congress</xsl:variable>
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
    </xsl:variable>
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
                <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css"/>
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
</xsl:stylesheet>