# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(RMariaDB)
library(keyring)

con <- dbConnect(MariaDB(), 
                 host = "mysql-prod5.oit.umn.edu", 
                 username = "wan00967", 
                 password = key_get("latis-mysql","wan00967"), 
                 port = 3306,
                 ssl.ca = '../mysql_hotel_umn_20220728_interm.cer')

dbExecute(con, "USE cla_tntlab")

# Analysis
## 1
dbGetQuery(con,
           "SELECT COUNT(*) AS total_manager
          FROM datascience_employees;")

## 2
dbGetQuery(con,
           "SELECT COUNT(DISTINCT(employee_id)) AS unique_manager_num
           FROM datascience_employees;")

## 3
dbGetQuery(con,
           "SELECT city, COUNT(employee_id) AS num_manager
           FROM datascience_employees
           WHERE manager_hire = 'N'
           GROUP BY city;")

## 4
dbGetQuery(con, 
           "SELECT performance_group, AVG(yrs_employed) AS avg_yr_employment, STD(yrs_employed) AS sd_yr_employment
           FROM datascience_employees
           GROUP BY performance_group;")

## 5
dbGetQuery(con,
           "SELECT o.type, e.employee_id AS ID, t.test_score
            FROM datascience_employees e
            INNER JOIN datascience_testscores t ON e.employee_id = t.employee_id
            INNER JOIN datascience_offices o ON e.city = o.office
            WHERE t.test_score IS NOT NULL
            ORDER BY o.type, test_score DESC;")

