use DZZ;
select  SUM(Pict.Size) as 'Всего Мбайт', COUNT(Pict.Size) as 'Количество файлов ' 
From Pict WHere Pict.ID_Marsh IN (select Marsh.ID from Marsh where Marsh.ID_KA = 7);