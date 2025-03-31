# puntos_point

run project

docker-compose build
docker-compose up
docker-compose run web rake db:migrate
docker-compose run web rake db:seed


for rails console

docker compose exec web rails console
docker-compose run --rm web rake routes
