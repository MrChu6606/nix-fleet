{ pkgs, ... }:

let
  defaultCheckstyleXml = ''
    <?xml version="1.0"?>
    <!DOCTYPE module PUBLIC
        "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
        "https://checkstyle.org/dtds/configuration_1_3.dtd">

    <module name="Checker">
      <property name="severity" value="warning"/>
      <module name="TreeWalker">
        <module name="AvoidStarImport"/>
        <module name="NeedBraces"/>
        <module name="LeftCurly"/>
        <module name="RightCurly"/>
        <module name="WhitespaceAround"/>
      </module>
    </module>
  '';

  vscodeExtensionsJson = ''
    {
      "recommendations": [
        "vscjava.vscode-java-pack",
        "shengchen.vscode-checkstyle"
      ]
    }
  '';
in
{
  languages.java = {
    enable = true;
    jdk.package = pkgs.jdk21;
  };

  env = {
    #JAVA_HOME = lib.mkForce "${pkgs.jdk21}";
    CHECKSTYLE_CONFIG = "${toString ./.}/checkstyle.xml";
    NIX_CFLAGS_COMPILE = "-Wno-error"; # Standard way to set compile flags in devenv
  };

  enterShell = ''
    # Create .envrc if it doesn't exist
    if [ ! -f .envrc ]; then
      echo "use flake" > .envrc
      echo "Created default .envrc file."
    fi

    # Create checkstyle.xml if it doesn't exist
      if [ ! -f checkstyle.xml ] && [ -z "$(find .vscode -maxdepth 2 -iname "*checkstyle*.xml" 2>/dev/null)" ]; then
      cat << 'EOF' > checkstyle.xml
${defaultCheckstyleXml}EOF
      echo "Created starter checkstyle.xml configuration."
    fi

    # Create .vscode/extensions.json if it doesn't exist
    if [ ! -f .vscode/extensions.json ]; then
      mkdir -p .vscode
      cat << 'EOF' > .vscode/extensions.json
${vscodeExtensionsJson}EOF
      echo "Created .vscode/extensions.json workspace recommendations."
    fi

    echo "☕ Java Development Shell Ready"
    echo "JDK: $(java -version 2>&1 | head -n 1)"
  '';
}
