###  Постановка
К Вам подошел начальник отдела кадров и попросил создать отчет по отделам для аудиторов. Но сделать так чтобы никто не смог бы увидеть исходные данные.

Вы договорились, что напишите конвейерную функцию, у которой в спецификации, из механизмов работы с данными, будет описана только конвейерная функция, чтобы было меньше вопросов.

Следующее о чем договорились - это то что сама конвейерная функция будет получать данные через параметр из процедуры, которая будет описана только в теле пакета.

После этого Вы попросили начальника отдела кадров формализовать требования и выслать Вам их на почту. Что он и сделал. 

### Задачи
1. Напишите пакет pkg_agg_employees.
2. В пакете реализуйте процедуру, которая содержит курсор с соединенными таблицами сотрудников, отделов и работ. По этому курсору собирается коллекция, состоящая из суммы зарплат, минимальной зарплате, максимальной зарплате в разрезе отделов.
3. Еще одно поле в коллекции должно содержать имена и фамилии сотрудников в разрезе отделов. Подсказка - используйте в курсоре функцию listagg() с разделителем - переводом каретки (chr(10)).
4. Собранная коллекция в процедуре должна быть выходным параметром этой процедуры. Подсказка: для того чтобы определить тип данных параметра - нужно подставить туда тип таблицы из спецификации пакета.
5. В рамках созданного пакета создайте конвейерную функцию, которая обращается к процедуре из задания 2 и по конвейеру отправляет данные из этой коллекции запросу.
6. Напишите запрос вызова конвейерной функции.

### Условия
Для успешной сдачи домашнего задания сделайте все задание и отправьте в GitLab ваши программные модули.