<?xml version="1.0"?> 
<!-- use this with an xslt processor to produce html  -->
<!-- e.g. $ java org.apache.xalan.xslt.Process \ -->
<!--                 -IN mossyfiber.xml \ -->
<!--                 -XSL ../xml2html.xsl \ -->
<!--                 -OUT mossyfiber.html -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="xml" indent="yes"/>

<xsl:template match="neurospaces-xml">
<HTML>
  <HEAD>
    <TITLE>
      Neurospaces HTML model description.
    </TITLE>
  </HEAD>
  <BODY BGCOLOR="#000080" TEXT="#add8e6" LINK="#ffff00" VLINK="#9acd32">

  <H1>
  <xsl:text> Neurospaces HTML model description. </xsl:text>
  </H1>

    <H2>
    <xsl:text> Imported files </xsl:text>
    </H2>
	<TABLE BORDER="3" FRAME="box" RULES="all" SUMMARY="Contents of disk">
	  <THEAD >
	  <TR>
	  <TD ALIGN="center" COLSPAN="4">
	    <H3> Imported files
	    </H3>
	  </TD>
	  </TR>
	  </THEAD>
	  <TBODY>
	    <TR>
	    <TD ALIGN="center" COLSPAN="1">
		<xsl:text> Namespace </xsl:text>
	    </TD>
	    <TD ALIGN="center" COLSPAN="1">
		<xsl:text> Description file </xsl:text>
	    </TD>
	    <TD ALIGN="center" COLSPAN="1">
		<xsl:text> HTML file </xsl:text>
	    </TD>
	    </TR>
	  <xsl:for-each select="import/file">
	    <TR>
	    <TD ALIGN="center" COLSPAN="1">
		<xsl:element name="a">
		<xsl:attribute name="name">
		  <xsl:value-of select="@namespace" />
		</xsl:attribute>
		<xsl:value-of select="@namespace" />
		</xsl:element>
		<xsl:apply-templates/>
	    </TD>
	    <TD ALIGN="center" COLSPAN="1">
		<xsl:element name="a">
		<xsl:attribute name="href">
		  <xsl:value-of select="@name" />
		</xsl:attribute>
	        <xsl:value-of select="@name" />
		</xsl:element>
		<xsl:apply-templates/>
	    </TD>
	    </TR>
	  </xsl:for-each>
	  </TBODY>
	</TABLE>

    <H2>
    <xsl:text> Private models </xsl:text>
    </H2>

      <xsl:for-each select="private-models/alias">
	  <DL>
	  <DT>
		<xsl:text> Alias </xsl:text>
		<xsl:element name="a">
		<xsl:attribute name="href">
		  <xsl:text>#number</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		<xsl:attribute name="name">
		  <xsl:text>index</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		  <xsl:text> </xsl:text>
		  <xsl:number value="position()" format="1. "/>
		  <xsl:text> : namespace = </xsl:text>
		  <xsl:value-of select="@namespace" />
		</xsl:element>
		<xsl:element name="a">
		<xsl:attribute name="href">
		  <xsl:text>#number</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		<xsl:attribute name="name">
		  <xsl:text>index</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		  <xsl:text> </xsl:text>
		  <xsl:number value="position()" format="1. "/>
		  <xsl:text> : source = </xsl:text>
		  <xsl:value-of select="@source" />
		</xsl:element>
		<xsl:element name="a">
		<xsl:attribute name="href">
		  <xsl:text>#number</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		<xsl:attribute name="name">
		  <xsl:text>index</xsl:text>
		  <xsl:number value="position()" format="1"/>
		</xsl:attribute>
		  <xsl:text> </xsl:text>
		  <xsl:number value="position()" format="1. "/>
		  <xsl:text> : private-model = </xsl:text>
		  <xsl:value-of select="@private-model" />
		</xsl:element>
	  </DT>
	  </DL>
		<xsl:apply-templates/>

<!-- 	<xsl:for-each select="./*"> -->
<!-- 	  <DL> -->
<!-- 	  <DT> -->
<!-- 		<xsl:element name="a"> -->
<!-- 		<xsl:attribute name="href"> -->
<!-- 		  <xsl:text>#number</xsl:text> -->
<!-- 		  <xsl:number value="position()" format="1"/> -->
<!-- 		</xsl:attribute> -->
<!-- 		<xsl:attribute name="name"> -->
<!-- 		  <xsl:text>index</xsl:text> -->
<!-- 		  <xsl:number value="position()" format="1"/> -->
<!-- 		</xsl:attribute> -->
<!-- 		  Import -->
<!-- 		  <xsl:text> </xsl:text> -->
<!-- 		  <xsl:number value="position()" format="1. "/> -->
<!-- 		  <xsl:text> : namespace = </xsl:text> -->
<!-- 		  <xsl:value-of select="@namespace" /> -->
<!-- 		</xsl:element> -->
<!-- 	  </DT> -->
<!-- 	  </DL> -->
<!-- 		<xsl:apply-templates/> -->
<!-- 	</xsl:for-each> -->

      </xsl:for-each>

    <H2>
    <xsl:text> Public models </xsl:text>
    </H2>

</BODY>
</HTML>
</xsl:template>

</xsl:stylesheet>
