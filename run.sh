#bash ./measure.sh -p $(pwd)/test/elasticsearch/buildSrc -l 'java' -s 'elasticsearch' 
#sh test.sh -p /home/kristoffer/test.png -l /home/kristoffer/test.txt -s 'phonenumbers-java' 

#bash ./measure.sh -p $(pwd)/test/cpp -l 'cpp' -s 'store-cpp' 
## Java Projects
bash ./measure.sh -p $(pwd)/test/store-java -l 'java' -s 'store-java' 
#bash ./measure.sh -p $(pwd)/test/libphonenumber/java -l 'java' -s 'libphonenumber-java' -j $(pwd)/test/libphonenumber/java/lib/
#bash ./measure.sh -p $(pwd)/test/elasticsearch/buildSrc -l 'java' -s 'elasticsearch' -x


## JavaScript Projects
#bash ./measure.sh -p $(pwd)/test/libphonenumber/javascript -l 'javascript' -s 'libphonenumber-js'
#bash ./measure.sh -p $(pwd)/test/axios/lib -l 'javascript' -s 'axios'


## C++ Projects
#bash ./measure.sh -p $(pwd)/test/store-cpp -l 'cpp' -s 'store-cpp'
#bash ./measure.sh -p $(pwd)/test/json/single_include/nlohmann -l 'cpp' -s 'nlohmann-json-single'