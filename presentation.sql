INSERT INTO "customers" ("id","name", "surname", "tel_number")
VALUES
('4', 'Adam', 'Smith', '+44 674-675-676');


SELECT * FROM "customers";


INSERT INTO "bookings" ("customer_id", "mountain_hut_id", "date", "num_of_people", "breakfast", "confirmed")
VALUES
('4', '7', '2024-01-18', '6', '1', '0');


SELECT * FROM "bookings";


INSERT INTO "bookings" ("customer_id", "mountain_hut_id", "date", "num_of_people", "breakfast", "confirmed")
VALUES
('4', '7', '2024-01-18', '30', '1', '0');
