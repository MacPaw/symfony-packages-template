.PHONY: help
.DEFAULT_GOAL := help

# Colors for output
COLOR_RESET   := \033[0m
COLOR_BOLD    := \033[1m
COLOR_SECTION := \033[1;36m
COLOR_COMMAND := \033[1;33m
COLOR_DESC    := \033[0;37m

##@ 📦 Setup

.PHONY: install
install: ## 📥 Install Composer dependencies
	@echo "$(COLOR_BOLD)Installing dependencies...$(COLOR_RESET)"
	composer install

.PHONY: update
update: ## 🔄 Update Composer dependencies
	@echo "$(COLOR_BOLD)Updating dependencies...$(COLOR_RESET)"
	composer update

.PHONY: validate
validate: ## ✔️ Validate composer.json
	@echo "$(COLOR_BOLD)Validating composer.json...$(COLOR_RESET)"
	composer validate --strict --no-check-publish

##@ 🧪 Testing

.PHONY: test
test: ## ✅ Run PHPUnit tests
	@echo "$(COLOR_BOLD)Running tests...$(COLOR_RESET)"
	vendor/bin/phpunit

.PHONY: test-coverage
test-coverage: ## 📊 Run tests with coverage report
	@echo "$(COLOR_BOLD)Running tests with coverage...$(COLOR_RESET)"
	vendor/bin/phpunit --coverage-html coverage/

.PHONY: test-coverage-clover
test-coverage-clover: ## 📈 Generate Clover coverage XML
	@echo "$(COLOR_BOLD)Generating Clover coverage XML...$(COLOR_RESET)"
	vendor/bin/phpunit --coverage-clover=coverage.xml

.PHONY: test-dox
test-dox: ## 📝 Run tests with testdox output
	@echo "$(COLOR_BOLD)Running tests with testdox...$(COLOR_RESET)"
	vendor/bin/phpunit --testdox

##@ 🔍 Code Quality

.PHONY: lint
lint: phpstan phpcs php-cs-fixer-dry ## 🔎 Run all linting tools (dry-run)
	@echo "$(COLOR_BOLD)Running all linting tools...$(COLOR_RESET)"

.PHONY: phpstan
phpstan: ## 🔬 Run PHPStan static analysis
	@echo "$(COLOR_BOLD)Running PHPStan...$(COLOR_RESET)"
	vendor/bin/phpstan analyse --no-progress

.PHONY: phpstan-baseline
phpstan-baseline: ## 📋 Generate PHPStan baseline
	@echo "$(COLOR_BOLD)Generating PHPStan baseline...$(COLOR_RESET)"
	vendor/bin/phpstan analyse --generate-baseline

.PHONY: phpcs
phpcs: ## 📏 Run PHP_CodeSniffer
	@echo "$(COLOR_BOLD)Running PHP_CodeSniffer...$(COLOR_RESET)"
	vendor/bin/phpcs

.PHONY: php-cs-fixer-dry
php-cs-fixer-dry: ## 🔍 Run PHP-CS-Fixer (dry-run)
	@echo "$(COLOR_BOLD)Running PHP-CS-Fixer (dry-run)...$(COLOR_RESET)"
	vendor/bin/php-cs-fixer fix --dry-run --diff

.PHONY: rector-dry
rector-dry: ## 🔄 Run Rector (dry-run)
	@echo "$(COLOR_BOLD)Running Rector (dry-run)...$(COLOR_RESET)"
	vendor/bin/rector process --dry-run

.PHONY: infection
infection: ## 🦠 Run Infection mutation testing
	@echo "$(COLOR_BOLD)Running Infection...$(COLOR_RESET)"
	vendor/bin/infection

##@ 🔧 Fixes

.PHONY: fix
fix: php-cs-fixer-fix ## 🛠️ Run all code fixers
	@echo "$(COLOR_BOLD)Running all code fixers...$(COLOR_RESET)"

.PHONY: php-cs-fixer-fix
php-cs-fixer-fix: ## ✨ Fix code style with PHP-CS-Fixer
	@echo "$(COLOR_BOLD)Fixing code style...$(COLOR_RESET)"
	vendor/bin/php-cs-fixer fix

.PHONY: rector-fix
rector-fix: ## 🔄 Apply Rector refactoring
	@echo "$(COLOR_BOLD)Applying Rector refactoring...$(COLOR_RESET)"
	vendor/bin/rector process

##@ 🐳 Docker

.PHONY: docker-build
docker-build: ## 🏗️ Build Docker image
	@echo "$(COLOR_BOLD)Building Docker image...$(COLOR_RESET)"
	docker-compose build

.PHONY: docker-up
docker-up: ## 🚀 Start Docker containers
	@echo "$(COLOR_BOLD)Starting Docker containers...$(COLOR_RESET)"
	docker-compose up -d

.PHONY: docker-down
docker-down: ## 🛑 Stop Docker containers
	@echo "$(COLOR_BOLD)Stopping Docker containers...$(COLOR_RESET)"
	docker-compose down

.PHONY: docker-logs
docker-logs: ## 📋 Show Docker container logs
	@echo "$(COLOR_BOLD)Showing Docker logs...$(COLOR_RESET)"
	docker-compose logs -f

.PHONY: docker-ps
docker-ps: ## 📊 Show running Docker containers
	@echo "$(COLOR_BOLD)Running containers:$(COLOR_RESET)"
	docker-compose ps

.PHONY: docker-shell
docker-shell: ## 🐚 Open shell in PHP container
	@echo "$(COLOR_BOLD)Opening shell in PHP container...$(COLOR_RESET)"
	docker-compose exec php sh

.PHONY: docker-install
docker-install: ## 📦 Install dependencies in Docker container
	@echo "$(COLOR_BOLD)Installing dependencies in Docker...$(COLOR_RESET)"
	docker-compose run --rm php composer install

.PHONY: docker-test
docker-test: ## 🧪 Run tests in Docker container
	@echo "$(COLOR_BOLD)Running tests in Docker...$(COLOR_RESET)"
	docker-compose run --rm php vendor/bin/phpunit

##@ 🚀 CI/CD

.PHONY: ci
ci: validate lint test ## ⚡ Run all CI checks locally

.PHONY: ci-full
ci-full: validate lint test infection ## 🔥 Run full CI pipeline including mutation testing

##@ 🧹 Cleanup

.PHONY: clean
clean: ## 🗑️ Remove generated files and caches
	@echo "$(COLOR_BOLD)Cleaning generated files...$(COLOR_RESET)"
	rm -rf coverage/ coverage.xml .phpunit.cache/ .infection/ infection.log infection-summary.log infection-debug.log

.PHONY: clean-vendor
clean-vendor: ## 📦 Remove vendor directory
	@echo "$(COLOR_BOLD)Removing vendor directory...$(COLOR_RESET)"
	rm -rf vendor/

.PHONY: clean-all
clean-all: clean clean-vendor ## 🧽 Remove all generated files and vendor

##@ 📖 Help

help: ## ❓ Display this help message
	@echo "$(COLOR_BOLD)Available commands:$(COLOR_RESET)"
	@awk 'BEGIN {FS = ":.*##"; section = ""} /^##@/ { \
		section = substr($$0, 5); \
		gsub(/^[ \t]+|[ \t]+$$/, "", section); \
		printf "\n$(COLOR_SECTION)%s$(COLOR_RESET)\n", section; \
	} /^[a-zA-Z_0-9-]+:.*?##/ { \
		if (section != "") { \
			split($$0, arr, ":"); \
			cmd = arr[1]; \
			desc = arr[2]; \
			gsub(/^[ \t]+|[ \t]+$$/, "", desc); \
			split(desc, descParts, " ##"); \
			if (length(descParts) > 1) { \
				desc = descParts[2]; \
			} \
			gsub(/^##/, "", desc); \
			if (desc !~ /^@/ && desc != "") { \
				printf "  $(COLOR_COMMAND)%-25s$(COLOR_RESET) $(COLOR_DESC)%s$(COLOR_RESET)\n", cmd, desc; \
			} \
		} \
	}' $(MAKEFILE_LIST)
	@echo ""
