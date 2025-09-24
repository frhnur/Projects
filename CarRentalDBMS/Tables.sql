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
    Colour VARCHAR2(20) NOT NULL,
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
