create table applestore_description_combined AS

select * from appleStore_description1
union ALL
select * from appleStore_description2
UNION ALL
SELECT * from appleStore_description3
union ALL
SELECT * from appleStore_description4


**EXPLORATORY DATA ANALYSIS**

--Check number of unique Apps in both the tables

select COUNT(DISTINCT id) as UniqueAppIds
FROM AppleStore

select COUNT(DISTINCT id) as UniqueAppIds
FROM applestore_description_combined

--Check for missing values in key feilds

SELECT COUNT(*) AS MissingValues
from AppleStore
where track_name is null or user_rating is null or prime_genre is NULL

SELECT COUNT(*) AS MissingValues
from applestore_description_combined
where app_desc is NULL

--Finding number of apps per genre

select prime_genre, count(*) as NumOfApps
from AppleStore
group by prime_genre
order by NumOfApps DESC

--Overview of app ratings

select min(user_rating) as MinRating,
	   max(user_rating) as MaxRating,
       avg(user_rating) as AvgRating
from AppleStore

--Distribution of app prices

SELECT
		(price/2) * 2 as PriceBinStart,
        ((price/2) * 2) + 2 as PriceBinEnd,
        count(*) as NumOfApps
from AppleStore
group by PriceBinStart
ORDER by PriceBinEnd


**DATA ANALYSIS**

--Determine whether paid apps have higher ratings than free apps

select CASE
		when (price>0) THEN 'PAID'
        ELSE 'FREE'
        END AS AppTypes,
        avg(user_rating) as AvgUserRating
from AppleStore
group BY AppTypes

--Check if apps with more supported languages have higher ratings

select CASE	
		when lang_num < 10 then '<10 languages'
        when lang_num BETWEEN 10 and 30 then '10 to 30 languages'
        else '>30 languages'
        end as Language_Bucket,
        avg(user_rating) as Avg_UserRating
from AppleStore
group by Language_Bucket
Order By Avg_UserRating desc 

--Check Genres with low rating

select prime_genre as App_Genre,
	avg(user_rating) as Avg_UserRating
from AppleStore
group by prime_genre
order by Avg_UserRating asc 
limit 10

-- Check if there is a correlation between length of app description and user rating

SELECT CASE
		when length(b.app_desc) < 500 then 'SHORT'
        WHEN length(b.app_desc) between 500 AND 1000 then 'MEDIUM'
        ELSE 'LONG'
        END AS Description_Length_Bucket,
        avg(user_rating) as Avg_User_Rating
from AppleStore a 
join applestore_description_combined b
on a.id = b.id
group by Description_Length_Bucket
order by Avg_User_Rating desc 


-- Top rates apps for each genre 

SELECT
	prime_genre,
	track_name,
	user_rating
FROM (
		SELECT
		prime_genre,
		track_name,
		user_rating,
		RANK() OVER(PARTITION BY prime_genre order BY user_rating desc, rating_count_tot desc) as rank
  		FROM
		AppleStore
	) AS a
WHERE
a.rank = 1
        
**INSIGHTS**


