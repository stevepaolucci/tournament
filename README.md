# README
## Rails
### Building

```
cd tournament

docker build -t app .

docker volume create app-storage

docker run --rm -it -v app-storage:/rails/storage --name rails_app -d --network rails -p 3000:3000 app
 
-d for detached mode

```


## Redis
### Dockerfile
```
FROM redis:latest

# Usually runs on 6379
EXPOSE 6400

CMD ["redis-server", "--port", "6400"]
```
### Building
```
docker build -t redis_image ./redis/.
docker run --network rails --name redis_app -p 6400:6400 -d redis_image
```