# Design Document

By Michał Kowalski

Video overview: <https://youtu.be/RYePCz8rRmA>

## Scope

* Purpose of this database was to build a database that would allow multiple mountain huts to keep track of their customers and bookings they make.

* People, places and things I included in the scope of my database database are:
  - customers characterized by id, name, surname and telephone number
  - mountain huts characterized by id, name, address, avg_rating and telephone number
  - availabilities characterized by id, mountain_hut_id, date, num_of_beds_available, bed_price and breakfast_price
  - bookings characterized by id, customer_id, mountain_hut_id, date, num_of_people, breakfast, confirmed and total_price

* Things that are currently *outside* the scope of my database that could be changed in the future are:
  - validation if customer that made the reservation made the payment within 48 hours
  - making reservations for multiple days (right now only single day reservation is possible)
  - dividing the places in mountain huts into rooms and differentiating the price of accomodation based on room type

## Functional Requirements

In this section you should answer the following questions:

* User should be able to:
  - add, edit and delete customers from the "customers" table
  - add, edit and delete mountain huts from the "mountain_huts" table
  - add, edit and delete availabilities from the "availabilities" table
  - add, edit and delete bookings from the "bookings" table
  Overall, the main purpose of my database is to allow mountain huts to keep track of bookings and extra facilities.
  It would allow to better plan processes inside the muntain huts and avoid overbooking (built-in triggers that warn users)

* Thing's that are beyond the scope of what a user should be able to do with this database are:
 - The triggers and schema do not include explicit mechanisms for handling concurrent access and updates.
 - The schema and triggers are designed for a certain scale of operations. As this application grows, scalability aspects as indexing strategies, partitioning, and
   optimizationmight be needed to ensure efficient performance.
 - There's no provision for an audit trail to track changes made to the data over time. Implementing an audit trail could be beneficial for tracking modifications
   and understanding the history of data changes.
 - It would be beneficial to establish a robust backup and recovery strategy to prevent data loss in case of system failures or other unforeseen events.

## Representation

### Entities

* Entities and attributes I have chosen to represent data in my database are:
 - customers represented by the "customers" table, containing information about individual customers such as their name, surname, and contact details
 - mountain huts: represented by the "mountain_huts" table, which stores information about different mountain huts, including their name, address, total number of
   beds, average rating, and contact details
 - bookings represented by the "bookings" table, this entity captures information about specific bookings made by customers. It includes details such as booking
   date, the number of people, whether breakfast is requested, confirmation status, and total price. Each booking is associated with a customer and a mountain hut.
 - availabilities represented by the "availabilities" table, this entity tracks the availability of beds in mountain huts on specific dates. It includes information
   such as the number of beds available, bed prices, and breakfast prices.

   These entities form the core structure of the database and represent the key elements involved in managing bookings for mountain huts. The relationships between these entities are established through foreign key constraints, creating a relational structure that allows for efficient data retrieval and manipulation.

   It's worth noting that the "availabilities_in_various_mountain_huts_in_January_2024" view provides a convenient way to query and display availability information for a specific time period across multiple mountain huts.

* Below you can find the logic behind the choice of data types.

  Customers:
  Attributes: Name, Surname, Tel_number
  Logic: Customers are individuals making bookings. Storing their personal information allows for personalized communication and management of bookings associated with specific customers.

  Mountain Huts:
  Attributes: Name, Address, Total_num_of_beds, Avg_rating, Tel_number
  Logic: Mountain huts are the accommodations available for booking. Storing information about each hut, such as its location, capacity, rating, and contact details, helps manage and present options to customers.

  Bookings:
  Attributes: Customer_id, Mountain_hut_id, Date, Num_of_people, Breakfast, Confirmed, Total_price
  Logic: Bookings represent reservations made by customers. By associating bookings with specific customers, mountain huts, and dates, the system can track reservations, manage availability, and calculate prices.

  Availabilities:
  Attributes: Mountain_hut_id, Date, Num_of_beds_available, Bed_price, Breakfast_price
  Logic: Availabilities track the availability of beds in mountain huts on specific dates. This information is crucial for the system to check if there are enough beds for a new booking, update availability after a booking, and calculate pricing.

  The logic behind choosing these types involves modeling the real-world entities and their relationships in a way that supports the intended functionality of the system. Here are some considerations:

  Normalization: The database design adheres to principles of normalization, reducing redundancy and improving data integrity.

  Relationships: Foreign key relationships between tables (e.g., customer_id and mountain_hut_id in the bookings table) establish connections between entities, enabling efficient data retrieval and maintenance.

  Efficiency: The structure is designed to efficiently manage bookings, availability, and customer information, allowing for straightforward queries and updates.

  Flexibility: The database design allows for flexibility in managing different mountain huts, customers, and bookings. The use of views and triggers enhances the system's functionality.

  Overall, the chosen entities and their attributes align with the requirements of a booking system for mountain huts, supporting tasks such as reservations, availability tracking, and customer management.

* The choice of constraints in a database is driven by several factors, including ensuring data integrity, enforcing relationships between tables, and providing a
  level of control over the data. In the provided database schema, the following constraints have been chosen:

  Primary Key Constraints:

  Example: PRIMARY KEY("id") in the "customers," "bookings," "mountain_huts," and "availabilities" tables.
  Logic: Primary key constraints uniquely identify each record in a table. In this case, the "id" column is chosen as the primary key for each table, ensuring that each customer, booking, mountain hut, and availability record has a unique identifier.

  Foreign Key Constraints:

  Example: FOREIGN KEY ("customer_id") REFERENCES "customers"("id") in the "bookings" table.
  Logic: Foreign key constraints establish relationships between tables. In this example, the "customer_id" column in the "bookings" table references the "id" column in the "customers" table. This ensures that every booking is associated with a valid customer.

  Unique Constraints:

  Example: UNIQUE("tel_number") in the "customers" table.
  Logic: Unique constraints ensure that a specific attribute or combination of attributes in a table is unique. In this case, the "tel_number" column in the "customers" table must contain unique values, preventing multiple customers from sharing the same telephone number.

  Trigger Logic Constraints:

  Example: Triggers such as "check_availability," "update_availability," and "update_total_price" enforce custom logic.
  Logic: Triggers execute custom logic in response to specific events (e.g., before or after an insert operation). In this case, the triggers enforce business rules, such as checking availability before allowing a booking or updating availability and total price after a successful booking.

  The logic behind choosing these constraints is to maintain data consistency, integrity, and adherence to business rules. Constraints help prevent the entry of invalid or inconsistent data and provide a level of control over the database operations. They contribute to a robust and reliable database system that accurately represents and manages the relationships between entities in the application domain.

### Relationships

![Screenshot of Entity Relationship Diagram.] [Entity Relationship Diagram](images/ER_diagram.png)

- Customers Entity consists of: id, name, surname and tel_number.

  Relationships:
  Customers are uniquely identified by their "id."
  Customers can make zero or more bookings, as represented by the relationship to the "bookings" table through the "customer_id" foreign key.

-  Mountain Huts Entity consists of: id, name, address, total_num_of_beds, avg_rating and tel_number.

  Relationships:
  Mountain huts are uniquely identified by their "id."
  Mountain huts can have zero or more availabilities, as represented by the relationship to the "availabilities" table through the "mountain_hut_id" foreign key.
  Mountain huts can be associated with zero or more bookings, as represented by the relationship to the "bookings" table through the "mountain_hut_id" foreign key.

- Bookings Entity consists of: id, customer_id, mountain_hut_id, date, num_of_people, breakfast, confirmed and total_price.

  Relationships:
  Bookings are uniquely identified by their "id."
  Each booking is associated with one customer, as represented by the "customer_id" foreign key referencing the "customers" table.
  Each booking is associated with one mountain hut, as represented by the "mountain_hut_id" foreign key referencing the "mountain_huts" table.

- Availabilities Entity consists of: id, mountain_hut_id, date, num_of_beds_available, bed_price and breakfast_price.

  Relationships:
  Availabilities are uniquely identified by their "id."
  Each availability is associated with one mountain hut, as represented by the "mountain_hut_id" foreign key referencing the "mountain_huts" table.

  Summary of Relationships:

  Customers can have zero or more associated bookings. Mountain huts can have zero or more associated availabilities and zero or more associated bookings.
  Bookings are associated with one customer and one mountain hut. Availabilities are associated with one mountain hut. These relationships are established through the use of foreign key constraints, which link the primary key of one table to the foreign key of another. This relational structure allows for the representation of real-world connections between customers, mountain huts, bookings, and availabilities in a systematic and organized manner.

## Optimizations

* There're two main optimisations in the database:

  Indexes:
  Indexes have been created to speed up searches:
  search_availabilities_by_mountain_hut_id on the "availabilities" table.
  search_availabilities_by_date on the "availabilities" table.

  Indexes will help to accelerate query performance by allowing the database engine to quickly locate and retrieve specific rows.

  Views:

  The "availabilities_in_various_mountain_huts_in_January_2024" view is created to facilitate querying and displaying availability information for a specific time period across multiple mountain huts. Views can help simplify complex queries and improve readability.

## Limitations

* While the provided database schema is well-structured for managing bookings, customers, mountain huts, and availabilities, there are some limitations and
  considerations:

  Simplicity vs. Complexity:

  The design appears to be geared towards simplicity, which is often a positive aspect. However, depending on the specific requirements of your application, it might be overly simplistic for more complex scenarios. Scalability and Extensibility needs of this system need to be considered.

  Assumption of Single Booking Date:

  The design assumes that each booking is associated with a single date. If this application required support for bookings spanning multiple days or flexible date ranges, the schema would need modification.

  Limited Customer Information:

  The "customers" table includes basic information like name, surname, and telephone number. Depending on the application requirements, additional customer details (e.g., email address, address) might be necessary.

  No User Authentication or Authorization:

  The schema does not include tables or mechanisms for user authentication and authorization. If this application involved user accounts with login credentials and different access levels, it would be needed to implement these features separately.

  No Logging or Auditing:

  The schema lacks features for logging or auditing changes to the data. Tracking who made changes and when can be crucial for security and accountability.

  Limited Price Calculation Logic:

  The "update_total_price" trigger calculates the total price for a new booking based on certain assumptions. If your pricing logic is more complex or involves dynamic factors, you may need to enhance this logic.

  No Soft Deletes:

  The design does not include a mechanism for soft deletes, where records are marked as deleted instead of being physically removed. Soft deletes can be useful for maintaining historical data.

  Assumption of Single Mountain Hut Price:

  The "availabilities" table assumes a single set of prices for each mountain hut. If your pricing structure involves variations based on room types or other factors, the schema might need modifications.

  No Explicit Handling of Time Zones:

  The schema does not explicitly handle time zones. If your application operates in multiple time zones, consider incorporating time zone information to ensure accurate date and time representations.
