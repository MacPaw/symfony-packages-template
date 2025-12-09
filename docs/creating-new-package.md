### Creating a new Symfony package from this template

This guide walks you through creating a brand‑new package using this repository as a GitHub template and rebranding it with your own package name and PHP namespace.

#### Prerequisites

- PHP 8.2+
- Composer
- GitHub account with permission to create a repository
- Optional: Docker (if you prefer running Composer and tools in containers)

#### 1) Create your repository from the template

1. Open the repository on GitHub and click the “Use this template” button.
2. Choose a repository name, visibility, and click “Create repository from template”.
3. Clone your new repository locally:

   ```bash
   git clone git@github.com:<your-org-or-user>/<your-new-repo>.git
   cd <your-new-repo>
   ```

#### 2) Install dependencies

Choose one of the following:

- Native:

  ```bash
  composer install
  ```

- Docker (if you have a PHP container in your environment):

  ```bash
  docker-compose run --rm php composer install
  ```

#### 3) Rebrand the template using the helper script

Use the included script to update the Composer package name, PHP namespaces, and optionally description. This will update `composer.json`, PSR‑4 autoload keys, and replace old occurrences in common files.

1. Make the script executable (first time only):

   ```bash
   chmod +x scripts/update-package.sh
   ```

2. Run one of the following commands:

   - Minimal (derive namespace from `vendor/package`):

     ```bash
     scripts/update-package.sh acme/cool-bundle
     ```

   - With an explicit namespace:

     ```bash
     scripts/update-package.sh acme/cool-bundle Acme\\CoolBundle
     ```

   - With namespace and description:

     ```bash
     scripts/update-package.sh acme/cool-bundle Acme\\CoolBundle "Cool Symfony bundle"
     ```

3. Confirm the prompt. The script will:

   - Update `composer.json` (`name`, optional `description`, PSR‑4 for `src/` and `tests/`).
   - Replace the old namespace and package strings in common files (`src/`, `tests/`, `phpunit.xml.dist`, `README.md`, `SECURITY.md`, `rector.php`, `phpstan.neon.dist`, `phpcs.xml.dist`).
   - Run `composer dump-autoload` if Composer is available.

4. Review changes and run tests:

   ```bash
   git status
   make test           # or: vendor/bin/phpunit
   make lint           # optional, run quality tools
   ```

#### 4) Update metadata and docs

- README.md: adjust title, description, badges (CI, coverage), usage examples, and links.
- composer.json: verify `authors`, `description`, and `license`.
- CHANGELOG.md: start your own changelog (optional).
- SECURITY.md: update contact and policy if needed.

#### 5) CI/CD and quality tools

This template ships with a reusable GitHub Actions CI workflow. You typically don’t need to change it immediately. Optionally:

- Confirm the PHP and Symfony matrix in `.github/workflows/ci.yml` matches your intended support.
- Ensure commit linting and code quality tools versions are acceptable.
- For code coverage reporting to external services, add the required secrets in your repo settings.

#### 6) Initialize your first commit and push

```bash
git add -A
git commit -m "chore: rebrand from template and initialize package"
git push origin main
```

#### 7) Register on Packagist (optional but recommended)

If you plan to publish on Packagist:

1. Create/Sign in to your Packagist.org account.
2. Submit your repository URL.
3. Enable GitHub Service Hook or Packagist GitHub integration so new tags are auto‑synced.

#### 8) Release your first version

1. Update `CHANGELOG.md` and ensure the code is ready.
2. Tag a version:

   ```bash
   git tag -a v0.1.0 -m "First preview release"
   git push origin v0.1.0
   ```

3. If using Packagist, the new tag will appear shortly. Consumers can install your package via Composer.

#### 9) Symfony Bundle specifics (optional)

If your package is a Symfony bundle, consider:

- Creating a bundle class, e.g., `src/AcmeCoolBundle.php`, matching your namespace.
- Adding a `DependencyInjection` extension if you expose configuration or services.
- Providing a minimal `README` section on how to install and enable the bundle in an application.

#### Troubleshooting

- The script says it can’t parse `composer.json`:
  - Ensure the file is valid JSON. Run `composer validate` to check.
- Namespaces didn’t update everywhere:
  - The script covers common files. If you have additional files or custom paths, search for the old namespace/package and update manually.
- `composer` not found:
  - Install Composer or use the Docker approach. The script will skip `dump-autoload` if Composer isn’t available; you can run it later.

---

That’s it — you’re ready to develop your Symfony package with batteries included: CI, quality tools, and tests!
