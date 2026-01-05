# ==============================================================================
# Tunisia Schools Success Rate Analysis - Data Loading and Preprocessing
# ==============================================================================

# Load required libraries
library(readxl)
library(tidyverse)
library(dplyr)
library(ggplot2)

# ==============================================================================
# Governorate Mapping based on school code prefix
# ==============================================================================
# Tunisia has 24 governorates, each with a specific code prefix

governorate_mapping <- tibble(
  code_prefix = c(11, 12, 13, 14, 21, 22, 23, 31, 32, 33, 41, 42, 43, 
                  51, 52, 53, 61, 71, 72, 81, 82, 83, 84, 91),
  governorate = c(
    "Tunis",           # 11
    "Ariana",          # 12
    "Ben Arous",       # 13
    "Manouba",         # 14
    "Nabeul",          # 21
    "Zaghouan",        # 22
    "Bizerte",         # 23
    "Beja",            # 31
    "Jendouba",        # 32
    "Le Kef",          # 33
    "Siliana",         # 41
    "Sousse",          # 42
    "Monastir",        # 43
    "Mahdia",          # 51
    "Sfax",            # 52
    "Kairouan",        # 53
    "Kasserine",       # 61
    "Sidi Bouzid",     # 71
    "Gabes",           # 72
    "Medenine",        # 81
    "Tataouine",       # 82
    "Gafsa",           # 83
    "Tozeur",          # 84
    "Kebili"           # 91
  ),
  governorate_ar = c(
    "تونس",
    "أريانة",
    "بن عروس",
    "منوبة",
    "نابل",
    "زغوان",
    "بنزرت",
    "باجة",
    "جندوبة",
    "الكاف",
    "سليانة",
    "سوسة",
    "المنستير",
    "المهدية",
    "صفاقس",
    "القيروان",
    "القصرين",
    "سيدي بوزيد",
    "قابس",
    "مدنين",
    "تطاوين",
    "قفصة",
    "توزر",
    "قبلي"
  )
)

# ==============================================================================
# Function to extract governorate code from school code
# ==============================================================================
get_governorate_code <- function(school_code) {
  # Extract first 2 digits of the school code
  as.integer(substr(as.character(school_code), 1, 2))
}

# ==============================================================================
# Load and preprocess the data
# ==============================================================================
load_school_data <- function(file_path = "data/liste_reussite_eleves.xls") {
  # Read the Excel file
  df <- read_excel(file_path)
  
  # Rename columns to English for easier manipulation
  df <- df %>%
    rename(
      school_code = codeetab,
      school_name = libeetabar,
      level_code = codeniveau,
      level_name = libeniveau,
      nb_students = nombre_eleve,
      nb_passed = nombre_reussite
    )
  
  # Add governorate code column
  df <- df %>%
    mutate(
      governorate_code = get_governorate_code(school_code)
    )
  
  # Join with governorate mapping
  df <- df %>%
    left_join(governorate_mapping, by = c("governorate_code" = "code_prefix"))
  
  # Calculate success percentage
  df <- df %>%
    mutate(
      success_rate = round((nb_passed / nb_students) * 100, 2),
      nb_failed = nb_students - nb_passed
    )
  
  # Order by school name
  df <- df %>%
    arrange(school_name)
  
  return(df)
}

# ==============================================================================
# Summary statistics by governorate
# ==============================================================================
summary_by_governorate <- function(df) {
  df %>%
    group_by(governorate, governorate_ar) %>%
    summarise(
      total_students = sum(nb_students, na.rm = TRUE),
      total_passed = sum(nb_passed, na.rm = TRUE),
      total_failed = sum(nb_failed, na.rm = TRUE),
      avg_success_rate = round(mean(success_rate, na.rm = TRUE), 2),
      nb_schools = n_distinct(school_code),
      .groups = "drop"
    ) %>%
    mutate(
      overall_success_rate = round((total_passed / total_students) * 100, 2)
    ) %>%
    arrange(desc(overall_success_rate))
}

# ==============================================================================
# Summary statistics by level
# ==============================================================================
summary_by_level <- function(df) {
  df %>%
    group_by(level_code, level_name) %>%
    summarise(
      total_students = sum(nb_students, na.rm = TRUE),
      total_passed = sum(nb_passed, na.rm = TRUE),
      total_failed = sum(nb_failed, na.rm = TRUE),
      avg_success_rate = round(mean(success_rate, na.rm = TRUE), 2),
      .groups = "drop"
    ) %>%
    mutate(
      overall_success_rate = round((total_passed / total_students) * 100, 2)
    ) %>%
    arrange(desc(overall_success_rate))
}

# ==============================================================================
# Top performing schools
# ==============================================================================
top_schools <- function(df, n = 10) {
  df %>%
    filter(nb_students >= 30) %>%  # Only schools with at least 30 students
    arrange(desc(success_rate)) %>%
    head(n) %>%
    select(school_name, governorate, level_name, nb_students, nb_passed, success_rate)
}

# ==============================================================================
# Bottom performing schools
# ==============================================================================
bottom_schools <- function(df, n = 10) {
  df %>%
    filter(nb_students >= 30) %>%  # Only schools with at least 30 students
    arrange(success_rate) %>%
    head(n) %>%
    select(school_name, governorate, level_name, nb_students, nb_passed, success_rate)
}

# ==============================================================================
# Load data when script is sourced
# ==============================================================================
cat("Loading Tunisia school success data...\n")
school_data <- load_school_data()
cat(paste("Loaded", nrow(school_data), "records from", n_distinct(school_data$school_code), "schools\n"))
cat(paste("Covering", n_distinct(school_data$governorate), "governorates\n"))
