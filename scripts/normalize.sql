-- weapon (which weapon_inventory depends on)

DROP TABLE IF EXISTS weapon CASCADE;

CREATE TABLE weapon(
  id INT PRIMARY KEY,
  name TEXT,
  special_power TEXT
);

INSERT INTO weapon(id, name, special_power)
(
  SELECT (j.doc::JSON -> 'weapon' ->> 'id')::INT,
         j.doc::JSON -> 'weapon' ->> 'name',
         j.doc::JSON -> 'weapon' ->> 'special_power'
  FROM import.raw_json AS j
)
ON CONFLICT (id) DO NOTHING;

-- weapon_inventory (which depends on weapon)

DROP TABLE IF EXISTS weapon_inventory;

CREATE TABLE weapon_inventory(
  id INT PRIMARY KEY,
  quantity INT,
  weapon_id INT REFERENCES weapon (id)
);

INSERT INTO weapon_inventory(id, quantity, weapon_id)
(
  SELECT (j.doc::JSON ->> 'id')::INT,
         (j.doc::JSON ->> 'quantity')::INT,
         (j.doc::JSON -> 'weapon' ->> 'id')::INT
  FROM import.raw_json AS j
);
