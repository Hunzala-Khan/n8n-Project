# ShopKeeping Voice Chat App

A Vue.js-based voice chat application that integrates with n8n workflows for AI-powered customer support.

## Features

- 🎤 Real-time voice recording
- 🤖 AI-powered responses via n8n
- 📊 Excel data analysis integration
- 🔊 Text-to-Speech (TTS) responses
- 💬 Real-time chat interface
- 📱 Responsive design

## Setup

1. Install dependencies:
```bash
npm install
```

2. Start development server:
```bash
npm run dev
```

3. The app will be available at `http://localhost:3000`

## Requirements

- Node.js 16+ 
- Modern browser with microphone access
- n8n server running on port 5678
- Active internet connection for AI services

## How it works

1. User clicks microphone button to start recording
2. Audio is sent to n8n workflow via webhook
3. n8n processes audio through STT (Speech-to-Text)
4. Text is analyzed by AI model
5. Excel data is analyzed for context
6. AI generates response
7. Response is converted to audio via TTS
8. Audio response is sent back to the app

## API Endpoints

- `POST /webhook/voice-chat` - Send audio for processing
- `GET /webhook/ai-response/{requestId}` - Get AI response
- `GET /webhook/health` - Check server status

## Environment Variables

Create a `.env` file in the root directory:

```env
VITE_N8N_WEBHOOK_URL=http://localhost:5678/webhook
VITE_API_TIMEOUT=30000
```

