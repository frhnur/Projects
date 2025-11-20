-- Drop Tables
DROP VIEW customer_reservations CASCADE CONSTRAINTS;
DROP VIEW customers_with_phone CASCADE CONSTRAINTS; 
DROP VIEW customer_info CASCADE CONSTRAINTS;
DROP VIEW luxury_vehicles CASCADE CONSTRAINTS;
DROP VIEW vehiclerepairs_andparts CASCADE CONSTRAINTS;
DROP VIEW pending_reservations CASCADE CONSTRAINTS;
DROP TABLE Customer CASCADE CONSTRAINTS;
DROP TABLE Vehicle CASCADE CONSTRAINTS;
DROP TABLE VehicleColour CASCADE CONSTRAINTS;
DROP TABLE Review CASCADE CONSTRAINTS;
DROP TABLE Reservation CASCADE CONSTRAINTS;
DROP TABLE Maintenance CASCADE CONSTRAINTS;
DROP TABLE Repairs CASCADE CONSTRAINTS;
DROP TABLE PartsRepaired CASCADE CONSTRAINTS;
DROP TABLE Cleaning CASCADE CONSTRAINTS;
DROP TABLE Rental CASCADE CONSTRAINTS;
DROP TABLE Payment CASCADE CONSTRAINTS;

-- Create Tables
CREATE TABLE Customer (
    CustomerID NUMBER PRIMARY KEY,
    FirstName VARCHAR2(50) NOT NULL,
    MiddleName VARCHAR2(50),
    LastName VARCHAR2(50) NOT NULL,
    PhoneNumber VARCHAR2(15) UNIQUE,
    Email VARCHAR2(100) UNIQUE,
    StreetNumber VARCHAR2(10) NOT NULL,
    StreetName VARCHAR2(100) NOT NULL,
    City VARCHAR2(50) NOT NULL,
    DriversLicense VARCHAR2(20) UNIQUE NOT NULL,
    CHECK (PhoneNumber IS NOT NULL OR Email IS NOT NULL)
);

CREATE TABLE Vehicle(
    VehicleID NUMBER PRIMARY KEY,
    FuelCapacity NUMBER(3) NOT NULL CHECK (FuelCapacity > 0),
    DailyRate NUMBER(6,2) NOT NULL CHECK (DailyRate > 0),
    VType VARCHAR2(8) NOT NULL CHECK (VType IN ('Economy', 'Luxury')),
    Plate VARCHAR2(10) UNIQUE NOT NULL,
    Model VARCHAR2(50) NOT NULL,
    VStatus VARCHAR2(12) DEFAULT 'Available' NOT NULL  CHECK (VStatus IN ('Available', 'Rented', 'Maintenance'))
);

-- Multivalued Attribute of Vehicle
CREATE TABLE VehicleColour(
    VehicleID NUMBER NOT NULL,
    Colour VARCHAR2(20) NOT NULL CHECK (Colour IN ('Red', 'Black', 'White', 'Blue', 'Silver', 'Grey','Green', 'Orange', 'Yellow', 'Purple', 'Pink', 'Brown')),
    PRIMARY KEY (VehicleID, Colour),
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID)
);

CREATE TABLE Review(
    ReviewID NUMBER PRIMARY KEY,
    Rating NUMBER(1) NOT NULL CHECK (Rating >= 1 AND Rating <= 5),
    ReviewDate DATE,
    Feedback VARCHAR2(200),
    WritingMethod VARCHAR2(10) DEFAULT 'Online',
    CustomerID NUMBER NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    VehicleID NUMBER NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID)
);

CREATE TABLE Reservation(
    ReservationID NUMBER PRIMARY KEY,
    RStatus VARCHAR2(10) NOT NULL CHECK (RStatus IN ('Pending', 'Confirmed', 'Cancelled')),
    PPickupDate DATE NOT NULL,
    PReturnDate DATE NOT NULL,
    CustomerID NUMBER NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    VehicleID NUMBER NOT NULL,
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID),
    CHECK (PPickupDate < PReturnDate)
);

-- Weak Entity 
CREATE TABLE Maintenance(
    ServiceDate DATE NOT NULL,
    MStatus VARCHAR2(25) NOT NULL CHECK (MStatus IN ('Needs_Maintenance', 'Under_Maintenance', 'Maintenance_Completed')),
    VehicleID NUMBER NOT NULL,
    PRIMARY KEY (VehicleID, ServiceDate),
    FOREIGN KEY (VehicleID) REFERENCES Vehicle(VehicleID)
);

-- Subclass of Maintenance
CREATE TABLE Repairs(
    RepairType VARCHAR(20) NOT NULL,
    VehicleID NUMBER NOT NULL,
    ServiceDate DATE NOT NULL,
    PRIMARY KEY(VehicleID, ServiceDate, RepairType), -- repairtype in primary key so we can have multiple repairs on the same vehicle on same date
    FOREIGN KEY(VehicleID, ServiceDate) REFERENCES Maintenance(VehicleID, ServiceDate) 
);

-- Multivalued Attribute of Repair
CREATE TABLE PartsRepaired(
    VehicleID NUMBER NOT NULL,
    ServiceDate DATE NOT NULL, 
    Part VARCHAR(30) NOT NULL,
    RepairType VARCHAR(20) NOT NULL,
    PRIMARY KEY(VehicleID, ServiceDate, RepairType, Part), -- part is part of the primary key for mulitple parts repaired
    FOREIGN KEY(VehicleID, ServiceDate, RepairType) REFERENCES Repairs(VehicleID, ServiceDate, RepairType)
);

-- Subclass of Maintenance
CREATE TABLE Cleaning(
    CleaningArea VARCHAR2(20) NOT NULL CHECK (CleaningArea IN ('Interior', 'Exterior')), 
    DetailLevel VARCHAR(20) NOT NULL CHECK (DetailLevel IN ('Basic', 'Deep', 'Premium')),
    VehicleID NUMBER NOT NULL,
    ServiceDate DATE NOT NULL,
    PRIMARY KEY(VehicleID, ServiceDate, CleaningArea), -- cleaning area part of the primary key so a vehicle can have exterior and interior cleaning on same date
    FOREIGN KEY(VehicleID, ServiceDate)REFERENCES Maintenance(VehicleID, ServiceDate)
);

CREATE TABLE Rental(
    RentalID NUMBER PRIMARY KEY,
    PickupDate DATE NOT NULL,
    ReturnDate DATE NOT NULL,
    RentalCost NUMBER(7,2) NOT NULL CHECK (RentalCost > 0),
    FuelCharge NUMBER(6,2),
    FuelLevel NUMBER(4) NOT NULL,
    ReservationID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (ReservationID) REFERENCES Reservation(ReservationID),
    CHECK (PickupDate < ReturnDate)
);

CREATE TABLE Payment(
    PaymentID NUMBER PRIMARY KEY,
    PaymentDate DATE NOT NULL,
    PaymentMethod VARCHAR2(8) NOT NULL CHECK (PaymentMethod IN ('Credit', 'Debit', 'Cash', 'Mobile', 'Online')),
    TotalAmount NUMBER(8,2) NOT NULL CHECK (TotalAmount > 0),
    RentalID NUMBER NOT NULL UNIQUE,
    FOREIGN KEY (RentalID) REFERENCES Rental(RentalID)
);


-- Populate Tables
-- All Customer Values Given
INSERT INTO Customer VALUES 
(1, 'Alice', 'K', 'Johnson', '416-111-2222', 'alice.j@gmail.com', '12', 'Maple St', 'Toronto', 'DL1001');
INSERT INTO Customer VALUES 
(2, 'Alice', 'K', 'Johnson', '416-444-2482', 'alice.j2@gmail.com', '13', 'Maple St', 'Toronto', 'DL1801');
INSERT INTO Customer VALUES 
(3, 'Bob', 'A', 'Smith', '416-333-4444', 'bob.smith@hotmail.com', '45', 'Oak Ave', 'Toronto', 'DL1002');
INSERT INTO Customer VALUES 
(4, 'Diana', 'M', 'Brown', '647-555-1212', 'diana.brown@yahoo.com', '23', 'Cedar Blvd', 'Mississauga', 'DL1004');
INSERT INTO Customer VALUES 
(5, 'Ethan', NULL, 'Wong', '905-222-3333', NULL, '56', 'Birch St', 'Toronto', 'DL1005');
-- No Customer MiddlenName/PhoneNumber
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, StreetNumber, StreetName, City, DriversLicense) VALUES 
(6, 'Apiena', 'Selvarajah', 'apiena.selvarajah@torontomu.ca', '89', 'Pine Rd', 'Ottawa', 'DL1003');
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, StreetNumber, StreetName, City, DriversLicense) VALUES 
(7, 'Farah', 'Noor', 'farah2.noor@etorontomu.ca', '77', 'Spruce Ln', 'Brampton', 'DL1006');
INSERT INTO Customer (CustomerID, FirstName, LastName, Email, StreetNumber, StreetName, City, DriversLicense) VALUES 
(8, 'Aishwin', 'Jeevothayan', 'aishwin.jeevothayan@torontomu.ca', '34', 'Elm St', 'Toronto', 'DL1007');
-- No Customer MiddleName/Email
INSERT INTO Customer (CustomerID, FirstName, LastName, PhoneNumber, StreetNumber, StreetName, City, DriversLicense) VALUES 
(9, 'Hannah', 'Kim', '6471237890', '90', 'Ash Ave', 'Scarborough', 'DL1008');
INSERT INTO Customer (CustomerID, FirstName, LastName, PhoneNumber, StreetNumber, StreetName, City, DriversLicense) VALUES 
(10, 'Ivan', 'Patel', '9055674321', '11', 'Willow Dr', 'Mississauga', 'DL1009');
INSERT INTO Customer (CustomerID, FirstName, LastName, PhoneNumber, StreetNumber, StreetName, City, DriversLicense) VALUES 
(11, 'Julia', 'Garcia', '4167654321', '66', 'Poplar Ct', 'Toronto', 'DL1010');
INSERT INTO Customer (CustomerID, FirstName, LastName, PhoneNumber, StreetNumber, StreetName, City, DriversLicense) VALUES
(12, 'Simon', 'Patel', '9055474329', '11', 'Willow Dr', 'Mississauga', 'DL1011');

-- All Vehicle Values Given
INSERT INTO Vehicle VALUES (101, 40, 49.99, 'Economy', 'ECO123', 'Toyota Corolla', 'Rented');
INSERT INTO Vehicle VALUES (102, 55, 120.00, 'Luxury', 'LUX456', 'BMW 5 Series', 'Rented');
INSERT INTO Vehicle VALUES (103, 50, 80.00, 'Economy', 'ECO789', 'Honda Civic', 'Maintenance');
INSERT INTO Vehicle VALUES (104, 65, 150.00, 'Luxury', 'LUX789', 'Mercedes E-Class', 'Available');
INSERT INTO Vehicle VALUES (105, 45, 60.00, 'Economy', 'ECO456', 'Hyundai Elantra', 'Rented');
INSERT INTO Vehicle VALUES (106, 70, 200.00, 'Luxury', 'LUX321', 'Audi A7', 'Rented');
INSERT INTO Vehicle VALUES (107, 48, 70.00, 'Economy', 'ECO654', 'Nissan Sentra', 'Rented');
INSERT INTO Vehicle VALUES (108, 55, 90.00, 'Economy', 'ECO852', 'Mazda 3', 'Available');
INSERT INTO Vehicle VALUES (109, 80, 250.00, 'Luxury', 'LUX159', 'Porsche Cayenne', 'Rented');
INSERT INTO Vehicle VALUES (110, 60, 110.00, 'Economy', 'ECO333', 'Kia Sportage', 'Rented');
INSERT INTO Vehicle VALUES (114, 55, 120.00, 'Luxury', 'LUX753', 'Mercedes C-Class', 'Maintenance');
INSERT INTO Vehicle VALUES (122, 55, 120.00, 'Luxury', 'MER101', 'Mercedes C-Class', 'Maintenance');
INSERT INTO Vehicle VALUES (123, 55, 120.00, 'Luxury', 'MER102', 'Mercedes C-Class', 'Maintenance');
INSERT INTO Vehicle VALUES (124, 55, 120.00, 'Economy', 'HON100', 'Honda Accord', 'Maintenance');
-- No Vehicle VStatus
INSERT INTO Vehicle (VehicleID, FuelCapacity, DailyRate, VType, Plate, Model) VALUES (111, 50, 95.00, 'Economy', 'ECO951', 'Honda Accord');
INSERT INTO Vehicle (VehicleID, FuelCapacity, DailyRate, VType, Plate, Model) VALUES (112, 65, 180.00, 'Luxury', 'LUX852', 'Lexus RX');
INSERT INTO Vehicle (VehicleID, FuelCapacity, DailyRate, VType, Plate, Model) VALUES (113, 45, 60.00, 'Economy', 'ECO753', 'Toyota Yaris');
INSERT INTO Vehicle (VehicleID, FuelCapacity, DailyRate, VType, Plate, Model) VALUES (115, 48, 70.00, 'Economy', 'ECO822', 'Nissan Versa');
INSERT INTO Vehicle (VehicleID, FuelCapacity, DailyRate, VType, Plate, Model) VALUES (116, 80, 250.00, 'Luxury', 'LUX951', 'Porsche 911');

-- All VehicleColour Values Given
INSERT INTO VehicleColour VALUES (101, 'Red');
INSERT INTO VehicleColour VALUES (101, 'Black');
INSERT INTO VehicleColour VALUES (102, 'White');
INSERT INTO VehicleColour VALUES (103, 'Blue');
INSERT INTO VehicleColour VALUES (104, 'Silver');
INSERT INTO VehicleColour VALUES (105, 'Grey');
INSERT INTO VehicleColour VALUES (106, 'Black');
INSERT INTO VehicleColour VALUES (107, 'Green');
INSERT INTO VehicleColour VALUES (108, 'Blue');
INSERT INTO VehicleColour VALUES (109, 'White');
INSERT INTO VehicleColour VALUES (110, 'Orange');
INSERT INTO VehicleColour VALUES (111, 'Red');
INSERT INTO VehicleColour VALUES (111, 'Black');
INSERT INTO VehicleColour VALUES (112, 'White');
INSERT INTO VehicleColour VALUES (112, 'Silver');
INSERT INTO VehicleColour VALUES (114, 'Black');
INSERT INTO VehicleColour VALUES (114, 'Blue');
INSERT INTO VehicleColour VALUES (116, 'Yellow');
INSERT INTO VehicleColour VALUES (116, 'Black');
INSERT INTO VehicleColour VALUES (113, 'Blue');
INSERT INTO VehicleColour VALUES (115, 'Grey');

-- All Review Values Given
INSERT INTO Review VALUES (205, 3, TO_DATE('2025-09-16','YYYY-MM-DD'), 'Decent car, but could be cleaner.', 'Online', 5, 105);
-- No Review ReviewDate
INSERT INTO Review (ReviewID, Rating, Feedback, WritingMethod, CustomerID, VehicleID) VALUES (206, 5, 'Amazing luxury ride, very smooth.', 'Text', 6, 106);
-- No Review ReviewDate/Feedback/WritingMethod
INSERT INTO Review (ReviewID, Rating, CustomerID, VehicleID) VALUES (207, 4, 7, 107);
INSERT INTO Review (ReviewID, Rating, CustomerID, VehicleID) VALUES (208, 1, 8, 108);
-- No Review ReviewDate/WritingMethod
INSERT INTO Review (ReviewID, Rating, Feedback, CustomerID, VehicleID) VALUES (209, 2,
'Poor job of interior cleaning, ', 9, 109);
INSERT INTO Review (ReviewID, Rating, Feedback, CustomerID, VehicleID) VALUES (211, 1,
'Terrible Service', 11, 111);
-- No Review ReviewDate/Feedback/WritingMethod
INSERT INTO Review (ReviewID, Rating, CustomerID, VehicleID) VALUES (210, 4, 10, 110);

-- All Reservation Values Given
INSERT INTO Reservation VALUES (301, 'Confirmed', TO_DATE('2025-09-15','YYYY-MM-DD'), TO_DATE('2025-09-20','YYYY-MM-DD'), 1, 101);
INSERT INTO Reservation VALUES (302, 'Confirmed', TO_DATE('2025-09-18','YYYY-MM-DD'), TO_DATE('2025-09-22','YYYY-MM-DD'), 2, 102);
INSERT INTO Reservation VALUES (303, 'Pending', TO_DATE('2025-09-25','YYYY-MM-DD'), TO_DATE('2025-09-28','YYYY-MM-DD'), 3, 103);
INSERT INTO Reservation VALUES (304, 'Cancelled', TO_DATE('2025-09-05','YYYY-MM-DD'), TO_DATE('2025-09-10','YYYY-MM-DD'), 4, 104);
INSERT INTO Reservation VALUES (305, 'Confirmed', TO_DATE('2025-09-12','YYYY-MM-DD'), TO_DATE('2025-09-15','YYYY-MM-DD'), 5, 105);
INSERT INTO Reservation VALUES (306, 'Confirmed', TO_DATE('2025-09-20','YYYY-MM-DD'), TO_DATE('2025-09-24','YYYY-MM-DD'), 6, 106);
INSERT INTO Reservation VALUES (307, 'Confirmed', TO_DATE('2025-09-07','YYYY-MM-DD'), TO_DATE('2025-09-11','YYYY-MM-DD'), 7, 107);
INSERT INTO Reservation VALUES (308, 'Pending', TO_DATE('2025-09-29','YYYY-MM-DD'), TO_DATE('2025-10-02','YYYY-MM-DD'), 8, 108);
INSERT INTO Reservation VALUES (309, 'Confirmed', TO_DATE('2025-09-01','YYYY-MM-DD'), TO_DATE('2025-09-05','YYYY-MM-DD'), 9, 109);
INSERT INTO Reservation VALUES (310, 'Confirmed', TO_DATE('2025-09-22','YYYY-MM-DD'), TO_DATE('2025-09-27','YYYY-MM-DD'), 10, 110);
INSERT INTO Reservation VALUES (311, 'Confirmed', TO_DATE('2025-10-05','YYYY-MM-DD'), TO_DATE('2025-10-07','YYYY-MM-DD'), 11, 115);
INSERT INTO Reservation VALUES (312, 'Confirmed', TO_DATE('2025-10-16','YYYY-MM-DD'), TO_DATE('2025-10-27','YYYY-MM-DD'), 12, 116);

-- All Maintenance Values Given
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-05','YYYY-MM-DD'), 'Needs_Maintenance', 103);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-18','YYYY-MM-DD'), 'Maintenance_Completed', 111);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-20','YYYY-MM-DD'), 'Maintenance_Completed', 112);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-22','YYYY-MM-DD'), 'Under_Maintenance', 114);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-23','YYYY-MM-DD'), 'Under_Maintenance', 122);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-25','YYYY-MM-DD'), 'Under_Maintenance', 123);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-25','YYYY-MM-DD'), 'Under_Maintenance', 124);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-26','YYYY-MM-DD'), 'Under_Maintenance', 122);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-27','YYYY-MM-DD'), 'Under_Maintenance', 123);
INSERT INTO Maintenance VALUES (TO_DATE('2025-09-28','YYYY-MM-DD'), 'Under_Maintenance', 124);
INSERT INTO Maintenance VALUES (TO_DATE('2025-10-12','YYYY-MM-DD'), 'Needs_Maintenance', 112);
INSERT INTO Maintenance VALUES (TO_DATE('2025-10-15','YYYY-MM-DD'), 'Under_Maintenance', 124);

-- All Repairs Values Given
INSERT INTO Repairs VALUES ('Engine', 103, TO_DATE('2025-09-05','YYYY-MM-DD'));
INSERT INTO Repairs VALUES ('Brake', 111, TO_DATE('2025-09-18','YYYY-MM-DD'));
INSERT INTO Repairs VALUES ('Engine', 114, TO_DATE('2025-09-22','YYYY-MM-DD'));
INSERT INTO Repairs VALUES ('Engine', 122, TO_DATE('2025-09-23','YYYY-MM-DD'));
INSERT INTO Repairs VALUES ('Engine', 123, TO_DATE('2025-09-25','YYYY-MM-DD'));
INSERT INTO Repairs VALUES ('Brake', 124, TO_DATE('2025-09-25','YYYY-MM-DD'));

-- All PartsRepaired Values Given
INSERT INTO PartsRepaired VALUES (103, TO_DATE('2025-09-05','YYYY-MM-DD'), 'Alternator', 'Engine');
INSERT INTO PartsRepaired VALUES (103, TO_DATE('2025-09-05','YYYY-MM-DD'), 'Battery', 'Engine');
INSERT INTO PartsRepaired VALUES (111, TO_DATE('2025-09-18','YYYY-MM-DD'), 'Brake Pads', 'Brake');
INSERT INTO PartsRepaired VALUES (111, TO_DATE('2025-09-18','YYYY-MM-DD'), 'Brake Disc', 'Brake');
INSERT INTO PartsRepaired VALUES (114, TO_DATE('2025-09-22','YYYY-MM-DD'), 'Spark Plugs', 'Engine');
INSERT INTO PartsRepaired VALUES (122, TO_DATE('2025-09-23','YYYY-MM-DD'), 'Spark Plugs', 'Engine');
INSERT INTO PartsRepaired VALUES (123, TO_DATE('2025-09-25','YYYY-MM-DD'), 'Spark Plugs', 'Engine');
INSERT INTO PartsRepaired VALUES (124, TO_DATE('2025-09-25','YYYY-MM-DD'), 'Brake Pads', 'Brake');

-- All Cleaning Values Given
INSERT INTO Cleaning VALUES ('Interior', 'Deep', 103, TO_DATE('2025-09-05','YYYY-MM-DD'));
INSERT INTO Cleaning VALUES ('Exterior', 'Premium', 103, TO_DATE('2025-09-05','YYYY-MM-DD'));
INSERT INTO Cleaning VALUES ('Interior', 'Premium', 112, TO_DATE('2025-09-20','YYYY-MM-DD'));
INSERT INTO Cleaning VALUES ('Exterior', 'Deep', 112, TO_DATE('2025-09-20','YYYY-MM-DD'));
INSERT INTO Cleaning VALUES ('Interior', 'Basic', 114, TO_DATE('2025-09-22','YYYY-MM-DD'));
INSERT INTO Cleaning VALUES ('Interior', 'Basic', 124, TO_DATE('2025-09-25','YYYY-MM-DD'));

-- All Rental Vaues Given
INSERT INTO Rental VALUES (401, TO_DATE('2025-09-15','YYYY-MM-DD'), TO_DATE('2025-09-20','YYYY-MM-DD'), 250.00, 40.00, 90, 301);
INSERT INTO Rental VALUES (402, TO_DATE('2025-09-18','YYYY-MM-DD'), TO_DATE('2025-09-22','YYYY-MM-DD'), 480.00, 60.00, 80, 302);
INSERT INTO Rental VALUES (403, TO_DATE('2025-09-12','YYYY-MM-DD'), TO_DATE('2025-09-15','YYYY-MM-DD'), 180.00, 30.00, 85, 305);
INSERT INTO Rental VALUES (404, TO_DATE('2025-09-20','YYYY-MM-DD'), TO_DATE('2025-09-24','YYYY-MM-DD'), 800.00, 70.00, 75, 306);
INSERT INTO Rental VALUES (405, TO_DATE('2025-09-07','YYYY-MM-DD'), TO_DATE('2025-09-11','YYYY-MM-DD'), 280.00, 35.00, 88, 307);
INSERT INTO Rental VALUES (406, TO_DATE('2025-09-01','YYYY-MM-DD'), TO_DATE('2025-09-05','YYYY-MM-DD'), 1000.00, 90.00, 70, 309);
INSERT INTO Rental VALUES (407, TO_DATE('2025-09-22','YYYY-MM-DD'), TO_DATE('2025-09-27','YYYY-MM-DD'), 500.00, 50.00, 82, 310);
INSERT INTO Rental VALUES (408, TO_DATE('2025-09-01','YYYY-MM-DD'), TO_DATE('2025-09-05','YYYY-MM-DD'), 1000.00, 90.00, 70, 311);
INSERT INTO Rental VALUES (409, TO_DATE('2025-09-22','YYYY-MM-DD'), TO_DATE('2025-09-27','YYYY-MM-DD'), 500.00, 50.00, 82, 312);

-- All Payment Values Given
INSERT INTO Payment VALUES (501, TO_DATE('2025-09-20','YYYY-MM-DD'), 'Credit', 290.00, 401);
INSERT INTO Payment VALUES (502, TO_DATE('2025-09-22','YYYY-MM-DD'), 'Debit', 540.00, 402);
INSERT INTO Payment VALUES (505, TO_DATE('2025-09-15','YYYY-MM-DD'), 'Cash', 210.00, 403);
INSERT INTO Payment VALUES (506, TO_DATE('2025-09-24','YYYY-MM-DD'), 'Credit', 870.00, 404);
INSERT INTO Payment VALUES (507, TO_DATE('2025-09-11','YYYY-MM-DD'), 'Mobile', 315.00, 405);
INSERT INTO Payment VALUES (509, TO_DATE('2025-09-05','YYYY-MM-DD'), 'Online', 1090.00, 406);
INSERT INTO Payment VALUES (510, TO_DATE('2025-09-27','YYYY-MM-DD'), 'Credit', 550.00, 407);

-- Queries
-- Customer
-- Q1: List all cities where customers live and count how many customers are in each city
-- Group results by city and ordered alphabetically.
SELECT City, COUNT(*) AS "Number of Customers"
FROM Customer
GROUP BY City
ORDER BY City;

-- Q2: Retrieve all customers who do not have a phone number listed
SELECT * 
FROM Customer
WHERE PhoneNumber IS NULL
ORDER BY FirstName, LastName;

-- Vehicle
-- Q1: List all unique daily rates for vehicles in descending order   
SELECT DISTINCT DailyRate
FROM Vehicle
ORDER BY DailyRate DESC;
--  Q2: Count the number of vehicles available in each vehicle type (Economy, Luxury)
SELECT VType, COUNT(*) AS "Number of Vehicles Available" 
FROM Vehicle
WHERE VStatus = 'Available'
GROUP BY VType;

-- VehicleColour
-- Q1: Show how many colours are associated with each vehicle   
SELECT DISTINCT VehicleID AS , COUNT(*) AS "Number of Colours" 
FROM VehicleColour
GROUP BY VehicleID
ORDER BY "Number of Colours" DESC;

-- Review
-- Q2: Retrieve all reviews with ratings less than 5, ordering results from lowest to highest rating
SELECT * 
FROM Review
WHERE rating < 5
ORDER BY rating;

-- Reservation
-- Q1: Show the number of reservations for each reservation status (Pending, Confirmed, Cancelled)
-- Group by status, and labelled the result as "Reservation_Count". Ordered the output so that statuses with the highest counts appear first.
SELECT RStatus, COUNT(DISTINCT ReservationID) AS Reservation_Count 
FROM Reservation 
GROUP BY RStatus 
ORDER BY Reservation_Count DESC;
-- Q2: Retrieve a distinct list of vehicles with their pickup dates, ensuring each vehicle pickup date pair appears only once
-- Order the results by pickup date in ascending order so that earlier reservations appear first
SELECT DISTINCT VehicleID, PPickupDate 
FROM Reservation 
ORDER BY PPickupDate ASC;

-- Rental
-- Q1: Count the number of rentals for each fuel level, label the count as Rental_Count and groubed by the fuel level
SELECT FuelLevel, COUNT(RentalID) AS Rental_Count 
FROM Rental 
GROUP BY FuelLevel;
-- Q2:Retrieve rentals that start after September 18, 2025, showing the rental ID, pickup date, and return date, and order the results by pickup date ascending.
SELECT RentalID, PickupDate, ReturnDate 
FROM Rental 
WHERE PickupDate > DATE '2025-09-18' 
ORDER BY PickupDate ASC;

-- Payment
-- Q1: Retrieve all distinct TotalAmount values from the Payment table that are less than or equal to a specified amount (e.g., $500)
-- Order the results by TotalAomunt in descending order
SELECT DISTINCT PaymentID, TotalAmount 
FROM Payment 
WHERE TotalAmount <= 500
ORDER BY TotalAmount DESC;
-- Q2: List all distinct payment methods used along with the total number of payments for each method
-- Label the count as Payment_Total, and order by the number of payments descending.
SELECT PaymentMethod, COUNT(PaymentID) AS Payment_Total 
FROM Payment 
GROUP BY PaymentMethod 
ORDER BY Payment_Total DESC;

-- Maintenance
-- Q1: List all the vehicles that have completed maintenace and that is sorted from most most recent to least recent  ISSUE
SELECT *
FROM maintenance
WHERE MStatus = 'Maintenance_Completed'
ORDER BY ServiceDate DESC;
-- Q2: Count the number of vehicles that are currently in under maintenance. 
SELECT VehicleID, COUNT(*) AS UndergoingMaintenance
FROM maintenance
WHERE MStatus = 'Under_Maintenance'
GROUP BY VehicleID; -- each vehicle id becomes single group 

-- Repairs
-- Q1: List repair types in least to most often in need of a repair 
SELECT RepairType, COUNT(*) As NumberOfRepairs
FROM repairs
GROUP BY RepairType
ORDER BY NumberOfRepairs ASC;
-- Q2: List all the unique vehicles (vehcile Id only) that have gone through some type of repairs. 
SELECT DISTINCT VehicleID
FROM repairs; 

-- PartsRequired
-- Q1: List parts by how often they are repaired 
SELECT Part, COUNT(*) AS RepairCount
FROM partsRepaired
GROUP BY Part
ORDER BY RepairCount DESC;

-- Cleaning
-- Q1: List all the vehicles that went through a premium level and interior cleaning that is sorted from most recent ot least.
SELECT *
FROM cleaning
WHERE CleaningArea = 'Interior' AND DetailLevel = 'Premium'
ORDER BY ServiceDate DESC;

-- Join Queries
-- Q1: Lists customer names, vehicle rented, and pickup/return dates 
SELECT FirstName, LastName, VehicleID, PickupDate, ReturnDate
FROM Customer, Reservation, Rental
WHERE Customer.CustomerID = Reservation.CustomerID
AND Reservation.ReservationID = Rental.ReservationID
ORDER BY PickupDate

-- Q2: Show customer ID, with their reservation ID, vehicle models, rental cost, and payment method
SELECT c.CustomerID, res.ReservationID , v.Model, rent.RentalCost, p.PaymentMethod
FROM Customer c, Reservation res, Vehicle v, Rental rent, Payment p
WHERE c.CustomerID = res.CustomerID
AND res.VehicleID = v.VehicleID
AND res.ReservationID = rent.ReservationID
AND rent.RentalID = p.RentalID;     
      
-- Q3: Count in Ascending order which models of vehicles have the most issues with brakes (so repair for brakes category) 
SELECT Model, COUNT(*) AS EngineIssues
FROM vehicle, repairs
WHERE vehicle.VehicleID = repairs.VehicleID
AND  RepairType = 'Engine'
GROUP By Model;

-- Q4: List all the vehicles with the parts that have replaced 
SELECT vehicle.VehicleID, Model, Plate, Part, RepairType
FROM vehicle, partsRepaired
WHERE vehicle.VehicleID = partsRepaired.VehicleID;

-- Q5: List all the vehicles with a mainteance record that had both some type of repair and some type of cleaning on same date 
SELECT DISTINCT vehicle.VehicleID, CleaningArea, RepairType, repairs.ServiceDate
FROM vehicle, repairs, cleaning
WHERE vehicle.VehicleID = repairs.VehicleID
AND vehicle.VehicleID = cleaning.VehicleID 
AND repairs.ServiceDate = cleaning.ServiceDate; 

-- Advanced Queries
-- Q1: Lists high spending customers
SELECT c.CustomerID, AVG(p.TotalAmount) AS AverageSpending
FROM Customer c, Reservation r, Rental t, Payment p
WHERE c.CustomerID = r.CustomerID
AND r.ReservationID = t.ReservationID
AND t.RentalID = p.RentalID
GROUP BY c.CustomerID
HAVING AVG(p.TotalAmount) > 700
ORDER BY AVG(p.TotalAmount) DESC;

-- Q2: Lists vehicles never rented
SELECT *
FROM Vehicle v
WHERE NOT EXISTS
(
    SELECT *
    FROM Reservation r, Rental t
    WHERE r.ReservationID = t.ReservationID
    AND r.VehicleID = v.VehicleID
);

-- Q3: Lists total revenue and average rental cost per vehicle type
SELECT v.VType, SUM(p.TotalAmount) AS TotalRevenue, AVG(p.TotalAmount) AS AverageRentalCost
FROM Vehicle v, Reservation r, Rental t, Payment p
WHERE v.VehicleID = r.VehicleID
AND r.ReservationID = t.ReservationID
AND t.RentalID = p.RentalID
GROUP BY v.VType
HAVING SUM(p.TotalAmount) > 0
ORDER BY TotalRevenue DESC;

-- Q4: Find customers with reservations but no payments
SELECT c.FirstName, c.CustomerID, r.ReservationID, rental.RentalID
FROM customer c, reservation r, rental
WHERE c.CustomerID = r.CustomerID AND
r.ReservationID = rental.ReservationID
MINUS
SELECT c.FirstName, c.CustomerID, r.ReservationID, rental.RentalID FROM customer c,
reservation r, rental, payment p
WHERE c.CustomerID = r.CustomerID AND
r.ReservationID = rental.ReservationID AND
rental.RentalID = p.RentalID;

-- Q5: Union of the vehicles with a rating greater than 4 and rating less than 2
SELECT Rating, ReviewID, Feedback
FROM review
WHERE Rating >= 4
UNION
SELECT Rating, ReviewID, Feedback
FROM review
WHERE Rating <= 2;

-- Q6: List of vehicles sent to maintenance more than 1 time
SELECT v.vehicleID, v.Model, COUNT(*) AS MaintenanceVisits
FROM vehicle v, maintenance
WHERE v.vehicleID = maintenance.vehicleID
GROUP BY v.vehicleID, v.Model
HAVING COUNT(*) > 1;

-- Views
-- V1: Shows each customer names, vehicle they reserved and pickup/return dates - uses join.  
Create VIEW customer_reservations(FirstName, LastName, VehicleID, PickupDate, ReturnDate) AS (
SELECT FirstName, LastName, VehicleID, PPickupDate, PReturnDate 
FROM Customer, Reservation
WHERE Customer.CustomerID = Reservation.CustomerID
);

-- V2: Lists all customers who have provided a phone number
CREATE VIEW customers_with_phone AS (
SELECT * 
FROM Customer 
WHERE PhoneNumber IS NOT NULL
);

-- V3: Shows customers alongside their rental cost, payment method, and total amount paid - uses join.
CREATE VIEW customer_info(CustomerID, RentalCost, PaymentMethod, TotalAmount) AS (
    SELECT c.CustomerID, rent.RentalCost, p.PaymentMethod, p.TotalAmount
    FROM Customer c, Reservation res, Rental rent, Payment p
    WHERE c.CustomerID = res.CustomerID
    AND res.ReservationID = rent.ReservationID
    AND rent.RentalID = p.RentalID
);

-- V4: Lists all vehicles type luxury with their ID, model, and daily rate
CREATE VIEW luxury_vehicles(VehicleID, Model, DailyRate) AS (
    SELECT VehicleID, Model, DailyRate
    FROM Vehicle
    WHERE VType = 'Luxury'
);

-- V5: --1) Show Vehicles with assocaited repair type, parts repaired and service date
CREATE VIEW vehiclerepairs_andparts AS (
    SELECT vehicle.VehicleID, Model, repairs.RepairType, repairs.ServiceDate, Part
    FROM vehicle, repairs, partsRepaired
    WHERE vehicle.VehicleID = repairs.VehicleID
    AND partsRepaired.VehicleID = repairs.VehicleID
    AND partsRepaired.ServiceDate = repairs.ServiceDate
);

-- V6: Shows all reservations that are still pending by customer, vehicle, and date details 
CREATE VIEW pending_reservations AS (
    SELECT vehicle.VehicleID, Model, customer.CustomerID, FirstName, LastName, Email, reservation.ReservationID, RStatus, PPickupDate, PReturnDate
    FROM vehicle, customer, reservation
    WHERE vehicle.VehicleID = reservation.VehicleID
    AND customer.CustomerID = reservation.CustomerID -- NEED to relate the customers back to the reservations 
    AND RStatus = 'Pending'
);


-- Check Populated Tables & Views
SELECT * FROM Customer;
SELECT * FROM Vehicle;
SELECT * FROM VehicleColour;
SELECT * FROM Review;
SELECT * FROM Reservation;
SELECT * FROM Maintenance;
SELECT * FROM Repairs;
SELECT * FROM PartsRepaired;
SELECT * FROM Cleaning;
SELECT * FROM Rental;
SELECT * FROM Payment;
SELECT * FROM customer_reservations;
SELECT * FROM customers_with_phone;
SELECT * FROM customer_info;
SELECT * FROM luxury_vehicles;
SELECT * FROM vehiclerepairs_andparts;
SELECT * FROM pending_reservations;
