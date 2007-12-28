<?xml version="1.0"?> 
<!-- use this with an xslt processor to produce a description file from xml  -->
<!-- e.g. $ java org.apache.xalan.xslt.Process \ -->
<!--                 -IN golgi.xml \ -->
<!--                 -XSL xml2des.xsl \ -->
<!--                 -out golgi.ndf -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text" indent="no"/>
  <xsl:preserve-space elements="*" />

<xsl:template match="neurospaces-xml">
  <xsl:text>&#035;!neurospacesparse&#010;</xsl:text>

	  <xsl:call-template name="tr-import" />
	  <xsl:call-template name="tr-private-model" />
	  <xsl:call-template name="tr-public-model" />

</xsl:template>

<xsl:template name="tr-alias">

	  <xsl:for-each select="./alias">
	    <xsl:text>  ALIAS </xsl:text>
	    <xsl:choose>
	      <xsl:when test="boolean(@namespace)">
	        <xsl:value-of select="@namespace" />
	        <xsl:text>::</xsl:text>
	        <xsl:value-of select="@source" />
	        <xsl:text> </xsl:text>
	        <xsl:value-of select="@private-model" />
	        <xsl:text> </xsl:text>
	      </xsl:when>
	      <xsl:otherwise>
	        <xsl:value-of select="@source" />
	        <xsl:text> </xsl:text>
	        <xsl:value-of select="@name" />
	        <xsl:text> </xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>

	    <xsl:call-template name="tr-parameter-set" />

	    <xsl:text>  END ALIAS&#010;</xsl:text>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-bindables">

	  <xsl:for-each select="./bindables">
	    <xsl:text>	BINDABLES&#010;</xsl:text>

	    <xsl:call-template name="tr-input" />
	    <xsl:call-template name="tr-output" />

	    <xsl:text>	END BINDABLES&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-bindings">

	  <xsl:for-each select="./bindings">
	    <xsl:text>	BINDINGS&#010;</xsl:text>

	    <xsl:call-template name="tr-input" />
	    <xsl:call-template name="tr-output" />

	    <xsl:text>	END BINDINGS&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-file">

	  <xsl:for-each select="./file">
	    <xsl:text>  FILE </xsl:text>
	    <xsl:value-of select="@namespace" />
	    <xsl:text> &quot;</xsl:text>
	    <xsl:value-of select="@name" />
	    <xsl:text>&quot; 0.1&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-group">

	  <xsl:for-each select="./group">
	    <xsl:text>  GROUP </xsl:text>
	        <xsl:text> </xsl:text>
	        <xsl:value-of select="@name" />
	        <xsl:text>&#010;</xsl:text>

	    <xsl:call-template name="tr-bindables" />

	    <xsl:call-template name="tr-parameter-set" />

	    <xsl:call-template name="tr-symbols-and-children" />

	    <xsl:text>  END GROUP&#010;</xsl:text>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-import">

	<xsl:for-each select="./import">
	  <xsl:text>IMPORT&#010;&#010;</xsl:text>
	  <xsl:call-template name="tr-file" />
	  <xsl:text>&#010;END IMPORT&#010;&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-input">

	  <xsl:for-each select="./input">
	    <xsl:text>		INPUT </xsl:text>
	    <xsl:choose>
	      <xsl:when test="boolean(@source)">
	        <xsl:value-of select="@source" />
	        <xsl:text>-&gt;</xsl:text>
	        <xsl:value-of select="@field" />
	      </xsl:when>
	      <xsl:when test="boolean(@name)">
	        <xsl:value-of select="@name" />
	      </xsl:when>
	    </xsl:choose>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-insert-child">

	  <xsl:for-each select="./insert-child">
	    <xsl:text>	CHILD </xsl:text>
	    <xsl:value-of select="@source" />
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="@name" />
	    <xsl:text>&#010;</xsl:text>

	    <xsl:call-template name="tr-bindings" />
	    <xsl:call-template name="tr-parameter-set" />

	    <xsl:text>	END CHILD&#010;</xsl:text>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-algorithm">

	  <xsl:for-each select="./algorithm">
	    <xsl:text>  ALGORITHM </xsl:text>
	    <xsl:value-of select="@class" />
	    <xsl:text>&#010;		ALGORITHM_INSTANCE </xsl:text>
	    <xsl:value-of select="@instance-name" />
	    <xsl:text>&#010;</xsl:text>

	    <xsl:call-template name="tr-algorithm-parameter-set" />

	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-algorithm-parameter">

	<xsl:for-each select="./algorithm-parameter">
	  <xsl:text>		</xsl:text>
	  <xsl:value-of select="@value" />
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

	<xsl:for-each select="./description-algorithm-parameter">
	  <xsl:text>		</xsl:text>
	  <xsl:value-of select="@value" />
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-algorithm-parameter-set">

	<xsl:for-each select="./parameter-set">
	  <xsl:call-template name="tr-algorithm-parameter" />
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-output">

	  <xsl:for-each select="./output">
	    <xsl:text>		OUTPUT </xsl:text>
	    <xsl:choose>
	      <xsl:when test="boolean(@source)">
	        <xsl:value-of select="@source" />
	        <xsl:text>-&gt;</xsl:text>
	        <xsl:value-of select="@field" />
	      </xsl:when>
	      <xsl:when test="boolean(@name)">
	        <xsl:value-of select="@name" />
	      </xsl:when>
	    </xsl:choose>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-parameter">

	<xsl:for-each select="./parameter">
	  <xsl:text>		PARAMETER ( </xsl:text>
	    <xsl:value-of select="@name" />
	    <xsl:text> = </xsl:text>
	    <xsl:value-of select="@value" />
	    <xsl:if test="position()=last()">
	      <xsl:text> )&#010;</xsl:text>
	    </xsl:if>
	    <xsl:if test="not(position()=last())">
	      <xsl:text> ),&#010;</xsl:text>
	    </xsl:if>
	</xsl:for-each>

	<xsl:for-each select="./reference-parameter">
	  <xsl:text>		PARAMETER ( </xsl:text>
	    <xsl:value-of select="@name" />
	    <xsl:text> = </xsl:text>
	    <xsl:value-of select="@source" />
	    <xsl:text>-&gt;</xsl:text>
	    <xsl:value-of select="@field" />
	    <xsl:if test="position()=last()">
	      <xsl:text> )&#010;</xsl:text>
	    </xsl:if>
	    <xsl:if test="not(position()=last())">
	      <xsl:text> ),&#010;</xsl:text>
	    </xsl:if>
	</xsl:for-each>

	<xsl:for-each select="./symbol-parameter">
	  <xsl:text>		PARAMETER ( </xsl:text>
	    <xsl:value-of select="@name" />
	    <xsl:text> = </xsl:text>
	    <xsl:value-of select="@value" />
	    <xsl:if test="position()=last()">
	      <xsl:text> )&#010;</xsl:text>
	    </xsl:if>
	    <xsl:if test="not(position()=last())">
	      <xsl:text> ),&#010;</xsl:text>
	    </xsl:if>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-parameter-set">

	<xsl:for-each select="./parameter-set">
	  <xsl:text>	PARAMETERS&#010;</xsl:text>
	  <xsl:call-template name="tr-parameter" />
	  <xsl:text>	END PARAMETERS&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-private-model">

	<xsl:for-each select="./private-models">
	  <xsl:text>PRIVATE_MODELS&#010;&#010;</xsl:text>
	  <xsl:call-template name="tr-symbols" />
	  <xsl:text>&#010;END PRIVATE_MODELS&#010;&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-public-model">

	<xsl:for-each select="./public-models">
	  <xsl:text>PUBLIC_MODELS&#010;&#010;</xsl:text>
	  <xsl:call-template name="tr-symbols" />
	  <xsl:text>&#010;END PUBLIC_MODELS&#010;&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-symbols">

	<xsl:call-template name="tr-alias" />
	<xsl:call-template name="tr-cell" />
	<xsl:call-template name="tr-channel" />
	<xsl:call-template name="tr-connection-group" />
	<xsl:call-template name="tr-group" />
	<xsl:call-template name="tr-algorithm" />
	<xsl:call-template name="tr-network" />
	<xsl:call-template name="tr-pool" />
	<xsl:call-template name="tr-population" />
	<xsl:call-template name="tr-projection" />
	<xsl:call-template name="tr-randomvalue" />
	<xsl:call-template name="tr-segment" />
	<xsl:call-template name="tr-segment-group" />

</xsl:template>

<xsl:template name="tr-symbols-and-children">

	<xsl:call-template name="tr-insert-child" />
	<xsl:call-template name="tr-symbols" />

</xsl:template>


<!-- biological data types -->
<!-- biological data types -->
<!-- biological data types -->

<xsl:template name="tr-cell">

	<xsl:for-each select="./cell">
	  <xsl:text>	CELL </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END CELL&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-channel">

	<xsl:for-each select="./channel">
	  <xsl:text>	CHANNEL </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END CHANNEL&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-connection-group">

	<xsl:for-each select="./connection-group">
	  <xsl:text>	CONNECTION_GROUP </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END CONNECTION_GROUP&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-network">

	<xsl:for-each select="./network">
	  <xsl:text>	NETWORK </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END NETWORK&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-pool">

	<xsl:for-each select="./pool">
	  <xsl:text>	POOL </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END POOL&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-projection">

	<xsl:for-each select="./projection">
	  <xsl:text>	PROJECTION </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END PROJECTION&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-segment">

	<xsl:for-each select="./segment">
	  <xsl:text>	SEGMENT </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END SEGMENT&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-segment-group">

	<xsl:for-each select="./segment-group">
	  <xsl:text>	SEGMENT_GROUP </xsl:text>
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@name" />
	      <xsl:text>&#010;</xsl:text>

	  <xsl:call-template name="tr-bindables" />
	  <xsl:call-template name="tr-parameter-set" />
	  <xsl:call-template name="tr-symbols-and-children" />

	  <xsl:text>	END SEGMENT_GROUP&#010;</xsl:text>
	  <xsl:text>&#010;</xsl:text>
	</xsl:for-each>

</xsl:template>

<xsl:template name="tr-population">

	  <xsl:for-each select="./population">
	    <xsl:text>  POPULATION </xsl:text>
	        <xsl:text> </xsl:text>
	        <xsl:value-of select="@name" />
	        <xsl:text>&#010;</xsl:text>

	    <xsl:call-template name="tr-bindables" />
	    <xsl:call-template name="tr-parameter-set" />
	    <xsl:call-template name="tr-symbols-and-children" />

	    <xsl:text>  END POPULATION&#010;</xsl:text>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>

<xsl:template name="tr-randomvalue">

	  <xsl:for-each select="./randomvalue">
	    <xsl:text>  RANDOMVALUE </xsl:text>
	        <xsl:text> </xsl:text>
	        <xsl:value-of select="@name" />
	        <xsl:text>&#010;</xsl:text>

	    <xsl:call-template name="tr-bindables" />
	    <xsl:call-template name="tr-parameter-set" />
	    <xsl:call-template name="tr-symbols-and-children" />

	    <xsl:text>  END RANDOMVALUE&#010;</xsl:text>
	    <xsl:text>&#010;</xsl:text>
	  </xsl:for-each>

</xsl:template>


</xsl:stylesheet>
