use ipl;


-- 1. Whats in the data?

-- i have used 1 table of matches and 2 tables of deliveries as the data was too large so i break the data of deliveries in 2 parts.

SELECT *
	FROM matches;
    
SELECT *
	FROM deliveries;

select * from deliveries2;

-- creating view for our data     
CREATE OR REPLACE VIEW  v_deliveries AS
SELECT * FROM deliveries
UNION ALL SELECT * 
FROM deliveries2;


-- 2. Match Analysis
--  Matches per season

SELECT season, COUNT(season) as matches_per_season
FROM matches
GROUP BY season;

-- Most player of the match awards

SELECT player_of_match as Name_of_person, count(player_of_match) as no_of_awards
FROM matches
GROUP BY player_of_match
ORDER BY no_of_awards DESC
LIMIT 15;

-- Most utilized Venues -- TOP 5

SELECT venue, COUNT(venue) as matches_per_venue
FROM matches
GROUP BY venue
ORDER BY matches_per_venue DESC
LIMIT 5;

-- Most wins by Team

SELECT winner as Team, COUNT(winner) as no_of_wins
FROM matches
GROUP BY winner
ORDER BY no_of_wins DESC;

-- 3. Runs Analysis 

-- Most runs by batsman in IPL

SELECT a.batsman as Name_of_player, sum(a.batsman_runs) as total_run
FROM (
SELECT batsman, batsman_runs 
from deliveries 
UNION ALL
SELECT batsman, batsman_runs
FROM deliveries2) AS a
GROUP BY batsman
ORDER BY total_run DESC;

--     OR   --

SELECT batsman as Name_of_player, sum(batsman_runs) as total_run
FROM v_deliveries
GROUP BY batsman
ORDER BY total_run DESC;


-- Most sixes by batsman in IPL

SELECT a.batsman as Name_of_player, COUNT(a.batsman_runs) as No_of_sixes
FROM(SELECT batsman, batsman_runs
FROM deliveries
WHERE batsman_runs = 6
UNION ALL 
SELECT batsman, batsman_runs
FROM deliveries2
WHERE batsman_runs = 6) AS a
GROUP BY batsman
ORDER BY No_of_sixes DESC;


-- OR--

SELECT batsman as Name_of_player, COUNT(batsman_runs) as No_of_sixes
FROM v_deliveries
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY no_of_sixes DESC;

-- Most FOUR by batsman in IPL

SELECT a.batsman as Name_of_player, COUNT(a.batsman_runs) as No_of_sixes
FROM(SELECT batsman, batsman_runs
FROM deliveries
WHERE batsman_runs = 4
UNION ALL 
SELECT batsman, batsman_runs
FROM deliveries2
WHERE batsman_runs = 4) AS a
GROUP BY batsman
ORDER BY No_of_sixes DESC;

-- OR --

SELECT batsman as Name_of_player, COUNT(batsman_runs) as No_of_sixes
FROM v_deliveries
WHERE batsman_runs = 4
GROUP BY batsman
ORDER BY no_of_sixes DESC;


-- 3000 runs stike rate club

SELECT a.batsman as Name_of_player, sum(a.batsman_runs) as total_run, 
round((sum(a.batsman_runs)/count(a.ball)*100),2) as strike_rate
FROM (
SELECT batsman, ball, batsman_runs
from deliveries 
UNION ALL
SELECT batsman, ball, batsman_runs 
FROM deliveries2) AS a
GROUP BY batsman
HAVING total_run >= 3000
ORDER BY strike_rate DESC;

-- OR --

SELECT batsman as Name_of_player, sum(batsman_runs) as total_run, 
round((sum(batsman_runs)/count(ball)*100),2) as strike_rate
FROM v_deliveries
GROUP BY batsman
HAVING total_run >= 3000
ORDER BY strike_rate DESC;

use ipl;
-- 1500 runs strike rate club

SELECT a.batsman as Name_of_player, sum(a.batsman_runs) as total_run, 
round((sum(a.batsman_runs)/count(a.ball)*100),2) as strike_rate
FROM (
SELECT batsman, ball, batsman_runs
from deliveries 
UNION ALL
SELECT batsman, ball, batsman_runs 
FROM deliveries2) AS a
GROUP BY batsman
HAVING total_run >= 1500
ORDER BY strike_rate DESC;

-- or --

SELECT batsman as Name_of_player, sum(batsman_runs) as total_run, 
round((sum(batsman_runs)/count(ball)*100),2) as strike_rate
FROM v_deliveries
GROUP BY batsman
HAVING total_run >= 1500
ORDER BY strike_rate DESC;

-- 4 Wicket Analysis
SELECT a.bowler, COUNT(a.dismissal_kind) AS wickets
FROM(
select bowler, dismissal_kind
FROM deliveries
where dismissal_kind IN("bowled","caught","caught and bowled","hit wicket","lbw","stumped")
UNION ALL SELECT 
bowler, dismissal_kind
FROM deliveries2
WHERE dismissal_kind IN("bowled","caught","caught and bowled","hit wicket","lbw","stumped")) AS a
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 20;


-- OR --

SELECT bowler, COUNT(dismissal_kind) AS wickets
FROM v_deliveries
WHERE dismissal_kind IN("bowled","caught","caught and bowled","hit wicket","lbw","stumped")
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 20;


-- Lowest Economy Rate for bowlers 100 overs

SELECT a.bowler, COUNT(a.ball), 
round((sum(total_runs)/count(a.ball)*6),2) as economy_rate,
dense_RANK() OVER(ORDER BY ROUND((SUM(total_runs) / COUNT(a.ball) * 6), 2)) AS Ranking
FROM(
SELECT ball, bowler, total_runs
FROM deliveries 
UNION ALL SELECT
ball, bowler, total_runs
FROM deliveries2) AS a
GROUP BY bowler
having count(a.ball) >=600
ORDER BY economy_rate;

-- OR --

SELECT bowler, COUNT(ball), 
round((sum(total_runs)/count(ball)*6),2) as economy_rate,
dense_RANK() OVER(ORDER BY ROUND((SUM(total_runs) / COUNT(ball) * 6), 2)) AS Ranking
FROM v_deliveries
GROUP BY bowler
HAVING COUNT(ball) >=600
ORDER BY economy_rate;