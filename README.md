# project-swoop
## A Professional Development project for Dinosaurs

## Stack

Frontend: React (TypeScript?), Bootstrap

Backend: FastAPI, SQLAlchemy, MongoDb, Postgres

Backend Data Import: MySQL -> MongoDb

### To Restore DB (manually)
1. Download from https://www.comics.org/download/ (account required), unzip to project root
1. `just up` to start containers
1. Open a terminal in the container using `docker exec -ti {mysql_container_id} bash`
1. Enter the mysql CLI using `mysql -u root -p`
1. Run the following:
    * `create schema gcdonline;`
    * `create user gcdonline;`
    * `grant all on gcdonline.* to gcdonline;`
1. Type `exit` to close the mysql cli, then `exit` again to exit the container shell
1. From project root, run `docker exec -i {mysql_container_id} /usr/bin/mysql -u root --password={password} gcdonline < {extracted_filename}.sql` (takes a bit of time)

### To Restore DB (automatically)
1. Download from https://www.comics.org/download/ (account required), unzip to project root
1. `just up` to start containers
1. `sh import_gcdb_dump.sh`
