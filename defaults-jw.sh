env:
  CFLAGS: -fPIC -O2 -I/usr/include/tirpc
  CMAKE_BUILD_TYPE: RELWITHDEBINFO
  CXXFLAGS: -fPIC -O2 -std=c++17 -I/usr/include/tirpc
  CXXSTD: '17'
  ENABLE_VMC: 'ON'
  GEANT4_BUILD_MULTITHREADED: 'ON'
overrides:
  AliPhysics:
    version: '%(commit_hash)s_O2'
  AliRoot:
    requires:
    - ROOT
    - fastjet:(?!.*ppc64)
    - GEANT3
    - GEANT4_VMC
    - Vc
    - ZeroMQ
    - JAliEn-ROOT
    version: '%(commit_hash)s_O2'
  cgal:
    version: 4.12.2
  fastjet:
    tag: v3.4.0_1.045-alice1
  pythia:
    requires:
    - lhapdf
    - boost
    tag: v8304
  O2-customization:
    env:
      ENABLE_UPGRADES: OFF # Disable detector upgrades in O2
      BUILD_ANALYSIS: OFF # Disable analysis in O2
      BUILD_EXAMPLES: OFF # Disable examples in O2
      ALIBUILD_ENABLE_CUDA: ON
package: defaults-jw
version: v1

---
# This file is included in any build recipe and it's only used to set
# environment variables. Which file to actually include can be defined by the
# "--defaults" option of alibuild.
