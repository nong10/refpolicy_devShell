# python package selinux
{ lib
, buildPythonPackage
, fetchPypi
, wheel
, setuptools
, setuptools-scm
, pkgs
}:

buildPythonPackage rec {
  pname = "selinux";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KoizN6xGrQ8G9VeygGw99iQhly92ZnPdi/JnMvt1qeo=";
  };

  dependencies = [
    pkgs.python311Packages.distro
    setuptools
    setuptools-scm
  ];

  doCheck = false;

  pyproject = true;
  build-system = [
    setuptools
    wheel
  ];
}
