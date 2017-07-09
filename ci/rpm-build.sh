#!/bin/bash

commit='3b4bbd5a11a1ac3bf3597daeee23306000d83a5c'

mkdir -p /usr/src/rpm/SOURCES/

echo $commit
version=$(wget -q https://raw.githubusercontent.com/hyperledger/indy-sdk/$commit/Cargo.toml -O - | grep -E '^version =' | head -n1 | cut -f2 -d= | tr -d '" ')
echo $version

[ -z $version ] && exit 1
[ -z $commit ] && exit 2

cd ci
whoami        
sed \
	-e "s|@commit@|$commit|g" \
	-e "s|@version@|$version.$commit|g" \
	indy-sdk.spec.in >indy-sdk.spec

spectool -g -R indy-sdk.spec || exit 3
echo 666
rpmbuild -ba indy-sdk.spec || exit 4
echo 777