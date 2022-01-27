declare
    v_num constant number = round(dbms_random.value(0, 10), 2;
begin
    v_num := round(dbms_random.value(0, 10), 2);
    
    if v_num <= 3 then
        dbms_output.put_line('БС1')
    elif v_num = 5 than
        dbms_ouptut.put_line('БС2');
    else
        dbms_output.put_line('счёт');
    end
end;