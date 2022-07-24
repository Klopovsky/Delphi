use DZZ;
DECLARE @I int;
DECLARE @END int;
SET @I = --1464;
SET @END = --(SELECT MAX(Marsh.ID) FROM Marsh )
WHILE (@I <= @END)
BEGIN

DECLARE @geog1 varchar(50);
DECLARE @geog2 varchar(50); 
DECLARE @geog3 varchar(50); 
DECLARE @geog4 varchar(50);


SELECT @geog1 = NW.STAsText() FROM Marsh WHERE id = @I; 
SELECT @geog2 = NE.STAsText() FROM Marsh WHERE id = @I; 
SELECT @geog3 = SE.STAsText() FROM Marsh WHERE id = @I; 
SELECT @geog4 = SW.STAsText() FROM Marsh WHERE id = @I;   

SET @geog1 = SUBSTRING(@geog1,8,LEN(@geog1)-8);
SET @geog2 = SUBSTRING(@geog2,8,LEN(@geog2)-8);
SET @geog3 = SUBSTRING(@geog3,8,LEN(@geog3)-8);
SET @geog4 = SUBSTRING(@geog4,8,LEN(@geog4)-8);
--SELECT ('POLYGON(('+@geog1+','+@geog2+', '+@geog3+','+@geog1+')')

UPDATE  Marsh 
SET Marsh.Plg = geography::STGeomFromText('POLYGON(('+@geog1+', '+@geog2+', '+@geog3+', ' +@geog4+', '+@geog1+'))', 4923)
WHERE Marsh.ID = @I
SET @I =@I + 1;
END;