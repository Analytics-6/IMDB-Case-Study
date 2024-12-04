/*
Kaggle link to the dataset:
https://www.kaggle.com/datasets/harshitshankhdhar/imdb-dataset-of-top-1000-movies-and-tv-shows
*/


drop table if exists imdb_top_movies;
create table if not exists imdb_top_movies
(
	Poster_Link		varchar(4000),		
	Series_Title	varchar(500),
	Released_Year	varchar(20),
	Certificate		varchar(10),
	Runtime			varchar(20),
	Genre			varchar(100),
	IMDB_Rating		decimal,
	Overview		varchar(4000),
	Meta_score		int,
	Director		varchar(200),
	Star1			varchar(200),
	Star2			varchar(200),
	Star3			varchar(200),
	Star4			varchar(200),
	No_of_Votes		int,
	Gross			money
);


select * from imdb_top_movies;

1) Fetch all data from imdb table 

select * from imdb_top_movies


2) Fetch only the name and release year for all movies.

select series_title as name, released_year as release_year
from imdb_top_movies


3) Fetch the name, release year and imdb rating of movies which are UA certified

select series_title as name, released_year as release_year
from imdb_top_movies
where certificate = 'UA'


4) Fetch the name and genre of movies which are UA certified and have a Imdb rating of over 8.

select series_title as name, genre
from imdb_top_movies
where certificate = 'UA' and imdb_rating > 8


5) Find out how many movies are of Drama genre.

select count(1)
from imdb_top_movies
where genre like '%Drama%'


6) How many movies are directed by 
"Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" and "Rajkumar Hirani".

select count(1)
from imdb_top_movies
where director in ('Quentin Tarantino','Steven Spielberg','Christopher Nolan', 'Rajkumar Hirani')


7) What is the highest imdb rating given so far?

select imdb_rating as highest_rating
from imdb_top_movies
order by 1 desc
limit 1

or

select max(imdb_rating) as highest_rating 
from imdb_top_movies

8) What is the highest and lowest imdb rating given so far?

select max(imdb_rating) as highest_rating,
min(imdb_rating) as lowest_rating
from imdb_top_movies


8a) Solve the above problem but display the results in different rows.

select max(imdb_rating) as ratings_lowest_highest
from imdb_top_movies
union
select min(imdb_rating) as ratings_lowest_highest
from imdb_top_movies


8b) Solve the above problem but display the results in different rows. 
And have a column which indicates the value as lowest and highest

select min(imdb_rating) as movie_ratings, 'lowest_rating' as high_low from imdb_top_movies
union
select max(imdb_rating), 'highest_rating' as high_low from imdb_top_movies


9) Find out the total business done by movies staring "Aamir Khan"

select sum(gross) as total_business from 
imdb_top_movies
where 'Aamir Khan' in (star1, star2, star3, star4)

or

select sum(gross) as total_business from 
imdb_top_movies
where star1 = 'Aamir Khan'
or star2 = 'Aamir Khan'
or star3 = 'Aamir Khan'
or star4 = 'Aamir Khan'


10) Find out the average imdb rating of movies 
which are neither directed by "Quentin Tarantino", "Steven Spielberg", "Christopher Nolan" 
and are not acted by any of these stars "Christian Bale", "Liam Neeson", "Heath Ledger", "Leonardo DiCaprio", "Anne Hathaway".

select avg(imdb_rating) from 
imdb_top_movies
where director not in ('Quentin Tarantino', 'Steven Spielberg', 'Christopher Nolan')
and
(star1 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
or star2 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
or star3 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway')
or star4 not in ('Christian Bale', 'Liam Neeson', 'Heath Ledger', 'Leonardo DiCaprio', 'Anne Hathaway'))


11) Mention the movies involving both "Steven Spielberg" and "Tom Cruise".

select * 
from imdb_top_movies
where director = 'Steven Spielberg' and 'Tom Cruise' in (star1, star2, star3, star4)

or

select *
from imdb_top_movies
where director = 'Steven Spielberg'
and
(
star1 = 'Tom Cruise'
or star2 = 'Tom Cruise'
or star3 = 'Tom Cruise'
or star4 = 'Tom Cruise'
)



12) Display the movie name and watch time (in both mins and hours) which have over 9 imdb rating.

select series_title as movie_name, runtime,
replace(runtime,'min', '') as runtime_mins,
cast(replace(runtime,'min', '') as decimal)/60 as runtime_hours_all_sql,
round(replace(runtime,'min', '')::decimal/60,2) as runtime_hours_postgre_sql,
imdb_rating
from imdb_top_movies
where imdb_rating > 9


13) What is the average imdb rating of movies 
which are released in the last 10 years and have less than 2 hrs of runtime.

select round(avg(imdb_rating),2) as avg_movie_rating
from imdb_top_movies
where round(replace(runtime, 'min', '')::decimal/60,2) < 2
and
(extract(year from current_date) - released_year::int) <= 10
and
released_year <> 'PG'

or

select round(avg(imdb_rating),2) as avg_movie_rating
from imdb_top_movies
where round(cast(replace(runtime, 'min', '') as decimal)/60,2) < 2
and
(extract(year from current_date) - released_year::int) <= 10
and
released_year <> 'PG'



14) Identify the Batman movie which is not directed by "Christopher Nolan".

select * 
from 
imdb_top_movies
where upper(series_title) like '%BATMAN%'
and
director not in ('Christopher Nolan')

or

select * 
from 
imdb_top_movies
where upper(series_title) like '%BATMAN%'
and
director <> ('Christopher Nolan')


15) Display all the A and UA certified movies 
which are either directed by "Steven Spielberg", "Christopher Nolan" 
or which are directed by other directors but have a rating of over 8

select *
from imdb_top_movies
where certificate in ('A', 'UA')
and
(director in ('Steven Spielberg', 'Christopher Nolan')
or
(director not in ('Steven Spielberg', 'Christopher Nolan')
and
imdb_rating > 8))



16) What are the different certificates given to movies?

select distinct certificate 
from imdb_top_movies
order by 1


17) Display all the movies acted by Tom Cruise in the order of their release. 
Consider only movies which have a meta score.

select series_title as movies, released_year as release_time, meta_score
from imdb_top_movies
where 'Tom Cruise' in (star1, star2, star3, star4) and meta_score is not null
order by release_time

or 

select *
from imdb_top_movies
where 'Tom Cruise' in (star1, star2, star3, star4) and meta_score is not null
order by released_year

or

select * 
from imdb_top_movies
where meta_score is not null
and (star1 = 'Tom Cruise'
	or star2 = 'Tom Cruise'
	or star3 = 'Tom Cruise'
	or star4 = 'Tom Cruise')
order by released_year



18) Segregate all the Drama and Comedy movies released in the last 10 years as per their runtime. 
Movies shorter than 1 hour should be termed as short film. 
Movies longer than 2 hrs should be termed as longer movies. 
All others can be termed as Good watch time.

select series_title as movies, genre,
released_year,
case when round(replace(runtime,'min','')::decimal/60, 2) < 1 then 'Short Film'
     when round(replace(runtime,'min','')::decimal/60, 2) > 2 then 'Longer Movies'
	 else 'Good Watch Time'
	 end as duration
from imdb_top_movies
where released_year <> 'PG'
and
(upper(genre) like '%DRAMA%'
or
lower(genre) like '%comedy%')
and
extract(year from current_date) - released_year::int <= 10
order by duration


19) Write a query to display the "Christian Bale" movies which released in odd year and even year. 
Sort the data as per Odd year at the top.

select series_title as movies,
released_year,
case when released_year::int % 2 = 0 then 'even'
     else 'odd'
	 end as odd_even
from imdb_top_movies
where 'Christian Bale' in (star1, star2, star3, star4)
and released_year <> 'PG'
order by released_year

or

select series_title as movies,
released_year,
case when released_year::int % 2 = 0 then 'even'
     else 'odd'
	 end as odd_even
from imdb_top_movies
where star1 = 'Christian Bale'
or star2 = 'Christian Bale'
or star3 = 'Christian Bale'
or star4 = 'Christian Bale'
and released_year <> 'PG'
order by released_year


20) Re-write problem #18 without using case statement.

select series_title as movies,'short_film' as duration,
round(replace(runtime,'min', '')::decimal/60,2) as runtime
from imdb_top_movies
where
released_year <> 'PG'
and
(upper(genre) like '%DRAMA%'
or
lower(genre) like '%comedy%')
and
extract(year from current_date) - released_year::int <= 10
and
round(replace(runtime,'min', '')::decimal/60,2) < 1
union all
select series_title as movies,'longer movie' as duration,
round(replace(runtime,'min', '')::decimal/60,2) as runtime
from imdb_top_movies
where
released_year <> 'PG'
and
(upper(genre) like '%DRAMA%'
or
lower(genre) like '%comedy%')
and
extract(year from current_date) - released_year::int <= 10
and
round(replace(runtime,'min', '')::decimal/60,2) > 2
union all
select series_title as movies,'good watch time' as duration,
round(replace(runtime,'min', '')::decimal/60,2) as runtime
from imdb_top_movies
where
released_year <> 'PG'
and
(upper(genre) like '%DRAMA%'
or
lower(genre) like '%comedy%')
and
extract(year from current_date) - released_year::int <= 10
and
round(replace(runtime,'min', '')::decimal/60,2) between 1 and 2
order by duration

