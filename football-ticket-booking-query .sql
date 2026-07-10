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

