up:
	docker-compose build --no-cache
	docker-compose up -d

test:
	docker-compose exec grafanim nim c -r tests/test.nim

ssh:
	docker-compose exec grafanim bash
