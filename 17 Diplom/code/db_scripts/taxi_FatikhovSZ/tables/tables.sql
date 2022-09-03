create table country (id int generated as identity not null, 
                      name varchar(255) not null, 
                      time_create timestamp not null,
                      primary key (id)); 

CREATE OR REPLACE TRIGGER timestamp_paste
before INSERT
   ON country FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;


create table city (id int generated as identity not null, 
                   name varchar(255) not null, 
                   country_id int not null,
                   time_create timestamp not null,
                   primary key (id),
                   foreign key (country_id) references taxi_fatikhov.country(id)); 
                   
CREATE OR REPLACE TRIGGER city_timestamp_paste
before INSERT
   ON taxi_fatikhov.city FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;

create table street (id int generated as identity not null, 
                    name varchar(255) not null, 
                    city_id int not null,
                    time_create timestamp not null,
                    primary key (id),
                    foreign key (city_id) references taxi_fatikhov.city(id)); 
                   
CREATE OR REPLACE TRIGGER street_timestamp_paste
before INSERT
   ON taxi_fatikhov.street FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;

create table adress (id int generated as identity not null, 
                    house_number int not null, 
                    street_id int not null,
                    time_create timestamp not null,
                    primary key (id),
                    foreign key (street_id) references taxi_fatikhov.street(id)); 
                   
CREATE OR REPLACE TRIGGER house_number_timestamp_paste
before INSERT
   ON taxi_fatikhov.adress FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;

create table passenger (id int generated as identity not null, 
                        is_anonymous int check(is_anonymous in (0,1)) not null,
                        name varchar(255), 
                        age int,
                        home_address_id int,
                        phone_number varchar(50) not null,
                        is_male int check(is_male in (0,1)), /*0-false, 1-true, null - undefined   */
                        time_create timestamp not null,
                        primary key (id),
                        foreign key (home_address_id) references taxi_fatikhov.adress(id)); 
                   
CREATE OR REPLACE TRIGGER passenger_timestamp_paste
before INSERT
   ON taxi_fatikhov.passenger FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;


create table passenger_rating (passenger_id int not null, 
                               rating decimal,
                               time_create timestamp not null,
                               primary key (passenger_id),
                               foreign key (passenger_id) references taxi_fatikhov.passenger(id)); 
                        
CREATE OR REPLACE TRIGGER passenger_rating_timestamp_paste
before INSERT
   ON taxi_fatikhov.passenger_rating FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;                        
                        
create table passenger_image  (id int not null, 
                               image CLOB,
                               time_create timestamp not null,
                               primary key (id),
                               foreign key (id) references taxi_fatikhov.passenger(id)); 
                        
CREATE OR REPLACE TRIGGER passenger_image_timestamp_paste
before INSERT
   ON taxi_fatikhov.passenger_image FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;      

create table driver (id int generated as identity not null, 
                     name varchar(255), 
                     age int,
                     phone_number varchar(50) not null,
                     percent_of_payment decimal(0,2) not null,
                     registration_date date not null,
                     time_create timestamp not null,
                     primary key (id)); 
                   
CREATE OR REPLACE TRIGGER driver_timestamp_paste
before INSERT
   ON taxi_fatikhov.driver FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END; 

create table driver_rating (driver_id int not null, 
                               rating decimal,
                               time_create timestamp not null,
                               primary key (driver_id),
                               foreign key (driver_id) references taxi_fatikhov.driver(id)); 
                        
CREATE OR REPLACE TRIGGER driver_rating_timestamp_paste
before INSERT
   ON taxi_fatikhov.driver_rating FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;                    

create table driver_image (id int not null, 
                           image CLOB,
                           time_create timestamp not null,
                           primary key (id),
                           foreign key (id) references taxi_fatikhov.driver(id)); 
                        
CREATE OR REPLACE TRIGGER driver_image_timestamp_paste
before INSERT
   ON taxi_fatikhov.driver_image FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;    

create table currency (id int generated as identity not null, 
                      name varchar(50) not null, 
                      abbreviation varchar(8) not null,
                      time_create timestamp not null,
                      primary key (id)); 
                      
CREATE OR REPLACE TRIGGER currency_timestamp_paste
before INSERT
   ON currency FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;                      
          
create table rate (id int generated as identity not null, 
                   currency1_id int not null, 
                   currency2_id int not null,  
                   time_create timestamp not null,
                   rate decimal not null,
                   primary key (id),
                   foreign key (currency1_id) references taxi_fatikhov.currency(id),
                   foreign key (currency2_id) references taxi_fatikhov.currency(id));
                   
                   
CREATE OR REPLACE TRIGGER rate_timestamp_paste
before INSERT
   ON taxi_fatikhov.rate FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;    

create table currency2country (currency_id int not null, 
                               country_id int not null,  
                               time_create timestamp not null,
                               foreign key (currency_id) references taxi_fatikhov.currency(id),
                               foreign key (country_id) references taxi_fatikhov.country(id));     

CREATE OR REPLACE TRIGGER currency2country_timestamp_paste
before INSERT
   ON taxi_fatikhov.currency2country FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;    

create table parking (id int generated as identity not null, 
                      p_number int not null, 
                      address_id int not null,  
                      time_create timestamp not null,
                      primary key (id),                
                      foreign key (address_id) references taxi_fatikhov.adress(id));    
                      
create unique index parking_p_number on taxi_fatikhov.parking(p_number);

CREATE OR REPLACE TRIGGER parking_timestamp_paste
before INSERT
   ON taxi_fatikhov.parking FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;   

create table car (id int generated as identity not null, 
                  brand varchar(50) not null,
                  model varchar(50) not null,
                  color varchar(15) check(color in ('White', 'Black', 'Grey', 'Red', 'Blue', 'Yellow', 'Green')) not null,
                  is_reserved int check(is_reserved in (0,1)) not null, /*0-false, 1-true   */
                  state_number varchar(50) not null, 
                  parking_id int not null,  
                  mileage number not null,
                  time_create timestamp not null,
                  primary key (id),                
                  foreign key (parking_id) references taxi_fatikhov.parking(id));    
create unique index car_state_number on taxi_fatikhov.car(state_number);                     
CREATE OR REPLACE TRIGGER car_timestamp_paste
before INSERT
   ON taxi_fatikhov.car FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;  

create table rent (id int generated as identity not null,                    
                   driver_id int not null,  
                   car_id int not null,  
                   date_start date not null,
                   data_stop date,
                   gas_mileage decimal,
                   distance number,
                   time_create timestamp not null,
                   primary key (id),                
                   foreign key (driver_id) references taxi_fatikhov.driver(id),
                   foreign key (car_id) references taxi_fatikhov.car(id));    
CREATE OR REPLACE TRIGGER rent_timestamp_paste
before INSERT
   ON taxi_fatikhov.rent FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;      

create table payment (id int generated as identity not null, 
                      amount_to_paid decimal not null, 
                      currency_id int not null,  
                      type varchar(15) check(type in ('CARD', 'CASH')) not null,
                      time_create timestamp not null,
                      primary key (id),                
                      foreign key (currency_id) references taxi_fatikhov.currency(id));    
                      
CREATE OR REPLACE TRIGGER payment_timestamp_paste
before INSERT
   ON taxi_fatikhov.payment FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;   

create table refueling (id int generated as identity not null,                    
                        driver_id int not null,  
                        car_id int not null,  
                        payment_id int not null,
                        amount_of_gasoline decimal not null,
                        adress_id int not null,
                        time_create timestamp not null,
                        primary key (id),                
                        foreign key (driver_id) references taxi_fatikhov.driver(id),
                        foreign key (car_id) references taxi_fatikhov.car(id),
                        foreign key (payment_id) references taxi_fatikhov.payment(id),
                        foreign key (adress_id) references taxi_fatikhov.adress(id));    
CREATE OR REPLACE TRIGGER refueling_timestamp_paste
before INSERT
   ON taxi_fatikhov.refueling FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;                        
                  
create table order_tab (id int generated as identity not null, 
                    passenger_id int not null, 
                    driver_id int, 
                    time_begin timestamp not null,
                    time_end timestamp,
                    status varchar(25) check(status in ('SEARCH_DRIVER', 'WAIT_DRIVER', 'WAIT_PASSENGER', 'TRIP_STARTED',
                                                        'WAIT-PAYMENT', 'TRIP_COMPLETED', 'CANCELLED')) not null,
                    payment_id int not null,
                    end_trip_adress_id int,
                    average_driver_speed decimal,
                    time_create timestamp not null,
                        primary key (id),                
                        foreign key (driver_id) references taxi_fatikhov.driver(id),
                        foreign key (passenger_id) references taxi_fatikhov.passenger(id),
                        foreign key (payment_id) references taxi_fatikhov.payment(id),
                        foreign key (end_trip_adress_id) references taxi_fatikhov.adress(id));         
drop table order_tab;   

CREATE OR REPLACE TRIGGER order_tab_timestamp_paste
before INSERT
   ON taxi_fatikhov.order_tab FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;  

create table way (id int generated as identity not null, 
                  from_adress_id  int not null, 
                  to_adress_id  int not null, 
                  distance decimal not null, 
                  order_id  int not null,
                  preview_way_id int,
                  time_create timestamp not null,
                  primary key (id),                
                  foreign key (from_adress_id) references taxi_fatikhov.adress(id),
                  foreign key (to_adress_id) references taxi_fatikhov.adress(id),
                  foreign key (order_id) references taxi_fatikhov.order_tab(id),
                  foreign key (preview_way_id) references taxi_fatikhov.way(id));                          
CREATE OR REPLACE TRIGGER way_tab_timestamp_paste
before INSERT
   ON taxi_fatikhov.way FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END;

create table rating_driver2passenger (id int generated as identity not null, 
                                      passenger int not null, 
                                      driver_id int not null, 
                                      order_id int not null,
                                      rating decimal,
                                      time_create timestamp not null,
                                      primary key (id),                
                                      foreign key (driver_id) references taxi_fatikhov.driver(id),
                                      foreign key (passenger) references taxi_fatikhov.passenger(id),
                                      foreign key (order_id) references taxi_fatikhov.order_tab(id));                          
CREATE OR REPLACE TRIGGER rating_driver2passenger_tab_timestamp_paste
before INSERT
   ON taxi_fatikhov.rating_driver2passenger FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END; 

create table rating_passenger2driver (id int generated as identity not null, 
                                      passenger int not null, 
                                      driver_id int not null, 
                                      order_id int not null,
                                      rating decimal,
                                      time_create timestamp not null,
                                      primary key (id),                
                                      foreign key (driver_id) references taxi_fatikhov.driver(id),
                                      foreign key (passenger) references taxi_fatikhov.passenger(id),
                                      foreign key (order_id) references taxi_fatikhov.order_tab(id));                          
CREATE OR REPLACE TRIGGER rating_passenger2driver_timestamp_paste
before INSERT
   ON taxi_fatikhov.rating_passenger2driver FOR EACH ROW 
DECLARE
BEGIN
   :new.time_create := sysdate; 
END; 

create table temp_way(address_id number, distance number);

select * from price_in_Russia  

