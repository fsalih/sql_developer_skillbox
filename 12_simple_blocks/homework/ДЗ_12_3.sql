/*
3. Напишите анонимный блок, в котором выбирается случайное количество яблок в отрезке [1, 5], и это число округляется до целого. 
Необходимо вывести на экран чётное или нечётное количество яблок.
*/
declare
    v_num number;
begin
    v_num:=round(dbms_random.value(1,5));
    dbms_output.put_line('Всего яблок '||v_num);
    
    if v_num/2=round(v_num/2) then
        dbms_output.put_line('Количество яблок четное');
    else
        dbms_output.put_line('Количество яблок нечетное');
    end if;
end;