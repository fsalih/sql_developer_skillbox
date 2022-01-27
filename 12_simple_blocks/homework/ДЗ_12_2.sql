/*
2. Исправьте листинг программы.
begin
    if round(dbms_random.value(0, 10), 2 <= 3 then
        dbms_output.put_line('БС1')
    elif round(dbms_random.value(0 10), 2) = 5 than
        dbms_ouptut.put_line('БС2');
    else
        dbms_output.put_line('счёт');
    end
end;
*/

begin
    if round(dbms_random.value(0, 10), 2) <= 3 then
        dbms_output.put_line('БС1');
    elsif round(dbms_random.value(0, 10), 2) = 5 then
        dbms_output.put_line('БС2');
    else
        dbms_output.put_line('счёт');
    end if;
end;


