# 🛍️ ShopKeeping Voice Chat System

A complete AI-powered voice chat solution for retail customer support, featuring real-time voice processing, AI analysis, Excel data integration, and automated responses.

## 🚀 System Overview

This system combines a Vue.js voice chat application with an n8n workflow to provide intelligent customer support through voice interaction. Customers can speak naturally, and the system responds with context-aware information from your business data.

## 🏗️ Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Vue.js App    │    │   n8n Workflow  │    │   External      │
│                 │    │                 │    │   Services      │
│ • Voice Chat    │◄──►│ • Webhooks      │◄──►│ • OpenAI STT    │
│ • Audio Record  │    │ • STT Processing│    │ • OpenAI GPT    │
│ • Real-time UI  │    │ • AI Analysis   │    │ • ElevenLabs TTS│
│ • Status Display│    │ • Excel Data    │    │ • File Storage  │
└─────────────────┘    │ • TTS Generation│    └─────────────────┘
                       └─────────────────┘
```

## 📁 Project Structure

```
ShopKeeping/
├── App/                          # Vue.js Voice Chat Application
│   ├── src/
│   │   ├── App.vue              # Main voice chat component
│   │   ├── main.js              # Vue app entry point
│   │   └── style.css            # Global styles
│   ├── package.json             # App dependencies
│   ├── vite.config.js           # Vite configuration
│   ├── index.html               # Main HTML file
│   └── README.md                # App setup guide
├── n8n-workflow/                 # n8n Workflow Configuration
│   ├── voice-chat-workflow.json # Main workflow file
│   ├── env.example              # Environment variables template
│   ├── sample-data.md           # Excel data structure guide
│   └── README.md                # Workflow setup guide
└── README.md                     # This file
```

## ✨ Key Features

### 🎤 Voice Chat App
- **Real-time Recording**: High-quality audio capture
- **Modern UI**: Beautiful, responsive interface
- **Status Monitoring**: Connection and audio status display
- **WebSocket Integration**: Real-time communication with n8n

### 🤖 AI-Powered Processing
- **Speech-to-Text**: OpenAI Whisper for accurate transcription
- **Intelligent Analysis**: GPT-3.5-turbo for context-aware responses
- **Business Context**: Excel data integration for relevant answers
- **Text-to-Speech**: ElevenLabs for natural voice responses

### 📊 Data Integration
- **Excel Processing**: Read and analyze business data
- **Context Awareness**: Provide accurate, relevant information
- **Real-time Updates**: Dynamic data processing
- **Structured Responses**: Consistent information delivery

## 🛠️ Quick Start

### 1. Prerequisites
- Node.js 16+ installed
- n8n installed globally
- OpenAI API key
- ElevenLabs API key
- Excel file with business data

### 2. Setup Voice Chat App
```bash
cd App
npm install
npm run dev
```

### 3. Setup n8n Workflow
```bash
cd n8n-workflow
cp env.example .env
# Edit .env with your API keys
n8n start
```

### 4. Import Workflow
1. Open n8n at `http://localhost:5678`
2. Import `voice-chat-workflow.json`
3. Activate the workflow

### 5. Test the System
1. Open voice chat app at `http://localhost:3000`
2. Click microphone button
3. Speak your question
4. Wait for AI response

## 🔧 Configuration

### Environment Variables
```env
# OpenAI
OPENAI_API_KEY=your_openai_key

# ElevenLabs
ELEVENLABS_API_KEY=your_elevenlabs_key
ELEVENLABS_VOICE_ID=21m00Tcm4TlvDq8ikWAM

# File Paths
EXCEL_FILE_PATH=./data/shopkeeping-data.xlsx
AUDIO_UPLOADS_PATH=./audio-uploads
AUDIO_RESPONSES_PATH=./audio-responses
```

### Excel Data Structure
- **Products**: Product information and inventory
- **Customers**: Customer details and history
- **Orders**: Order tracking and status
- **FAQ**: Common questions and answers
- **Policies**: Business rules and procedures

## 🔄 Workflow Process

1. **Voice Input** → Customer speaks into the app
2. **Audio Upload** → App sends audio to n8n webhook
3. **STT Processing** → OpenAI converts speech to text
4. **Data Analysis** → AI analyzes query with Excel context
5. **Response Generation** → AI generates relevant answer
6. **TTS Conversion** → ElevenLabs converts text to speech
7. **Audio Delivery** → Response sent back to the app
8. **Playback** → Customer hears the AI response

## 🌐 API Endpoints

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/webhook/voice-chat` | POST | Receive audio files |
| `/webhook/health` | GET | Check system status |
| `/webhook/ai-response/:id` | GET | Retrieve AI responses |

## 📱 Usage Examples

### Product Inquiry
**Customer**: "What laptops do you have in stock?"
**AI Response**: "We currently have 15 Dell XPS laptops in stock, priced at $1,299.99. These are high-performance business laptops with excellent reviews."

### Order Status
**Customer**: "What's the status of my order?"
**AI Response**: "I can see your order O001 for a Dell XPS laptop was delivered on January 15th. Is there anything specific you'd like to know about your order?"

### Policy Question
**Customer**: "What's your return policy?"
**AI Response**: "We offer a 30-day return policy with receipt. You can return any item within 30 days of purchase for a full refund or exchange."

## 🚀 Production Deployment

### Security Considerations
- Use HTTPS for all webhook endpoints
- Implement authentication and authorization
- Secure API key storage
- Regular security audits

### Scaling Strategies
- Load balancing for multiple n8n instances
- Cloud storage for audio files
- Database storage for request tracking
- Monitoring and alerting systems

### Performance Optimization
- Audio file compression
- Caching for frequent queries
- Database indexing for Excel data
- CDN for audio file delivery

## 🧪 Testing

### Unit Testing
- Test individual workflow nodes
- Validate API integrations
- Check error handling

### Integration Testing
- End-to-end voice chat flow
- Excel data processing
- Audio file handling

### Performance Testing
- Response time measurement
- Concurrent user testing
- Audio quality validation

## 📊 Monitoring

### Key Metrics
- Response time per request
- Audio processing success rate
- AI response accuracy
- System uptime and health

### Logging
- Request/response logging
- Error tracking and reporting
- Performance metrics collection
- User interaction analytics

## 🤝 Support & Contributing

### Getting Help
1. Check the documentation in each folder
2. Review n8n workflow logs
3. Test individual components
4. Verify API configurations

### Contributing
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## 📄 License

This project is provided as-is for educational and commercial use. Please ensure compliance with all third-party API terms of service.

## 🙏 Acknowledgments

- **OpenAI** for Speech-to-Text and AI capabilities
- **ElevenLabs** for Text-to-Speech services
- **n8n** for workflow automation platform
- **Vue.js** for the frontend framework

---

**Ready to revolutionize your customer support?** 🚀

Start with the voice chat app, then integrate the n8n workflow for a complete AI-powered customer experience!

