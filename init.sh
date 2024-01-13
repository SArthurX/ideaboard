export PGPASSWORD=mysecretpassword
psql -h localhost -U postgres -p 5433 -a -w -f example.sql

