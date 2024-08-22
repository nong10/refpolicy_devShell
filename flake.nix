{
  description = "reference policy build & install environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
  };

  outputs = { self , nixpkgs , ... }: 
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { system = "x86_64-linux"; };
  in 
  {
    devShells."${system}".default = 
        pkgs.mkShell {
        # create an environment with nodejs_18, pnpm, and yarn
          packages = with pkgs; [
            gnum4
            python311
            python311Packages.setuptools
            (python311.withPackages ( ps: with ps; 
              [ 
                setuptools
                (callPackage ./selinux_pypackage.nix {}) 
              ]             # support/selinux_binary_policy_path.py
            ))

            policycoreutils # semodule
            checkpolicy     # checkpolicy checkmodule
            semodule-utils  # semodule_link semodule_unpackage semodule_expand semodule_package
            setools         # sechecker
            libselinux      # sefcontext_compile
            libxml2         # xmllint
          ];

          shellHook = ''
            export THE_TEST_VAR="Lmao"
            export CHECKPOLICY="${pkgs.checkpolicy}/bin/checkpolicy" 
            export CHECKMODULE="${pkgs.checkpolicy}/bin/checkmodule"
            export SEMODULE="${pkgs.policycoreutils}/bin/semodule"
            export SEMOD_PKG="${pkgs.semodule-utils}/bin/semodule_package"
            export SEMOD_LNK="${pkgs.semodule-utils}/bin/semodule_link"
            export SEMOD_EXP="${pkgs.semodule-utils}/bin/semodule_expand"
            export LOADPOLICY="${pkgs.policycoreutils}/bin/load_policy"

            export SEPOLGEN_IFGEN="${pkgs.selinux-python}/bin/sepolgen-ifgen"
            export SETFILES="${pkgs.policycoreutils}/bin/setfiles"
            export SEFCONTEXT_COMPILE="${pkgs.libselinux}/bin/sefcontext_compile"

            export SECHECK="${pkgs.setools}/bin/sechecker"
            export XMLLINT="${pkgs.libxml2}/bin/xmllint"
            echo "hello devShell! env for building and installing refpolicy" 
          '';

          #AWK ?= gawk
          #GREP ?= grep -E
          #INSTALL ?= install
          #M4 ?= m4 -E -E
          #PYTHON ?= python3 -bb -t -t -E -W error
          #SED ?= sed
          #SORT ?= LC_ALL=C sort
          #UMASK ?= umask
        };

#    defaultPackage."${system}" = 
#
#      #devShells."${system}".default = 
#      let
#        pkgs = import nixpkgs {inherit system; };
#      in pkgs.mkShell {
#        # create an environment with nodejs_18, pnpm, and yarn
#        packages = with pkgs; [
#          gnum4
#          python39
#          policycoreutils
#          checkpolicy
#        ];
#
#        shellHook = ''
#          echo "hello!" 
#        '';
#
#  #        export CHECKPOLICY="${pkgs.checkpolicy}/bin/checkpolicy" 
#  #        export CHECKMODULE="${pkgs.checkpolicy}/bin/checkmodule"
#  #        export SEMODULE="${pkgs.policycoreutils}/semodule"
#  #        export THETESTVAR="Lmao"
#  #      '';
#    };
  };
}
