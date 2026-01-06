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
# Tunisia has 24 governorates - mapping based on actual school data analysis

governorate_mapping <- tibble(
  code_prefix = c(10, 11, 12, 13, 14, 15, 21, 31, 32, 41, 42, 43, 
                  51, 52, 53, 61, 62, 63, 64, 71, 72, 81, 82, 83, 84, 91),
  governorate = c(
    "Tunis",           # 10 - Carthage area
    "Tunis",           # 11 - El Menzah area
    "Ariana",          # 12 - Soukra area
    "Ben Arous",       # 13 - Mornag area
    "Zaghouan",        # 14 - El Fahs area
    "Manouba",         # 15 - Oued Ellil area
    "Bizerte",         # 21 - Menzel Bourguiba
    "Beja",            # 31 - Beja city
    "Jendouba",        # 32 - Ain Draham
    "Le Kef",          # 41 - Le Sers
    "Siliana",         # 42 - Siliana city
    "Kasserine",       # 43 - Kasserine area
    "Mahdia",          # 51 - Mahdia area
    "Gafsa",           # 52 - Redeyef area
    "Sidi Bouzid",     # 53 - Sidi Bouzid area
    "Kebili",          # 61 - Jemna area
    "Tataouine",       # 62 - Tataouine city
    "Medenine",        # 63 - Boughrara area
    "Gabes",           # 64 - Gabes area
    "Sfax",            # 71 - Sakiet Ezzit
    "Sfax",            # 72 - Sfax suburbs
    "Kairouan",        # 81 - Oueslati area
    "Monastir",        # 82 - Cherben area
    "Monastir",        # 83 - Moknine area
    "Sousse",          # 84 - Enfidha area
    "Nabeul"           # 91 - Bou Argoub area
  ),
  governorate_ar = c(
    "تونس",
    "تونس",
    "أريانة",
    "بن عروس",
    "زغوان",
    "منوبة",
    "بنزرت",
    "باجة",
    "جندوبة",
    "الكاف",
    "سليانة",
    "القصرين",
    "المهدية",
    "قفصة",
    "سيدي بوزيد",
    "قبلي",
    "تطاوين",
    "مدنين",
    "قابس",
    "صفاقس",
    "صفاقس",
    "القيروان",
    "المنستير",
    "المنستير",
    "سوسة",
    "نابل"
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
