# FILES=*.rst
# for f in $FILES
# do
#   filename="${f%.*}"
#   echo "Converting $f to $filename.md"
#   `pandoc $f -f rst -t markdown -o $filename.md`
# done

for rst in $(find . -name '*.rst'); do
    echo $rst;
    pandoc --from=rst --to=markdown --output=$(dirname $rst)/$(basename ${rst/.rst/}).md $rst;
    rm -rf $rst; # 删除
    # echo "${rst/.rst/}"; # 替换空
    #mv $md ${md/.md/}; # 改名
done
