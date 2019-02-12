:: Get minor/major version of libgdal
set GDAL_MAJ_MIN=%PKG_VERSION:~0,3%
set "gdalplugins_ver=%LIBRARY_LIB%\gdalplugins\%GDAL_MAJ_MIN%"
if not exist "%gdalplugins_ver%" mkdir "%gdalplugins_ver%"

call "%RECIPE_DIR%\set_bld_opts.bat"

:: Just build the main DLL, but not install
:: NOTE: can also use 'plugin_dir' target to build defined plugins
nmake /f makefile.vc dll %BLD_OPTS%
if errorlevel 1 exit 1


:: Build/install plugin
pushd ogr\ogrsf_frmts\oci

  nmake /f makefile.vc plugin plugin-install %BLD_OPTS%
  if errorlevel 1 exit 1

popd

:: Move it to gdalplugins\x.x (major.minor) subdir
pushd "%LIBRARY_LIB%\gdalplugins"

  if exist ogr_OCI.dll (
    move ogr_OCI.dll "%gdalplugins_ver%\"
  )

popd
