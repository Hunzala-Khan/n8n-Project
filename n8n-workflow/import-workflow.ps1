# ShopKeeping n8n Workflow Import Script
# This script helps import the voice chat workflow into n8n

Write-Host "📥 Importing ShopKeeping Voice Chat Workflow..." -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan

# Check if workflow file exists
$workflowFile = "voice-chat-workflow.json"
if (!(Test-Path $workflowFile)) {
    Write-Host "❌ Workflow file not found: $workflowFile" -ForegroundColor Red
    Write-Host "Please ensure you're running this script from the n8n-workflow folder." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Workflow file found: $workflowFile" -ForegroundColor Green

# Check if n8n is running
Write-Host "`n🔍 Checking if n8n is running..." -ForegroundColor Cyan
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5678" -UseBasicParsing -TimeoutSec 5
    if ($response.StatusCode -eq 200) {
        Write-Host "✅ n8n is running at http://localhost:5678" -ForegroundColor Green
    }
} catch {
    Write-Host "❌ n8n is not running!" -ForegroundColor Red
    Write-Host "Please start n8n first using: .\start-n8n.ps1" -ForegroundColor Yellow
    Write-Host "Or manually start with: n8n start" -ForegroundColor Yellow
    exit 1
}

# Display import instructions
Write-Host "`n📋 Manual Import Instructions:" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "1. Open your browser and go to: http://localhost:5678" -ForegroundColor White
Write-Host "2. Click 'Import from file' or 'Import' button" -ForegroundColor White
Write-Host "3. Select the file: $workflowFile" -ForegroundColor White
Write-Host "4. Click 'Import' to add the workflow" -ForegroundColor White
Write-Host "5. Activate the workflow by clicking the toggle switch" -ForegroundColor White
Write-Host "=================================================" -ForegroundColor Cyan

# Try to open n8n in default browser
Write-Host "`n🌐 Opening n8n in your default browser..." -ForegroundColor Cyan
try {
    Start-Process "http://localhost:5678"
    Write-Host "✅ Browser opened successfully!" -ForegroundColor Green
} catch {
    Write-Host "⚠️  Could not open browser automatically" -ForegroundColor Yellow
    Write-Host "Please manually open: http://localhost:5678" -ForegroundColor White
}

# Display workflow details
Write-Host "`n📊 Workflow Details:" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "Name: ShopKeeping Voice Chat Workflow" -ForegroundColor White
Write-Host "Webhooks:" -ForegroundColor White
Write-Host "  - POST /webhook/voice-chat" -ForegroundColor Gray
Write-Host "  - GET /webhook/health" -ForegroundColor Gray
Write-Host "  - GET /webhook/ai-response/:requestId" -ForegroundColor Gray
Write-Host "Nodes: 12" -ForegroundColor White
Write-Host "Status: Ready for import" -ForegroundColor Green

# Check if required directories exist
Write-Host "`n📁 Checking required directories..." -ForegroundColor Cyan
$requiredDirs = @("audio-uploads", "audio-responses", "data")
foreach ($dir in $requiredDirs) {
    if (Test-Path $dir) {
        Write-Host "✅ $dir" -ForegroundColor Green
    } else {
        Write-Host "❌ $dir (will be created by start script)" -ForegroundColor Yellow
    }
}

# Check environment configuration
Write-Host "`n🔧 Environment Configuration:" -ForegroundColor Cyan
if (Test-Path ".env") {
    Write-Host "✅ .env file exists" -ForegroundColor Green
    
    # Check for required API keys
    $envContent = Get-Content ".env"
    $openaiKey = $envContent | Where-Object { $_ -match "^OPENAI_API_KEY=" }
    $elevenlabsKey = $envContent | Where-Object { $_ -match "^ELEVENLABS_API_KEY=" }
    
    if ($openaiKey -and $openaiKey -notmatch "your_openai_api_key_here") {
        Write-Host "✅ OpenAI API key configured" -ForegroundColor Green
    } else {
        Write-Host "⚠️  OpenAI API key not configured" -ForegroundColor Yellow
    }
    
    if ($elevenlabsKey -and $elevenlabsKey -notmatch "your_elevenlabs_api_key_here") {
        Write-Host "✅ ElevenLabs API key configured" -ForegroundColor Green
    } else {
        Write-Host "⚠️  ElevenLabs API key not configured" -ForegroundColor Yellow
    }
} else {
    Write-Host "❌ .env file not found" -ForegroundColor Red
    Write-Host "Please run .\start-n8n.ps1 first to create it" -ForegroundColor Yellow
}

# Display next steps
Write-Host "`n🚀 Next Steps:" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "1. Import the workflow in n8n interface" -ForegroundColor White
Write-Host "2. Activate the workflow" -ForegroundColor White
Write-Host "3. Test with the voice chat app" -ForegroundColor White
Write-Host "4. Monitor workflow execution" -ForegroundColor White

Write-Host "`n💡 Tips:" -ForegroundColor Yellow
Write-Host "- Ensure your API keys are valid" -ForegroundColor Gray
Write-Host "- Check n8n logs for any errors" -ForegroundColor Gray
Write-Host "- Test webhook endpoints manually first" -ForegroundColor Gray
Write-Host "- Verify Excel data file exists" -ForegroundColor Gray

Write-Host "`n✅ Workflow import script completed!" -ForegroundColor Green
Write-Host "Happy voice chatting! 🎤✨" -ForegroundColor Cyan
