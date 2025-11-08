create table Administrator ( 
Admin_ID INTEGER NOT NULL PRIMARY KEY, 
Admin_FName varchar(20) Not null, 
Admin_LName varchar(20) not null, 
Admin_StreetNo integer not null, 
Admin_StreetName varchar(100) not null, 
Admin_City varchar(50) not null, 
Admin_State varchar(20) not null, 
Amin_zipcode integer not null, 
Admin_Country varchar(40) not null, 
Admin_Email varchar(40) not null, 
Admin_PhoneNo integer not null  
); 


create table Administrator ( 
Admin_ID INTEGER NOT NULL PRIMARY KEY, 
Admin_FName varchar(20) Not null, 
Admin_LName varchar(20) not null, 
Admin_StreetNo integer not null, 
Admin_StreetName varchar(100) not null, 
Admin_City varchar(50) not null, 
Admin_State varchar(20) not null, 
Amin_zipcode integer not null, 
Admin_Country varchar(40) not null, 
Admin_Email varchar(40) not null, 
Admin_PhoneNo integer not null  
); 

create table Users( 
User_ID integer not null primary key,   
User_FName varchar(20) not null, 
User_LName varchar(20) not null, 
User_StreetNo integer not null, 
User_StreetName varchar(100) not null,
User_City varchar(50) not null, 
User_State integer not null, 
User_Zipcode integer not null, 
User_Country varchar(40) not null, 
User_Email varchar(40) not null, 
User_PhoneNo integer not null, 
User_Admin_ID integer not null foreign key references Admin(Admin_ID) 
);  

create table Product_Category( 
Prod_Cat_ID integer not null primary key, 
Prod_Cat_Name varchar(30) not null
);

create table Product( 
Prod_ID integer not null primary key, 
Prod_Name varchar(40) not null, 
Prod_Description varchar(400) not null, 
Prod_Start_Bid_Amount money not null, 
Min_Bid_Increment money, 
Seller_ID integer not null foreign key references Users(User_ID), 
Prod_Cat_ID integer not null foreign key references Product_Category(Prod_Cat_ID)
); 


create table Auction( 
Auc_ID integer not null primary key, 
Auc_Start_Date date not null, 
Auc_Close_Date date not null, 
Auc_Reserve_Price money not null, 
Auc_Payment_Date date, 
Auc_Winner_FName varchar(20) not null, 
Auc_Winner_LName varchar(20) not null, 
Auc_Payment_Amount money, 
Auc_Item_ID integer not null foreign key references Product(Prod_ID)
); 

create table Feedback( 
Fdb_ID integer not null primary key, 
Fdb_Time time not null, 
Fdb_Date date not null, 
Satisfaction_rating integer not null, 
Shipping_Delivery integer not null,  
Seller_Cooperation integer not null,  
Overall_Rating integer not null, 
Seller_ID integer not null foreign key references Users(User_ID), 
Buyer_ID integer not null foreign key references Users(User_ID)
); 

create table Bid( 
Bid_Number integer not null, 
Bid_Item_ID integer not null foreign key references Product(Prod_ID), 
Bid_Time time not null,
Bid_Date date not null, 
Bid_Price money not null, 
Bid_Comment varchar(200), 
Bidder_ID integer not null foreign key references Users(User_ID), 
Seller_ID integer not null foreign key references Users(User_ID), 
Auc_ID integer not null foreign key references Auction(Auc_ID) primary key(Bid_Number, Bid_Item_ID) 
); 

create table Shipment( 
Shipment_ID integer not null primary key, 
Ship_Planned_Date date not null, 
Ship_Actual_Date date not null,  
Ship_Cost money, 
Ship_Item_ID integer not null foreign key references Product(Prod_ID) 
); 

create table Payment_Method( 
Pay_Method_Code integer not null primary key,
Pay_Method_Description varchar(200) not null, 
Auc_ID integer not null foreign key references Auction(Auc_ID)
); 

select distinct U.User_FName + ' ' + U.User_LName as [Seller Name] , P.Prod_Name, P.Prod_Description, A.Auc_Reserve_Price as [Starting Bid Price], A.Auc_Payment_Amount as [Selling Price], A.Auc_Winner_FName + ' ' + A.Auc_Winner_LName as [Buyer Name], S.Ship_Planned_Date, S.Ship_Actual_Date, S.Ship_Cost 
from Users as U Join Product as P on U.User_ID = P.Seller_ID 
Join Bid as B on B.Bid_Item_ID = P.Prod_ID Join Shipment as S on S.Ship_Item_ID = P.Prod_ID 
Join Auction as A on A.Auc_ID = B.Auc_ID 
where P.Prod_Name = 'Baseball';

select Seller_ID, avg(Overall_Rating) as rating into #TempTable 
from Feedback group by Seller_ID; 
 
select User_FName + ' ' + User_LName as Name, User_State, User_Country, TT.rating 
from Users as U Join #TempTable as TT on U.User_ID = TT.Seller_ID 
where U.User_ID in (select Seller_ID from #TempTable where rating = (select max(rating) from #TempTable));

select Bid_Time, Bid_Date, Bid_Price, U.User_FName, U.User_LName 
from Bid as B join Users as U on B.Bidder_ID= U.User_ID join Product as P on P.Prod_ID = B.Bid_Item_ID 
where P.Prod_Name= 'Baseball'; 

select Prod_Cat_Name, P.Prod_Name 
from Product_Category as PC Join Product as P on PC.Prod_Cat_ID = P.Prod_Cat_ID 
where P.Prod_ID = (select Bid_Item_ID from  (SELECT Bid_Item_ID , COUNT(*) AS num FROM Bid GROUP BY Bid_Item_ID)a 
where num = (select max(num) from (SELECT Bid_Item_ID , COUNT(*) AS num FROM Bid GROUP BY Bid_Item_ID) a)); 

select distinct Prod_Name, Prod_Description, A.Auc_Payment_Amount as Final_Price 
from Product as P Join Bid as B on P.Prod_ID = B.Bid_Item_ID  
Join Auction as A on A.Auc_ID = B.Auc_ID 
where A.Auc_Winner_FName = 'Alvina' and A.Auc_Winner_LName='Kulicke'; 

select User_FName + ' ' + User_LName as FullName, User_StreetNo, User_StreetName, User_City, User_State, User_Zipcode  as User_Address, User_Country, User_Email, User_PhoneNo
from Users  as U Join Product as P on U.User_ID = P.Seller_ID 
where P.Prod_Name = 'Dishwasher'; 