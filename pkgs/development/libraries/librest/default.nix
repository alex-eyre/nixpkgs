{ lib
, stdenv
, fetchurl
, pkg-config
, glib
, libsoup
, gobject-introspection
, gnome3
}:

stdenv.mkDerivation rec {
  pname = "rest";
  version = "0.8.1";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0513aad38e5d3cedd4ae3c551634e3be1b9baaa79775e53b2dba9456f15b01c9";
  };

  nativeBuildInputs = [
    pkg-config
    gobject-introspection
  ];

  buildInputs = [
    glib
    libsoup
  ];

  configureFlags = [
    # Remove when https://gitlab.gnome.org/GNOME/librest/merge_requests/2 is merged.
    "--with-ca-certificates=/etc/ssl/certs/ca-certificates.crt"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      attrPath = "librest";
      versionPolicy = "odd-unstable";
    };
  };

  meta = with lib; {
    description = "Helper library for RESTful services";
    homepage = "https://wiki.gnome.org/Projects/Librest";
    license = licenses.lgpl21Only;
    platforms = platforms.unix;
    maintainers = teams.gnome.members;
  };
}
