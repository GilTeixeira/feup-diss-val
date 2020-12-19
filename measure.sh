#!/bin/sh

## Parse Arguments

while getopts p:l:s: opts; do
   case ${opts} in
      p) PROJECT_PATH=${OPTARG} ;;
      l) LANG_PROJECT=${OPTARG} ;;
      s) SONAR_ID=${OPTARG} ;;
   esac
done


echo "Measuring Project: " $SONAR_ID



## VARS
TIMESTAMP=`date +%Y-%m-%d_%H-%M-%S`
RESULTS_FOLDER=$SONAR_ID::$TIMESTAMP
SONAR_URL="http://localhost:9000"



## Results Folder
mkdir results/$RESULTS_FOLDER


## Calculate Metrics

### Run analizo

if [ $LANG_PROJECT == 'java' ] || [ $LANG_PROJECT == 'c' ] || [ $LANG_PROJECT == 'cpp' ]
then
    echo "Using tool Analizo"

    mkdir results/$RESULTS_FOLDER/analizo
    cd analizo
    sh run.sh ${PROJECT_PATH} ../results/$RESULTS_FOLDER/analizo/
    cd ..
fi


### Retrive Sonar results
echo "Retriving Sonar results"
mkdir results/$RESULTS_FOLDER/sonarqube
PATH_RESULTS_SONAR=$(pwd)/results/$RESULTS_FOLDER/sonarqube/
PATH_RESULTS_SONAR=${PATH_RESULTS_SONAR} SONAR_URL=${SONAR_URL} PROJECT_ID=${SONAR_ID} npm start --prefix ./sonarqube-parser/


### Run CKJM
if [ $LANG_PROJECT == 'java' ] 
then
   mkdir results/$RESULTS_FOLDER/ckjm
   PATH_RESULTS_CKJM=$(pwd)/results/$RESULTS_FOLDER/ckjm/
   find ${PROJECT_PATH} -name '*.class' -print | java -jar ./ckjm/build/ckjm-1.9.jar
   mv class_results.csv $PATH_RESULTS_CKJM
   mv time_results_per_class.csv $PATH_RESULTS_CKJM
fi


# # # ## Run LARA
mkdir results/$RESULTS_FOLDER/lara
PATH_RESULTS_LARA=$(pwd)/results/$RESULTS_FOLDER/lara/
PATH_TO_LARA_METRICS_INTERFACE="$(pwd)/feup-diss/lara/Interface.lara"

if [ $LANG_PROJECT == 'c' ] || [ $LANG_PROJECT == 'cpp' ]
then
# # # #clava $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
# # # java -jar ./lara/clava/Clava.jar $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
   echo "Running Clava"
   java -jar ./lara/clava/Clava.jar  $PATH_TO_LARA_METRICS_INTERFACE -p $PROJECT_PATH -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
fi

if [ $LANG_PROJECT == 'java' ] 
then

java -jar ./lara/kadabra/kadabra.jar  $PATH_TO_LARA_METRICS_INTERFACE -p $PROJECT_PATH -WC -o $PATH_RESULTS_LARA -s -X
fi

if [ $LANG_PROJECT == 'javascript' ] 
then
   echo "Running Jackdaw"
fi

RES_PATH=$PATH_RESULTS_LARA npm start --prefix ./parser/

mv function_results.csv $PATH_RESULTS_LARA
mv file_results.csv $PATH_RESULTS_LARA
mv class_results.csv $PATH_RESULTS_LARA
mv project_results.csv $PATH_RESULTS_LARA

#### Parse results
RES_PATH=$PATH_RESULTS_LARA npm start --prefix ./parser/



### Parse Understand Results
mkdir results/$RESULTS_FOLDER/understand
PATH_RESULTS_UNDERSTAND=$(pwd)/results/$RESULTS_FOLDER/understand/
PROJ_PATH=$PROJECT_PATH RES_PATH=$PATH_RESULTS_UNDERSTAND npm start --prefix ./understand-parser/






## Merge Results

RES_PATH=$(pwd)/results/$RESULTS_FOLDER FILE_TO_MERGE=file_results.csv npm run merge_metrics --prefix ./merger/
RES_PATH=$(pwd)/results/$RESULTS_FOLDER FILE_TO_MERGE=class_results.csv npm run merge_metrics --prefix ./merger/
RES_PATH=$(pwd)/results/$RESULTS_FOLDER FILE_TO_MERGE=function_results.csv npm run merge_metrics --prefix ./merger/
#RES_PATH=$(pwd)/results/$RESULTS_FOLDER npm run merge_file_metrics --prefix ./merger/
RES_PATH=$(pwd)/results/$RESULTS_FOLDER npm run merge_project_metrics --prefix ./merger/

# #
#RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_class_metrics --prefix ./merger/





# ##########################


# ###
# #PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/cpp"
# #PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/java/src/main/java"
# #PATH_TO_PROJECT_FOLDER="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/pbeans-2.0.2/src"
# #PATH_TO_PROJECT_CLASSES_FILES="/home/gildt/Desktop/feup-diss-val/test/elasticsearch/server/build/classes/java/main/org/elasticsearch/*.class"
# #PATH_TO_PROJECT_FOLDER=$(pwd)/test/elasticsearch/buildSrc/src/main/java
# #PATH_TO_PROJECT_CLASSES_FILES="/home/gildt/Desktop/feup-diss/MetricsCalculators/test/java/build/classes/java/main/store/*.class"
# #PROJECT_ID="elasticsearch" 

# ### PROJECT VARS
# #PROJECT_ID="StoreJava" 
# #LANGUAGE="java"
# #PATH_TO_PROJECT_FOLDER=$(pwd)/test/java
# #PATH_TO_PROJECT_CLASSES_FILES=$(pwd)/test/java/build/classes/java/main/store/*.class


# #PROJECT_ID="elasticsearch" 
# #PROJECT_ID="testElasticSearch" 

# #PROJECT_ID="axios" 
# #PROJECT_ID="phonenumbers-java" 

# #LANGUAGE="java"
# #PATH_TO_PROJECT_FOLDER=$(pwd)/test/simdjson
# #PATH_TO_PROJECT_FOLDER=$(pwd)/test/elasticsearch/buildSrc
# #PATH_TO_PROJECT_CLASSES_FILES=$(pwd)/test/elasticsearch/buildSrc/build-bootstrap/classes/java/main/org/elasticsearch/gradle/*.class











# # # ## Run LARA
# mkdir results/$TIMESTAMP/lara
# PATH_RESULTS_LARA=$(pwd)/results/$TIMESTAMP/lara/

# # # PATH_TO_LARA_METRICS_INTERFACE="/home/gildt/Desktop/feup-diss/lara/Interface.lara"
# # # echo $PATH_RESULTS_LARA

# # # ## TODO
# # # #clava $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
# # # java -jar ./lara/clava/Clava.jar $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -ncg -cl -o $PATH_RESULTS_LARA -thd 4 -s -nci -pi -of woven
# # # #java -jar ./lara/kadabra/kadabra.jar  $PATH_TO_LARA_METRICS_INTERFACE -p $PATH_TO_PROJECT_FOLDER -WC -o $PATH_TO_PROJECT_FOLDER -s -X

# # # mv full_results.txt $PATH_RESULTS_LARA

# # # # Parse results
# # RES_PATH=$PATH_RESULTS_LARA npm start --prefix ./parser/




# # ## Run CKJM
# # mkdir results/$TIMESTAMP/ckjm
# # PATH_RESULTS_CKJM=$(pwd)/results/$TIMESTAMP/ckjm/
# # java -jar ./ckjm/build/ckjm-1.9.jar $PATH_TO_PROJECT_CLASSES_FILES
# # mv class_time_results.txt $PATH_RESULTS_CKJM
# # mv full_results.txt $PATH_RESULTS_CKJM



# # ## Run Sonarqube
# # # cd test/elasticsearch/buildSrc/
# # # ./gradlew sonarqube \
# # #   -Dsonar.projectKey=elasticsearch \
# # #   -Dsonar.host.url=http://localhost:9000 \
# # #   -Dsonar.login=f700a1a49c7fd8ad8bbf8dd92e835c19b6031e38
# # # cd ../../../


# ## REPLACEMENT LARA
# #cp /home/gildt/Desktop/LARA/kadabra/JavaWeaver/run/file_results.csv ${PATH_RESULTS_LARA}
# cp /home/gildt/Desktop/LARA/kadabra/JavaWeaver/run/file_results.csv ${PATH_RESULTS_LARA}

# #cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/file_results.csv ${PATH_RESULTS_LARA}
# #cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/function_results.csv ${PATH_RESULTS_LARA}
# #cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/file_results.csv ${PATH_RESULTS_LARA}
# #cp /home/gildt/Desktop/LARA/jsweaver/jsweaver/project_results.csv ${PATH_RESULTS_LARA}



# # ## Merge results

# RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_file_metrics --prefix ./merger/
# #RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_project_metrics --prefix ./merger/
# # RES_PATH=$(pwd)/results/$TIMESTAMP npm run merge_class_metrics --prefix ./merger/