use sqldata1;
-- Importing large data more than lakhs of rows

-- 1. Create the table athletes
create table athletes(
	Id int,
    Name varchar(200),
    Sex char(1),
    Age int,
    Height float,
    Weight float,
    Team varchar(200),
    NOC char(3),
    Games varchar(200),
    Year int,
    Season varchar(200),
    City varchar(200),
    Sport varchar(200),
    Event varchar(200),
    Medal Varchar(50));
    
    -- View the blank Athletes table
select * from athletes;

-- Location to add the csv
SHOW VARIABLES LIKE "secure_file_priv";

-- Load the data from csv file after saving to above location
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Athletes_Cleaned.csv'
into table athletes
fields terminated by ','
enclosed by '"'
lines terminated by '\r\n'
ignore 1 rows;

-- View the table
select * from athletes;

-- Check number of rows in the table

select count(*) from athletes;


-- Q1. Show how many medal counts present for entire data.
select medal, count(*) as total_medal_count
from athletes
group by medal
order by total_medal_count desc;

-- Q2. Show count of unique Sports are present in olympics.
select count(distinct sport) as count_of_unique_sport
from athletes;

-- Q3. Show how many different medals won by Team India in data.
select team, medal ,count(medal) as total_medal
from athletes
where team ='india'
and medal<> 'nomedal'
group by team, medal
order by total_medal desc;


-- Q4. Show event wise medals won by india show from highest to lowest medals won in order.
select team, event,medal, count(*) as Total_medal
from athletes
where team ='india'
and medal<> 'nomedal'
group by team,event, medal
order by total_medal desc;

-- Q5. Show event and yearwise medals won by india in order of year.
select year,event,medal, count(*) as Total_medal
from athletes
where team ='india'
and medal<> 'nomedal'
group by event, year, medal
order by year desc;


-- Q6. Show the country with maximum medals won gold, silver, bronze
SELECT noc,
    SUM(CASE WHEN medal = 'gold' THEN 1 ELSE 0 END +
       CASE WHEN medal = 'silver' THEN 1 ELSE 0 END +
        CASE WHEN medal = 'bronze' THEN 1 ELSE 0 END) AS Total_medal
FROM athletes
 where medal<>'nomedal'
GROUP BY noc 
order by Total_medal desc;
-- or another method ans
SELECT noc, 
	count(case when medal= "gold" then "gold" end )as Gold_medal,
    count(case when medal= "silver" then "silver" end )as silver_medal,
    count(case when medal= "bronze" then "bronze" end )as bronze_medal
FROM   athletes
group by noc
order by Gold_medal desc, silver_medal desc, bronze_medal desc
limit 10;

-- Q7. Show the top 10 countries with respect to gold medals
SELECT noc,
    count(case when medal= "gold" then "gold" end )as Gold_medal
FROM athletes
group by noc
ORDER BY Gold_medal desc
LIMIT 10;


-- Q8. Show in which year did United States won most medals
SELECT
    team,
    year,
    SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS GoldCount,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS SilverCount,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeCount,
    SUM(CASE WHEN medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS TotalMedals
FROM athletes
WHERE team = 'United States'
GROUP BY team, year
ORDER BY TotalMedals DESC 
limit 1;

-- Q9. In which sports United States has most medals
SELECT sport, COUNT(medal) AS most_medals
FROM athletes
WHERE medal='nomedal' and team = 'United States'
GROUP BY sport
ORDER BY most_medals DESC;

-- Q10. Find top 3 players who have won most medals along with their sports and country.
SELECT name,sport,noc, COUNT(medal) AS most_medals
FROM athletes
WHERE medal='nomedal' 
GROUP BY sport,name,noc
ORDER BY most_medals DESC
limit 3;

-- Q11. Find player with most gold medals in cycling along with his country.
SELECT Name,sport,NOC, COUNT(*) AS gold_medals
FROM athletes
WHERE sport = 'Cycling' AND medal = 'Gold'
GROUP BY Name, NOC,sport
ORDER BY gold_medals DESC
limit 10;

-- Q12. Find player with most medals (Gold + Silver + Bronze) in Basketball also show his country
SELECT name,noc,
    SUM(CASE WHEN medal = 'gold' THEN 1 ELSE 0 END +
       CASE WHEN medal = 'silver' THEN 1 ELSE 0 END +
        CASE WHEN medal = 'bronze' THEN 1 ELSE 0 END) AS Total_medals
FROM athletes
 where medal<>'nomedal' and sport = 'Basketball'
GROUP BY name, noc
order by Total_medals desc;

-- Q13. Find out the count of different medals of the top basketball player.
SELECT name,
     SUM(CASE WHEN medal = 'Gold' THEN 1 ELSE 0 END) AS GoldCount,
    SUM(CASE WHEN medal = 'Silver' THEN 1 ELSE 0 END) AS SilverCount,
    SUM(CASE WHEN medal = 'Bronze' THEN 1 ELSE 0 END) AS BronzeCount,
    SUM(CASE WHEN medal IN ('Gold', 'Silver', 'Bronze') THEN 1 ELSE 0 END) AS Most_medals
FROM athletes
 where  sport = 'Basketball'
GROUP BY name 
order by Most_medals desc
limit 5;


-- Q14. Find out medals won by male, female each year.
SELECT sex,year, count(medal) as Madel_won_each_year
FROM athletes
 GROUP BY sex,year 
order by Madel_won_each_year desc;