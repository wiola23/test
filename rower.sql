CREATE DATABASE bicycle_rental;
GO

USE bicycle_rental;
GO

CREATE TABLE bicycle (
    rover_id int IDENTITY(1,1) NOT NULL,
    rover_type varchar(100) DEFAULT 'Adventure Road Bike',
    origin varchar(80) DEFAULT 'NextBike',
    CONSTRAINT PK_bicycle PRIMARY KEY (rover_id)
);

CREATE TABLE bicycle_station (
    station_id int IDENTITY(1,1) NOT NULL,
    city varchar(100),
    address text,
    racks_amount int,
    available_racks int,
    CONSTRAINT PK_bicycle_station PRIMARY KEY (station_id)
);

CREATE TABLE users_user (
    user_id int IDENTITY(1,1) NOT NULL,
    email varchar(255),
    first_name varchar(200),
    last_name varchar(200),
    is_active bit,
    age datetime,
    current_balance money,
    CONSTRAINT PK_users_user PRIMARY KEY (user_id)
);

CREATE TABLE bycicle_rent (
    rent_id int IDENTITY(1,1) NOT NULL,
    user_id int,
    bicycle_id int,
    rented_at datetime,
    returned_at datetime,
    rent_station int,
    return_station int,
    total_cost money,
    is_finished bit DEFAULT 0,
    is_returned_manually bit DEFAULT 0,
    CONSTRAINT PK_bycicle_rent PRIMARY KEY (rent_id),
    CONSTRAINT FK_user FOREIGN KEY (user_id) REFERENCES users_user(user_id),
    CONSTRAINT FK_bicycle FOREIGN KEY (bicycle_id) REFERENCES bicycle(rover_id),
    CONSTRAINT FK_rent_station FOREIGN KEY (rent_station) REFERENCES bicycle_station(station_id),
    CONSTRAINT FK_return_station FOREIGN KEY (return_station) REFERENCES bicycle_station(station_id)
);
GO

ALTER TABLE users_user ADD phone_number varchar(25);
ALTER TABLE users_user DROP COLUMN age;
ALTER TABLE users_user ADD birth_date datetime;
GO

ALTER TABLE users_user ADD CONSTRAINT CHK_AdultUser CHECK (DATEDIFF(YEAR, birth_date, GETDATE()) >= 18);
GO

INSERT INTO bicycle (rover_type, origin) VALUES 
('City Bike', 'NextBike'), 
('MTB', 'NextBike'), 
('Electric', 'Bolt');

INSERT INTO bicycle_station (city, address, racks_amount, available_racks) VALUES 
('Warszawa', 'Centrum', 10, 5), 
('Warszawa', 'Mokotów', 5, 0), 
('Kraków', 'Rynek', 15, 10);

INSERT INTO users_user (email, first_name, last_name, is_active, current_balance, birth_date) VALUES 
('jan@test.pl', 'Jan', 'Kowalski', 1, 50.00, '1990-05-15'),
('anna@test.pl', 'Anna', 'Nowak', 1, 15.00, '1995-10-20'),
('piotr@test.pl', 'Piotr', 'Zieliński', 1, 100.00, '2002-01-01');

INSERT INTO bycicle_rent (user_id, bicycle_id, rented_at, rent_station) VALUES 
(1, 1, DATEADD(MINUTE, -15, GETDATE()), 1),
(2, 2, DATEADD(MINUTE, -45, GETDATE()), 1),
(3, 3, DATEADD(MINUTE, -130, GETDATE()), 3);
GO

CREATE PROCEDURE ZwrotRoweru 
    @user_id INT, 
    @rent_id INT, 
    @station_id INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRAN;

        DECLARE @rented_at DATETIME;
        SELECT @rented_at = rented_at 
        FROM bycicle_rent 
        WHERE rent_id = @rent_id AND user_id = @user_id AND is_finished = 0;

        IF @rented_at IS NULL
            THROW 50001, 'Blad: Wypozyczenie nie istnieje lub jest juz zakonczone.', 1;

        DECLARE @duration_minutes INT = DATEDIFF(MINUTE, @rented_at, GETDATE());
        DECLARE @total_cost MONEY = 0;

        IF @duration_minutes < 20
            SET @total_cost = 0;
        ELSE IF @duration_minutes < 60
            SET @total_cost = 1;
        ELSE IF @duration_minutes < 120
            SET @total_cost = 3;
        ELSE
            SET @total_cost = CEILING(@duration_minutes / 60.0) * 7;

        DECLARE @available_racks INT;
        SELECT @available_racks = available_racks 
        FROM bicycle_station 
        WHERE station_id = @station_id;

        IF @available_racks > 0
        BEGIN
            UPDATE bycicle_rent
            SET returned_at = GETDATE(),
                return_station = @station_id,
                total_cost = @total_cost,
                is_finished = 1
            WHERE rent_id = @rent_id;

            UPDATE bicycle_station
            SET available_racks = available_racks - 1
            WHERE station_id = @station_id;
        END
        ELSE
        BEGIN
            UPDATE bycicle_rent
            SET returned_at = GETDATE(),
                return_station = @station_id,
                total_cost = @total_cost,
                is_finished = 1,
                is_returned_manually = 1
            WHERE rent_id = @rent_id;
        END

        UPDATE users_user
        SET current_balance = current_balance - @total_cost
        WHERE user_id = @user_id;

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        ROLLBACK TRAN;
        THROW;
    END CATCH
END;
GO

CREATE INDEX IX_bycicle_rent_user ON bycicle_rent(user_id);
CREATE UNIQUE INDEX UQ_users_user_email ON users_user(email);
CREATE INDEX IX_bycicle_rent_station_date ON bycicle_rent(rent_station, returned_at);
CREATE INDEX IX_bicycle_station_city_racks ON bicycle_station(city, racks_amount);
CREATE INDEX IX_users_user_names ON users_user(first_name, last_name);
GO
