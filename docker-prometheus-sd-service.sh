#!/usr/bin/env bash

#
# Function responsible to add specific instances to a prometheus service discovery file
#
function addPrometheusServiceDiscoveryService {
  CONTAINER_PREFIX=$1
  PORT=$2

  NUM_INSTANCES=()
  while IFS='' read -r line; do NUM_INSTANCES+=("$line"); done < <(docker ps | grep -oh "\w*$CONTAINER_PREFIX\w*")

  TARGETS=''
  for var in "${NUM_INSTANCES[@]}"
  do
    CONTAINER_NUMBER=${var//$CONTAINER_PREFIX}
    CONTAINER_EXPOSED_PORT=$(docker port "$CONTAINER_PREFIX$CONTAINER_NUMBER" "$PORT" | cut -d':' -f 2)

    echo "$CONTAINER_EXPOSED_PORT"
    if [ ! -z "$CONTAINER_EXPOSED_PORT" ]
    then
      TARGETS+="\"host.docker.internal:$CONTAINER_EXPOSED_PORT\", "
    fi

  done

  SERVICE_NAME=$3
  TARGETS_JSON_PATH=$4

if [ "${#NUM_INSTANCES[@]}" -gt 0 ] && [ ! -z "$TARGETS" ]
then
  TARGETS=${TARGETS::${#TARGETS}-2}

  if [ -f "$TARGETS_JSON_PATH/targets.json" ] && grep -q "\"job\": \"instances_" "$TARGETS_JSON_PATH/targets.json";
  then

    CONTENT="\ \ \{ \n \ \ \ \"targets\": [ $TARGETS ]\, \n \ \ \ \"labels\": \{ \n \ \ \ \ \ \"env\": \"local\", \n \ \ \ \ \ \"job\": \"instances_$SERVICE_NAME\" \n \ \ \ \} \n \ \},";

    gsed -i "\$i $CONTENT" "$TARGETS_JSON_PATH"/targets.json

  else
  echo "[
  {
    \"targets\": [ $TARGETS ],
    \"labels\": {
      \"env\": \"local\",
      \"job\": \"instances_$SERVICE_NAME\"
    }
  },
]" > "$TARGETS_JSON_PATH"/targets.json
fi
  fi

}

function createPrometheusServiceDiscoveryFile {
  YAML_FILE="$1";
  echo "$YAML_FILE"

  TARGETS_JSON_PATH=$(yq r "$YAML_FILE" target_json_path)

  true > "$TARGETS_JSON_PATH"/targets.json

  COUNT_SERVICES_IN_YML_FILE=$(yq r "$YAML_FILE" --length services)

  for ((i=0; i<COUNT_SERVICES_IN_YML_FILE; i++))
  do
    SERVICE_NAME_YML=$(yq r "$YAML_FILE" "services[$i].name")
    CONTAINER_PREFIX_YML=$(yq r "$YAML_FILE" "services[$i].container_prefix")
    CONTAINER_PORT_YML=$(yq r "$YAML_FILE" "services[$i].internal_port")

    addPrometheusServiceDiscoveryService "$CONTAINER_PREFIX_YML" "$CONTAINER_PORT_YML" "$SERVICE_NAME_YML" "$TARGETS_JSON_PATH"
  done

  if [ -f "$TARGETS_JSON_PATH/targets.json" ] && grep -q "\"job\": \"instances_" "$TARGETS_JSON_PATH/targets.json";
  then
    gsed -i "x;\${s/,$//;p;x;};1d" "$TARGETS_JSON_PATH/targets.json"
  fi
}

while true; do
  createPrometheusServiceDiscoveryFile "$1"
  sleep 5
done