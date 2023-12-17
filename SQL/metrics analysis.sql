CREATE DATABASE Job_Data_Analysis;
USE Job_Data_Analysis;
select * from job_data;
#Jobs reviewed per hour
SELECT 
    ds AS day_of_week, Round(COUNT(job_id) /sum(time_spent)*3600, 1) AS jobs_reviewed_perhr_perdy
FROM
    job_data
    WHERE ds <= '11/30/2020' AND ds >= '11/1/2020'
GROUP BY ds
ORDER BY jobs_reviewed_perhr_perdy;

#throughput rolling average.
WITH CTE AS ( 
 SELECT ds, COUNT(job_id) AS num_jobs, SUM(time_spent) AS total_time_spent
 FROM job_data
 GROUP BY ds) 
 SELECT ds, 
 SUM(num_jobs) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
 / SUM(total_time_spent) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_7day
 FROM CTE;
 
 #language share analysis
SELECT 
    language,
    COUNT(language) AS lang_count,
    ROUND((COUNT(language) * 100 / (SELECT 
                    COUNT(language)
                FROM
                    job_data)),
            2) AS Percentage_language
FROM
    job_data
WHERE
    ds <= '11/30/2020' AND ds >= '11/1/2020'
GROUP BY language;

# Duplicate detection in a table.
SELECT 
    ds, job_id, actor_id, COUNT(*) AS dup_count
FROM
    job_data
GROUP BY ds , job_id , actor_id
HAVING COUNT(*) > 1;

 
 

 


