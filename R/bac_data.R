# ==============================================================================
# Baccalaureate 2025 Official Results Data
# ==============================================================================

# Bac success rates by field (شعبة)
bac_by_field <- tibble(
  field_ar = c("رياضيات", "رياضة", "علوم الإعلامية", "العلوم التجريبية", 
               "العلوم التقنية", "الاقتصاد والتصرف", "الآداب"),
  field_en = c("Mathematics", "Sports", "Computer Science", "Experimental Sciences",
               "Technical Sciences", "Economics & Business", "Literature"),
  field_emoji = c("🔢 Mathematics", "🏃 Sports", "💻 Computer Science", "🔬 Experimental Sciences",
                  "⚙️ Technical Sciences", "💼 Economics", "📚 Literature"),
  bac_success_rate = c(74.93, 73.33, 48.47, 45.83, 35.02, 28.95, 23.02)
)

# Bac success rates by governorate (from official 2025 results)
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

# Governorate mapping for joining with school data (simplified names)
bac_gov_simplified <- tibble(
  governorate = c("Sfax", "Medenine", "Sidi Bouzid", "Mahdia", "Sousse", 
                  "Ariana", "Monastir", "Tunis", "Nabeul", "Ben Arous", 
                  "Tataouine", "Gabes", "Tozeur", "Kebili", "Manouba", 
                  "Bizerte", "Siliana", "Kasserine", "Le Kef", "Beja", 
                  "Gafsa", "Kairouan", "Zaghouan", "Jendouba"),
  bac_rate = c(70.09, 68.96, 67.71, 63.69, 62.69, 61.70, 61.36, 59.38, 
               60.74, 60.70, 60.42, 58.93, 57.55, 56.06, 53.96, 53.70, 
               52.82, 50.86, 50.13, 49.96, 46.45, 46.28, 46.15, 43.08)
)
