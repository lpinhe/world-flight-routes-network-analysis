select distinct source_airport as 'Source', destination_airport as 'Target', count(*) as 'strength'
from flight_routes.routes
group by source_airport, destination_airport
into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\routes.csv'
#FIELDS ESCAPED BY '\\' LINES TERMINATED BY '\r\n'; 
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n';

