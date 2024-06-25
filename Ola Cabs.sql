/* Created a Database*/
create database Ola_Cabs;

/*Used Database*/
use Ola_Cabs;

/* Created a Table*/

create table cab_data(
pickup_date text, 
pickup_time text ,
pickup_datetime text ,
weekday text ,
PickupArea text ,
DropArea text ,
Booking_id text ,
Booking_type text ,
Booking_mode text ,
Driver_number text ,
Service_status text ,
Status int ,
Fare int ,
Distance int ,
Confirmed_at text);


/* select the table to see the data and the structure of the table*/
select * from Cab_Data ;

/* Altered the table and addded 2 new columns*/

alter table cab_data
add column new_pickup datetime,
add column new_Confirmed datetime;

/*updated the new columns with dates*/

update cab_data
set new_pickup= str_to_date(pickup_datetime,"%d-%m-%Y %k:%i");

update cab_data
set new_confirmed= str_to_date(confirmed_at,"%d-%m-%Y %k:%i");

/'*Problem statements'*/

/*'Find hour of 'pickup' and 'confirmed_at' time, and make a column of weekday as "Sun,Mon, etc"next to pickup_datetime.'*/

select hour(new_pickup) ,hour(new_confirmed) from cab_data;

alter table cab_data
add column weekday text after pickup_datetime;

update cab_data
set weekday=dayname(new_pickup);


/*'Make a table with count of bookings with booking_type = p2p catgorized by booking mode as 'phone', 'online','app',etc'*/

select Booking_mode,count(booking_type) as Booking_Type_P2P from cab_data
WHERE Booking_Type ="P2P"
group by Booking_mode ;


/*'Find top 5 drop zones in terms of  average revenue'*/

select droparea,avg(fare) as Average_Fare from cab_data
group by droparea
order by (Average_fare) desc
limit 5 ;

/*'Find all unique driver numbers grouped by top 5 pickzones'*/

select pickuparea,distinct(driver_number) from cab_data 
where pickuparea in (select pickuparea from cab_data
where pickuparea <> ""
group by pickuparea
order by sum(fare) desc
limit 5 );



/*'Make a list of top 10 driver by driver numbers in terms of fare collected where service_status is done, done-issue'*/

select Driver_number,sum(fare) as Total_fare_collected from cab_data
where service_status in("Done","Done-issue")
group by driver_number
order by Total_fare_collected
limit 10 ;


/*'Make a hourwise table of bookings for week between Nov01-Nov-07 and highlight the hours with more than average no.of bookings day wise'*/


' Step-01'
                                                      
select hour(new_pickup) as Hours,count(*) as Total_Bookings from cab_data
where day(new_pickup) > 01 and day(new_pickup) <= 07
group by hours
order by hours asc;

'Step-02'

select avg(Daily_Bookings)
from(select day(new_pickup),count(*) as Daily_Bookings from Cab_data
							 group by day(new_pickup))as tt;

'Combined Step1 & 2'

select hour(new_pickup) as Hours,count(*) as Total_Bookings from cab_data
where day(new_pickup) > 01 and day(new_pickup) <= 07
group by hours
having count(*)>(select avg(Daily_Bookings)
from(select day(new_pickup),count(*) as Daily_Bookings from Cab_data
where day(new_pickup) > 01 and day(new_pickup) <= 07
							 group by day(new_pickup))as tt
                             order by hours asc);

