/*
3. �������� ��������� ����, � ������� ���������� ��������� ���������� ����� � ������� [1, 5], � ��� ����� ����������� �� ������. 
���������� ������� �� ����� ������ ��� �������� ���������� �����.
*/
declare
    v_num number;
begin
    v_num:=round(dbms_random.value(1,5));
    dbms_output.put_line('����� ����� '||v_num);
    
    if v_num/2=round(v_num/2) then
        dbms_output.put_line('���������� ����� ������');
    else
        dbms_output.put_line('���������� ����� ��������');
    end if;
end;