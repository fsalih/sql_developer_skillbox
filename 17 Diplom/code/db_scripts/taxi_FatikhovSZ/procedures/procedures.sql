/*
     .
 :
- id 
- id .
     rent,   date_stop, gas_mileage
 distance .   car   true   is_reserved.
*/
create or replace procedure proc_car_reserving (p_driver_id in number, p_car_id in int) ------------------------------- 4
    is
        car_reseved exception;
        car_is_reserved int;
    begin
        /*    */
        select is_reserved into car_is_reserved from taxi_fatikhov.car where id=p_car_id;        
        if car_is_reserved = 1 then 
            RAISE car_reseved; 
        end if;
        
        INSERT INTO rent (driver_id , car_id , date_start) values 
                 (p_driver_id, p_car_id, sysdate); 
                
        UPDATE car
            SET is_reserved = 1 /* true */
            WHERE id = p_car_id;
        commit;
                
    exception
        WHEN car_reseved THEN
            raise_application_error (-20001,'This car (id='||p_car_id||') is already  reseved');
        WHEN OTHERS THEN
            raise_application_error(-20002,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;
/*   
      .
 :
- id 
-   
- ,    
     rent.    false 
is_reserved  car     mileage
*/

create or replace procedure proc_car_unreserve (p_car_id in number, p_fuel_count in number, p_distance in number) ----- 5
    is
        car_not_reseved exception;
        car_is_not_reserved int;
    begin
         /*    */
        select is_reserved into car_is_not_reserved from taxi_fatikhov.car where id=p_car_id;        
        if car_is_not_reserved = 0 then 
            RAISE car_not_reseved; 
        end if;
        
        UPDATE rent SET
            data_stop = sysdate,
            gas_mileage = p_fuel_count,
            distance =p_distance
        WHERE car_id = p_car_id and data_stop is null; 
                
        UPDATE car SET 
            is_reserved = 0, /* false */
            mileage=mileage + p_distance
        WHERE id = p_car_id;
        
        commit;
                
    exception
        WHEN car_not_reseved THEN
            raise_application_error (-20001,'This car (id='||p_car_id||') is not  reseved');
        WHEN OTHERS THEN
            raise_application_error(-20002,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;

/*
   . -------------------------------------------------------------------------------- 6
 :
- id 
-   
- 
-  
-  
     refueling  payment
*/

create or replace procedure proc_car_refueling (p_car_id in number, p_cost in number, p_currency in number,             /* проверить правильность работы !!!!! */
                                                p_pay_type in varchar2, p_fuel_count in number, p_refill_id number)                          /*Внимание! Тип валюты в чем должна быть? */
    is
       v_driver_id number := null;
       v_new_pay_id number;
       v_time timestamp;
    begin
        select max(time_create) into v_time from rent where car_id=p_car_id;
        select driver_id into v_driver_id from rent where car_id=p_car_id and time_create=v_time;

        insert into payment (amount_to_paid, currency_id, type) VALUES (p_cost, p_currency, p_pay_type); 

        SELECT max(id) into v_new_pay_id FROM payment ;

        INSERT INTO refueling (driver_id,  car_id, payment_id, amount_of_gasoline, adress_id) values
                              (v_driver_id, p_car_id, v_new_pay_id, p_fuel_count, p_refill_id);                                            
        commit;

    exception

        WHEN OTHERS THEN
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;
    
 /*                                             
 7.    .                                                               ------------------ 7
 :
- id 
- id 
-  id 
-  
-   
-  
- 
     order   SEARCH_DRIVER   
payment.       way.    way:
    id  ,   
         (  
            ). 
  way   ,    . 1  -  1
 .     way       
preview_way_id,  from_address_id  id  ,   to_address_id
   .    way     
:
-  from_address_id    to_address_id    way 
 .
-  to_address_id    
-  preview_way_id  id   way   .
 */
 
CREATE OR REPLACE TYPE num_table_type IS TABLE OF number;
  
create or replace procedure proc_create_order (p_passenger_id in number, 
                                                p_adress_id in number, 
                                                t_adress_id in num_table_type,
                                                t_distanse in num_table_type,
                                                p_cost in number, --   
                                                p_pay_type in varchar2, --  
                                                p_currency in number) --                         
    is
       --v_driver_id number := null;
       v_new_pay_id number;
       v_new_order_id number;
       v_prev_way_id number;
       i int;
    begin        
        insert into payment (amount_to_paid, currency_id, type) VALUES (p_cost, p_currency, p_pay_type); 
        SELECT max(id) into v_new_pay_id FROM payment ;
        
        --select driver_id into v_driver_id from rent where car_id=p_car_id;
        
        insert into order_tab (PASSENGER_ID, STATUS, PAYMENT_ID, Time_begin) 
                              VALUES 
                              (p_passenger_id, 'SEARCH_DRIVER', v_new_pay_id, sysdate);  ----------------------------------------- ?
        SELECT max(id) into v_new_order_id FROM order_tab ;
        
        insert into way (FROM_ADRESS_ID,
                         TO_ADRESS_ID,
                         DISTANCE,
                         ORDER_ID) values 
                         (p_adress_id,
                         t_adress_id(1),
                         t_distanse(1),
                         v_new_order_id);  
        SELECT max(id) into v_prev_way_id FROM way ;
        
        for i in 2..t_adress_id.count loop
            insert into way (FROM_ADRESS_ID,
                             TO_ADRESS_ID,
                             DISTANCE,
                             ORDER_ID,
                             PREVIEW_WAY_ID) values 
                             (t_adress_id(i-1),
                             t_adress_id(i),
                             t_distanse(i),
                             v_new_order_id,
                             v_prev_way_id);                             
            SELECT max(id) into v_prev_way_id FROM way ;
        end loop;
                                              
        commit;                
    exception        
        WHEN OTHERS THEN
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;
    
/*
8.     .   -------------------------------------------------------------- 8.
 :
-   ,        .
        passenger_rating.
*/
create or replace procedure proc_update_user_rating (p_days in number) 
    is
        avg_rating number;
    begin
    for r in (select id from passenger)
    loop
        select avg(rating)  into avg_rating
            from rating_driver2passenger rat
            inner join order_tab ord
            on rat.order_id=ord.id
            where rat.passenger=r.id and ord.time_end>sysdate-p_days;  
        UPDATE passenger_rating set
            rating=avg_rating
            where passenger_id=r.id;
    end loop;        
    commit;
                
    exception        
        WHEN OTHERS THEN
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;    
 
/*
9.     .         ------------------------------------------------------------ 9.
 :
-   ,        .
        driver_rating
*/
create or replace procedure proc_update_driver_rating (p_days in number) 
    is
        avg_rating number;
    begin
    for r in (select id from driver)
    loop
        select avg(rating)  into avg_rating
            from rating_passenger2driver rat
            inner join order_tab ord
            on rat.order_id=ord.id
            where rat.driver_id=r.id and ord.time_end>sysdate-p_days;  
        UPDATE driver_rating set
            rating=avg_rating
            where driver_id=r.id;
    end loop;        
    commit;
                
    exception        
        WHEN OTHERS THEN
            raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);    
    end;    


/*
10.   ,          ------------------------------------------ 10.
      .  
  :
percent_of_payment * (sum( ) - sum( ))
       .
*/

create or replace package driver_report is
    type salary_rec is record (id int, salary number);
    type salary_tbl is table of salary_rec;
    function get_drivers_salary(p_month in int, p_year in int) return salary_tbl pipelined;
end driver_report;

create or replace package body driver_report is
    base_currency_id constant number:=1;
    function get_drivers_salary(p_month in int, p_year in int) return salary_tbl pipelined
    is
        v_salary_row salary_rec;
        v_sum_pay number;
        v_sum_pay_to_gas number;
        --percent_to_driver number;
        --currency_rate number;
        cursor c_driver
        is
            select id, percent_of_payment from driver;
    begin        
        for r in c_driver loop
            v_salary_row:=null;
            v_salary_row.id:=r.id;
            v_salary_row.salary:=0;
            
            select sum(pmnt.amount_to_paid*rt.rate) into v_sum_pay      --    
                from order_tab ord
                inner join payment pmnt on pmnt.id=ord.payment_id
                inner join rate rt on pmnt.currency_id=rt.currency1_id 
                                   and rt.currency2_id=base_currency_id 
                                   and (rt.time_create)<=last_day(to_date(TO_CHAR(p_year)||TRIM(TO_CHAR(p_month,'09'))||'01','yyyymmdd'))
                where ord.driver_id=r.id 
                    and ord.status='TRIP_COMPLETED' 
                    and extract(year from ord.time_begin)=p_year 
                    and extract(month from ord.time_begin)=p_month 
                    and rt.time_create = ( SELECT max(time_create)
                                            from rate rt
                                            where  rt.currency2_id=base_currency_id 
                                                and rt.currency1_id=pmnt.currency_id 
                                                and (rt.time_create)<=last_day(to_date(TO_CHAR(p_year)||TRIM(TO_CHAR(p_month,'09'))||'01','yyyymmdd'))
                                            group by    currency1_id,
                                                        currency2_id
                                         );  
                                         
            select sum(pmnt.amount_to_paid*rt.rate) into v_sum_pay_to_gas    --    
                from refueling rfl
                inner join payment pmnt on pmnt.id=rfl.payment_id
                inner join rate rt on pmnt.currency_id=rt.currency1_id 
                                   and rt.currency2_id=base_currency_id 
                                   and (rt.time_create)<=last_day(to_date(TO_CHAR(p_year)||TRIM(TO_CHAR(p_month,'09'))||'01','yyyymmdd'))
                where rfl.driver_id=r.id 
                    and extract(year from rfl.time_create)=p_year 
                    and extract(month from rfl.time_create)=p_month 
                    and rt.time_create = ( SELECT max(time_create)
                                            from rate rt
                                            where  rt.currency2_id=base_currency_id 
                                                and rt.currency1_id=pmnt.currency_id 
                                                and (rt.time_create)<=last_day(to_date(TO_CHAR(p_year)||TRIM(TO_CHAR(p_month,'09'))||'01','yyyymmdd'))
                                            group by    currency1_id,
                                                        currency2_id
                                         );                                           
            
            if v_sum_pay_to_gas is null then v_sum_pay_to_gas:=0; end if;
            if v_sum_pay is null then v_sum_pay:=0; end if;
            
            v_salary_row.salary:=(v_sum_pay-v_sum_pay_to_gas)*r.percent_of_payment;  --  ,                  
            pipe row(v_salary_row);
        end loop;
        return;
    end get_drivers_salary;
    
end driver_report;
