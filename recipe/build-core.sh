set -euf 

#
# Install and source the [de]activate scripts.
for F in activate deactivate; do
  mkdir -p "${PREFIX}/etc/conda/${F}.d"
  cp -v "${RECIPE_DIR}/${F}-go-${cgo_var}.sh" "${PREFIX}/etc/conda/${F}.d/${F}-z60-${cgo_var}.sh"
done

source "${PREFIX}/etc/conda/activate.d/activate-z60-go-${cgo_var}.sh"

# Do not use GOROOT_FINAL. Otherwise, every conda environment would
# need its own non-hardlinked copy of the go (+100MB per env).
# It is better to rely on setting GOROOT during environment activation.
#
# c.f. https://github.com/conda-forge/go-feedstock/pull/21#discussion_r202513916
export GOROOT=$SRC_DIR/go
export GOCACHE=off

pushd $GOROOT/src
if [[ $(uname) == 'Darwin' ]]; then
  # Tests on macOS receive SIGABRT on Travis :-/
  # All tests run fine on Mac OS X:10.9.5:13F1911 locally
  ./make.bash
elif [[ $(uname) == 'Linux' ]]; then
  # TODO: remove this before going back to master if possible
  ./make.bash
fi
popd

# Don't need the cached build objects
rm -fr ${SRC_DIR}/go/pkg/obj

# Dropping the verbose option here, because Travis chokes on output >4MB
cp -a $SRC_DIR/go ${PREFIX}/go

# Right now, it's just go and gofmt, but might be more in the future!
# We don't move files, and instead rely on soft-links
mkdir -p ${PREFIX}/bin && pushd $_
find ../go/bin -type f -exec ln -s {} . \;
