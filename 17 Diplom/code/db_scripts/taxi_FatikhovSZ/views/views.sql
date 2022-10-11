/*
11. —оздать представление, которое дл€ каждого пользовател€, который хот€ бы раз   ------------------------------------- 11.
пользовалс€ услугами такси, подберЄт 5 водителей, с которыми данный пользователь
ещЄ не ездил, но у которых средн€€ оценка выше 4.
*/

create or replace view find_good_driver
as
select * from
(select passenger_id, id drv_id, row_number() over(partition by passenger_id order by passenger_id) idx
from (
with pas_tab as (select distinct passenger_id from order_tab),  
 driv_tab as
    (select id from driver inner join driver_rating on driver.id=driver_rating.driver_id where driver_rating.rating>4)

select 
pas_tab.passenger_id,
driv_tab.id
from pas_tab, driv_tab 
minus  (select distinct passenger_id, driver_id from order_tab) ) )
where idx<6;
        
/*
12. —оздать представление, которое дл€ каждого пользовател€, у которых больше 10           ----------------------------- 12.
поездок, в пор€дке убывани€ подберЄт 5 самых частых мест начала или окончани€
поездки.
*/

create or replace view frequent_trips
as   
    select * from     
       (select
            pass_id_1,
            pass_adrs,
            pass_adr_cnt,
            row_number() over (PARTITION BY pass_id_1 ORDER  BY pass_adr_cnt DESC) as idx
       from
           (select pass_adr.pass_id as pass_id_1,
                  --pass_cnt.cnt,
                  pass_adr.adress_id as pass_adrs,
                  count(pass_adr.adress_id) as pass_adr_cnt          
                from
                (select passenger_id as pass_id,
                    count(passenger_id) as cnt  
                    from order_tab 
                    group by passenger_id) pass_cnt
                
           inner join     
           (select passenger_id as pass_id,
                  end_trip_adress_id as adress_id
            from order_tab
            union all
            select ord.passenger_id as pass_id,
                   w.from_adress_id as adress_id
                from order_tab ord       
                inner join way w on  ord.id=w.order_id
                where w.preview_way_id is null) pass_adr
            on pass_cnt.pass_id=pass_adr.pass_id
            where pass_cnt.cnt>10               --------------- больше 10 поездок
            group by pass_adr.adress_id,
                     pass_adr.pass_id
            order by pass_adr.pass_id asc,
                     pass_adr_cnt desc))
    where idx<6;                                --------------- 5 самых частых мест 
    
/*
13. —оздать представление, которое отобразит, в каких городах самые дорогие тарифы на ---------------------------------- 13. проверить правильность
бензин в рубл€х с учЄтом курса валюты на тот момент, когда была оплата за бензин. 
ƒл€ данного представлени€ в apex необходимо будет создать столбчатую диаграмму.                                         + APEX
*/
create or replace view full_adress
as
    select 
        adress.id as adress_id,
        adress.house_number as house_number,
        street.id as street_id,
        street.name as street_name,
        city.id as city_id,
        city.name as city_name,
        country.id as country_id,
        country.name as country_name 
    from adress
    right outer join street on street.id=adress.street_id
    right outer join city on city.id=street.city_id
    right outer join country on country.id=city.country_id;
    

create or replace view fuel_rates
as   
    select 
        --*
        max(amount_to_paid/amount_of_gasoline*rate) as price,
        city_name
        
    from  refueling 
    inner join payment on refueling.payment_id=payment.id
    inner join full_adress on full_adress.adress_id=refueling.adress_id
    inner join rate 
        on rate.currency1_id=payment.currency_id 
        and rate.currency2_id=1                                                                                         -- base_currency_id constant number:=1;
        and rate.time_create = (
                                select max(rate.time_create) from rate
                                inner join payment on payment.currency_id=rate.currency1_id and rate.currency2_id=1     -- base_currency_id constant number:=1;
                                inner join refueling on refueling.payment_id=payment.id 
                                and rate.time_create <= (refueling.time_create ) 
                                )
    
    group by city_name                            
    order by price desc;                            
          
    
/*
14. —оздать представление, которое отобразит средний чек за поездку в разных странах.   ------------------------------   14.
ƒл€ данного представлени€ в apex необходимо будет создать пончиковую диаграмму.                                         + APEX
*/

create or replace view average_chek
as   
    select 
        avg(payment.amount_to_paid*currency_convert(payment.currency_id,1,sysdate)) as average_check,
        full_adress.country_name as country_name
        from payment
        inner join order_tab on payment.id=order_tab.payment_id
        inner join full_adress on order_tab.end_trip_adress_id=full_adress.adress_id
        group by full_adress.country_name;
        
/*
15. —оздать представление, которое отобрази мес€чную динамику цен на проезд за 1                ------------------------ 15.
километр в городах –оссии. 
ƒл€ данного представлени€ в apex необходимо будет создать график зависимости цен от мес€ца + года.                      + apex
*/
create or replace view cost_for_order
as   
    select      order_tab.id as order_id, 
                payment.amount_to_paid / sum(way.distance)  as cost_to_km     
        from order_tab
        inner join way on way.order_id=order_tab.id
        inner join payment on order_tab.payment_id=payment.id
        group by order_tab.id, payment.amount_to_paid;

create or replace view price_in_Russia
as
select 
  avg(cost_for_order.cost_to_km) as avg_cost_to_km, 
  count(mt) as order_count,
  full_adress.city_name as city,
  mt as order_month,
  my as order_year,
  to_date('01'||to_char(mt,'09')||to_char(my),'DDMMYYYY') as date_of_month
  from        
      (select time_end,
              id,
              end_trip_adress_id,
              extract(month from time_end) as mt,
              extract(year from time_end) as my
      from order_tab) range_order_by_month    
  inner join cost_for_order on range_order_by_month.id=cost_for_order.order_id
  inner join full_adress on range_order_by_month.end_trip_adress_id=full_adress.adress_id
  where full_adress.country_id=21
  group by mt, my, full_adress.city_name
  order by date_of_month asc;
 