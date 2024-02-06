-- Check number of available places in 'SCHRONISKO NA HALI ORNAK' for 2024-01-16
SELECT SUM("num_of_beds") AS "total number of beds available in SCHRONISKO NA HALI ORNAK" FROM "rooms"
    WHERE "mountain_hut_id" = (SELECT "id" FROM "mountain_huts" WHERE "name" = 'SCHRONISKO NA HALI ORNAK');

SELECT SUM("num_of_beds") AS "number of beds available for 2024-01-16 in SCHRONISKO NA HALI ORNAK" FROM "rooms"
    WHERE "mountain_hut_id" = (SELECT "id" FROM "mountain_huts" WHERE "name" = 'SCHRONISKO NA HALI ORNAK')



INSERT INTO "bookings" ("customer_id", "mountain_hut_id", "date", "num_of_people", "breakfast", "confirmed")
VALUES
('1', '2', '2024-01-15', '1', '1', '1');


SELECT SUM("num_of_people")
    FROM "bookings"
        WHERE "mountain_hut_id" = '1' AND "date" = '2024-01-15';
