# Variabelen
PKG_VERSION := $(shell grep '^Version:' DESCRIPTION | awk '{print $$2}')
PKG_NAME    := $(shell grep '^Package:' DESCRIPTION | awk '{print $$2}')
PKG_TAR     := $(PKG_NAME)_$(PKG_VERSION).tar.gz

# Mappen
JSON_DIR    := inst/extdata
SCRIPT_DIR  := data-raw

# Zoek automatisch alle R-scripts in de data-raw map
R_SCRIPTS   := $(wildcard $(SCRIPT_DIR)/*.R)

.PHONY: all doc json build check install clean

# Standaard flow
all: doc json build check

# 1. Genereer documentatie
doc:
	Rscript -e "devtools::document()"

# 2. Voer alle gevonden R-scripts één voor één uit
json:
	mkdir -p $(JSON_DIR)
	@for script in $(R_SCRIPTS); do \
		echo "Uitvoeren van $$script..."; \
		Rscript $$script; \
	done

# 3. Bouw het bronpakket
build: doc json
	R CMD build .

check: build
	R CMD check $(PKG_TAR) --as-cran

install: build
	R CMD INSTALL $(PKG_TAR)

# 4. Schoonmaken
clean:
	rm -rf $(PKG_NAME).Rcheck/
	rm -f $(PKG_NAME)_*.tar.gz
	rm -f $(JSON_DIR)/*.json
