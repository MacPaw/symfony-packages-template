<?php

declare(strict_types=1);

namespace MacPaw\SymfonyPackagesTemplate;

/**
 * Example service demonstrating the template structure.
 */
class ExampleService
{
    public function __construct(
        private readonly string $name = 'Symfony Packages Template'
    ) {
    }

    public function getName(): string
    {
        return $this->name;
    }

    public function greet(string $subject = 'World'): string
    {
        return sprintf('Hello, %s! From %s', $subject, $this->name);
    }

    public function add(int $a, int $b): int
    {
        return $a + $b;
    }
}
