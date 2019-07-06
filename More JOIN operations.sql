#List the films where the yr is 1962 [Show id, title]
SELECT id, title
FROM movie
WHERE yr = 1962;

#Give year of 'Citizen Kane'.
SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

#List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
SELECT id, title, yr
FROM movie
WHERE title LIKE '%Star Trek%'
ORDER BY yr;

#What id number does the actor 'Glenn Close' have?
SELECT id 
FROM actor
WHERE name = 'Glenn Close';

#What is the id of the film 'Casablanca'
SELECT id
FROM movie
WHERE title = 'Casablanca';

#Obtain the cast list for 'Casablanca'.The cast list is the names of the actors who were in the movie.Use movieid=11768
SELECT name
FROM actor LEFT JOIN casting ON actor.id = casting.actorid
WHERE casting.movieid = '11768';

#Obtain the cast list for the film 'Alien'
SELECT name
FROM actor LEFT JOIN casting ON actor.id = casting.actorid
WHERE casting.movieid = (SELECT id FROM movie WHERE title = 'Alien');

#List the films in which 'Harrison Ford' has appeared
SELECT title FROM movie WHERE id IN 
	(SELECT movieid
		FROM casting LEFT JOIN actor ON casting.actorid = actor.id
		WHERE actor.name = 'Harrison Ford');
        
#List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
SELECT 
    title
FROM
    movie
WHERE
    id IN (SELECT 
            movieid
        FROM
            casting
                LEFT JOIN
            actor ON casting.actorid = actor.id
        WHERE
            actor.name = 'Harrison Ford'
                AND casting.ord <> 1);

#List the films together with the leading star for all 1962 films.
SELECT movie.title, actor.name
FROM movie 
LEFT JOIN casting ON movie.id = casting.movieid
LEFT JOIN actor ON casting.actorid = actor.id
WHERE movie.yr = 1962 AND casting.ord = 1;

#Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies
SELECT yr, COUNT(title) AS CNT
FROM movie
WHERE id IN 
	(SELECT movieid
		FROM casting JOIN actor ON casting.actorid = actor.id
		WHERE actor.name = 'John Travolta')
GROUP BY yr
HAVING COUNT(title) > 2
LIMIT 1;

#List the film title and the leading actor for all of the films 'Julie Andrews' played in.
SELECT DISTINCT t1.title, actor.name
FROM 
(SELECT movie.id, movie.title 
	FROM movie JOIN casting ON movie.id = casting.movieid
				JOIN actor ON actor.id = casting.actorid
	WHERE actor.name = 'Julie Andrews') t1
JOIN casting ON t1.id = casting.movieid
JOIN actor ON actor.id = casting.actorid
WHERE casting.ord = 1;

#Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
SELECT DISTINCT name
FROM actor JOIN casting ON actor.id = casting.actorid
WHERE actor.id IN 
	(SELECT actorid
		FROM casting 
		WHERE ord = 1
		GROUP BY actorid
		HAVING SUM(ord) >= 30)
ORDER BY name ASC;

#List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
SELECT movie.title, t1.CNT
FROM movie JOIN (SELECT movieid, COUNT(actorid) AS CNT
						FROM casting
						GROUP BY movieid) t1 
			ON movie.id = t1.movieid
WHERE movie.yr = 1978 
ORDER BY t1.CNT DESC, movie.title;

#List all the people who have worked with 'Art Garfunkel'.
SELECT DISTINCT actor.name 
FROM actor JOIN casting ON casting.actorid = actor.id
WHERE movieid IN  
(SELECT movieid
	FROM casting JOIN actor ON casting.actorid = actor.id 
	WHERE actor.name = 'Art Garfunkel') 
AND actor.name <> 'Art Garfunkel';