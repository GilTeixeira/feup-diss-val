#!/bin/sh

## VARS
PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/cpp"
PATH_TO_PROJECT_CLASSES_FILES="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/java/build/classes/java/main/store/*.class"
LANGUAGE="cpp"
TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`


## Results Folder
mkdir results/$TIMESTAMP


## Run analizo
mkdir results/$TIMESTAMP/analizo
cd analizo
sh run.sh ${PATH_TO_PROJECT_FOLDER} ../results/$TIMESTAMP/analizo/
cd ..


## Run LARA
mkdir results/$TIMESTAMP/lara
PATH_RESULTS_LARA=$(pwd)/results/$TIMESTAMP/lara/

PATH_TO_LARA_METRICS_INTERFACE="/home/gildt/Desktop/feup-diss/lara/Interface.lara"
echo $PATH_RESULTS_LARA

## TODO
clava $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
mv full_results.txt $PATH_RESULTS_LARA

# Parse results
TOOL=$PATH_RESULTS_LARA npm start --prefix ./parser/


## Run CKJM
mkdir results/$TIMESTAMP/ckjm
PATH_RESULTS_CKJM=$(pwd)/results/$TIMESTAMP/ckjm/
java -jar ./ckjm/build/ckjm-1.9.jar $PATH_TO_PROJECT_CLASSES_FILES
mv time_results.txt $PATH_RESULTS_CKJM
mv full_results.txt $PATH_RESULTS_CKJM