-- inner_table (which outer_table depends on)

DROP TABLE IF EXISTS inner_table CASCADE;

CREATE TABLE inner_table(
  id INT PRIMARY KEY,
  b TEXT,
  c TEXT
);

INSERT INTO inner_table(id, b, c)
(
  SELECT (j.doc::JSON -> 'inner_table' ->> 'id')::INT,
         j.doc::JSON -> 'inner_table' ->> 'b',
         j.doc::JSON -> 'inner_table' ->> 'c'
  FROM import.raw_json AS j
)
ON CONFLICT (id) DO NOTHING;

-- outer_table (which depends on inner_table)

DROP TABLE IF EXISTS outer_table;

CREATE TABLE outer_table(
  id INT PRIMARY KEY,
  a INT,
  inner_table_id INT REFERENCES inner_table (id)
);

INSERT INTO outer_table(id, a, inner_table_id)
(
  SELECT (j.doc::JSON ->> 'id')::INT,
         (j.doc::JSON ->> 'a')::INT,
         (j.doc::JSON -> 'inner_table' ->> 'id')::INT
  FROM import.raw_json AS j
);
