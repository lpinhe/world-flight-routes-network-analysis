create table flight_routes.routes (airline nvarchar(5), airline_id nvarchar(10), source_airport nvarchar(5), source_airport_id nvarchar (5),
destination_airport nvarchar (5), destination_airport_id nvarchar (5), codeshare nvarchar(5), Stops nvarchar(5), equipment nvarchar(30))

load data local infile 'C:/Users/Luis/Desktop/Business Network Analytics/Assignment/data/routes.txt'
into table flight_routes.routes
fields terminated BY ","
lines terminated BY "\n"
SET codeshare = nullif(codeshare,'')
;