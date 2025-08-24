# ShopKeeping Voice Chat n8n Workflow

This n8n workflow provides a complete voice chat solution with AI-powered customer support, integrating Speech-to-Text, AI analysis, Excel data processing, and Text-to-Speech capabilities.

## 🚀 Features

- **Voice Input Processing**: Receives audio files via webhook
- **Speech-to-Text**: Converts audio to text using OpenAI Whisper
- **AI Analysis**: Processes customer queries using GPT-3.5-turbo
- **Excel Integration**: Analyzes business data for context-aware responses
- **Text-to-Speech**: Converts AI responses to audio using OpenAI TTS
- **Real-time Processing**: Asynchronous workflow with status tracking

## 📋 Prerequisites

1. **n8n Installation**: n8n must be installed and running
2. **API Keys**: 
   - OpenAI API key for STT, AI chat, and TTS
3. **Excel Data**: ShopKeeping business data file
4. **File Permissions**: Write access to audio and data directories

## 🛠️ Setup Instructions

### 1. Install n8n

```bash
npm install -g n8n
```

### 2. Configure Environment Variables

Copy `env.example` to `.env` and fill in your API keys:

```bash
cp env.example .env
```

Edit `.env` with your actual API keys:

```env
OPENAI_API_KEY=sk-your-openai-key-here
ELEVENLABS_API_KEY=your-elevenlabs-key-here
EXCEL_FILE_PATH=./data/shopkeeping-data.xlsx
```

### 3. Create Required Directories

```bash
mkdir -p audio-uploads audio-responses data
```

### 4. Import Workflow

1. Start n8n: `n8n start`
2. Open n8n interface at `http://localhost:5678`
3. Import the `voice-chat-workflow.json` file
4. Activate the workflow

### 5. Configure Nodes

#### OpenAI Nodes
- Set your OpenAI API key in both STT and Chat nodes
- Verify model settings (gpt-3.5-turbo recommended)

#### OpenAI TTS Node
- Uses the same OpenAI API key as STT and Chat
- Available voices: alloy, echo, fable, onyx, nova, shimmer

#### File Nodes
- Verify file paths match your directory structure
- Ensure write permissions for audio files

## 🔄 Workflow Flow

```
1. Voice Chat Webhook → Receives audio file
2. If Audio Exists → Validates audio input
3. Generate Request ID → Creates unique tracking ID
4. Save Audio File → Stores uploaded audio
5. OpenAI STT → Converts audio to text
6. Read Excel Data → Loads business context
7. OpenAI Chat → Generates AI response
8. Combine Data → Merges all information
9. OpenAI TTS → Converts response to audio
10. Save Audio Response → Stores generated audio
```

## 🌐 Webhook Endpoints

### POST `/webhook/voice-chat`
- **Purpose**: Receive audio files for processing
- **Input**: Multipart form data with audio file
- **Response**: Request ID and processing status

### GET `/webhook/health`
- **Purpose**: Check workflow health status
- **Response**: Server status and timestamp

### GET `/webhook/ai-response/:requestId`
- **Purpose**: Retrieve AI response and audio
- **Parameters**: `requestId` - Unique request identifier
- **Response**: AI response text and audio URL

## 📊 Excel Data Integration

The workflow reads Excel data to provide context-aware responses. Ensure your Excel file contains:

- Customer information
- Product details
- Order history
- Business policies
- FAQ data

## 🔧 Customization

### AI Response Customization
Edit the system prompt in the OpenAI Chat node:

```javascript
"You are a helpful customer support assistant for ShopKeeping, 
a retail management system. Analyze customer queries and provide 
helpful responses based on the Excel data context. Be professional, 
friendly, and concise."
```

### Voice Customization
Change the OpenAI TTS voice in the TTS node or environment variables. Available voices: alloy, echo, fable, onyx, nova, shimmer.

### Error Handling
The workflow includes error handling for:
- Missing audio files
- API failures
- File processing errors

## 📈 Monitoring and Debugging

### Workflow Execution
- Monitor execution in n8n interface
- Check webhook logs for incoming requests
- Verify file creation in audio directories

### Common Issues
1. **API Key Errors**: Verify API keys in environment variables
2. **File Permission Errors**: Check directory write permissions
3. **Audio Format Issues**: Ensure audio files are in supported formats
4. **Timeout Errors**: Adjust execution timeouts if needed

## 🚀 Production Deployment

### Security Considerations
- Use HTTPS for webhook endpoints
- Implement authentication for webhooks
- Store API keys securely
- Use database instead of in-memory storage

### Scaling
- Implement queue system for high volume
- Use cloud storage for audio files
- Add load balancing for multiple n8n instances

### Monitoring
- Set up logging and alerting
- Monitor API usage and costs
- Track workflow performance metrics

## 📝 API Response Format

### Success Response
```json
{
  "requestId": "1234567890_abc123",
  "success": true,
  "message": "Audio received and processing started"
}
```

### AI Response
```json
{
  "requestId": "1234567890_abc123",
  "response": "Thank you for your inquiry...",
  "audioUrl": "./audio-responses/response-1234567890_abc123.mp3",
  "timestamp": "2024-01-01T12:00:00.000Z"
}
```

## 🤝 Support

For issues or questions:
1. Check n8n logs and execution history
2. Verify API key configurations
3. Test individual nodes separately
4. Check file permissions and paths

## 📄 License

This workflow is provided as-is for educational and commercial use.

