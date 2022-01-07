/*
* Create first tables to upload the data
*/
create table credits(
	cast_id text,
	crew text,
	id int
);

create table Keywords(
	id int,
	keywords text
);

create table Links(
	movieId int,
	imdbId int,
	tmdbId int
);

create table Movies_Metadata(
	adult varchar(10),
	belongs_to_collection varchar(190),
	budget int,
	genres varchar(270),
	homepage varchar(250),
	id int,
	imdb_id varchar(10),
	original_language varchar(10),
	original_title varchar(110),
	overview varchar(1000),
	popularity varchar(10),
	poster_path varchar(40),
	production_companies varchar(1260),
	production_countries varchar(1040),
	release_date date,
	revenue bigint,
	runtime varchar(10),
	spoken_languages varchar(770),
	status varchar(20),
	tagline varchar(300),
	title varchar(110),
	video varchar(10),
	vote_average varchar(10),
	vote_count int
);

create table Ratings_Small(
	userId int,
	movieId int,
	rating numeric,
	timestamp int
);

/*
* Create second tables to delete duplicates
*/

--Credits--
create table "Credits" as
select distinct id
from credits;

alter table "Credits"
add column cast_id text,
add column crew text;

update "Credits"
set cast_id = credits.cast_id,
	crew = credits.crew
from credits
where "Credits".id = credits.id;

--Keywords--
create table "Keywords" as
select distinct id, keywords
from keywords;

--Links--
create table "Links" as
select distinct movieId, imdbId, tmdbId
from links;

alter table "Links"
add column movieid int,
add column imdbid int;

update "Links"
set movieid = links.movieid,
	imdbid = links.imdbid
from links
where "Links".tmdbid = links.tmdbid;

--Movies_Metadata--
create table "Movies_metadata" as
select distinct id
from movies_metadata;

alter table "Movies_metadata"
	add column adult varchar(10),
	add column belongs_to_collection varchar(190),
	add column budget int,
	add column genres varchar(270),
	add column homepage varchar(250),
	add column imdb_id varchar(10),
	add column original_language varchar(10),
	add column original_title varchar(110),
	add column overview varchar(1000),
	add column popularity varchar(10),
	add column poster_path varchar(40),
	add column production_companies varchar(1260),
	add column production_countries varchar(1040),
	add column release_date date,
	add column revenue bigint,
	add column runtime varchar(10),
	add column spoken_languages varchar(770),
	add column status varchar(20),
	add column tagline varchar(300),
	add column title varchar(110),
	add column video varchar(10),
	add column vote_average varchar(10),
	add column vote_count int;
	
update "Movies_metadata"
set adult = movies_metadata.adult,
	belongs_to_collection = movies_metadata.belongs_to_collection,
	budget = movies_metadata.budget,
	genres = movies_metadata.genres,
	homepage = movies_metadata.homepage,
	imdb_id = movies_metadata.imdb_id,
	original_language = movies_metadata.original_language,
	original_title = movies_metadata.original_title,
	overview = movies_metadata.overview,
	popularity = movies_metadata.popularity,
	poster_path = movies_metadata.poster_path,
	production_companies = movies_metadata.production_companies,
	production_countries = movies_metadata.production_countries,
	release_date = movies_metadata.release_date,
	revenue = movies_metadata.revenue,
	runtime = movies_metadata.runtime,
	spoken_languages = movies_metadata.spoken_languages,
	status = movies_metadata.status,
	title = movies_metadata.title,
	video = movies_metadata.video,
	vote_average = movies_metadata.vote_average,
	vote_count = movies_metadata.vote_count
from movies_metadata
where "Movies_metadata".id = movies_metadata.id;

UPDATE "Movies_metadata"
SET genres = replace(genres, '''', '"');

alter table "Movies_metadata"
alter column genres type json using genres::json;

/*
* Create Primary/Foreign keys
*/
ALTER TABLE "Credits"
ADD CONSTRAINT credits_pkey PRIMARY KEY (id);

ALTER TABLE "Keywords"
ADD CONSTRAINT keywords_pkey PRIMARY KEY (id);

ALTER TABLE "Movies_metadata"
ADD CONSTRAINT movies_m_pkey PRIMARY KEY (id);

ALTER TABLE "Links" 
ADD CONSTRAINT fk_links_movies_meta FOREIGN KEY (tmdbid) REFERENCES "Movies_metadata" (id);

ALTER TABLE ratings_small 
ADD CONSTRAINT fk_ratings_movies_meta FOREIGN KEY (movieid) REFERENCES "Movies_metadata" (id);

ALTER TABLE "Keywords" 
ADD CONSTRAINT fk_keywords_movies_meta FOREIGN KEY (id) REFERENCES "Movies_metadata" (id);

ALTER TABLE "Credits" 
ADD CONSTRAINT fk_credits_movies_meta FOREIGN KEY (id) REFERENCES "Movies_metadata" (id);


/*
* Delete data that do not Exist in Movies_metadata
*/
delete from "Links" 
where tmdbid not in(
	select id 
	from "Movies_metadata");
	
delete from "Ratings_small" 
where movieid not in(
	select id 
	from "Movies_metadata");