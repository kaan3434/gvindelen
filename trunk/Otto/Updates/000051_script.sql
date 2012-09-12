delete from bonuses;
-- Levakova
update orders set client_id = -183601, adress_id = -183601, account_id=12684 where order_id = 3169;
update accopers set account_id = 12684 where account_id = 16344;
update accrests set account_id = 12684 where account_id = 16344;
update ordermoneys om set om.account_id = 12684 where om.account_id = 16344;
delete from clients c where c.client_id=5090;
delete from accounts a where a.account_id = 16344;
delete from adresses a where a.adress_id = 1546;

-- Lukomskiy
update orders set client_id = 4349, adress_id = 695, account_id=14792 where order_id = 3929;
update ordermoneys om set om.account_id = 14792 where om.account_id = 17124;
update accopers set account_id = 14792 where account_id = 17124;
update accrests set account_id = 14792 where account_id = 17124;
delete from clients c where c.client_id=5395;
delete from accounts a where a.account_id = 17124;
delete from adresses a where a.adress_id = 1923;

-- Maruk
update orders set client_id = 3931, adress_id = 944, account_id=14074 where order_id = 1142;
update ordermoneys om set om.account_id = 14074 where om.account_id = 14458;
update accopers set account_id = 14074 where account_id = 14458;
update accrests set account_id = 14074 where account_id = 14458;
delete from clients c where c.client_id=4143;
delete from accounts a where a.account_id = 14458;
delete from adresses a where a.adress_id = 466;
update orders set client_id = 3931, adress_id = 944, account_id=14074 where order_id = 2699;
update ordermoneys om set om.account_id = 14074 where om.account_id = 15879;
update accopers set account_id = 14074 where account_id = 15879;
update accrests set account_id = 14074 where account_id = 15879;
delete from clients c where c.client_id=4911;
delete from accounts a where a.account_id = 15879;
delete from adresses a where a.adress_id = 1339;
update orders set client_id = 3931, adress_id = 944, account_id=14074 where order_id = 2991;
update ordermoneys om set om.account_id = 14074 where om.account_id = 16141;
update accopers set account_id = 14074 where account_id = 16141;
update accrests set account_id = 14074 where account_id = 16141;
delete from clients c where c.client_id=5023;
delete from accounts a where a.account_id = 16141;
delete from adresses a where a.adress_id = 1468;

-- Savelova
update orders set client_id = 4034, adress_id = 355, account_id=14266 where order_id = 1452;
update ordermoneys om set om.account_id = 14266 where om.account_id = 14724;
update accopers set account_id = 14266 where account_id = 14724;
update accrests set account_id = 14266 where account_id = 14724;
delete from clients c where c.client_id=4315;
delete from accounts a where a.account_id = 14724;
delete from adresses a where a.adress_id = 649;


execute procedure bonus_make('Байбак Ирина Станиславовна',  6);
execute procedure bonus_make('Булавин Вячеслав Васильевич',  6);
execute procedure bonus_make('Булавина Татьяна Николаевна',  6);
execute procedure bonus_make('Друян Юлия Викторовна',  6);
execute procedure bonus_make('Ковалева Ядвига Станиславовна',  6);
execute procedure bonus_make('Королевич Анжелика Иосифовна',  6);
execute procedure bonus_make('Курганова Фаина Леонидовна',  6);
execute procedure bonus_make('Левакова Наталья Васильевна',  6);
execute procedure bonus_make('Левко Жанна Валентиновна',  6);
execute procedure bonus_make('Лукомский Станислав Викторович',  6);
execute procedure bonus_make('Марук Каролина Анатольевна',  6);
execute procedure bonus_make('Минчик Оксана Борисовна',  6);
execute procedure bonus_make('Платонова Ольга Викторовна',  6);
execute procedure bonus_make('Поплавская Нина Павловна',  6);
execute procedure bonus_make('Потупчик Ирина Георгиевна',  6);
execute procedure bonus_make('Романова Жанна Ивановна',  6);
execute procedure bonus_make('Степовой Сергей Георгиевич',  6);
execute procedure bonus_make('Ступак Татьяна Николаевна',  6);
execute procedure bonus_make('Халява Татьяна Васильевна',  6);
execute procedure bonus_make('Хомич Фаина Станиславовна',  6);
execute procedure bonus_make('Шебеко Елена Николаевна',  6);
execute procedure bonus_make('Янкова Ольга Николаевна',  6);
execute procedure bonus_make('Гриб Светлана Валентиновна',  6);


execute procedure bonus_make('Иовик Татьяна Николаевна',  7);
execute procedure bonus_make('Куличкова Татьяна Владимировна',  7);
execute procedure bonus_make('Мушинский Виктор Васильевич',  7);
execute procedure bonus_make('Никитенко Наталья Николаевна',  7);
execute procedure bonus_make('Павлова Татьяна Михайловна',  7);
execute procedure bonus_make('Попельская Оксана Александровна',  7);
execute procedure bonus_make('Протченко Андрей Васильевич',  7);
execute procedure bonus_make('Савелова Людмила Александровна',  7);

execute procedure bonus_make('Коваль Нина Митрофановна',  8);
execute procedure bonus_make('Коваль Нина Митрофановна',  8);
execute procedure bonus_make('Рылькова Татьяна Александровна',  8);
execute procedure bonus_make('Рылькова Татьяна Александровна',  8);



