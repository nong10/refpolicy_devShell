{
  description = "environment for selinux refpolicy";

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
          packages = with pkgs; [
            gawk	      # awk
            gnugrep	    # grep
            coreutils	  # GNU coreutils: install sort
            gnused	    # sed
            gnumake	    # make
            gnum4	      # m4
            policycoreutils # semodule
            checkpolicy     # checkpolicy checkmodule
            semodule-utils  # semodule_link semodule_unpackage semodule_expand semodule_package
            setools         # sechecker
            libselinux      # sefcontext_compile
            libxml2         # xmllint
            (python311.withPackages ( ps: with ps; 
              [ 
                setuptools
                (callPackage ./selinux_pypackage.nix {}) 
              ]             # [policy_root]/support/selinux_binary_policy_path.py
            ))
          ];

          shellHook = ''
            export TEST_VAR="Lmaoooooo"

            export AWK="${pkgs.gawk}/bin/awk" 
            export GREP="${pkgs.gnugrep}/bin/grep" 
            export INSTALL="${pkgs.coreutils}/bin/install" 
            export SORT="${pkgs.coreutils}/bin/sort"
            export M4="${pkgs.gnum4}/bin/m4" 
            export PYTHON="${pkgs.python311}/bin/python3 -bb -t -t -E -W error"
            export SED="${pkgs.gnused}/bin/sed" 

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
            echo "hello devShell! env for refpolicy" 
          '';
        };
  };
}
