<?php
/*
 * Database Connection
 * This file connects to your MySQL database.
 * Update the $db_host, $db_name, $db_user, and $db_pass variables with your database credentials./
 */

$db_host = 'localhost'; // Usually 'localhost'
$db_name = 'auction_db';  // The name of the database you created with auction_db.sql
$db_user = 'root';      // Your MySQL username
$db_pass = '';      // Your MySQL password (can be 'root' or empty for XAMPP)

try {
    // Create a new PDO database connection
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name;charset=utf8mb4", $db_user, $db_pass);
    
    // Set PDO to throw exceptions on error
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Set default fetch mode to associative array
    $pdo->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
    
} catch (PDOException $e) {
    // If connection fails, stop the script and show an error
    // In a production environment, you would log this error, not display it to the user
    die("Error: Could not connect to database. " . $e->getMessage());
}

// Set the header to return JSON
// This is important so our JavaScript knows how to read the response
header('Content-Type: application/json');
?>