#!/bin/sh
#
# s3fs-check-aspell.sh
#
# Copyright(C) 2019 Takeshi Nakatani <ggtakec@gmail.com>
#
# This script is a tool to check spelling of s3fs-fuse source code.
# The tool acts as a wrapper for GNU Aspell(http://aspell.net/).
# This uses a personal dictionary dedicated to s3fs.
#
# For the full copyright and license information, please view
# the license file that was distributed with this source code.
#
# AUTHOR:   Takeshi Nakatani
# CREATE:   Wed 7 Dec 2016
# REVISION:
# 

#
# Usage
#
func_usage()
{
	echo ""
	echo "Usage:  $1 [--help(-h)] <s3fs-fuse source top directory>"
	echo ""
}

#
# Globals
#
PRGNAME=`basename $0`
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`cd ${SCRIPTDIR}; pwd`
S3FS_DICTIONARY="${SCRIPTDIR}/s3fs-personal.pws"

#
# Options
#
S3FS_BASE_DIR=""
while [ $# -ne 0 ]; do
	if [ "X$1" = "X" ]; then
		break

	elif [ "X$1" = "X-h" -o "X$1" = "X-H" -o "X$1" = "X--help" -o "X$1" = "X--HELP" ]; then
		func_usage $PRGNAME
		exit 0

	else
		if [ "X${S3FS_BASE_DIR}" != "X" ]; then
			echo "[ERROR] Already set s3fs-fuse repository directory path(${S3FS_BASE_DIR})."
			exit 1
		fi
		if [ ! -d $1 ]; then
			echo "[ERROR] $1 is not directory."
			exit 1
		fi
		S3FS_BASE_DIR=`cd $1; pwd`
	fi
	shift
done
if [ "X${S3FS_BASE_DIR}" = "X" ]; then
	echo "[ERROR] $PRGNAME needs s3fs-fuse repository directory path."
	func_usage $PRGNAME
	exit 1
fi

#
# File list
#
cd ${S3FS_BASE_DIR}
if [ $? -ne 0 ]; then
	echo "[ERROR] could not change directory ${S3FS_BASE_DIR}."
	exit 1
fi
S3FS_CSOURCES=`git ls-files | grep -e '\.cpp$' -e '\.h$' -e '\.cc$' -e '\.c$' 2>/dev/null`
S3FS_CSOURCES=`echo ${S3FS_CSOURCES}`
S3FS_MANPAGES=`git ls-files | grep 'doc/man/' 2>/dev/null`
S3FS_MANPAGES=`echo ${S3FS_MANPAGES}`
S3FS_TEXTFILES=`git ls-files | grep -v '\.cpp$' | grep -v '\.h$' | grep -v '\.cc$' | grep -v '\.c$' | grep -v 'doc/man/' | grep -v '\.png$' | grep -v '\.jks$' 2>/dev/null`
S3FS_TEXTFILES=`echo ${S3FS_TEXTFILES}`

#
# Check files
#
ASPELL_TMP_FILE="/tmp/${PRGNAME}.$$.tmp"
ASPELL_RESULT_FILE="/tmp/${PRGNAME}.$$.result"
cat /dev/null > ${ASPELL_RESULT_FILE}

if [ "X${S3FS_CSOURCES}" != "X" ]; then
	cat ${S3FS_CSOURCES}  | aspell --lang=en --encoding=utf-8 -C -B --ignore-case --personal=${S3FS_DICTIONARY} --mode=ccpp  list >> ${ASPELL_TMP_FILE}
fi
if [ "X${S3FS_MANPAGES}" != "X" ]; then
	cat ${S3FS_MANPAGES}  | aspell --lang=en --encoding=utf-8 -C -B --ignore-case --personal=${S3FS_DICTIONARY} --mode=nroff list >> ${ASPELL_TMP_FILE}
fi
if [ "X${S3FS_TEXTFILES}" != "X" ]; then
	cat ${S3FS_TEXTFILES} | aspell --lang=en --encoding=utf-8 -C -B --ignore-case --personal=${S3FS_DICTIONARY}              list >> ${ASPELL_TMP_FILE}
fi

cat ${ASPELL_TMP_FILE} | sort | uniq > ${ASPELL_RESULT_FILE}

#
# Print result
#
LINE_COUNT=`cat ${ASPELL_RESULT_FILE} | wc -l`

echo "------------------------------------------------------------"
echo " Spell check result : Unknown words"
echo "------------------------------------------------------------"
echo "Found unknown word count : ${LINE_COUNT}"
echo ""
cat ${ASPELL_RESULT_FILE}
echo "------------------------------------------------------------"

rm -f ${ASPELL_TMP_FILE} ${ASPELL_RESULT_FILE}

exit 0

#
# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noet sw=4 ts=4 fdm=marker
# vim<600: noet sw=4 ts=4
#
