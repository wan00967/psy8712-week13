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

# Data Import and Cleaning

employees_tbl <- dbGetQuery(con, "SELECT * FROM datascience_employees;") %>%
  as_tibble()
write_csv(employees_tbl, "../data/employees.csv")

testscores_tbl<- dbGetQuery(con, "SELECT * FROM datascience_testscores;") %>%
  as_tibble()
write_csv(testscores_tbl, "../data/testscores.csv")

offices_tbl <- dbGetQuery(con, "SELECT * FROM datascience_offices;") %>%
  as_tibble()
write_csv(offices_tbl, "../data/offices.csv")

week13_tbl <- employees_tbl %>%
  inner_join(testscores_tbl, by = "employee_id") %>%
  inner_join(offices_tbl, by = c("city" = "office")) %>%
  filter(!is.na(test_score))
write_csv(week13_tbl, "../out/week13.csv")

# Analysis
## 1
week13_tbl %>% 
  nrow()

## 2
week13_tbl %>% select(employee_id) %>%
  unique() %>% 
  nrow()

## 3
week13_tbl %>% filter(manager_hire == "N") %>% 
  group_by(city) %>%
  summarize(num_manager = n())

## 4
week13_tbl %>% group_by(performance_group) %>% 
  summarize(avg_yr_employment = mean(yrs_employed),
            sd_yr_employment = sd(yrs_employed))

## 5
week13_tbl %>%
  arrange(type, desc(test_score)) %>%
  select(type, employee_id, test_score) 

