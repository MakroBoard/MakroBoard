<xsl:stylesheet
  version="2.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:wix="http://schemas.microsoft.com/wix/2006/wi"
  xmlns:msxsl="urn:schemas-microsoft-com:xslt"
  xmlns:user="urn:my-scripts"
  xmlns="http://schemas.microsoft.com/wix/2006/wi">

  <msxsl:script language="C#" implements-prefix="user">
    <![CDATA[
      public string LowerCase(string source)
      {
          return source.ToLower();
      }
      
      public bool HasFileExtension(string fileName, string extension)
      {
          return System.IO.Path.GetExtension(fileName).Equals(extension, System.StringComparison.Ordinal);
      }
    ]]>
  </msxsl:script>

  <!-- copy all nodes as is -->
  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*" />
      <xsl:apply-templates select="*" />
    </xsl:copy>
  </xsl:template>
  <xsl:output method="xml" indent="yes" />


  <!-- but exclude pdb -->
  <xsl:key name="pdbRemove" match="wix:Component[user:HasFileExtension(wix:File/@Source, '.pdb')]" use="@Id"/>
  <xsl:template match="wix:Component[key('pdbRemove', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('pdbRemove', @Id)]" />
  
  <!-- but exclude deps.json -->
  <xsl:key name="depsJsonRemove" match="wix:Component[user:HasFileExtension(wix:File/@Source, '.deps.json')]" use="@Id"/>
  <xsl:template match="wix:Component[key('depsJsonRemove', @Id)]" />
  <xsl:template match="wix:ComponentRef[key('depsJsonRemove', @Id)]" />

</xsl:stylesheet>