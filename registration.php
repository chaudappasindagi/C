<?php
/*
 * User Registration Script
 * Handles POST requests from the registration form.
 * Connects to the database, hashes the password, and inserts the new user.
 * Returns a JSON response.
 */

// Include the database connection file
require 'db_connect.php';

// Get the raw POST data (which is a JSON string)
$json_data = file_get_contents('php://input');
$data = json_decode($json_data);

// Basic validation
if (!$data || !isset($data->name) || !isset($data->email) || !isset($data->password) || !isset($data->role)) {
    // Send an error response
    echo json_encode([
        'success' => false,
        'message' => 'Invalid input. Please fill out all fields.'
    ]);
    exit;
}

// Sanitize inputs
$name = filter_var(trim($data->name), FILTER_SANITIZE_STRING);
$email = filter_var(trim($data->email), FILTER_SANITIZE_EMAIL);
$password = $data->password; // We'll hash this, so no trimming
$role = $data->role === 'seller' ? 'seller' : 'buyer'; // Default to buyer

// Check if email already exists
try {
    $stmt = $pdo->prepare("SELECT user_id FROM Users WHERE email = ?");
    $stmt->execute([$email]);
    if ($stmt->fetch()) {
        echo json_encode([
            'success' => false,
            'message' => 'This email address is already registered.'
        ]);
        exit;
    }

    // Hash the password
    $password_hash = password_hash($password, PASSWORD_DEFAULT);

    // Insert the new user into the database
    $stmt = $pdo->prepare("INSERT INTO Users (name, email, password_hash, role) VALUES (?, ?, ?, ?)");
    $stmt->execute([$name, $email, $password_hash, $role]);
    
    // Get the ID of the new user
    $new_user_id = $pdo->lastInsertId();

    // Send a success response with the new user's data (excluding password)
    echo json_encode([
        'success' => true,
        'message' => 'Registration successful!',
        'user' => [
            'id' => (int)$new_user_id,
            'name' => $name,
            'email' => $email,
            'role' => $role
        ]
    ]);

} catch (PDOException $e) {
    // Handle database errors
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
