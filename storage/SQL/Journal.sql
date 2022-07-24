use DZZ;
Select Users.Login,Pict.Name,Download.Date,Download.Operation,
Download.Size,
Download.Success 
from Download inner join Users on Users.ID=Download.ID_User
		left join Pict on Download.ID_Pict=Pict.ID  
 