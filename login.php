<?php
/*
 * User Login Script
 * Handles POST requests from the login form.
 * Connects to the database, finds the user, and verifies the password.
 * Returns a JSON response.
 */

// Include the database connection file
require 'db_connect.php';

// Get the raw POST data (which is a JSON string)
$json_data = file_get_contents('php://input');
$data = json_decode($json_data);

// Basic validation
if (!$data || !isset($data->email) || !isset($data->password)) {
    // Send an error response
    echo json_encode([
        'success' => false,
        'message' => 'Invalid input. Please provide email and password.'
    ]);
    exit;
}

// Sanitize inputs
$email = filter_var(trim($data->email), FILTER_SANITIZE_EMAIL);
$password = $data->password;

try {
    // Find the user by email
    $stmt = $pdo->prepare("SELECT user_id, name, email, password_hash, role FROM Users WHERE email = ?");
    $stmt->execute([$email]);
    $user = $stmt->fetch();

    // Check if user exists and password is correct
    if ($user && password_verify($password, $user['password_hash'])) {
        // Password is correct!
        
        // In a real application, you would start a session here.
        // session_start();
        // $_SESSION['user_id'] = $user['user_id'];
        // $_SESSION['user_name'] = $user['name'];

        // Send a success response with user data
        echo json_encode([
            'success' => true,
            'message' => 'Login successful!',
            'user' => [
                'id' => (int)$user['user_id'],
                'name' => $user['name'],
                'email' => $user['email'],
                'role' => $user['role']
            ]
        ]);
    } else {
        // Invalid email or password
        echo json_encode([
            'success' => false,
            'message' => 'Invalid email or password.'
        ]);
    }

} catch (PDOException $e) {
    // Handle database errors
    echo json_encode([
        'success' => false,
        'message' => 'Database error: ' . $e->getMessage()
    ]);
}
?>
