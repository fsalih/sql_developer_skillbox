###  Постановка
Сегодня у Вас тяжелый день, Вы нарасхват. К Вам опять обратился архитектор, он попросил Вас написать скрипт для обработки задержек при подключении к базам данных.

Потом к Вам обратилась сотрудница отдела кадров, которая попросила сделать заготовку для печатной формы.

И уже вечером к Вам подошли коллеги-программисты, которые попросили написать программу генерации списка глав.

### Задачи
1. Напишите анонимный блок, в котором будет бесконечный цикл с выходом по условию что количество попыток соединений равно пяти. В теле цикла необходимо реализовать ожидание перед попыткой по формуле (порядковый номер итерации) * (2 секунды). В Oracle функция ожидания - dbms_session.sleep().
2. Напишите анонимный блок, в котором будет цикл по сотрудникам из ИТ отдела. На экран нужно будет вывести печатную форму вида: ```Имя Фамилия    ___________      зарплата        Имя Фамилия руководителя    ___________```
3. Напишите анонимный блок, в котором задается две константы. Эти константы будут задавать верхние границы двух циклов. Первый цикл с предусловием, что суммарное количество глав и подглав меньше заданной верхней границы. Внутри первого цикла есть второй цикл, со счётчиком. Нижняя граница которого на 10 меньше верхней границы и больше нуля. Необходимо выводить на экран значения шагов счётчиков вместе, через точку (конкатенация).

### Условия
Для успешной сдачи домашнего задания сделайте все задание и отправьте в GitLab ваши программные модули.
