CREATE DATABASE kterletskyi_db2;
\c kterletskyi_db2;
CREATE TABLE person (
    person_id int ,
    last_name varchar(255),
    first_name varchar(255),
    city varchar(255),
    PRIMARY KEY (person_id)
);

INSERT INTO person (person_id,last_name,first_name,city)
VALUES (1, 'Ramesh', 'Ahmedabad', 'Kabul' );

INSERT INTO person (person_id,last_name,first_name,city)
VALUES (2, 'Khilan', 'Delhi', 'Dakar' );

INSERT INTO person (person_id,last_name,first_name,city)
VALUES (3, 'Mykola', 'Kota', 'L`viv' );

SELECT * FROM person;
