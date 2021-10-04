---Modification of Movie table---------------
/* Since we have a one-one relationship with Movie
table and Movie_Characteristics table we will first insert a new movie to a Movie table
then add its characteristics in Movie_characteristics and show basic Insert,update and delete operation on rows*/


select * from Movie where movie_ID=103
select * from Movie_Characteristics where characteristics_ID=103
select * from Age_Category where age_category_ID=103
select * from Title where title=103

EXEC sp_fkeys 'Movie'
EXEC sp_fkeys 'Movie_Characteristics'


begin transaction

--Insert 1 row to our Movies table first then to the Movie_Characteristics
Insert into Movie(movie_ID,category_ID,catalog_ID) values(103,2,1);
Insert into Movie_Characteristics(characteristics_ID,production_startday,expected_days,release_date,description,status_flag,original_language) values(103,'2019-08-27',300,'2020-08-27','This movie is super scary',1,'English');
Insert into Age_Category(age_category_ID,restriction_color) values(103,'red');
Insert into Title(title,title_original,title_english) values (103,'Hitman','Hitman');


-----update--------------
update Movie_Characteristics set original_language='French' where characteristics_ID=103;
update Age_Category set restriction_color='green' where age_category_ID=103;

-----delete the created movie-----------
Delete from Title where title=103;
Delete from Movie_Characteristics where characteristics_ID=103
Delete from Age_Category where age_category_ID=103
Delete from Movie where movie_ID=103;


rollback transaction