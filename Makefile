up:
	docker-compose build
	docker-compose up -d

ssh:
	docker-compose exec grafanim bash
