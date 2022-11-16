build *build_args:
    docker compose build {{build_args}}

up:
    docker compose up

down:
    docker compose down
    