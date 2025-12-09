# Symfony Packages Template

Boilerplate template for creating Symfony packages within the MacPaw organization. This template includes all the necessary configuration files, CI/CD setup, and code quality tools to get started quickly.

## Features

- ✅ **CI/CD Integration**: Pre-configured GitHub Actions workflow using MacPaw's reusable workflow
- ✅ **Code Quality Tools**: PHPStan, PHP_CodeSniffer, PHP-CS-Fixer, Rector, and Infection
- ✅ **Testing**: PHPUnit configuration with example tests
- ✅ **Docker Support**: Dockerfile and docker-compose.yml with PHP built-in server
- ✅ **Modern PHP**: PHP 8.2+ with strict types and modern syntax
- ✅ **Symfony Compatibility**: Supports Symfony 6.4+ and 7.0+

## Requirements

- PHP 8.2 or higher
- Composer
- Symfony 6.4+ or 7.0+
- Docker and Docker Compose (optional, for containerized development)

## Installation

1. Clone this repository or use it as a template
2. Copy environment file:
   ```bash
   cp .env.example .env
   ```
3. Install dependencies:

```bash
composer install
```

Or using Docker:
```bash
docker-compose run --rm php composer install
```

## Create a new package from this template

The easiest way to bootstrap a new Symfony package is to use GitHub’s “Use this template” button and then run the included rebranding script.

Quick start:

1. Click “Use this template” on GitHub to create a new repository from this template.
2. Clone your new repository locally and enter the project directory.
3. Install dependencies (see Installation above).
4. Run the package update script to set your Composer package name, PHP namespace, and optional description:

   ```bash
   # Make sure the script is executable
   chmod +x scripts/update-package.sh

   # Minimal: only vendor/package (namespace will be derived)
   scripts/update-package.sh acme/cool-bundle

   # With explicit namespace
   scripts/update-package.sh acme/cool-bundle Acme\\CoolBundle

   # With explicit namespace and description
   scripts/update-package.sh acme/cool-bundle Acme\\CoolBundle "Cool Symfony bundle"
   ```

5. Review the changes, run tests, and update documentation details (badges, README intro, author info) as needed.

For a comprehensive, step-by-step guide, see: `docs/creating-new-package.md`.

### About the update-package.sh script

Path: `scripts/update-package.sh`

What it does:

- Updates `composer.json`:
  - Sets `name` to your new `vendor/package`.
  - Optionally sets `description` if you pass it.
  - Rewrites PSR-4 namespaces for `src/` and `tests/` based on your new namespace.
- Replaces occurrences of the old namespace and package name across common files (`src/`, `tests/`, `phpunit.xml.dist`, `README.md`, `SECURITY.md`, `rector.php`, `phpstan.neon.dist`, `phpcs.xml.dist`).
- Runs `composer dump-autoload` (if Composer is available).

Usage:

```
scripts/update-package.sh vendor/package [New\Namespace] ["New description"]
```

Notes:

- Requires PHP CLI. Works on macOS (BSD `sed`) and GNU/Linux.
- If you omit `New\Namespace`, it will be derived from `vendor/package` (e.g., `acme/cool-bundle` → `Acme\CoolBundle`).
- Always review changes with `git status` and run tests after the script finishes.

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── ci.yml              # CI/CD workflow configuration
├── public/                     # Public web directory
│   └── index.php              # Application entry point
├── src/                        # Source code
│   └── ExampleService.php      # Example service class
├── tests/                      # Test files
│   └── ExampleServiceTest.php  # Example test class
├── composer.json               # Composer configuration
├── Makefile                    # Makefile with common commands
├── Dockerfile                  # Docker image definition
├── docker-compose.yml          # Docker Compose configuration
├── .env.example                # Environment variables template
├── phpunit.xml.dist           # PHPUnit configuration
├── phpstan.neon.dist          # PHPStan configuration
├── phpcs.xml.dist             # PHP_CodeSniffer configuration
├── .php-cs-fixer.dist.php     # PHP-CS-Fixer configuration
├── rector.php                 # Rector configuration
└── infection.json5.dist       # Infection configuration
```

## Usage

### Makefile Commands

The project includes a comprehensive Makefile with auto-generated help. Run `make help` to see all available commands organized by sections:

```bash
make help
```

**Most Popular Commands:**

```bash
# Setup
make install          # Install dependencies
make update           # Update dependencies

# Testing
make test             # Run tests
make test-coverage    # Run tests with coverage

# Code Quality (Linting)
make lint             # Run all linting tools
make phpstan          # Run PHPStan
make phpcs            # Run PHP_CodeSniffer
make php-cs-fixer-dry # Check code style

# Fixes
make fix              # Fix code style automatically
make php-cs-fixer-fix # Apply PHP-CS-Fixer fixes
make rector-fix       # Apply Rector refactoring

# CI/CD
make ci               # Run all CI checks locally
make ci-full          # Full CI pipeline with mutation testing

# Docker
make docker-up        # Start containers
make docker-test      # Run tests in Docker
```

### Docker Development

The template includes Docker support with PHP built-in server (no nginx required).

1. Copy environment file:
```bash
cp .env.example .env
```

2. Start the container:
```bash
docker-compose up -d
```

3. Access the application:
   - Open http://localhost:8000 in your browser
   - Port can be customized via `PHP_SERVER_PORT` in `.env`

4. View logs:
```bash
docker-compose logs -f
```

5. Stop the container:
```bash
docker-compose down
```

#### Customizing Port

Edit `.env` file and set:
```bash
PHP_SERVER_PORT=8080
```

Then restart the container:
```bash
docker-compose restart
```

### Running Tests

```bash
# Run all tests
vendor/bin/phpunit

# Run with coverage
vendor/bin/phpunit --coverage-html coverage/
```

### Code Quality Checks

```bash
# PHPStan static analysis
vendor/bin/phpstan analyse

# PHP_CodeSniffer
vendor/bin/phpcs

# PHP-CS-Fixer (dry-run)
vendor/bin/php-cs-fixer fix --dry-run --diff

# PHP-CS-Fixer (fix)
vendor/bin/php-cs-fixer fix

# Rector (dry-run)
vendor/bin/rector process --dry-run

# Infection mutation testing
vendor/bin/infection
```

## CI/CD

The project uses MacPaw's reusable GitHub Actions workflow located at:
`MacPaw/github-actions/.github/workflows/symfony-php-reusable.yml`

The CI workflow automatically runs:
- ✅ Composer validation
- ✅ PHP_CodeSniffer
- ✅ PHPStan (level: max)
- ✅ PHP-CS-Fixer
- ✅ Rector
- ✅ PHPUnit tests with coverage
- ✅ Infection mutation testing

### CI Configuration

The workflow is configured in `.github/workflows/ci.yml` and tests against:
- PHP versions: 8.2, 8.3, 8.4
- Symfony versions: 6.4.*, 7.0.*, 7.3.*

## Customization

### Update Package Name

1. Update `composer.json`:
   - Change `name` field
   - Update `description`
   - Update `autoload` and `autoload-dev` namespaces

2. Update namespaces in source files:
   ```bash
   # Replace namespace in src/ and tests/
   find src tests -type f -name "*.php" -exec sed -i '' 's/MacPaw\\SymfonyPackagesTemplate/Your\\Namespace/g' {} +
   ```

3. Update directory structure if needed:
   ```bash
   # Rename directories to match namespace
   ```

### Configure Code Quality Tools

Each tool has its own configuration file:
- **PHPStan**: `phpstan.neon.dist` - Adjust level and paths
- **PHP_CodeSniffer**: `phpcs.xml.dist` - Configure coding standards
- **PHP-CS-Fixer**: `.php-cs-fixer.dist.php` - Configure code style rules
- **Rector**: `rector.php` - Configure refactoring rules
- **Infection**: `infection.json5.dist` - Configure mutation testing

## Development

### Adding New Code

1. Add your classes to `src/` directory
2. Follow PSR-12 coding standards
3. Write tests in `tests/` directory
4. Ensure all code quality checks pass

### Example Service

The template includes an `ExampleService` class demonstrating:
- Proper namespace usage
- Type declarations
- Constructor property promotion
- Test coverage

You can use this as a reference for creating your own services.

## Contributing

1. Create a feature branch
2. Make your changes
3. Ensure all tests pass
4. Ensure all code quality checks pass
5. Submit a pull request

## License

MIT

## Support

For issues and questions, please open an issue in the repository.
