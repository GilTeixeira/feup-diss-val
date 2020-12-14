#!/bin/sh

## VARS

TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`
### SONAR VARS
SONAR_URL="http://localhost:9000"
###

#PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/cpp"
#PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/java/src/main/java"
#PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/pbeans-2.0.2/src"
#PATH_TO_PROJECT_CLASSES_FILES="/home/gildt/Desktop/feup-diss-val/test/elasticsearch/server/build/classes/java/main/org/elasticsearch/*.class"
#PATH_TO_PROJECT_FOLDER=$(pwd)/test/elasticsearch/buildSrc/src/main/java
#PATH_TO_PROJECT_CLASSES_FILES="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/java/build/classes/java/main/store/*.class"
#PROJECT_ID="elasticsearch" 

### PROJECT VARS
#PROJECT_ID="StoreJava" 
#LANGUAGE="java"
#PATH_TO_PROJECT_FOLDER=$(pwd)/test/java
#PATH_TO_PROJECT_CLASSES_FILES=$(pwd)/test/java/build/classes/java/main/store/*.class


PROJECT_ID="elasticsearch" 
PROJECT_ID="testElasticSearch" 

PROJECT_ID="axios" 

LANGUAGE="java"
#PATH_TO_PROJECT_FOLDER=$(pwd)/test/simdjson
PATH_TO_PROJECT_FOLDER=$(pwd)/test/elasticsearch/buildSrc
#PATH_TO_PROJECT_CLASSES_FILES=$(pwd)/test/elasticsearch/buildSrc/build-bootstrap/classes/java/main/org/elasticsearch/gradle/*.class





## Results Folder
mkdir results/$TIMESTAMP


# ## Run analizo
# mkdir results/$TIMESTAMP/analizo
# cd analizo
# sh run.sh ${PATH_TO_PROJECT_FOLDER} ../results/$TIMESTAMP/analizo/
# cd ..


# # ## Run LARA
mkdir results/$TIMESTAMP/lara
PATH_RESULTS_LARA=$(pwd)/results/$TIMESTAMP/lara/

# # PATH_TO_LARA_METRICS_INTERFACE="/home/gildt/Desktop/feup-diss/lara/Interface.lara"
# # echo $PATH_RESULTS_LARA

# # ## TODO
# # #clava $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
# # java -jar ./lara/clava/Clava.jar $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
# # #java -jar ./lara/kadabra/kadabra.jar  $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -WC -o $PATH_TO_PROJECT_FOLDER -s -X

# # mv full_results.txt $PATH_RESULTS_LARA

# # # Parse results
# RES_PATH=$PATH_RESULTS_LARA npm start --prefix ./parser/




# ## Run CKJM
# mkdir results/$TIMESTAMP/ckjm
# PATH_RESULTS_CKJM=$(pwd)/results/$TIMESTAMP/ckjm/
# java -jar ./ckjm/build/ckjm-1.9.jar $PATH_TO_PROJECT_CLASSES_FILES
# mv class_time_results.txt $PATH_RESULTS_CKJM
# mv full_results.txt $PATH_RESULTS_CKJM



# ## Run Sonarqube
# # cd test/elasticsearch/buildSrc/
# # ./gradlew sonarqube \
# #   -Dsonar.projectKey=elasticsearch \
# #   -Dsonar.host.url=http://localhost:9000 \
# #   -Dsonar.login=f700a1a49c7fd8ad8bbf8dd92e835c19b6031e38
# # cd ../../../

## Get Sonarqube results
mkdir results/$TIMESTAMP/sonarqube
PATH_RESULTS_SONAR=$(pwd)/results/$TIMESTAMP/sonarqube/
PATH_RESULTS_SONAR=${PATH_RESULTS_SONAR} SONAR_URL=${SONAR_URL} PROJECT_ID=${PROJECT_ID} npm start --prefix ./sonarqube-parser/

## REPLACEMENT LARA
#cp /home/gildt/Desktop/LARA/kadabra/JavaWeaver/run/file_results.txt ${PATH_RESULTS_LARA}
#cp /home/gildt/Desktop/LARA/kadabra/JavaWeaver/run/file_results.txt ${PATH_RESULTS_LARA}

cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/file_results.csv ${PATH_RESULTS_LARA}
cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/function_results.csv ${PATH_RESULTS_LARA}
cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/file_results.csv ${PATH_RESULTS_LARA}
cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/project_results.csv ${PATH_RESULTS_LARA}



# ## Merge results

RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_file_metrics --prefix ./merger/
RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_project_metrics --prefix ./merger/
# RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_class_metrics --prefix ./merger/