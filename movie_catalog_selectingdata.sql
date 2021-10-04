-----Selecting data---------

---1.Total number of movie releases by actors on a monthly window
with Monthly_Movie_release_by_actors as
(select YEAR(release_date) as movie_year,DATEPART(MONTH,release_date) as movie_month,CONCAT(Creator.name,Creator.surname) as actor_name,
count(*) over (partition by Creator.name,DATEPART(MONTH,release_date) ) as Monthly_movie_count from Movie_Characteristics 
Join Movie on Movie.movie_ID=Movie_Characteristics.characteristics_ID
Join Movie_Cast on Movie_Cast.movie_ID=Movie.movie_ID
Join Actor on Actor.creator_ID=Movie_Cast.actor_ID
Join Creator on Creator.creator_ID=Actor.creator_ID)

select * from Monthly_Movie_release_by_actors
order by movie_year,movie_month




----2.A list of actors that can play in more than 2 languages
select name,surname , count(distinct original_language) as lang_count from Creator
join Actor on Actor.creator_ID=Creator.creator_ID
join Movie_Cast on Movie_Cast.actor_ID=Actor.creator_ID
join Movie on Movie_Cast.movie_ID=Movie.movie_ID
join Movie_Characteristics on Movie_Characteristics.characteristics_ID=Movie.movie_ID
GROUP BY name,surname
having COUNT(distinct original_language)>2;



--proof

select name,surname , original_language  from Creator
join Actor on Actor.creator_ID=Creator.creator_ID
join Movie_Cast on Movie_Cast.actor_ID=Actor.creator_ID
join Movie on Movie_Cast.movie_ID=Movie.movie_ID
join Movie_Characteristics on Movie_Characteristics.characteristics_ID=Movie.movie_ID
where name='Aidan'
GROUP BY original_language,name,surname


--3.A list of actors that spent more that an average time on a production plan in a yearly window


select name,surname ,avg(DATEDIFF(day,production_startday,release_date)) as production_days from Creator
join Actor on Actor.creator_ID=Creator.creator_ID
join Movie_Cast on Movie_Cast.actor_ID=Actor.creator_ID
join Movie on Movie_Cast.movie_ID=Movie.movie_ID
join Movie_Characteristics on Movie_Characteristics.characteristics_ID=Movie.movie_ID
where DATEDIFF(YEAR,production_startday,release_date)<=1
group by name,surname,case when (DATEDIFF(YEAR,production_startday,release_date))<=1 then 1 else 0 end
having avg(DATEDIFF(day,production_startday,release_date))>(select AVG(DATEDIFF(day,production_startday,release_date)) as total_avg from Movie_Characteristics
where DATEDIFF(YEAR,production_startday,release_date)<=1); 



--proof
select AVG(DATEDIFF(day,production_startday,release_date)) as total_avg from Movie_Characteristics
where DATEDIFF(YEAR,production_startday,release_date)<=1


select characteristics_ID,DATEDIFF(YEAR,production_startday,release_date) as year from Movie_Characteristics

select * from Movie_Characteristics

---4. A list of directors with the number of movies in each age category
select name,surname,
sum(Case when restriction_color='green' then 1 else 0 end) as Green,
sum(Case when restriction_color='yellow' then 1 else 0 end) as Yellow,
sum(Case when restriction_color='red'    then 1 else 0 end) as Red
from Creator
inner join Director on Director.creator_ID=Creator.creator_ID
inner join Movie_Direction on Movie_Direction.director_ID=Creator.creator_ID
inner join Movie on Movie.movie_ID=Movie_Direction.movie_ID
join Age_Category on Age_Category.age_category_ID=Movie.movie_ID
group by name,surname;

--proof
select name,surname,count(restriction_color) as movies_directed
from Creator
inner join Director on Director.creator_ID=Creator.creator_ID
inner join Movie_Direction on Movie_Direction.director_ID=Creator.creator_ID
inner join Movie on Movie.movie_ID=Movie_Direction.movie_ID
join Age_Category on Age_Category.age_category_ID=Movie.movie_ID
group by name,surname;


---5.Three Movie genres with highest number of actors
select top 3 category_Name ,Count( distinct Actor.creator_ID) as actor_count from Categories
join Movie on Movie.movie_ID=Categories.movie_ID
join Movie_Cast on Movie_Cast.movie_ID=Movie.movie_ID
join Actor on Actor.creator_ID=Movie_Cast.actor_ID
join Creator on Creator.creator_ID=Actor.creator_ID
group by category_Name
order by actor_count desc
--proof we use distinct because the same actor can play multiple characters in a movie
select distinct Actor.creator_ID from Categories
join Movie on Movie.movie_ID=Categories.movie_ID
join Movie_Cast on Movie_Cast.movie_ID=Movie.movie_ID
join Actor on Actor.creator_ID=Movie_Cast.actor_ID
join Creator on Creator.creator_ID=Actor.creator_ID
where  category_Name='western';