set -euf

# Install [de]activate scripts.
for F in activate deactivate; do
  mkdir -p "${PREFIX}/etc/conda/${F}.d"

  # First, copy them to the work directory
  cp "${RECIPE_DIR}/${F}-go-platform.sh" .

  # Second, expand the GOOS and GOARCH variables
  # We have to use the conda provided ones in this case
  // OSX bash version is too old to convert it lowercase
  goos=$(uname 2>&1 | tr A-Z A-z)
  sed -i.bak \
    -e "s|@GOOS@|${goos}|g" \
    -e "s|@GOARCH@|${conda_goarch}|g" "${F}-go-platform.sh"

  # Copy the rendered [de]activate scripts to $PREFIX/etc/conda/[de]activate.d
  cp -v "${F}-go-platform.sh" "${PREFIX}/etc/conda/${F}.d/${F}-z60-${PKG_NAME}.sh"
done
