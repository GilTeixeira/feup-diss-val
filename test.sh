f () {
   sleep 1

}

start=`date +%s%N`
f
end=`date +%s%N`
echo Execution time was `expr $end - $start` nanoseconds.


#'/(?<=Total time: )(.*)(?=s)/g'

#myvariable=$(awk '/(?<=Total time: )(.*)(?=s)/g{print $1}' ./test/axios/sonar.txt)




#grep "Total time:" ./test/axios/sonar.txt | sed 's/^.*: //' | sed 's/.$//'
#
#grep "Total time:" ./test/libphonenumber/java/sonar.txt | sed 's/^.*: //' | sed -r 's/^([^.]+).*$/\1/; s/^[^0-9]*([0-9]+).*$/\1/'
#grep "Total time:" ./test/axios/sonar.txt | sed 's/^.*: //'  | grep -Eo '[+-]?[0-9]+([.][0-9]+)?'


echo wut1 
#myvariable1=$(grep 'Total time:\|BUILD SUCCESSFUL in ' ./test/axios/sonar.txt | sed 's/^.*: //'  | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
myvariable1=$(grep 'Total time:\|BUILD SUCCESSFUL in ' ./test/elasticsearch/buildSrc/sonar.txt | sed 's/^.*: //'  | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
echo "-"$myvariable1"-"

## Get Time from sonar files
#myvariable2=$(grep "Total time:\|BUILD SUCCESSFUL in " ./test/libphonenumber/java/sonar.txt | sed 's/^.*: //'  | grep -Eo '[+-]?[0-9]+([.][0-9]+)?')
result=$(awk '{printf "%f", $1 * 1000 * 1000 * 1000}' <<<"${myvariable1}")
echo "-"$myvariable1"-" 

echo `expr $myvariable1 * 1000 * 1000 * 1000`

echo $result
echo $myvariable2