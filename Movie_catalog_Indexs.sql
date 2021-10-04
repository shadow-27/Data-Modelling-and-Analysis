
---Indexes--------------

--1.For query searches regarding Movie title on original title of the movie

Create Nonclustered Index [IDX_Title_title_original]
on Title (title_original ASC) INCLUDE (title_english);

--2.For query searches regarding movie of specific language

Create Nonclustered Index [IDX_Movie_Characteristics_original_language]
on Movie_Characteristics (original_language ASC) ;


--3.For query searches regarding latest movie releases and production date

Create Nonclustered Index [IDX_Movie_Characteristics_release_date]
on Movie_Characteristics (release_date Desc,production_startday Asc) ;

--4.For query searches related to movie categories
Create Nonclustered Index [IDX_Categories_category_name]
on Categories (category_name ASC);


--5.For query searches related to Age restriction of movie
Create Nonclustered Index [IDX_Age_Category_restriction_color]
on Age_Category (restriction_color ASC);


--6.For query searches related to Actor or Creator names  acting in a movie

Create NonClustered Index [IDX_Creator_name]
on Creator ([name],surname ASC);


--7.For query searches related to Job of Creator in the movie
Create NonClustered Index [IDX_Job_function]
on Job ([function] ASC );

--8.For query searches related to character_name in a movie
Create NonClustered Index[IDX_Movie_Cast_character_name]
on Movie_Cast (character_name ASC);

