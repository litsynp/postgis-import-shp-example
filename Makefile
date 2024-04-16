# From https://business.juso.go.kr/
juso\:unzip:
	. scripts/juso-extract.sh
juso\:clean:
	. scripts/juso-clean.sh

db\:up:
	docker compose up -d
db\:down:
	docker compose down
db\:destroy:
	docker compose down -v

migration\:create:
	docker compose exec postgres bash -c 'source ./scripts/generate_geom_sql.sh'
migration\:migrate:
	# run all in migrations/**/*.sql where ** can be any directory
	docker compose exec postgres bash -c 'for f in ./migrations/**/*.sql; do psql -U postgres -d postgres -f $$f; done'
migration\:clean:
	rm -rf migrations

create:
	# Creates shapefiles under migrations directory
	make destroy
	make migration\:clean
	make juso\:unzip
	make db\:up
	make migration\:create
	make migration\:migrate

shell:
	docker compose exec postgres bash

destroy:
	make db\:destroy
	make juso\:clean
