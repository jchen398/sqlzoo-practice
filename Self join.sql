#How many stops are in the database.
SELECT COUNT(*)
FROM stops;

#Find the id value for the stop 'Craiglockhart'
SELECT id
FROM stops
WHERE name = 'Craiglockhart';

#Give the id and the name for the stops on the '4' 'LRT' service.
SELECT DISTINCT id, name
FROM stops LEFT JOIN route ON stops.id = route.stop
WHERE route.num = 4 AND route.company = 'LRT';

#The query shown gives the number of routes that visit either London Road (149) or Craiglockhart (53). Run the query and notice the two services that link these stops have a count of 2. Add a HAVING clause to restrict the output to these two routes.
SELECT company, num, COUNT(*)
FROM route
WHERE stop = 53 OR stop = 149
GROUP BY company, num
HAVING COUNT(*) > 1;

#Execute the self join shown and observe that b.stop gives all the places you can get to from Craiglockhart, without changing routes. Change the query so that it shows the services from Craiglockhart to London Road.
SELECT a.company, a.num, a.stop, b.stop
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 53 AND b.stop = 149;

#The query shown is similar to the previous one, however by joining two copies of the stops table we can refer to stops by name rather than by number. Change the query so that the services between 'Craiglockhart' and 'London Road' are shown. 
SELECT a.company, a.num, a.name, b.name
FROM
(SELECT route.company, route.num, stops.name
FROM route JOIN stops ON route.stop = stops.id) a JOIN 
(SELECT route.company, route.num, stops.name
FROM route JOIN stops ON route.stop = stops.id) b ON (a.company = b.company AND a.num = b.num)
WHERE a.name = 'Craiglockhart' AND b.name = 'London Road';

#Give a list of all the services which connect stops 115 and 137 ('Haymarket' and 'Leith')
SELECT DISTINCT a.company, a.num
FROM route a JOIN route b ON (a.company = b.company AND a.num = b.num)
WHERE a.stop = 115 AND b.stop = 137;

#Give a list of the services which connect the stops 'Craiglockhart' and 'Tollcross'
SELECT DISTINCT a.company, a.num
FROM
(SELECT route.company, route.num, stops.name
FROM route JOIN stops ON route.stop = stops.id) a JOIN 
(SELECT route.company, route.num, stops.name
FROM route JOIN stops ON route.stop = stops.id) b ON (a.company = b.company AND a.num = b.num)
WHERE a.name = 'Craiglockhart' AND b.name = 'Tollcross';

#Give a distinct list of the stops which may be reached from 'Craiglockhart' by taking one bus, including 'Craiglockhart' itself, offered by the LRT company. Include the company and bus no. of the relevant services.
SELECT DISTINCT stops.name, route.company, route.num
FROM stops JOIN route ON stops.id = route.stop
WHERE (route.num, route.company) IN (SELECT route.num, route.company
										FROM route JOIN stops ON route.stop = stops.id
										WHERE route.company = 'LRT' AND stops.name = 'Craiglockhart');

#Find the routes involving two buses that can go from Craiglockhart to Lochend.
#Show the bus no. and company for the first bus, the name of the stop for the transfer,
#and the bus no. and company for the second bus.
SELECT a.num, a.company, s2.name, d.num, d.company
FROM route a JOIN route b ON (a.company=b.company AND a.num=b.num)
			 JOIN (route c JOIN route d ON (c.company=d.company AND c.num=d.num))
			 JOIN stops s1 ON (a.stop = s1.id)
			 JOIN stops s2 ON (b.stop = s2.id)
			 JOIN stops s3 ON (c.stop = s3.id)
			 JOIN stops s4 ON (d.stop = s4.id)
WHERE s1.name = 'Craiglockhart' AND s4.name = 'Lochend' AND s2.name = s3.name


