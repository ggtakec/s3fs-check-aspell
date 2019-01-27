#!/bin/sh
#
# s3fs-update-aspell-dictionaryl.sh
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
	echo "Usage:  $1 [--help(-h)] [add dictionary file | <word> <word> ...]"
	echo ""
}

#
# Globals
#
PRGNAME=`basename $0`
SCRIPTDIR=`dirname $0`
SCRIPTDIR=`cd ${SCRIPTDIR}; pwd`
S3FS_DICTIONARY="${SCRIPTDIR}/s3fs-personal.pws"
S3FS_DICTIONARY_BUP="${SCRIPTDIR}/s3fs-personal.pws.bak"

#
# Options
#
DICT_FILE=""
WORDS=""
while [ $# -ne 0 ]; do
	if [ "X$1" = "X" ]; then
		break

	elif [ "X$1" = "X-h" -o "X$1" = "X-H" -o "X$1" = "X--help" -o "X$1" = "X--HELP" ]; then
		func_usage $PRGNAME
		exit 0

	else
		if [ "X${DICT_FILE}" != "X" ]; then
			echo "[ERROR] Already set adding dictionary(${DICT_FILE})."
			exit 1
		fi
		if [ -f $1 ]; then
			if [ "X${WORDS}" != "X" ]; then
				echo "[ERROR] Already set adding words(${WORDS})."
				exit 1
			fi
			DICT_FILE=`cd $1; pwd`
		else
			if [ "X${WORDS}" != "X" ]; then
				WORDS="${WORDS} $1"
			else
				WORDS="$1"
			fi
		fi
	fi
	shift
done
if [ "X${DICT_FILE}" = "X" -a "X${WORDS}" = "X" ]; then
	echo "[ERROR] $PRGNAME needs adding dictionary or words."
	func_usage $PRGNAME
	exit 1
fi

#
# New words list to new dictionary file
#
TMP_DICT_FILE="/tmp/$$.tmp.pws"
NEW_DICT_FILE="/tmp/$$.new.pws"

cat ${S3FS_DICTIONARY} | grep -v 'personal_ws-1.1' > ${TMP_DICT_FILE}

if [ "X${DICT_FILE}" != "X" ]; then
	cat ${DICT_FILE} | grep -v 'personal_ws-1.1' >> ${TMP_DICT_FILE}
else
	for one in ${WORDS}; do
		echo ${one} >> ${TMP_DICT_FILE}
	done
fi

WORD_COUNT=`cat ${TMP_DICT_FILE} | sort | uniq | wc -l`

echo "personal_ws-1.1 en ${WORD_COUNT}" > ${NEW_DICT_FILE}
cat ${TMP_DICT_FILE} | sort | uniq >> ${NEW_DICT_FILE}

#
# replace file
#
rm -f ${S3FS_DICTIONARY_BUP}
cp -p ${S3FS_DICTIONARY} ${S3FS_DICTIONARY_BUP}
cat ${NEW_DICT_FILE} > ${S3FS_DICTIONARY}

rm ${TMP_DICT_FILE} ${NEW_DICT_FILE}

#
# Report
#
echo "------------------------------------------------------------"
echo " Update personal dictionary : Result"
echo "------------------------------------------------------------"
diff ${S3FS_DICTIONARY} ${S3FS_DICTIONARY_BUP}
echo "------------------------------------------------------------"

exit 0

#
# Local variables:
# tab-width: 4
# c-basic-offset: 4
# End:
# vim600: noet sw=4 ts=4 fdm=marker
# vim<600: noet sw=4 ts=4
#
