# تحليل نسب النجاح في المدارس التونسية 🎓
# Tunisia School Success Rate Analysis

## 📊 نظرة عامة | Overview

هذا المشروع يحلل نسب النجاح في المدارس التونسية باستخدام بيانات الباكالوريا 2025 الرسمية.

This project analyzes school success rates in Tunisia using official Bac 2025 data across 7 academic fields and 26 regional delegations.

## 🌐 Live Website

📍 **[View the Analysis](https://chaima-massaoudi.github.io/R_project/)**

## 📁 Project Structure

```
R_project/
├── _quarto.yml          # Quarto configuration (Arabic RTL)
├── index.qmd            # Homepage with Bac 2025 summary
├── bac_story.qmd        # Bac journey analysis
├── bac_analysis.qmd     # Complete Bac analysis
├── data_exploration.qmd # Data exploration
├── visualizations.qmd   # Visualizations
├── statistics.qmd       # Statistical analysis
├── analysis.ipynb       # R Jupyter notebook
├── R/
│   └── run_analysis.R   # Master R analysis script
├── data/
│   ├── Bac2025.xlsx     # Official Bac 2025 data
│   └── results/         # Pre-computed RDS files
├── img/                 # Generated plots
└── styles.css           # RTL Arabic styling
```

## 🛠️ Technologies

- **Quarto** - Scientific publishing system
- **R** - Statistical computing
- **ggplot2** - Data visualization
- **dplyr** - Data manipulation
- **readxl** - Excel file reading

## 📈 Data Source

بيانات الباكالوريا 2025 الرسمية من وزارة التربية التونسية

Official Bac 2025 data from the Tunisian Ministry of Education:
- 7 Academic Fields (الشعب): Sciences, Mathematics, Economics, Letters, IT, Sports, Arts
- 26 Regional Delegations (المندوبيات الجهوية)
- Success rates by field and region

## 🚀 Getting Started

### Prerequisites

- R (>= 4.0)
- Quarto
- Required R packages: `tidyverse`, `readxl`, `knitr`, `DT`

### Installation

```bash
# Clone the repository
git clone https://github.com/chaima-massaoudi/R_project.git
cd R_project

# Install R packages
Rscript -e "install.packages(c('tidyverse', 'readxl', 'knitr', 'DT', 'kableExtra'))"

# Run analysis
Rscript R/run_analysis.R

# Render website
quarto render
```

## 📊 Key Findings

| الشعبة (Field) | نسبة النجاح (Success Rate) |
|----------------|---------------------------|
| الرياضيات | 71.09% |
| العلوم التجريبية | 55.94% |
| الاقتصاد والتصرف | 53.73% |
| الآداب | 38.91% |
| علوم الإعلامية | 64.62% |
| الرياضة | 69.73% |
| فنون التشكيل | 80.00% |

**المعدل الوطني (National Average): 53.05%**

## 👩‍💻 Author

**Chaima Massaoudi**

## 📄 License

This project is open source and available under the MIT License.

---

<div dir="rtl">

🇹🇳 مشروع تحليل البيانات التعليمية في تونس

</div>
