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
in
{
  languages.java = {
    enable = true;
    jdk = pkgs.jdk21;
  };

  env = {
    JAVA_HOME = "${pkgs.jdk21}";
    CHECKSTYLE_CONFIG = "${toString ./.}/checkstyle.xml";
  };

  vscode.extensions = [
    "vscjava.vscode-java-pack"
    "shengchen.vscode-checkstyle"
  ];

  enterShell = ''
    # Create .envrc if it doesn't exist
    if [ ! -f .envrc ]; then
      echo "use flake" > .envrc
      echo "Created default .envrc file."
    fi

    # Create checkstyle.xml if it doesn't exist
    if [ ! -f checkstyle.xml ]; then
      cat << 'EOF' > checkstyle.xml
${defaultCheckstyleXml}EOF
      echo "Created starter checkstyle.xml configuration."
    fi

    echo "☕ Java Development Shell Ready"
    echo "JDK: $(java -version 2>&1 | head -n 1)"
  '';
}
