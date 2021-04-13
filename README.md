# confluent-ce-docker
Confluent community edition docker file to run in standalone mode

## Command to execute
> Build image
`docker-compose build`

> Run image in container
`docker-compose up -d`

> Docker logs
`docker logs confluent-community`

> to execute commands (sample below)
`docker exec -it confluent-community curl localhost:8081/subjects`
