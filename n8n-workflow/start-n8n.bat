@echo off
chcp 65001 >nul
title ShopKeeping n8n Voice Chat System

echo.
echo 🚀 Starting ShopKeeping n8n Voice Chat System...
echo =================================================
echo.

REM Check if Node.js is installed
node --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Node.js not found! Please install Node.js 16+ first.
    echo Download from: https://nodejs.org/
    echo.
    pause
    exit /b 1
)

echo ✅ Node.js found
node --version

REM Check if n8n is installed globally
n8n --version >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ❌ n8n not found! Installing n8n globally...
    echo Installing n8n (this may take a few minutes)...
    echo.
    
    npm install -g n8n
    if %errorlevel% neq 0 (
        echo.
        echo ❌ Failed to install n8n. Please run: npm install -g n8n
        pause
        exit /b 1
    )
    echo ✅ n8n installed successfully!
)

echo ✅ n8n found
n8n --version

REM Check if .env file exists
if not exist ".env" (
    echo.
    echo ⚠️  .env file not found! Creating from template...
    if exist "env.example" (
        copy "env.example" ".env" >nul
        echo ✅ .env file created from template
        echo.
        echo ⚠️  Please edit .env file with your API keys before starting!
        echo.
        echo Press any key to continue after editing .env file...
        pause >nul
    ) else (
        echo ❌ env.example not found! Please create .env file manually.
        pause
        exit /b 1
    )
) else (
    echo ✅ Environment file found
)

REM Create required directories
echo.
echo 📁 Creating required directories...
if not exist "audio-uploads" mkdir "audio-uploads"
if not exist "audio-responses" mkdir "audio-responses"
if not exist "data" mkdir "data"
echo ✅ Directories created

REM Check if Excel data file exists
if exist "data\shopkeeping-data.xlsx" (
    echo ✅ Excel data file found
) else (
    echo ⚠️  Excel data file not found in data\ folder
    echo Please create shopkeeping-data.xlsx with the structure from sample-data.md
)

REM Display configuration
echo.
echo 📋 Configuration Summary:
echo =================================================
echo n8n Port: 5678
echo n8n URL: http://localhost:5678
echo Excel File: data\shopkeeping-data.xlsx
echo Audio Uploads: audio-uploads\
echo Audio Responses: audio-responses\

REM Check if port 5678 is available
echo.
echo 🔍 Checking if port 5678 is available...
netstat -an | find "5678" >nul 2>&1
if %errorlevel% equ 0 (
    echo ❌ Port 5678 is already in use!
    echo Please stop any existing n8n instance or change the port.
    echo.
    echo Press any key to continue anyway...
    pause >nul
) else (
    echo ✅ Port 5678 is available
)

REM Start n8n
echo.
echo 🚀 Starting n8n...
echo =================================================
echo n8n will be available at: http://localhost:5678
echo Press Ctrl+C to stop n8n
echo =================================================
echo.

REM Start n8n with custom configuration
n8n start --port 5678 --host localhost

if %errorlevel% neq 0 (
    echo.
    echo ❌ Failed to start n8n!
    echo.
    echo Troubleshooting tips:
    echo 1. Check if port 5678 is available
    echo 2. Verify your .env file configuration
    echo 3. Ensure you have proper permissions
    echo 4. Try running: n8n start --port 5678
)

echo.
echo 👋 n8n stopped. Goodbye!
pause
