#/bin/bash

$(aws ecr get-login)
kubectl patch secret $SECRET_NAME -p "{\"data\":{\".dockerconfigjson\": \"$(cat ~/.docker/config.json|base64 -w 0)\"}}"
