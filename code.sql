-- Table Creation

CREATE TABLE User (
    user_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15)
);

CREATE TABLE Vehicle (
    vehicle_id INT PRIMARY KEY,
    model VARCHAR(100),
    registration_number VARCHAR(20),
    daily_rate DECIMAL(8,2),
    available BOOLEAN
);

CREATE TABLE Booking (
    booking_id INT PRIMARY KEY,
    user_id INT,
    vehicle_id INT,
    start_date DATE,
    end_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES User(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicle(vehicle_id)
);

CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    booking_id INT,
    amount DECIMAL(10,2),
    payment_date DATE,
    method VARCHAR(20),
    FOREIGN KEY (booking_id) REFERENCES Booking(booking_id)
);

CREATE TABLE Driver (
    driver_id INT PRIMARY KEY,
    aadhar_card_no VARCHAR(12),
    name VARCHAR(100),
    age INT,
    gender VARCHAR(10),
    experience INT
);

-- Example Stored Procedures (simplified)

DELIMITER //

CREATE PROCEDURE AddUser (
    IN p_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(15)
)
BEGIN
    INSERT INTO User (name, email, phone) VALUES (p_name, p_email, p_phone);
END //

CREATE PROCEDURE AddVehicle (
    IN p_model VARCHAR(100),
    IN p_registration_number VARCHAR(20),
    IN p_daily_rate DECIMAL(8,2),
    IN p_available BOOLEAN
)
BEGIN
    INSERT INTO Vehicle (model, registration_number, daily_rate, available)
    VALUES (p_model, p_registration_number, p_daily_rate, p_available);
END //

CREATE PROCEDURE SearchAvailableVehicles (
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN
    SELECT * FROM Vehicle V
    WHERE V.available = TRUE
    AND V.vehicle_id NOT IN (
        SELECT vehicle_id FROM Booking
        WHERE NOT (end_date < p_start_date OR start_date > p_end_date)
    );
END //

CREATE PROCEDURE BookVehicle (
    IN p_user_id INT,
    IN p_vehicle_id INT,
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE rental_days INT;
    DECLARE rental_cost DECIMAL(10,2);

    IF EXISTS (
        SELECT 1 FROM Booking
        WHERE vehicle_id = p_vehicle_id AND NOT (end_date < p_start_date OR start_date > p_end_date)
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Vehicle not available for selected dates';
    ELSE
        INSERT INTO Booking (user_id, vehicle_id, start_date, end_date, status)
        VALUES (p_user_id, p_vehicle_id, p_start_date, p_end_date, 'Confirmed');

        SET rental_days = DATEDIFF(p_end_date, p_start_date) + 1;

        SELECT daily_rate INTO rental_cost FROM Vehicle WHERE vehicle_id = p_vehicle_id;
        SET rental_cost = rental_cost * rental_days;

        INSERT INTO Payment (booking_id, amount, payment_date, method)
        VALUES (LAST_INSERT_ID(), rental_cost, CURDATE(), p_payment_method);

        UPDATE Vehicle SET available = FALSE WHERE vehicle_id = p_vehicle_id;
    END IF;
END //

CREATE PROCEDURE ReturnVehicle (
    IN p_booking_id INT
)
BEGIN
    UPDATE Booking SET status = 'Completed' WHERE booking_id = p_booking_id;

    UPDATE Vehicle V
    JOIN Booking B ON V.vehicle_id = B.vehicle_id
    SET V.available = TRUE
    WHERE B.booking_id = p_booking_id;
END //

CREATE PROCEDURE AddDriver (
    IN p_aadhar_no VARCHAR(12),
    IN p_name VARCHAR(100),
    IN p_age INT,
    IN p_gender VARCHAR(10),
    IN p_experience INT
)
BEGIN
    INSERT INTO Driver (aadhar_card_no, name, age, gender, experience)
    VALUES (p_aadhar_no, p_name, p_age, p_gender, p_experience);
END //

DELIMITER ;
