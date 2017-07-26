#!/bin/bash

tmp=`mktemp`
tmp2=`mktemp`
wget -N -P ./i386/repodata http://linuxdownload.adobe.com/linux/i386/repodata/repomd.xml
cat ./i386/repodata/repomd.xml | grep location > $tmp
sed 's/  <location href="/http:\/\/linuxdownload.adobe.com\/linux\/i386\//g' $tmp > $tmp2
sed 's/"\/>//g' $tmp2>$tmp
while IFS='' read -r line || [[ -n "$line" ]]; do
wget -N -P ./i386/repodata $line
done <$tmp


tmp3=`mktemp`
bzip2 -dk `ls -1 ./i386/repodata/*-primary.sqlite.bz2`

sqlite3 `ls -1 ./i386/repodata/*-primary.sqlite` << SQL_ENTRY_TAG_1 > $tmp3
SELECT location_href FROM packages;
SQL_ENTRY_TAG_1

while IFS=`` read -r line || [[ -n "$line" ]]; do
wget -N -P ./i386 http://linuxdownload.adobe.com/linux/i386/$line
done<$tmp3
rm -f ./i386/repodata/*.sqlite
rm -f $tmp3

rm -f $tmp
rm -f $tmp2

tmp=`mktemp`
tmp2=`mktemp`
wget -N -P ./x86_64/repodata http://linuxdownload.adobe.com/linux/x86_64/repodata/repomd.xml
cat ./x86_64/repodata/repomd.xml | grep location > $tmp
sed 's/  <location href="/http:\/\/linuxdownload.adobe.com\/linux\/x86_64\//g' $tmp > $tmp2
sed 's/"\/>//g' $tmp2>$tmp
while IFS='' read -r line || [[ -n "$line" ]]; do
wget -N -P ./x86_64/repodata $line
done <$tmp


tmp3=`mktemp`
bzip2 -dk `ls -1 ./x86_64/repodata/*-primary.sqlite.bz2`

sqlite3 `ls -1 ./x86_64/repodata/*-primary.sqlite` << SQL_ENTRY_TAG_1 > $tmp3
SELECT location_href FROM packages;
SQL_ENTRY_TAG_1

while IFS=`` read -r line || [[ -n "$line" ]]; do
wget -N -P ./x86_64 http://linuxdownload.adobe.com/linux/x86_64/$line
done<$tmp3
rm -f ./x86_64/repodata/*.sqlite
rm -f $tmp3

rm -f $tmp
rm -f $tmp2
