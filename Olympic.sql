SELECT * FROM Olympic_analysis

-- 1 . Top Five Athletes who have won the most medals
  SELECT TOP 10 Athlete,Country, COUNT(Medal) AS medal_cnt
  FROM Olympic_analysis
  GROUP BY Athlete,Country
  ORDER BY 3 DESC


--2. Which country the most Gold medals
SELECT Country,Medal,COUNT(Medal) Cnt_of_gold
FROM  Olympic_analysis
WHERE Medal= 'Gold'
GROUP BY Country,Medal
ORDER BY Cnt_of_gold DESC,Country

--3. Which country the most Silver medals
SELECT Country,Medal,COUNT(Medal) Cnt_of_silver
FROM  Olympic_analysis
WHERE Medal= 'Silver'
GROUP BY Country,Medal
ORDER BY Cnt_of_silver DESC,Country

--4. Which country the most bronze medals
SELECT Country,Medal,COUNT(Medal) Cnt_of_bronze
FROM  Olympic_analysis
WHERE Medal= 'Bronze'
GROUP BY Country,Medal
ORDER BY Cnt_of_bronze DESC,Country

--5. List down total gold,silver,bronze medals won by each country

WITH cnt_of_gold AS(
					SELECT Country,COUNT(Medal) Cnt_of_gold
					FROM  Olympic_analysis
					WHERE Medal= 'Gold'
					GROUP BY Country
					--ORDER BY Cnt_of_gold DESC,Country
					),

	cnt_of_silver AS(
					SELECT Country,COUNT(Medal) Cnt_of_silver
					FROM  Olympic_analysis
					WHERE Medal= 'Silver'
					GROUP BY Country
					--ORDER BY Cnt_of_silver DESC,Country
					),
	cnt_of_bronze AS(
					SELECT Country,COUNT(Medal) Cnt_of_bronze
					FROM  Olympic_analysis
					WHERE Medal= 'Bronze'
					GROUP BY Country
					--ORDER BY Cnt_of_bronze DESC,Country
					)
SELECT a.Country,a.cnt_of_gold,b.cnt_of_silver,c.cnt_of_bronze
FROM cnt_of_gold AS a
INNER JOIN cnt_of_silver AS b
ON a.Country = b.Country 
INNER JOIN cnt_of_bronze AS c
ON a.Country = c.Country 
ORDER BY  2 DESC

--6. Total number of Sports played in each olympics game
SELECT Year, COUNT(DISTINCT Sport) AS No_of_sports
FROM Olympic_analysis
GROUP BY Year

--7 All Olympic games held so far

SELECT COUNT(DISTINCT Year) FROM Olympic_analysis

--8 Total number of NATIONS that participated in each olympic game 
 SELECT DISTINCT Year,City, COUNT(DISTINCT Country) AS No_of_Countries
 FROM Olympic_analysis
 GROUP BY Year, City

 --9 sport in which india has most medals

 SELECT Sport, Event, COUNT(Medal) AS no_of_medals FROM Olympic_analysis
 WHERE Country = 'India'
 GROUP BY Sport,Event

 --10 Break down all olympic games where India won Medal for hockey and how many medals in each olympic games
 SELECT DISTINCT Year,City, COUNT(medal) AS N0_of_medals
 FROM Olympic_analysis
 WHERE Country= 'India' AND Sport = 'Hockey' AND Event='hockey'
 GROUP BY Year,City


 -- 11 Which countries have never won gold medal but have won Silver or Bronze medals

 WITH cte_gold AS ( SELECT DISTINCT Country FROM Olympic_analysis EXCEPT
					    SELECT Country FROM Olympic_analysis WHERE Medal='Gold'
						GROUP BY Country HAVING COUNT(Medal) > 0),

	cte_silver AS( SELECT Country, COUNT(Medal) AS silver_cnt FROM Olympic_analysis
					WHERE Medal= 'Silver'
					GROUP BY Country),

    cte_bronze AS ( SELECT Country, COUNT(Medal) AS bronze_cnt
					FROM Olympic_analysis
					WHERE Medal='Bronze'
					GROUP BY Country)
SELECT a.Country, 0 AS gold_cnt,b.silver_cnt,c.bronze_cnt
FROM cte_gold AS a
LEFT JOIN cte_silver AS b
ON a.Country = b.Country
LEFT JOIN cte_bronze AS c
ON a.Country = c.Country
WHERE b.silver_cnt >= 1
OR c.bronze_cnt >=1

--12 Which Year saw the highest and lowest no of countries participating in in Olympics
WITH Lower_participant AS(
				SELECT TOP 1 Year,COUNT(DISTINCT Country) AS No_of_country
				FROM Olympic_analysis
				GROUP BY Year
				ORDER BY No_of_country ASC),

	High_participant AS	(SELECT TOP 1 Year,COUNT(DISTINCT Country) AS No_of_country
				FROM Olympic_analysis
				GROUP BY Year
				ORDER BY No_of_country DESC)

SELECT Lower_participant.Year AS year_with_low_part,	High_participant.Year AS year_with_high_part
FROM Lower_participant,High_participant


