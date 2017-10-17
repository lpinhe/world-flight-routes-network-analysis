SELECT source_airport as 'from', destination_airport as 'to' from routes
into outfile 'C:\\ProgramData\\MySQL\\MySQL Server 5.7\\Uploads\\routes.txt'
FIELDS ESCAPED BY '\\' LINES TERMINATED BY '\r\n'; 
