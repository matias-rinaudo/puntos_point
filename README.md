# puntos_point

run project

docker-compose build
docker-compose up
docker-compose run web rake db:migrate
docker-compose run web rake db:seed

for rails console

docker compose exec web rails console
docker-compose run --rm web rake routes
docker-compose run web rake db:create RAILS_ENV=test
docker-compose run --rm web bundle exec rspec
docker-compose run web rake db:migrate RAILS_ENV=test
docker-compose run web rake db:seed RAILS_ENV=test