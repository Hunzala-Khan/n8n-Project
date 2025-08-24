# ShopKeeping n8n Startup Script
# This script starts n8n with the voice chat workflow configuration

Write-Host "🚀 Starting ShopKeeping n8n Voice Chat System..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

# Check if Node.js is installed
try {
    $nodeVersion = node --version
    Write-Host "✅ Node.js found: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Node.js not found! Please install Node.js 16+ first." -ForegroundColor Red
    Write-Host "Download from: https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if n8n is installed globally
try {
    $n8nVersion = n8n --version
    Write-Host "✅ n8n found: $n8nVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ n8n not found! Installing n8n globally..." -ForegroundColor Yellow
    Write-Host "Installing n8n (this may take a few minutes)..." -ForegroundColor Cyan
    
    try {
        npm install -g n8n
        Write-Host "✅ n8n installed successfully!" -ForegroundColor Green
    } catch {
        Write-Host "❌ Failed to install n8n. Please run: npm install -g n8n" -ForegroundColor Red
        exit 1
    }
}

# Check if .env file exists
if (Test-Path ".env") {
    Write-Host "✅ Environment file found" -ForegroundColor Green
} else {
    Write-Host "⚠️  .env file not found! Creating from template..." -ForegroundColor Yellow
    
    if (Test-Path "env.example") {
        Copy-Item "env.example" ".env"
        Write-Host "✅ .env file created from template" -ForegroundColor Green
        Write-Host "⚠️  Please edit .env file with your API keys before starting!" -ForegroundColor Red
        Write-Host "Press any key to continue after editing .env file..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } else {
        Write-Host "❌ env.example not found! Please create .env file manually." -ForegroundColor Red
        exit 1
    }
}

# Create required directories
Write-Host "📁 Creating required directories..." -ForegroundColor Cyan

$directories = @(
    "audio-uploads",
    "audio-responses", 
    "data"
)

foreach ($dir in $directories) {
    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Host "✅ Created directory: $dir" -ForegroundColor Green
    } else {
        Write-Host "✅ Directory exists: $dir" -ForegroundColor Green
    }
}

# Check if Excel data file exists
if (Test-Path "data/shopkeeping-data.xlsx") {
    Write-Host "✅ Excel data file found" -ForegroundColor Green
} else {
    Write-Host "⚠️  Excel data file not found in data/ folder" -ForegroundColor Yellow
    Write-Host "Please create shopkeeping-data.xlsx with the structure from sample-data.md" -ForegroundColor Cyan
}

# Set environment variables for this session
Write-Host "🔧 Setting environment variables..." -ForegroundColor Cyan

# Load .env file if it exists
if (Test-Path ".env") {
    Get-Content ".env" | ForEach-Object {
        if ($_ -match "^([^#][^=]+)=(.*)$") {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "✅ Set: $name" -ForegroundColor Green
        }
    }
}

# Set default values if not in .env
if (!$env:OPENAI_API_KEY) {
    Write-Host "⚠️  OPENAI_API_KEY not set in .env" -ForegroundColor Yellow
}

if (!$env:ELEVENLABS_API_KEY) {
    Write-Host "⚠️  ELEVENLABS_API_KEY not set in .env" -ForegroundColor Yellow
}

if (!$env:EXCEL_FILE_PATH) {
    $env:EXCEL_FILE_PATH = "./data/shopkeeping-data.xlsx"
    Write-Host "✅ Set default EXCEL_FILE_PATH: $env:EXCEL_FILE_PATH" -ForegroundColor Green
}

# Display configuration
Write-Host "`n📋 Configuration Summary:" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "n8n Port: 5678" -ForegroundColor White
Write-Host "n8n URL: http://localhost:5678" -ForegroundColor White
Write-Host "Excel File: $env:EXCEL_FILE_PATH" -ForegroundColor White
Write-Host "Audio Uploads: ./audio-uploads" -ForegroundColor White
Write-Host "Audio Responses: ./audio-responses" -ForegroundColor White

# Check if port 5678 is available
Write-Host "`n🔍 Checking if port 5678 is available..." -ForegroundColor Cyan
try {
    $connection = Test-NetConnection -ComputerName localhost -Port 5678 -WarningAction SilentlyContinue
    if ($connection.TcpTestSucceeded) {
        Write-Host "❌ Port 5678 is already in use!" -ForegroundColor Red
        Write-Host "Please stop any existing n8n instance or change the port." -ForegroundColor Yellow
        Write-Host "Press any key to continue anyway..." -ForegroundColor Yellow
        $null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    } else {
        Write-Host "✅ Port 5678 is available" -ForegroundColor Green
    }
} catch {
    Write-Host "✅ Port check completed" -ForegroundColor Green
}

# Start n8n
Write-Host "`n🚀 Starting n8n..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "n8n will be available at: http://localhost:5678" -ForegroundColor Yellow
Write-Host "Press Ctrl+C to stop n8n" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

# Start n8n with custom configuration
try {
    n8n start --port 5678 --host localhost
} catch {
    Write-Host "❌ Failed to start n8n!" -ForegroundColor Red
    Write-Host "Error: $_" -ForegroundColor Red
    Write-Host "`nTroubleshooting tips:" -ForegroundColor Yellow
    Write-Host "1. Check if port 5678 is available" -ForegroundColor White
    Write-Host "2. Verify your .env file configuration" -ForegroundColor White
    Write-Host "3. Ensure you have proper permissions" -ForegroundColor White
    Write-Host "4. Try running: n8n start --port 5678" -ForegroundColor White
}

Write-Host "`n👋 n8n stopped. Goodbye!" -ForegroundColor Green
