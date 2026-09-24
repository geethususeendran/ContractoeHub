<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ERP Login | Enterprise Management System</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
             --primary-color: #16697a;       /* Deep Blue */
            --secondary-color: #34495e;     /* Slightly Lighter Blue */
            --accent-color: #3498db;        /* Bright Blue */
            --background-color: #f4f6f9;    /* Light Gray-Blue */
            --text-color: #2c3e50;          /* Dark Blue Text */
            --white: #ffffff;               /* Pure White */
        }

        body {
            font-family: 'Roboto', Arial, sans-serif;
            background-color: var(--background-color);
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            margin: 0;
            color: var(--text-color);
        }

        .login-wrapper {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 2rem 0;
        }

        .login-container {
            background-color: var(--white);
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 500px; /* Increased max-width */
            padding: 2.5rem;
            border: 1px solid rgba(0, 0, 0, 0.07);
            margin: 0 auto; /* Center the container */
        }

        .login-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .login-header h2 {
            color: var(--primary-color);
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .login-header p {
            color: var(--secondary-color);
            font-size: 0.9rem;
        }

        .form-control {
            background-color: rgba(255,255,255,0.85);;
            border: 1px solid #ced4da;
            padding: 0.75rem;
            transition: all 0.3s ease;
        }

        .form-control:focus {
            background-color: rgba(255,255,255,0.85);
            border-color: var(--accent-color);
            box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
        }

        .btn-login {
            background-color: var(--primary-color);
            color: var(--white);
            padding: 0.75rem;
            font-weight: 600;
            border: none;
            transition: all 0.3s ease;
        }

        .btn-login:hover {
            background-color: vlinear-gradient(135deg, var(--primary-color), var(--secondary-color));
            transform: translateY(-2px);
        }

        .forgot-password {
            text-align: center;
            margin-top: 1rem;
        }

        .site-header {
            background-color: var(--primary-color);
            color: var(--white);
            padding: 1rem 0;
            text-align: center;
        }

        .site-footer {
            background-color: var(--secondary-color);
            color: var(--white);
            padding: 1rem 0;
            text-align: center;
            margin-top: auto;
        }

        @media (max-width: 576px) {
            .login-container {
                margin: 0 15px;
                padding: 1.5rem;
                max-width: calc(100% - 30px); /* Adjust for mobile */
            }
        }
    </style>
</head>
<body>
    <!-- Site Header -->
    <header class="site-header">
        <div class="container">
            <h1 class="mb-0">The Contractor Workforce Management Hub</h1>
            <p class="mb-0">Streamline Your Business Operations</p>
        </div>
    </header>

    <!-- Login Wrapper -->
    <div class="login-wrapper">
        <div class="container-fluid">
            <div class="row justify-content-center">
                <div class="col-12 col-sm-10 col-md-8 col-lg-6 col-xl-5">
                    <div class="login-container">
                        <div class="login-header">
                            <h2>Welcome Back</h2>
                            <p>Sign in to your Enterprise Management Account</p>
                        </div>
                        
                        <form action="login" method="post">
                            <div class="mb-3">
                                <label for="username" class="form-label">
                                    <i class="fas fa-user me-2"></i>Username
                                </label>
                                <input type="text" class="form-control" id="username" name="username" 
                                       placeholder="Enter your username" required>
                            </div>
                            
                            <div class="mb-3">
                                <label for="password" class="form-label">
                                    <i class="fas fa-lock me-2"></i>Password
                                </label>
                                <input type="password" class="form-control" id="password" name="password" 
                                       placeholder="Enter your password" required>
                            </div>
                            
                            <div class="mb-3 d-flex justify-content-between align-items-center">
                                <div class="form-check">
                                    <input type="checkbox" class="form-check-input" id="rememberMe">
                                    <label class="form-check-label" for="rememberMe">Remember me</label>
                                </div>
                                <a href="#" class="text-primary">Forgot Password?</a>
                            </div>
                            
                            <button type="submit" class="btn btn-login w-100">
                                <i class="fas fa-sign-in-alt me-2"></i>Login
                            </button>
                            
                            <% 
                                String errorMessage = (String) request.getAttribute("errorMessage");
                                if (errorMessage != null) {
                            %>
                                <div class="alert alert-danger mt-3" role="alert">
                                    <%= errorMessage %>
                                </div>
                            <% } %>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Site Footer -->
    <footer class="site-footer">
        <div class="container">
            <div class="row">
                <div class="col-md-6">
                    <p class="mb-0">&copy; Owned By Geethu</p>
                </div>
                <div class="col-md-6 text-md-end">
                    <a href="#" class="text-white me-3">Privacy Policy</a>
                    <a href="#" class="text-white">Terms of Service</a>
                </div>
            </div>
        </div>
    </footer>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>