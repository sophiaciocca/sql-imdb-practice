//creating movies table

CREATE TABLE movies (
    id integer PRIMARY KEY,
    name text DEFAULT NULL,
    year integer DEFAULT NULL,
    rank real DEFAULT NULL
);

//creating actors table

CREATE TABLE actors (
    id integer PRIMARY KEY,
    first_name text DEFAULT NULL,
    last_name text DEFAULT NULL,
    gender text DEFAULT NULL
);

//creating roles table

CREATE TABLE roles (
    actor_id integer,
    movie_id integer,
    role_name text DEFAULT NULL
);

//----------------------------------------

//FIND ALL MOVIES MADE IN THE YEAR YOU WERE BORN:

SELECT name, year 
FROM movies
WHERE (year = 1993);

//(note: dont use parentheses after select!)

//-----

// HOW MANY MOVIES DOES OUR DB HAVE FROM YEAR 1982?

SELECT COUNT(*)
FROM movies
WHERE (year = 1982);

//-----

// FIND ACTORS WHO HAVE "STACK" IN THEIR LAST NAME.

SELECT *
FROM actors
WHERE last_name LIKE "%stack%";

//-----

// WHAT ARE THE 10 MOST POPULAR FIRST NAMES & LAST NAMES IN THE BUSINESS?
// & HOW MANY ACTORS HAVE EACH GIVEN FIRST OR LAST NAME?

//by first name:

SELECT first_name, COUNT (*) AS 'occurrences'
FROM actors
GROUP BY first_name
ORDER BY occurrences DESC
LIMIT 10;

//by last name:

SELECT last_name, COUNT (*) AS 'occurrences'
FROM actors
GROUP BY last_name
ORDER BY occurrences DESC
LIMIT 10;

//by first AND last names:

??????

//-----

//LIST THE TOP 100 MOST ACTIVE ACTORS AND THE NUMBER OF ROLES THEY HAVE STARRED IN.

//join actors & roles table

SELECT first_name, last_name, COUNT (*) AS 'role_count'
FROM actors
INNER JOIN roles ON roles.actor_id = actors.id
GROUP BY actors.id
ORDER BY role_count DESC
LIMIT 100;

//-----

//HOW MANY MOVIES DOES IMDB HAVE OF EACH GENRE, 
//ORDERED BY THE *LEAST* POPULAR GENRE?

//gonna use "movies" & movie genres table

SELECT genre, COUNT (*) AS 'num_movies_by_genres'
FROM movies_genres
INNER JOIN movies ON movies.id = movies_genres.movie_id
GROUP BY movies_genres.genre
ORDER BY num_movies_by_genres ASC;

//-----

//LIST THE FIRST AND LAST NAMES OF ALL THE ACTORS 
//WHO PLAYED IN THE 1995 MOVIE 'BRAVEHEART', 
//ARRANGED ALPHABETICALLY BY LAST NAME.

//gonna use: actors, movies, roles
//inner-joined tables
//only want first/last names where 

SELECT first_name, last_name
FROM actors
INNER JOIN roles ON roles.actor_id = actors.id
INNER JOIN movies ON movies.id = roles.movie_id
WHERE (movies.name = 'Braveheart' AND movies.year = '1995')
ORDER BY last_name ASC;

//-----

//LIST ALL DIRECTORS WHO DIRECTED A 'Film-Noir'-GENRE MOVIE
//IN A LEAP YEAR (all years divisible by 4, well say);
//RETURN DIRECTOR NAME, MOVIE NAME, & YEAR, SORTED BY MOVIE NAME

//gotta join directors(chk), movies(chk), movies_directors(chk), 
// directors_genres(chk), & movies_genres(chk)


SELECT directors.first_name, directors.last_name, movies.name, movies.year 
FROM directors
INNER JOIN movies_directors ON movies_directors.director_id = directors.id
INNER JOIN movies ON movies.id = movies_directors.movie_id
INNER JOIN movies_genres ON movies_genres.movie_id = movies.id
WHERE movies_genres.genre = 'Film-Noir' AND movies.year % 4 = 0
#GROUP BY directors.id (this is truer to the directions, but the solution shows ALL movies, even if the same director directed two){otto preminger problem}
ORDER BY movies.name ASC
LIMIT 20;

//-----

//LIST ALL ACTORS WHO HAVE WORKED WITH KEVIN BACON IN DRAMA MOVIES (INCLUDE THE MOVIE NAME). 
//EXCLUDE KEVIN BACON HIMSELF

//start by finding movies kevin bacon has acted in 
//then, filter those movies for just genre='Drama'
//then, find all actors in all of those movies


[[[[[//first, get kevin bacons id
-- SELECT *
-- FROM actors
-- WHERE (first_name = 'Kevin' AND last_name = 'Bacon')
-- LIMIT 10;

-- Kevin Bacons ID is 22591! (actors.id)]]]]]]

//then, connect roles; get all movie IDs which are connected to kevin bacons actor id

-- SELECT movies.id, movies.name
-- FROM movies
-- INNER JOIN roles ON roles.movie_id = movies.id
-- WHERE (roles.actor_id = (22591);

//this statement both gets kevin bacons ID and THEN gets all roles hes in (using a SUBQUERY) and THEN filters for Drama (using a SUBQUERY)

SELECT movies.id, movies.name
FROM movies
INNER JOIN roles ON roles.movie_id = movies.id
WHERE (roles.actor_id = 
            (SELECT id FROM actors WHERE (actors.first_name = 'Kevin' AND actors.last_name = 'Bacon'))
        AND movies.id IN (SELECT movie_id FROM movies_genres WHERE (movies_genres.genre = 'Drama')));

//OK NOW BIG KAHUNA TO GET THE ACTORS THO. lets put our other statement into the FROM()

SELECT movies.name, actors.first_name, actors.last_name
FROM (SELECT *
            FROM movies
            INNER JOIN roles ON roles.movie_id = movies.id
            WHERE (roles.actor_id = 
                    (SELECT id FROM actors WHERE (actors.first_name = 'Kevin' AND actors.last_name = 'Bacon'))
                AND movies.id IN 
                    (SELECT movie_id FROM movies_genres WHERE (movies_genres.genre = 'Drama'))) 
AND SELECT *
            FROM actors
            WHERE (movies.id))
LIMIT 20;

ORDER BY actors.last_name ASC





