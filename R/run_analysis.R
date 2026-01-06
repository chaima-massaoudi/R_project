# ==============================================================================
# Run All Analysis - Generate outputs for Quarto
# ==============================================================================

.libPaths(Sys.getenv("R_LIBS_USER"))
library(tidyverse)
library(readxl)
library(ggplot2)
library(scales)

# Create output directories
dir.create("img", showWarnings = FALSE)
dir.create("data/results", showWarnings = FALSE, recursive = TRUE)

cat("✅ Libraries loaded\n")

# ==============================================================================
# STEP 1: Governorate Mapping
# ==============================================================================
governorate_mapping <- tibble(
  code_prefix = c("10", "11", "12", "13", "14", "15", "16", "17", "18", "19",
                  "21", "22", "23", "31", "32", "41", "42", "51", "52", "61",
                  "62", "71", "72", "81", "82", "83", "91"),
  governorate = c("Tunis", "Tunis", "Ariana", "Ben Arous", "Manouba", "Nabeul", 
                  "Zaghouan", "Bizerte", "Beja", "Jendouba", "Le Kef", "Siliana",
                  "Sousse", "Monastir", "Mahdia", "Sfax", "Sfax", "Kairouan", 
                  "Gafsa", "Kasserine", "Tataouine", "Gabes", "Medenine", 
                  "Tozeur", "Kebili", "Sidi Bouzid", "Nabeul"),
  governorate_ar = c("تونس", "تونس", "أريانة", "بن عروس", "منوبة", "نابل",
                     "زغوان", "بنزرت", "باجة", "جندوبة", "الكاف", "سليانة",
                     "سوسة", "المنستير", "المهدية", "صفاقس", "صفاقس", "القيروان",
                     "قفصة", "القصرين", "تطاوين", "قابس", "مدنين",
                     "توزر", "قبلي", "سيدي بوزيد", "نابل")
)

# ==============================================================================
# STEP 2: Load School Data
# ==============================================================================
school_data <- read_excel("data/liste_reussite_eleves.xls") %>%
  rename(
    school_code = codeetab,
    school_name = libeetabar,
    level_code = codeniveau,
    level_name = libeniveau,
    nb_students = nombre_eleve,
    nb_passed = nombre_reussite
  ) %>%
  mutate(
    nb_failed = nb_students - nb_passed,
    success_rate = round(nb_passed / nb_students * 100, 2),
    code_prefix = str_sub(as.character(school_code), 1, 2)
  ) %>%
  left_join(governorate_mapping, by = "code_prefix") %>%
  arrange(school_name)

cat("✅ School data loaded:", nrow(school_data), "records\n")

# ==============================================================================
# STEP 3: Bac 2025 Data
# ==============================================================================
bac_by_field <- tibble(
  field_ar = c("رياضيات", "رياضة", "علوم الإعلامية", "العلوم التجريبية", 
               "العلوم التقنية", "الاقتصاد والتصرف", "الآداب"),
  field_en = c("Mathematics", "Sports", "Computer Science", "Experimental Sciences",
               "Technical Sciences", "Economics & Business", "Literature"),
  field_emoji = c("🔢 Mathematics", "🏃 Sports", "💻 Computer Science", "🔬 Experimental Sciences",
                  "⚙️ Technical Sciences", "💼 Economics", "📚 Literature"),
  bac_success_rate = c(74.93, 73.33, 48.47, 45.83, 35.02, 28.95, 23.02)
)

bac_by_governorate <- tibble(
  rank = 1:26,
  governorate_ar = c("صفاقس 1", "مدنين", "صفاقس 2", "سيدي بوزيد", "المهدية", 
                     "سوسة", "أريانة", "المنستير", "تونس 1", "نابل",
                     "بن عروس", "تطاوين", "قابس", "تونس 2", "توزر",
                     "قبلي", "منوبة", "بنزرت", "سليانة", "القصرين",
                     "الكاف", "باجة", "قفصة", "القيروان", "زغوان", "جندوبة"),
  governorate_en = c("Sfax 1", "Medenine", "Sfax 2", "Sidi Bouzid", "Mahdia",
                     "Sousse", "Ariana", "Monastir", "Tunis 1", "Nabeul",
                     "Ben Arous", "Tataouine", "Gabes", "Tunis 2", "Tozeur",
                     "Kebili", "Manouba", "Bizerte", "Siliana", "Kasserine",
                     "Le Kef", "Beja", "Gafsa", "Kairouan", "Zaghouan", "Jendouba"),
  candidates = c(5839, 4964, 4307, 4379, 3988, 7629, 6323, 6928, 5947, 8618,
                 7882, 1420, 4086, 5437, 1423, 2078, 4809, 6767, 2694, 4900,
                 2998, 3541, 4211, 5454, 2119, 4742),
  passed = c(4164, 3423, 2966, 2965, 2540, 4783, 3901, 4251, 3615, 5235,
             4784, 858, 2408, 3152, 819, 1165, 2595, 3634, 1423, 2492,
             1503, 1769, 1956, 2524, 978, 2043),
  bac_success_rate = c(71.31, 68.96, 68.86, 67.71, 63.69, 62.69, 61.70, 61.36, 
                       60.79, 60.74, 60.70, 60.42, 58.93, 57.97, 57.55, 56.06,
                       53.96, 53.70, 52.82, 50.86, 50.13, 49.96, 46.45, 46.28, 
                       46.15, 43.08)
)

cat("✅ Bac 2025 data loaded\n")

# ==============================================================================
# STEP 4: Summary Statistics
# ==============================================================================
total_students <- sum(school_data$nb_students)
total_passed <- sum(school_data$nb_passed)
overall_rate <- round(total_passed / total_students * 100, 2)

summary_stats <- list(
  total_students = total_students,
  total_passed = total_passed,
  overall_rate = overall_rate,
  n_schools = n_distinct(school_data$school_code),
  n_governorates = n_distinct(school_data$governorate),
  n_levels = n_distinct(school_data$level_name)
)
saveRDS(summary_stats, "data/results/summary_stats.rds")

summary_by_gov <- school_data %>%
  filter(!is.na(governorate)) %>%
  group_by(governorate, governorate_ar) %>%
  summarise(
    n_schools = n_distinct(school_code),
    total_students = sum(nb_students),
    total_passed = sum(nb_passed),
    success_rate = round(total_passed / total_students * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(success_rate))
saveRDS(summary_by_gov, "data/results/summary_by_governorate.rds")

summary_by_level <- school_data %>%
  group_by(level_name) %>%
  summarise(
    total_students = sum(nb_students),
    total_passed = sum(nb_passed),
    success_rate = round(total_passed / total_students * 100, 2),
    .groups = "drop"
  ) %>%
  arrange(desc(success_rate))
saveRDS(summary_by_level, "data/results/summary_by_level.rds")

cat("✅ Summary statistics saved\n")

# ==============================================================================
# STEP 5: Year Analysis
# ==============================================================================
year_analysis <- school_data %>%
  mutate(
    year_order = case_when(
      str_detect(level_name, "سابعة") ~ 1,
      str_detect(level_name, "ثامنة") ~ 2,
      str_detect(level_name, "تاسعة") ~ 3,
      str_detect(level_name, "أولى") ~ 4,
      str_detect(level_name, "ثانية") ~ 5,
      str_detect(level_name, "ثالثة") ~ 6,
      TRUE ~ 0
    ),
    year_label = case_when(
      str_detect(level_name, "سابعة") ~ "7th\nBasic",
      str_detect(level_name, "ثامنة") ~ "8th\nBasic",
      str_detect(level_name, "تاسعة") ~ "9th\nBasic",
      str_detect(level_name, "أولى") ~ "1st\nSecondary",
      str_detect(level_name, "ثانية") ~ "2nd\nSecondary",
      str_detect(level_name, "ثالثة") ~ "3rd\nSecondary",
      TRUE ~ "Other"
    )
  ) %>%
  filter(year_order > 0) %>%
  group_by(year_order, year_label) %>%
  summarise(
    students = sum(nb_students),
    passed = sum(nb_passed),
    success_rate = round(passed / students * 100, 1),
    .groups = "drop"
  )
saveRDS(year_analysis, "data/results/year_analysis.rds")

# ==============================================================================
# STEP 6: Generate Plots
# ==============================================================================

# Plot 1: Educational Journey
p_journey <- ggplot(year_analysis, aes(x = year_order, y = success_rate)) +
  geom_area(fill = "#3498db", alpha = 0.3) +
  geom_line(color = "#2c3e50", linewidth = 2) +
  geom_point(aes(size = students), color = "#e74c3c") +
  geom_text(aes(label = paste0(success_rate, "%")), vjust = -1.5, size = 5, fontface = "bold") +
  scale_x_continuous(breaks = year_analysis$year_order, labels = year_analysis$year_label) +
  scale_size_continuous(range = c(8, 18), guide = "none") +
  labs(title = "THE PATH TO BACCALAUREATE", subtitle = "Tracking success rates from 7th grade to 3rd Secondary",
       x = "Educational Year", y = "Success Rate (%)") +
  ylim(70, 100) +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 22))
ggsave("img/01_educational_journey.png", p_journey, width = 14, height = 8, dpi = 150)
cat("✅ Saved: img/01_educational_journey.png\n")

# Plot 2: Bac by Field
p_bac_field <- ggplot(bac_by_field, aes(x = reorder(field_emoji, bac_success_rate), y = bac_success_rate)) +
  geom_col(aes(fill = bac_success_rate), width = 0.75, show.legend = FALSE) +
  geom_text(aes(label = paste0(bac_success_rate, "%")), hjust = -0.1, size = 6, fontface = "bold") +
  geom_hline(yintercept = 50, linetype = "dashed", color = "#e74c3c", linewidth = 1.2) +
  scale_fill_gradient2(low = "#c0392b", mid = "#f39c12", high = "#27ae60", midpoint = 50) +
  coord_flip() + ylim(0, 85) +
  labs(title = "BACCALAUREATE 2025 - SUCCESS BY FIELD", x = "", y = "Success Rate (%)") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 24))
ggsave("img/02_bac_by_field.png", p_bac_field, width = 14, height = 10, dpi = 150)
saveRDS(bac_by_field, "data/results/bac_by_field.rds")
cat("✅ Saved: img/02_bac_by_field.png\n")

# Plot 3: Bac by Governorate
p_bac_gov <- ggplot(bac_by_governorate, aes(x = reorder(governorate_ar, bac_success_rate), y = bac_success_rate)) +
  geom_segment(aes(xend = governorate_ar, yend = 40), color = "gray80", linewidth = 1) +
  geom_point(aes(color = bac_success_rate, size = candidates)) +
  geom_text(aes(label = paste0(bac_success_rate, "%")), hjust = -0.3, size = 4, fontface = "bold") +
  scale_color_gradient2(low = "#c0392b", mid = "#f39c12", high = "#27ae60", midpoint = 55) +
  scale_size_continuous(range = c(4, 12), labels = comma) +
  geom_hline(yintercept = 50, linetype = "dashed", color = "#e74c3c") +
  coord_flip() + ylim(40, 78) +
  labs(title = "BAC 2025 - REGIONAL RANKING", x = "", y = "Success Rate (%)") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 22))
ggsave("img/03_bac_by_governorate.png", p_bac_gov, width = 14, height = 14, dpi = 150)
saveRDS(bac_by_governorate, "data/results/bac_by_governorate.rds")
cat("✅ Saved: img/03_bac_by_governorate.png\n")

# Plot 4: Gap Analysis
comparison_data <- tibble(
  field = c("Literature", "Economics", "Technical Sci.", "Exp. Sciences", 
            "Computer Sci.", "Sports", "Mathematics"),
  prebac_estimate = c(90.5, 85.4, 88.2, 92.5, 94.1, 97.8, 97.2),
  bac_actual = c(23.02, 28.95, 35.02, 45.83, 48.47, 73.33, 74.93),
  field_ar = c("الآداب", "الاقتصاد", "العلوم التقنية", "العلوم التجريبية", 
               "علوم الإعلامية", "الرياضة", "الرياضيات")
) %>%
  mutate(gap = prebac_estimate - bac_actual)

comparison_long <- comparison_data %>%
  pivot_longer(cols = c(prebac_estimate, bac_actual), 
               names_to = "exam_type", values_to = "success_rate") %>%
  mutate(exam_label = if_else(exam_type == "prebac_estimate", "Pre-Bac (School)", "Actual Bac 2025"))

p_gap <- ggplot(comparison_long, aes(x = reorder(field, success_rate), y = success_rate, fill = exam_label)) +
  geom_col(position = "dodge", width = 0.7) +
  geom_text(aes(label = paste0(success_rate, "%")), 
            position = position_dodge(width = 0.7), hjust = -0.1, size = 4, fontface = "bold") +
  scale_fill_manual(values = c("Pre-Bac (School)" = "#27ae60", "Actual Bac 2025" = "#c0392b")) +
  coord_flip() + ylim(0, 110) +
  labs(title = "THE REALITY GAP", x = "", y = "Success Rate (%)", fill = "Exam Type") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 24, color = "#c0392b"),
        legend.position = "bottom")
ggsave("img/04_gap_analysis.png", p_gap, width = 14, height = 10, dpi = 150)
saveRDS(comparison_data, "data/results/gap_analysis.rds")
cat("✅ Saved: img/04_gap_analysis.png\n")

# Plot 5: Heatmap
heatmap_data <- school_data %>%
  filter(str_detect(level_name, "ثالثة")) %>%
  mutate(
    field_short = case_when(
      str_detect(level_name, "آداب") ~ "Literature",
      str_detect(level_name, "رياضيات") ~ "Math",
      str_detect(level_name, "علوم تجريبية") ~ "Exp.Sci",
      str_detect(level_name, "علوم تقنية") ~ "Tech.Sci",
      str_detect(level_name, "علوم إعلامية") ~ "IT",
      str_detect(level_name, "إقتصاد") ~ "Economics",
      str_detect(level_name, "رياضة") ~ "Sports",
      TRUE ~ "Other"
    )
  ) %>%
  filter(!is.na(governorate)) %>%
  group_by(governorate, field_short) %>%
  summarise(success_rate = round(sum(nb_passed) / sum(nb_students) * 100, 1), .groups = "drop")

gov_order <- heatmap_data %>%
  group_by(governorate) %>% summarise(avg = mean(success_rate)) %>%
  arrange(desc(avg)) %>% pull(governorate)

heatmap_data <- heatmap_data %>%
  mutate(governorate = factor(governorate, levels = rev(gov_order)))

p_heatmap <- ggplot(heatmap_data, aes(x = field_short, y = governorate, fill = success_rate)) +
  geom_tile(color = "white", linewidth = 1.2) +
  geom_text(aes(label = success_rate), size = 4, fontface = "bold") +
  scale_fill_gradient2(low = "#c0392b", mid = "#f39c12", high = "#27ae60", midpoint = 88) +
  labs(title = "PRE-BAC HEATMAP: Fields x Regions", x = "Academic Field", y = "Governorate") +
  theme_minimal(base_size = 12) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 22),
        axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("img/05_heatmap.png", p_heatmap, width = 16, height = 14, dpi = 150)
saveRDS(heatmap_data, "data/results/heatmap_data.rds")
cat("✅ Saved: img/05_heatmap.png\n")

# Plot 6: Distribution
p_dist <- ggplot(school_data, aes(x = success_rate)) +
  geom_histogram(aes(y = after_stat(density)), bins = 30, fill = "#3498db", alpha = 0.7, color = "white") +
  geom_density(color = "#e74c3c", linewidth = 1.5) +
  geom_vline(xintercept = mean(school_data$success_rate), color = "#27ae60", linewidth = 1.5, linetype = "dashed") +
  labs(title = "DISTRIBUTION OF SUCCESS RATES", x = "Success Rate (%)", y = "Density") +
  theme_minimal(base_size = 14) +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 20))
ggsave("img/06_distribution.png", p_dist, width = 12, height = 8, dpi = 150)
cat("✅ Saved: img/06_distribution.png\n")

# ==============================================================================
# STEP 7: Save Final Data
# ==============================================================================
saveRDS(school_data, "data/results/school_data_processed.rds")

final_summary <- list(
  total_bac_candidates = sum(bac_by_governorate$candidates),
  total_bac_passed = sum(bac_by_governorate$passed),
  national_bac_rate = round(sum(bac_by_governorate$passed) / sum(bac_by_governorate$candidates) * 100, 2),
  best_field = "Mathematics (74.93%)",
  worst_field = "Literature (23.02%)",
  best_region = "Sfax 1 (71.31%)",
  worst_region = "Jendouba (43.08%)",
  biggest_gap = "Literature: 90% -> 23% (-67 pts)"
)
saveRDS(final_summary, "data/results/final_summary.rds")

cat("\n")
cat("═══════════════════════════════════════════════════════\n")
cat("✅ ALL ANALYSIS COMPLETE!\n")
cat("═══════════════════════════════════════════════════════\n")
cat("\n📊 Plots saved in img/\n")
cat("📁 Data saved in data/results/\n")
cat("🎯 Now run 'quarto render' to build the website!\n")
