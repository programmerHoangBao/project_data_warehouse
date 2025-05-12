CREATE DATABASE HOTEL
GO
USE HOTEL
GO
DROP TABLE hotel_booking
CREATE TABLE hotel_booking (
    hotel NVARCHAR(50),
    is_canceled BIT,
    lead_time INT,
    arrival_date_year INT,
    arrival_date_month NVARCHAR(20),
    arrival_date_week_number INT,
    arrival_date_day_of_month INT,
    stays_in_weekend_nights INT,
    stays_in_week_nights INT,
    adults INT,
    children NVARCHAR(10),
    babies INT,
    meal NVARCHAR(20),
    country NVARCHAR(10),
    market_segment NVARCHAR(50),
    distribution_channel NVARCHAR(50),
    is_repeated_guest BIT,
    previous_cancellations INT,
    previous_bookings_not_canceled INT,
    reserved_room_type NVARCHAR(5),
    assigned_room_type NVARCHAR(5),
    booking_changes INT,
    deposit_type NVARCHAR(20),
    agent NVARCHAR(20),
    company NVARCHAR(20),
    days_in_waiting_list INT,
    customer_type NVARCHAR(50),
    adr FLOAT,
    required_car_parking_spaces INT,
    total_of_special_requests INT,
    reservation_status NVARCHAR(20),
    reservation_status_date DATE,
    name NVARCHAR(100),
    email NVARCHAR(100),
    [phone-number] NVARCHAR(20),
    credit_card NVARCHAR(20)
);
BULK INSERT [dbo].[hotel_booking]
FROM 'C:\Users\DELL\Downloads\hotel_booking.csv'
WITH (
    FIELDTERMINATOR = ',',      -- dấu phân cách cột
    ROWTERMINATOR = '\n',       -- dấu ngắt dòng
    FIRSTROW = 2,               -- bỏ qua dòng tiêu đề
    TABLOCK
);




