<?php

declare(strict_types=1);

namespace MacPaw\SymfonyPackagesTemplate\Tests;

use MacPaw\SymfonyPackagesTemplate\ExampleService;
use PHPUnit\Framework\TestCase;

/**
 * Example test demonstrating PHPUnit setup.
 */
final class ExampleServiceTest extends TestCase
{
    private ExampleService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->service = new ExampleService();
    }

    public function testGetName(): void
    {
        $this->assertSame('Symfony Packages Template', $this->service->getName());
    }

    public function testGreet(): void
    {
        $result = $this->service->greet('Developer');
        $this->assertStringContainsString('Hello, Developer!', $result);
        $this->assertStringContainsString('Symfony Packages Template', $result);
    }

    public function testGreetWithDefault(): void
    {
        $result = $this->service->greet();
        $this->assertStringContainsString('Hello, World!', $result);
    }

    public function testAdd(): void
    {
        $this->assertSame(5, $this->service->add(2, 3));
        $this->assertSame(0, $this->service->add(0, 0));
        $this->assertSame(-1, $this->service->add(-2, 1));
    }

    public function testCustomName(): void
    {
        $service = new ExampleService('Custom Name');
        $this->assertSame('Custom Name', $service->getName());
    }
}
