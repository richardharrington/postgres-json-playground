-- cd (which ab depends on)

DROP TABLE IF EXISTS cd CASCADE;

CREATE TABLE cd(
  id SERIAL PRIMARY KEY,
  external_id INT UNIQUE,
  c TEXT,
  d TEXT
);

INSERT INTO cd(external_id, c, d)
(
  SELECT (j.doc::JSON -> 'b' ->> 'external_id')::INT,
         j.doc::JSON -> 'b' ->> 'c',
         j.doc::JSON -> 'b' ->> 'd'
  FROM import.raw_json AS j
)
ON CONFLICT (external_id) DO NOTHING;

-- ab (which depends on cd)

DROP TABLE IF EXISTS ab;

CREATE TABLE ab(
  id SERIAL PRIMARY KEY,
  external_id INT UNIQUE,
  a INT,
  b INT REFERENCES cd (external_id)
);

INSERT INTO ab(external_id, a, b)
(
  SELECT (j.doc::JSON ->> 'external_id')::INT,
         (j.doc::JSON ->> 'a')::INT,
         (j.doc::JSON -> 'b' ->> 'external_id')::INT
  FROM import.raw_json AS j
);
