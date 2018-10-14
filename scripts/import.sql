CREATE SCHEMA IF NOT EXISTS import;
DROP TABLE IF EXISTS import.raw_json;
CREATE TABLE import.raw_json(doc text);
