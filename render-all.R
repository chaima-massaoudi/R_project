# ==============================================================================
# Render All Quarto Documents
# ==============================================================================

# Set library path
.libPaths(Sys.getenv("R_LIBS_USER"))

# Load quarto
if (!requireNamespace("quarto", quietly = TRUE)) {
  install.packages("quarto", repos = "https://cloud.r-project.org")
}

library(quarto)

# Get all .qmd files
qmd_files <- list.files(pattern = "\\.qmd$", full.names = TRUE)

cat("Found", length(qmd_files), "Quarto documents to render:\n")
print(qmd_files)

# Render the entire project
cat("\nRendering Quarto project...\n")
quarto::quarto_render()

cat("\nDone! Check the _site folder for the rendered website.\n")
