# refpolicy_devShell
## Description
This is a nix flake that provide a development bash shell that 
contains environment to build and install 
the [selinux refpolicy](https://github.com/SELinuxProject/refpolicy).

## How to use
- to evaluate from remote source 
```nix --experimental-features 'nix-command flakes' develop github:nong10/refpolicy_env/#default
```
- to evaluate using local flake
at root directory of the repo, run
```nix --experimental-features 'nix-command flakes' develop ./#default 
```
