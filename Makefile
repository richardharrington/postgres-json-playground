DB=pg_playground
BUILD=${CURDIR}/build.sql
SCRIPTS=${CURDIR}/scripts
DATA=${CURDIR}/data
JSON='$(DATA)/test.json'
IMPORT=$(SCRIPTS)/import.sql
NORMALIZE=$(SCRIPTS)/normalize.sql

all: normalize
	psql $(DB) -f $(BUILD)
import: clean
	# next line is kind of like 'DROP DATABASE IF EXISTS $(DB); CREATE DATABASE $(DB)'
	psql -tc "SELECT 1 FROM pg_database WHERE datname = '$(DB)'" | grep -q 1 || psql -c "CREATE DATABASE $(DB)"
	@cat $(IMPORT) >> $(BUILD)
	@echo "COPY import.raw_json FROM $(JSON);" >> $(BUILD)
normalize: import
	@cat $(NORMALIZE) >> $(BUILD)
clean:
	@rm -rf $(BUILD)