
-- 1. What range of years for baseball games played does the provided database cover? 
SELECT MIN(year),Max(Year)
from homegames;

-- Answer: 1871 to 2016

/*
2.b How many games did shortest player play in? ANSWER: One game
2.c. What team did shortest player play for?  ANSWER: ST. Louis Browns
*/
SELECT height,namefirst,namelast
from people
WHERE height=(select MIN(height)
			  FROM people
			  );
			  
-- Or
SELECT namefirst, namegiven, namelast, height as Height_Measurment
	FROM people 
	ORDER BY height
	LIMIT 1;
SELECT people.playerid, namefirst, namegiven, namelast, g_all as games, height as height_inches, teams.name
	FROM people INNER JOIN appearances ON people.playerid = appearances.playerid
		INNER JOIN teams ON teams.teamid = appearances.teamid
	WHERE people.playerid = 'gaedeed01'
	LIMIT 1;
	
	--test
	select *
	FROM APPEARANCES
/*
Query 3: 
a. Find all players in the database who played at Vanderbilt University  
ANSWER: List of 15 players.
b. Create a list showing each player’s first and last names as well as the total salary they earned in the major leagues. 
Sort this list in descending order by the total salary earned. 
d. Which Vanderbilt player earned the most money in the majors?  
ANSWER: David Price, earned $245,533,888
*/	
SELECT p.playerid, schoolname, namefirst, namelast, SUM(salary)::numeric::money as total_salary
FROM schools AS s 
		JOIN collegeplaying AS cp USING(schoolid)  --LEFT and INNER JOIN also work for all joins.
		JOIN people AS p ON p.playerid = cp.playerid
		JOIN salaries as sal ON sal.playerid = p.playerid
	WHERE schoolname like '%Vanderbilt%'
--		AND salary IS NOT NULL
GROUP BY p.playerid, schoolname, namefirst, namelast, namegiven
ORDER BY total_salary DESC;
/* 	QUESTION #4: Using the fielding table, group players into three groups based on their position: 
label players with position OF as "Outfield", 
those with position "SS", "1B", "2B", and "3B" as "Infield", and those with position "P" or "C" as "Battery". 
Determine the number of putouts made by each of these three groups in 2016.
*/
--DOESN'T WORK
WITH putouts_2016 AS (SELECT pos, 
					  po, 
	 					CASE WHEN pos = 'OF' THEN 'Outfield'
	 						 WHEN pos = 'P'OR pos = 'C' THEN 'Battery'
	 						 WHEN pos in ('SS', '1B', '2B', '3B') THEN 'Infield' END AS position_group
					FROM fielding
					WHERE yearid = 2016
					GROUP BY pos, po, position_group
					ORDER BY position_group)
SELECT sum(po),position_group
FROM putouts_2016
GROUP BY position_group;

--FROM MARY -- this is correct
select sum(f.po) as total_putouts,
	(case when f.pos = 'OF' then 'outfield'
			when f.pos in ('SS', '1B', '2B', '3B') then 'Infield'
	 		when pos = 'P' or pos = 'C' THEN 'Battery'
			 end) as position
from fielding f
where yearid = 2016
group by position;
	 