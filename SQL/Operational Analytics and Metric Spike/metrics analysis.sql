#USE JOBDATA ANALYSIS DATASET
USE Job_Data_Analysis;

#OVERVIEW OF THE DATASET
SELECT 
    *
FROM
    job_data;

#JOBS REVIEWED PER HOUR PER DAY
SELECT 
    ds AS day_of_week,
    ROUND(COUNT(job_id) / SUM(time_spent) * 3600,
            1) AS jobs_reviewed_perhr_perdy
FROM
    job_data
WHERE
    ds <= '11/30/2020' AND ds >= '11/1/2020'
GROUP BY ds
ORDER BY jobs_reviewed_perhr_perdy;

#THROUGHPUT ROLLING AVERAGE
WITH CTE AS ( 
 SELECT ds, COUNT(job_id) AS num_jobs, SUM(time_spent) AS total_time_spent
 FROM job_data
 GROUP BY ds) 
 SELECT ds, 
 SUM(num_jobs) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW)
 / SUM(total_time_spent) OVER (ORDER BY ds ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_7day
 FROM CTE;

#LANGUAGE SHARE ANALYSIS
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

#DUPLICATE JOB DETECTION
SELECT 
    ds, job_id, actor_id, COUNT(*) AS dup_count
FROM
    job_data
GROUP BY ds , job_id , actor_id
HAVING COUNT(*) > 1;
