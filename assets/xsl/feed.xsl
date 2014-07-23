<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:template match="/">
<html>
  <head>
    <title><xsl:value-of select="rss/channel/title"/></title>
    <style type="text/css">
    @import url(http://fonts.googleapis.com/css?family=Open+Sans:400italic,600italic,400,600);
    @import url(/assets/css/feed.css);
    </style>
  </head>
  <body>
    <div id="container">
      <header>
        <h1><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="rss/channel/link" /></xsl:attribute><xsl:attribute name="rel"><xsl:value-of select="rss/channel/title" /></xsl:attribute><xsl:value-of select="rss/channel/title" /></xsl:element></h1>
        <h2><xsl:value-of select="rss/channel/description"/></h2>
      </header>
      <section id="content">
        <xsl:for-each select="rss/channel/item">
        <article>
          <h3><xsl:element name="a"><xsl:attribute name="href"><xsl:value-of select="link" /></xsl:attribute><xsl:attribute name="rel"><xsl:value-of select="title" /></xsl:attribute><xsl:value-of select="title" /></xsl:element></h3>
          <small><xsl:value-of select="pubDate"/> | <xsl:value-of select="author"/></small>
          <xsl:value-of select="description"  disable-output-escaping="yes"/>
        </article>
        </xsl:for-each>
      </section>
      <footer>
        <small><xsl:value-of select="rss/channel/copyright" /></small>
      </footer>
    </div>
  </body>
</html>
</xsl:template>
</xsl:stylesheet>