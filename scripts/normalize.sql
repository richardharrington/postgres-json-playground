-- inner_table (which outer_table depends on)

DROP TABLE IF EXISTS inner_table CASCADE;

CREATE TABLE inner_table(
  id SERIAL PRIMARY KEY,
  external_id INT UNIQUE,
  b TEXT,
  c TEXT
);

INSERT INTO inner_table(external_id, b, c)
(
  SELECT (j.doc::JSON -> 'inner_table' ->> 'external_id')::INT,
         j.doc::JSON -> 'inner_table' ->> 'b',
         j.doc::JSON -> 'inner_table' ->> 'c'
  FROM import.raw_json AS j
)
ON CONFLICT (external_id) DO NOTHING;

-- outer_table (which depends on inner_table)

DROP TABLE IF EXISTS outer_table;

CREATE TABLE outer_table(
  id SERIAL PRIMARY KEY,
  external_id INT UNIQUE,
  a INT,
  inner_table_external_id INT REFERENCES inner_table (external_id)
);

INSERT INTO outer_table(external_id, a, inner_table_external_id)
(
  SELECT (j.doc::JSON ->> 'external_id')::INT,
         (j.doc::JSON ->> 'a')::INT,
         (j.doc::JSON -> 'inner_table' ->> 'external_id')::INT
  FROM import.raw_json AS j
);
