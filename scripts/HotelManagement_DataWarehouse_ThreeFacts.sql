-- Tạo database cho Data Warehouse
CREATE DATABASE HotelManagement_DW;
USE HotelManagement_DW;

-- Bảng Dim_Customer
CREATE TABLE Dim_Customer (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    country VARCHAR(100),
    is_repeated_guest BOOLEAN DEFAULT 0,
    previous_cancellations INT DEFAULT 0,
    previous_bookings_not_canceled INT DEFAULT 0,
    UNIQUE (customer_id)
);

-- Bảng Dim_Hotel
CREATE TABLE Dim_Hotel (
    hotel_key INT PRIMARY KEY AUTO_INCREMENT,
    hotel_id INT NOT NULL,
    hotel_type ENUM('Resort Hotel', 'City Hotel') NOT NULL,
    UNIQUE (hotel_id)
);

-- Bảng Dim_Date
CREATE TABLE Dim_Date (
    date_key INT PRIMARY KEY AUTO_INCREMENT,
    arrival_date DATE,
    year INT,
    month VARCHAR(20),
    week_number INT,
    day_of_month INT,
    is_weekend BOOLEAN
);

-- Bảng Dim_Market_Segment
CREATE TABLE Dim_Market_Segment (
    market_segment_key INT PRIMARY KEY AUTO_INCREMENT,
    market_segment ENUM('Online TA', 'Offline TA/TO', 'Groups', 'Direct', 'Corporate') NOT NULL,
    UNIQUE (market_segment)
);

-- Bảng Dim_Distribution_Channel
CREATE TABLE Dim_Distribution_Channel (
    distribution_channel_key INT PRIMARY KEY AUTO_INCREMENT,
    distribution_channel ENUM('TA/TO', 'GDS', 'Direct', 'Corporate', 'Undefined') NOT NULL,
    UNIQUE (distribution_channel)
);

-- Bảng Dim_Customer_Type
CREATE TABLE Dim_Customer_Type (
    customer_type_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_type ENUM('Group', 'Transient', 'Transient Party') NOT NULL,
    UNIQUE (customer_type)
);

-- Bảng Dim_Room_Type
CREATE TABLE Dim_Room_Type (
    room_type_key INT PRIMARY KEY AUTO_INCREMENT,
    reserved_room_type VARCHAR(50),
    assigned_room_type VARCHAR(50),
    UNIQUE (reserved_room_type, assigned_room_type)
);

-- Bảng Dim_Meal
CREATE TABLE Dim_Meal (
    meal_key INT PRIMARY KEY AUTO_INCREMENT,
    meal ENUM('BB', 'HB', 'FB'),
    UNIQUE (meal)
);

-- Bảng Dim_Deposit_Type
CREATE TABLE Dim_Deposit_Type (
    deposit_type_key INT PRIMARY KEY AUTO_INCREMENT,
    deposit_type ENUM('No Deposit', 'Non Refund', 'Refundable') NOT NULL,
    UNIQUE (deposit_type)
);

-- Bảng Dim_Agent
CREATE TABLE Dim_Agent (
    agent_key INT PRIMARY KEY AUTO_INCREMENT,
    agent_id INT,
    agent_name VARCHAR(255),
    UNIQUE (agent_id)
);

-- Bảng Dim_Company
CREATE TABLE Dim_Company (
    company_key INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT,
    company_name VARCHAR(255),
    UNIQUE (company_id)
);

-- Bảng Fact_Booking (Phân tích đặt phòng)
CREATE TABLE Fact_Booking (
    booking_key INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    customer_key INT NOT NULL,
    hotel_key INT NOT NULL,
    date_key INT NOT NULL,
    market_segment_key INT NOT NULL,
    distribution_channel_key INT NOT NULL,
    customer_type_key INT NOT NULL,
    deposit_type_key INT,
    agent_key INT,
    company_key INT,
    is_canceled BOOLEAN DEFAULT 0,
    lead_time INT,
    booking_changes INT DEFAULT 0,
    days_in_waiting_list INT DEFAULT 0,
    reservation_status ENUM('Check-Out', 'No-Show', 'Cancelled') NOT NULL,
    FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    FOREIGN KEY (hotel_key) REFERENCES Dim_Hotel(hotel_key),
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key),
    FOREIGN KEY (market_segment_key) REFERENCES Dim_Market_Segment(market_segment_key),
    FOREIGN KEY (distribution_channel_key) REFERENCES Dim_Distribution_Channel(distribution_channel_key),
    FOREIGN KEY (customer_type_key) REFERENCES Dim_Customer_Type(customer_type_key),
    FOREIGN KEY (deposit_type_key) REFERENCES Dim_Deposit_Type(deposit_type_key),
    FOREIGN KEY (agent_key) REFERENCES Dim_Agent(agent_key),
    FOREIGN KEY (company_key) REFERENCES Dim_Company(company_key)
);

-- Bảng Fact_Stay (Phân tích lưu trú)
CREATE TABLE Fact_Stay (
    stay_key INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    customer_key INT NOT NULL,
    hotel_key INT NOT NULL,
    date_key INT NOT NULL,
    stays_in_weekend_nights INT DEFAULT 0,
    stays_in_week_nights INT DEFAULT 0,
    adults INT DEFAULT 0,
    children INT DEFAULT 0,
    babies INT DEFAULT 0,
    FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    FOREIGN KEY (hotel_key) REFERENCES Dim_Hotel(hotel_key),
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key)
);

-- Bảng Fact_Service (Phân tích dịch vụ)
CREATE TABLE Fact_Service (
    service_key INT PRIMARY KEY AUTO_INCREMENT,
    booking_id INT NOT NULL,
    customer_key INT NOT NULL,
    hotel_key INT NOT NULL,
    date_key INT NOT NULL,
    meal_key INT,
    required_car_parking_spaces INT DEFAULT 0,
    total_of_special_requests INT DEFAULT 0,
    FOREIGN KEY (customer_key) REFERENCES Dim_Customer(customer_key),
    FOREIGN KEY (hotel_key) REFERENCES Dim_Hotel(hotel_key),
    FOREIGN KEY (date_key) REFERENCES Dim_Date(date_key),
    FOREIGN KEY (meal_key) REFERENCES Dim_Meal(meal_key)
);

-- Thêm chỉ mục để tối ưu hóa truy vấn
CREATE INDEX idx_booking_key ON Fact_Booking(booking_id);
CREATE INDEX idx_booking_customer_key ON Fact_Booking(customer_key);
CREATE INDEX idx_booking_hotel_key ON Fact_Booking(hotel_key);
CREATE INDEX idx_booking_date_key ON Fact_Booking(date_key);
CREATE INDEX idx_stay_key ON Fact_Stay(booking_id);
CREATE INDEX idx_stay_customer_key ON Fact_Stay(customer_key);
CREATE INDEX idx_stay_hotel_key ON Fact_Stay(hotel_key);
CREATE INDEX idx_stay_date_key ON Fact_Stay(date_key);
CREATE INDEX idx_service_key ON Fact_Service(booking_id);
CREATE INDEX idx_service_customer_key ON Fact_Service(customer_key);
CREATE INDEX idx_service_hotel_key ON Fact_Service(hotel_key);
CREATE INDEX idx_service_date_key ON Fact_Service(date_key);