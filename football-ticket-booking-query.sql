-- DROP TABLES IF THEY ALREADY EXIST TO PREVENT CONFLICTS
DROP TABLE IF EXISTS Bookings;
DROP TABLE IF EXISTS Matches;
DROP TABLE IF EXISTS Users;


-- =========================================================================
-- 1. Users Table successfully Created in Beekeper
-- =========================================================================
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(40) UNIQUE NOT NULL,
    role VARCHAR(30) NOT NULL CHECK(role IN('Ticket Manager','Football Fan')),
    phone_number VARCHAR(14)
);

-- =========================================================================
-- 2. Matches Table successfully Created in Beekeper
-- =========================================================================
CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY,
    fixture VARCHAR(80) NOT NULL,
    tournament_category VARCHAR(50) NOT NULL,
    base_ticket_price DECIMAL(10,2) NOT NULL CHECK(base_ticket_price > 0),
    match_status VARCHAR(15) NOT NULL CHECK (match_status IN (
        'Available','Selling Fast','Sold Out','Postponed'
    ))
);


-- =========================================================================
-- 3. Bookings Table successfully Created in Beekeper
-- =========================================================================
CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES Users(user_id) NOT NULL,
    match_id INT REFERENCES Matches(match_id) NOT NULL,
    seat_number VARCHAR(10),
    payment_status VARCHAR(15) CHECK(payment_status IN('Pending','Confirmed','Cancelled','Refunded')),
    total_cost DECIMAL(10,2) NoT NULL CHECK(total_cost > 0)
);

--- Query 1: Retrieve all upcoming football matches belonging to the 'Champions League' where the match status is 'Available'.

SELECT
  match_id,
  fixture,
  base_ticket_price
FROM
  matches
WHERE
  tournament_category = 'Champions League'
  AND match_status = 'Available';

--- Query 2: Search for all users whose full names start with 'Tanvir' or contain the phrase 'Haque' (case-insensitive).
SELECT
  user_id,
  full_name,
  email
FROM
  users
WHERE
  full_name ILIKE 'Tanvir%'
  OR full_name ILIKE '%Haque%';

--- Query 3: Retrieve all booking records where the payment status is missing (NULL), replacing the empty result with 'Action Required'.
SELECT
  booking_id,
  user_id,
  match_id,
  COALESCE(payment_status, 'Action Required') AS payment_status
FROM
  bookings
WHERE
  payment_status IS NULL;

--- Query 4: Retrieve match booking details along with the User's full name and the scheduled Match fixture teams.
SELECT
  booking_id,
  users.full_name,
  fixture,
  total_cost
FROM
  bookings
  JOIN users USING (user_id)
  JOIN matches USING (match_id)

--- Query 5: Display a comprehensive list of all users and their booking IDs, ensuring that fans who have never bought a ticket are still listed.
SELECT
  user_id,
  full_name,
  booking_id
FROM
  users
  LEFT JOIN bookings USING (user_id)
  LEFT JOIN matches USING (match_id)