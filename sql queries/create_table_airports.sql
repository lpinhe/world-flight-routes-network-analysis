create table flight_routes.airports (airportID nvarchar(5), airport_name nvarchar(50), City nvarchar(40), Country nvarchar(40), 
IATA nvarchar(4), ICAO nvarchar (5), latitude nvarchar (20), longitude nvarchar (20), altitude nvarchar (5), 
timezone nvarchar(5), DST nvarchar(2), tzdbtime nvarchar(30), airport_type nvarchar(20), source nvarchar(20))

load data local infile 'C:/Users/Luis/Desktop/Business Network Analytics/Assignment/data/airports1.txt'
into table flight_routes.airports
fields terminated BY "," OPTIONALLY ENCLOSED BY '"'
lines terminated BY "\n"
SET airport_type = nullif(airport_type,'')
;