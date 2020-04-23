@echo on

rem Put TMP on the same drive as the conda prefix (the D drive),
rem to avoid a known issue in the go test suite:
rem https://github.com/golang/go/issues/24846#issuecomment-381380628
set TMP=%PREFIX%\tmp
mkdir "%TMP%"


rem Diagnostics
where go
go env


rem Expect PASS
go tool dist test -v -no-rebuild
if errorlevel 1 exit 1
go tool dist test -v -no-rebuild -race -run='^go_test:runtime/race$'
if errorlevel 1 exit 1
set GO_BUILDER_NAME=windows-amd64-condaforge
go tool dist test -run='^testcshared|testcarchive$'
if errorlevel 1 exit 1
set "GO_BUILDER_NAME="


exit 0
