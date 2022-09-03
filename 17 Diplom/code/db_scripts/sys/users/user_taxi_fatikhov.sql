create user taxi_fatikhov identified by taxi2 default tablespace sysaux temporary tablespace temp account unlock;
alter user taxi_fatikhov quota unlimited on sysaux;

grant create session to taxi_fatikhov;
grant create table to taxi_fatikhov;

GRANT create view TO taxi_fatikhov;
GRANT create any trigger TO taxi_fatikhov;
GRANT create any procedure TO taxi_fatikhov;
GRANT create sequence TO taxi_fatikhov;
GRANT create synonym TO taxi_fatikhov;
GRANT create type TO taxi_fatikhov;

GRANT ALL ON country TO taxi_fatikhov;