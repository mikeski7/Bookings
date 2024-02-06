-- Create tables: "customers", "bookings", "mountain_huts" and "availabilities"

CREATE TABLE IF NOT EXISTS "customers" (
    "id" INTEGER,
    "name" TEXT,
    "surname" TEXT,
    "tel_number" INTEGER UNIQUE,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "bookings" (
    "id" INTEGER,
    "customer_id" INTEGER,
    "mountain_hut_id" INTEGER,
    "date" DATE,
    "num_of_people" INTEGER,
    "breakfast" BOOLEAN,
    "confirmed" BOOLEAN DEFAULT "0",
    "total_price" INTEGER DEFAULT "0",
    PRIMARY KEY("id"),
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id")
    FOREIGN KEY ("mountain_hut_id") REFERENCES "mountain_huts"("id")
);

CREATE TABLE IF NOT EXISTS "mountain_huts" (
    "id" INTEGER,
    "name" TEXT,
    "address" TEXT,
    "total_num_of_beds" INTEGER,
    "avg_rating" REAL,
    "tel_number" TEXT,
    PRIMARY KEY("id")
);

CREATE TABLE IF NOT EXISTS "availabilities" (
    "id" INTEGER,
    "mountain_hut_id" INTEGER,
    "date" DATE,
    "num_of_beds_available" INTEGER,
    "bed_price" INTEGER,
    "breakfast_price" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY ("mountain_hut_id") REFERENCES "mountain_huts"("id")
);

-- Create view "availabilities_in_various_mountain_huts_in_January_2024"

CREATE VIEW "availabilities_in_various_mountain_huts_in_January_2024" AS
SELECT "name", "date", "num_of_beds_available"
FROM "mountain_huts"
JOIN "availabilities" ON "mountain_huts"."id" = "availabilities"."mountain_hut_id"
WHERE date > '2023-12-31' AND date < '2024-02-01';

-- Create view "availabilities_in_various_mountain_huts_in_February_2024"

CREATE VIEW "availabilities_in_various_mountain_huts_in_February_2024" AS
SELECT "name", "date", "num_of_beds_available"
FROM "mountain_huts"
JOIN "availabilities" ON "mountain_huts"."id" = "availabilities"."mountain_hut_id"
WHERE date > '2024-01-31' AND date < '2024-03-01';

-- Create indexes: "search_availabilities_by_mountain_hut_id", "search_availabilities_by_date", "search_bookings_by_customer_id" to speed up searching

CREATE INDEX "search_availabilities_by_mountain_hut_id"
ON "availabilities"("mountain_hut_id");

CREATE INDEX "search_availabilities_by_date"
ON "availabilities"("date");

CREATE INDEX "search_bookings_by_customer_id"
ON "availabilities"("date");

-- Trigger "check_availability" checks if there're enough free places for a specified day in a specified mountain hut,
-- if so a new booking is added to the "bookings" table, if not the operation stops.

CREATE TRIGGER "check_availability"
BEFORE INSERT ON "bookings"
FOR EACH ROW
BEGIN
    SELECT
        CASE
            WHEN (
                SELECT "num_of_beds_available"
                FROM "availabilities"
                WHERE "availabilities"."mountain_hut_id" = NEW."mountain_hut_id" AND "availabilities"."date" = NEW."date"
            ) < (
                SELECT NEW."num_of_people"
                FROM "bookings"
            )
            THEN
                RAISE(ABORT, 'Not enough beds for that day to accomodate all people. We are sorry.')
            END;
END;

-- Trigger "update_availability" updates remaining free places for a specified day in a specified mountain hut
-- after a sucessfully added row in "bookings" table.

CREATE TRIGGER "update_availability"
AFTER INSERT ON "bookings"
FOR EACH ROW
BEGIN
    UPDATE "availabilities"
    SET "num_of_beds_available" = ((
            SELECT "num_of_beds_available"
            FROM "availabilities"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        ) - (
            SELECT NEW."num_of_people"
            FROM "bookings"
        ))
    WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date";
END;

-- Trigger "update_total_price" calculates total price for a new booking based on prices from "availabilities" table.

CREATE TRIGGER "update_total_price"
AFTER INSERT ON "bookings"
FOR EACH ROW
BEGIN
    UPDATE "bookings"
    SET "total_price" = ((
            SELECT "bed_price"
            FROM "availabilities"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        ) * (
            SELECT NEW."num_of_people"
            FROM "bookings"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        )) + ((
            SELECT "breakfast_price"
            FROM "availabilities"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        ) * (
            SELECT NEW."num_of_people"
            FROM "bookings"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        ) * (
            SELECT NEW."breakfast"
            FROM "bookings"
            WHERE "mountain_hut_id" = NEW."mountain_hut_id" AND "date" = NEW."date"
        ))
    WHERE "id" = NEW."id";
END;
