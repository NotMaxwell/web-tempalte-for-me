web: ./bin/server
release: psql $DATABASE_URL -f migrations/0001_init.sql || true
