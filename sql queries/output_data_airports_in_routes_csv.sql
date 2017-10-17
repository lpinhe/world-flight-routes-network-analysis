select distinct 
CASE
	WHEN nullif(IATA, '') IS NOT NULL THEN IATA
    ELSE ICAO
END as IATA,
latitude, longitude
from airports t1
join (
	select distinct source_airport
	from flight_routes.routes
	UNION
	select destination_airport
	from flight_routes.routes
	) t2 on t1.IATA = t2.source_airport
into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\airports_in_routes.csv'
#FIELDS ESCAPED BY '\\' LINES TERMINATED BY '\r\n'; 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';