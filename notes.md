
import-concepts on 8000
validation on 8001






Run import concepts

  docker run -it --rm -v $PWD:/app \
    -e SPARQL_ENDPOINT="http://virtuoso:8890/sparql-graph-crud" \
    -v /data \
    -p 8000:9000 --net user_bridge \
    import-concepts

Upload file with

  curl -X POST -T example.tsv http://localhost:8000/import/taxonomy

  curl -X POST -T example.tsv http://localhost/import-concepts/import/taxonomy


Run validation service

  docker run -p 8001:80 --volume $PWD:/app -it --rm -e MU_SPARQL_ENDPOINT="http://virtuoso:8890/sparql" -e RACK_ENV=development -e LOG_LEVEL=debug -v $PWD/config:/config  --net user_bridge  validation-service

Validate a file

  curl -X POST -H "Content-Length: 0" http://localhost:8001/validations/run?graph=

Run copy service

  docker run -it --rm \
    -e SPARQL_ENDPOINT="http://virtuoso:8890/sparql-graph-crud" \
    -p 8002:9000 --net user_bridge \
    copy-graph