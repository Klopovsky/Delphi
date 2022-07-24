USE DZZ;
UPDATE Pict SET NE = NULL, NW = NULL, SE=NULL, SW=NULL  FROM Pict 
WHERE  Pict.NE.STDisjoint(geography::STPointFromText('POINT(0 0)',4923)) = 0