-- Create tables

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

-- Insert sample data

INSERT INTO User (user_id, name, email, phone) VALUES
(1, 'Alice Sharma', 'alice@gmail.com', '9876543210'),
(2, 'Bob Kumar', 'bobkumar@gmail.com', '9988776655'),
(3, 'Carol Mehta', 'carolm@example.com', '9612345678'),
(4, 'David Singh', 'davidsingh@example.com', '8899776655'),
(5, 'Eva Joseph', 'evajoseph@example.com', '7722334455'),
(6, 'Faisal Khan', 'faisalkhan@example.com', '8888882222'),
(7, 'Grace Pinto', 'gracepinto@example.com', '9004321234'),
(8, 'Hari Rao', 'harirao@example.com', '8989989898');

INSERT INTO Vehicle (vehicle_id, model, registration_number, daily_rate, available) VALUES
(101, 'Toyota Camry', 'RJ14AB1234', 2500.00, TRUE),
(102, 'Honda City', 'DL08XZ5412', 1800.00, TRUE),
(103, 'Maruti Swift', 'MH01AA1010', 1300.00, TRUE),
(104, 'Hyundai Creta', 'WB07MG6543', 2200.00, TRUE),
(105, 'Ford EcoSport', 'KA05FC2012', 2100.00, TRUE),
(106, 'Tata Nexon', 'TN22CG1100', 1750.00, TRUE);

INSERT INTO Booking (booking_id, user_id, vehicle_id, start_date, end_date, status) VALUES
(5001, 1, 101, '2025-10-08', '2025-10-10', 'Confirmed'),
(5002, 2, 102, '2025-10-09', '2025-10-11', 'Pending'),
(5003, 3, 103, '2025-10-13', '2025-10-15', 'Confirmed'),
(5004, 4, 104, '2025-10-14', '2025-10-16', 'Confirmed');

INSERT INTO Payment (payment_id, booking_id, amount, payment_date, method) VALUES
(9001, 5001, 5000.00, '2025-10-08', 'Card'),
(9002, 5002, 3600.00, '2025-10-09', 'Cash'),
(9003, 5003, 2600.00, '2025-10-13', 'UPI'),
(9004, 5004, 4400.00, '2025-10-14', 'Card');

INSERT INTO Driver (driver_id, aadhar_card_no, name, age, gender, experience) VALUES
(1, '123456789012', 'Rajesh Yadav', 35, 'Male', 10),
(2, '987654321098', 'Deepa Verma', 28, 'Female', 6),
(3, '112233445566', 'Omkar Joshi', 40, 'Male', 15),
(4, '223344556677', 'Sunita Das', 32, 'Female', 8);

