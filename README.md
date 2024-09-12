Тестовое задание (frontend flutter)
Примерная трудоемкость задачи 3ч. 
Решение (ссылку на резюме и видео ролик на 1-3 мин) выслать в течении 3 суток в телеграм @Aminov_Bakhtier
Вывести задачи на КАНБАН-ДОСКУ
Получить задачи от backend: indicator_to_mo_id (id задачи), parent_id (id папки) , name (название задачи), order (порядковый номер)
Авторизация по bearer token 48ab34464a5573519725deb5865cc74c
Запрос получения показателей с фильтром по типу задачи POST
https://development.kpi-drive.ru/_api/indicators/get_mo_indicators
body для form-data
period_start:2024-06-01
period_end:2024-06-30
period_key:month
requested_mo_id:478
behaviour_key:task,kpi_task
with_result:false
response_fields:name,indicator_to_mo_id,parent_id,order
auth_user_id:2
Вывести задачи на канбан-доску (как в trello) каждая колонка (столбец) это папка (pid)
Сделать перемещение задач Drag-&-Drop из папки в папку (pid) и вверх вниз (order)
Авторизация по bearer token 48ab34464a5573519725deb5865cc74c
Запрос на сохранение полей задачи POST
https://development.kpi-drive.ru/_api/indicators/save_indicator_instance_field
body для form-data
period_start:2024-06-01
period_end:2024-06-30
period_key:month
indicator_to_mo_id:315892
field_name:parent_id
field_value:311841
field_name:order
field_value:2
auth_user_id:2
Прислать короткое видео (до 5 минут) демонстрирующее результаты выполнения и ссылку на резюме https://hh.ru в телеграм https://t.me/Aminov_Bakhtier 
Можно использовать готовое решение open source.
Критерий оценки задания: 
Удобство использования для обычного пользователя (он не программист). 
Минимум кликов, интуитивно понятный интерфейс.
Красивое оформление (в стиле KPI-DRIVE)
Учитывать ответы от сервера
Предусмотреть “защиту от дурака” (неправильные действия пользователя которые приведут к сбоям)
Пример решения TRELLO который нам понравился (РОЛИК). Сделайте похоже или лучше в рамках отведенного времени
