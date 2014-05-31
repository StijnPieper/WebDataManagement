<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
    <xsl:output method="html" encoding="utf-8"/>
    <xsl:template match="movie-list[not(title)]">
        <p class="movie_list_header">No relevant movies found.</p>
    </xsl:template>
    <xsl:template match="movie-list[title]">
        <p class="movie_list_header">Relevant movies are (click for details):</p>
        <ul class="movie_list">
            <xsl:apply-templates select="title"/>
        </ul>
    </xsl:template>
    <xsl:template match="movie-list/title">
        <li>
            <a class="movie_title">
                <xsl:value-of select="."/>
            </a>
        </li>
    </xsl:template>
    <xsl:template match="movie">
        <div class="movie">
            <p class="title">
                <xsl:value-of select="title"/>
            </p>
            <p class="year">
                <xsl:value-of select="year"/>
            </p>
            <p class="country">
                <xsl:value-of select="country"/>
            </p>
            <p class="genre">
                <xsl:value-of select="genre"/>
            </p>
            <p class="summary">
                <xsl:value-of select="summary"/>
            </p>
            <p class="director">
                <span class="first">
                    <xsl:value-of select="director/first_name"/>
                </span>
                <span class="last">
                    <xsl:value-of select="director/last_name"/>
                </span>
            </p>
            <div class="actors">
                <xsl:apply-templates select="actor"/>
            </div>
        </div>
    </xsl:template>
    <xsl:template match="movie/actor">
        <p class="actor">
            <span class="first">
                <xsl:value-of select="first_name"/>
            </span>
            <span class="last">
                <xsl:value-of select="last_name"/>
            </span>
        as <i>
                <xsl:value-of select="role"/>
            </i>
        </p>
    </xsl:template>
</xsl:stylesheet>