<?php

declare(strict_types=1);

/**
 * Simple PHP application entry point.
 * This is a template file demonstrating a basic PHP application structure.
 */

// Set error reporting
error_reporting(E_ALL);
ini_set('display_errors', '1');

// Set timezone
date_default_timezone_set('UTC');

// Load Composer autoloader if available
if (file_exists(__DIR__.'/../vendor/autoload.php')) {
    require_once __DIR__.'/../vendor/autoload.php';
}

// Simple routing example
$requestUri = $_SERVER['REQUEST_URI'] ?? '/';
$requestMethod = $_SERVER['REQUEST_METHOD'] ?? 'GET';

// Remove query string from URI
$path = parse_url($requestUri, PHP_URL_PATH);

// Simple response
http_response_code(200);
header('Content-Type: text/html; charset=utf-8');

?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Symfony Packages Template</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 12px;
            padding: 40px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            max-width: 600px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            font-size: 2.5em;
        }
        .info {
            background: #f8f9fa;
            border-left: 4px solid #667eea;
            padding: 15px;
            margin: 20px 0;
            border-radius: 4px;
        }
        .info-item {
            margin: 10px 0;
            color: #555;
        }
        .info-item strong {
            color: #333;
        }
        .status {
            display: inline-block;
            background: #28a745;
            color: white;
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 0.9em;
            margin-top: 10px;
        }
        code {
            background: #f4f4f4;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Courier New', monospace;
            color: #e83e8c;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Symfony Packages Template</h1>
        <div class="status">✓ Server Running</div>
        
        <div class="info">
            <div class="info-item">
                <strong>PHP Version:</strong> <?php echo PHP_VERSION; ?>
            </div>
            <div class="info-item">
                <strong>Server:</strong> PHP Built-in Server
            </div>
            <div class="info-item">
                <strong>Request Method:</strong> <?php echo htmlspecialchars($requestMethod); ?>
            </div>
            <div class="info-item">
                <strong>Request Path:</strong> <code><?php echo htmlspecialchars($path); ?></code>
            </div>
            <div class="info-item">
                <strong>Server Port:</strong> <?php echo $_SERVER['SERVER_PORT'] ?? 'N/A'; ?>
            </div>
            <?php if (file_exists(__DIR__.'/../vendor/autoload.php')) { ?>
            <div class="info-item">
                <strong>Composer:</strong> ✓ Autoloader loaded
            </div>
            <?php } ?>
        </div>
        
        <div class="info" style="margin-top: 30px;">
            <p><strong>Next Steps:</strong></p>
            <ul style="margin-left: 20px; margin-top: 10px; color: #555;">
                <li>Update <code>composer.json</code> with your package name</li>
                <li>Replace namespaces in <code>src/</code> and <code>tests/</code></li>
                <li>Add your application logic</li>
                <li>Run tests: <code>vendor/bin/phpunit</code></li>
            </ul>
        </div>
    </div>
</body>
</html>

