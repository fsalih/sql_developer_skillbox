/*
2. ��������� ������� ���������.
begin
    if round(dbms_random.value(0, 10), 2 <= 3 then
        dbms_output.put_line('��1')
    elif round(dbms_random.value(0 10), 2) = 5 than
        dbms_ouptut.put_line('��2');
    else
        dbms_output.put_line('����');
    end
end;
*/

begin
    if round(dbms_random.value(0, 10), 2) <= 3 then
        dbms_output.put_line('��1');
    elsif round(dbms_random.value(0, 10), 2) = 5 then
        dbms_output.put_line('��2');
    else
        dbms_output.put_line('����');
    end if;
end;


