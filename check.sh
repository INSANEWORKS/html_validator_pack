#!/bin/bash
trap "rm *.tmp" 0

PREFIX=`dirname $0`

find . \( -type d -and -name "`basename $PREFIX`" -and -prune \) -or \( -type f -name '*.html' -print \) > tmplists.tmp
find . \( -type d -and -name "`basename $PREFIX`" -and -prune \) -or \( -type f -name '*.css'  -print \) > tmplists_css.tmp
find . \( -type d -and -name "`basename $PREFIX`" -and -prune \) -or \( -type f -name '*.js'   -print \) > tmplists_js.tmp
find . \( -type d -and -name "`basename $PREFIX`" -and -prune \) -or \( -type f -name '*.php'  -print \) > tmplists_php.tmp

if [ -f excludes ]; then
	grep -vf excludes tmplists.tmp     > validator_list.tmp
	grep -vf excludes tmplists_css.tmp > validator_list_css.tmp
	grep -vf excludes tmplists_js.tmp  > validator_list_js.tmp
	grep -vf excludes tmplists_php.tmp > validator_list_php.tmp
else
	cp tmplists.tmp     validator_list.tmp
	cp tmplists_css.tmp validator_list_css.tmp
	cp tmplists_js.tmp  validator_list_js.tmp
	cp tmplists_php.tmp validator_list_php.tmp
fi

cd $PREFIX/tidy-html5
make -C build/gmake/
cd -

cd $PREFIX/javascriptlint
make install
cd -

while read i; do
	echo "Process $i ... "
	$PREFIX/tidy-html5/bin/tidy -e -q -raw $i
	if [ $? = 0 ]; then
		echo -ne "\e[32m"
		echo -e "SUCCESS!!"
		echo -e "\e[0m"
	else
		echo -ne "\e[31m"
		echo -e "FAIL.."
		echo -e "\e[0m"
		val=1
	fi
done < validator_list.tmp

while read i; do
	echo "Process $i ... "
	php -d include_path=$PREFIX/CSSTidy $PREFIX/csstidy-cmd/csstidy $i 2>&1 | grep '^[0-9]'
	if [ $? = 1 ]; then
		echo -ne "\e[32m"
		echo -e "SUCCESS!!"
		echo -e "\e[0m"
	else
		echo -ne "\e[31m"
		echo -e "FAIL.."
		echo -e "\e[0m"
		val=1
	fi
done < validator_list_css.tmp

while read i; do
	echo "Process $i ... "
	$PREFIX/javascriptlint/build/install/jsl --conf $PREFIX/jsl.conf --nologo --nofilelisting --nosummary $i
	if [ $? = 0 ]; then
		echo -ne "\e[32m"
		echo -e "SUCCESS!!"
		echo -e "\e[0m"
	else
		echo -ne "\e[31m"
		echo -e "FAIL.."
		echo -e "\e[0m"
		val=1
	fi
done < validator_list_js.tmp

while read i; do
	echo "Process $i ... "
	php -l  $i > /dev/null
	if [ $? = 0 ]; then
		echo -ne "\e[32m"
		echo -e "SUCCESS!!"
		echo -e "\e[0m"
	else
		echo -ne "\e[31m"
		echo -e "FAIL.."
		echo -e "\e[0m"
		val=1
	fi
done < validator_list_php.tmp

exit $val
