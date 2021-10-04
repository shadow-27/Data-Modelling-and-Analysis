-------Stored Procedure-------------
--Prepare a stored Procedure for automatic detection of production delays

Create Procedure SPproductionDelays
@production_time int 
AS 
 declare @delayed_percent decimal(5,2)
 declare @delayed_days float
 declare @movie_ID int
 declare @production_startday date
 declare @release_date date
 declare @movie_count int
 declare @avg int
 declare @delayedmovies_summary table(id int,dealyedDays float,durationPercent decimal(5,2),startday date,releasedate date,directorName varchar(50),directorSurname varchar(50))

 declare delayed_movies cursor local for
 select characteristics_ID,DATEDIFF(day,production_startday,release_date) as dealyed_days,production_startday,release_date,case when exists (select 1 from Movie_Characteristics) 
          then 1
          else 0 
       end from Movie_Characteristics
 where DATEDIFF(day,production_startday,release_date)>@production_time
 group by characteristics_ID,production_startday,release_date
 open delayed_movies
 fetch next from delayed_movies into @movie_ID,@delayed_days,@production_startday,@release_date,@movie_count

 IF @movie_count>0
 BEGIN
		 WHILE @@FETCH_STATUS=0
		BEGIN
		----First we update the delay_flag of the movie
		 
		 update Movie_Characteristics
		 set delay_flag=1 where characteristics_ID=@movie_ID;
		
		--Assign an extra director to the movie that is not already present
		 
				Declare @flag int
				Set @flag=1
				Declare @director_ID int 
				Set @director_ID=(select top 1 creator_ID from Director order by NEWID())

				While(@flag=1)
				Begin
					BEGIN
					   IF NOT EXISTS (SELECT * FROM Movie_Direction 
									   WHERE director_ID=@director_ID
                   
									  and movie_ID=@movie_ID)
					   BEGIN
						   INSERT INTO Movie_Direction(director_ID,movie_ID)
						   VALUES (@director_ID,@movie_ID)
							   PRINT 'The director_ID assigned is = ' + CONVERT(VARCHAR,@director_ID)

							   --Inserting director names and movie_id and delayed percent to table for calcualting avg worst %
							   set @delayed_percent=(cast (@production_time as float)/CAST(@delayed_days as float))
								  set @delayed_percent=(1-@delayed_percent)
								  set @delayed_percent=@delayed_percent*100
							   INSERT INTO @delayedmovies_summary(id,dealyedDays,durationPercent,startday,releasedate,directorName,directorSurname)
							   select @movie_ID,@delayed_days,@delayed_percent,@production_startday,@release_date,Creator.name,Creator.surname from Creator
							   where Creator.creator_ID=@director_ID

						   Set @flag=0;
					   END
					   ELSE
					   Begin
					   Set @director_ID=(select top 1 creator_ID from Director order by NEWID())
					   End
					END

				end
		
		

 fetch next from delayed_movies into @movie_ID,@delayed_days,@production_startday,@release_date,@movie_count

          END
	close delayed_movies
	deallocate delayed_movies

	---verifies which movie has worst duration % realtive to the average from last 3 years

	set @avg=(select AVG(durationPercent) from @delayedmovies_summary)

	select top 1 id as highest_delaymovie from @delayedmovies_summary
	where  startday>=DATEADD(YEAR,-3,GETDATE()) and durationPercent>@avg
	order by durationPercent desc
	
	

	------Print Summary-------------
	Print 'Summary of Delayed Movies'
	select * from @delayedmovies_summary

	

END

ELSE
BEGIN
PRINT 'No Movies With Production Delays'
END

--checking:
declare @time int
set @time=450

begin transaction
exec SPproductionDelays @time

select * from Movie_Characteristics

rollback transaction

drop proc SPproductionDelays