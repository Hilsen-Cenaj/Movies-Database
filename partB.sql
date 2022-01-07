/*
* Number of movies per year
*/
select date_part('year', release_date), count(id)
from "Movies_metadata"
group by date_part
order by date_part;

/*
* Number of movies per genre
*/
SELECT y.x->'name' "name", COUNT(id)
FROM "Movies_metadata"
CROSS JOIN LATERAL (SELECT jsonb_array_elements("Movies_metadata".genres::jsonb) x) y
GROUP BY y.x
ORDER BY "name";

/*
* Number of movies per genre and per year
*/
SELECT date_part('year', release_date), y.x->'name' "name", COUNT(id)
FROM "Movies_metadata"
CROSS JOIN LATERAL (SELECT jsonb_array_elements("Movies_metadata".genres::jsonb) x) y
GROUP BY date_part, y.x
ORDER BY date_part;

/*
* Average rating per genre
*/

select 
	y.x->'name' "name", 
	to_char(
		AVG (rating),
		'99999999999999999D99'
	) AS average_rating
from "Movies_metadata", ratings_small
CROSS JOIN LATERAL (SELECT jsonb_array_elements("Movies_metadata".genres::jsonb) x) y
where "Movies_metadata".id = ratings_small.movieid
group by y.x
order by "name";

/*
* Number of ratings from users
*/
select userid, count(rating)
from ratings_small
group by userid
order by userid;

/*
* Average rating from users
*/
select 
	userid, 
	to_char(
		AVG (rating),
		'99999999999999999D99'
	) AS average_rating
from ratings_small
group by userid
order by userid;

/*
* Create Table View
*/
create table view (total_ratings, average_rating) 
as
	select count(rating),
		to_char(
			AVG (rating),
			'99999999999999999D99'
		) AS average_rating
from ratings_small
group by userid