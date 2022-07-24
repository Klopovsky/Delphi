USE DZZ;
DECLARE @geo geometry;
DECLARE @pol geometry;
DECLARE @temp geography;
SET @geo = geometry::STGeomFromText('POINT(49.5266 53.5111)', 4326);
DECLARE @I int;
SET @I = 1512;
WHILE (@I < 2169) 
BEGIN
SET @temp = (select TOP(1) Marsh.Plg from Marsh where (Marsh.ID = @I)AND(Marsh.ID_KA =7));
SET @pol = geometry::STGeomFromWKB(@temp.STAsBinary(), 4326);
IF (@pol.STContains(@geo) = 1) 
SELECT Marsh.Name FROM Marsh WHERE (Marsh.ID = @I);
SET @I = @I+1;
END