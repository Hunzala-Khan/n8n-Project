<template>
  <div id="app">
    <div class="chat-container">
      <div class="header">
        <h1>🛍️ ShopKeeping Voice Chat</h1>
        <p>AI-powered customer support</p>
      </div>
      
      <div class="chat-messages" ref="messagesContainer">
        <div 
          v-for="(message, index) in messages" 
          :key="index" 
          :class="['message', message.type]"
        >
          <div class="message-content">
            <div class="message-text">{{ message.text }}</div>
            <div class="message-time">{{ formatTime(message.timestamp) }}</div>
          </div>
          <div class="message-avatar">
            {{ message.type === 'user' ? '👤' : '🤖' }}
          </div>
        </div>
      </div>
      
      <div class="voice-controls">
        <button 
          @click="toggleRecording" 
          :class="['record-btn', { recording: isRecording }]"
          :disabled="isProcessing"
        >
          {{ isRecording ? '🛑 Stop Recording' : '🎤 Start Recording' }}
        </button>
        
        <div v-if="isProcessing" class="processing">
          <div class="spinner"></div>
          <span>Processing your request...</span>
        </div>
        
        <div v-if="transcription" class="transcription">
          <strong>You said:</strong> {{ transcription }}
        </div>
      </div>
      
      <div class="status">
        <div class="status-item">
          <span class="status-label">Connection:</span>
          <span :class="['status-value', connectionStatus]">{{ connectionStatus }}</span>
        </div>
        <div class="status-item">
          <span class="status-label">Audio:</span>
          <span :class="['status-value', audioStatus]">{{ audioStatus }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { ref, onMounted, nextTick } from 'vue'
import axios from 'axios'

export default {
  name: 'App',
  setup() {
    const messages = ref([])
    const isRecording = ref(false)
    const isProcessing = ref(false)
    const transcription = ref('')
    const connectionStatus = ref('disconnected')
    const audioStatus = ref('disconnected')
    const messagesContainer = ref(null)
    
    let mediaRecorder = null
    let audioChunks = []
    let stream = null
    
    const addMessage = (text, type = 'user') => {
      messages.value.push({
        text,
        type,
        timestamp: new Date()
      })
      scrollToBottom()
    }
    
    const scrollToBottom = async () => {
      await nextTick()
      if (messagesContainer.value) {
        messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight
      }
    }
    
    const formatTime = (timestamp) => {
      return timestamp.toLocaleTimeString()
    }
    
    const startRecording = async () => {
      try {
        stream = await navigator.mediaDevices.getUserMedia({ audio: true })
        mediaRecorder = new MediaRecorder(stream)
        audioChunks = []
        
        mediaRecorder.ondataavailable = (event) => {
          audioChunks.push(event.data)
        }
        
        mediaRecorder.onstop = async () => {
          const audioBlob = new Blob(audioChunks, { type: 'audio/wav' })
          await processAudio(audioBlob)
        }
        
        mediaRecorder.start()
        isRecording.value = true
        audioStatus.value = 'recording'
        addMessage('🎤 Recording started...', 'system')
        
      } catch (error) {
        console.error('Error starting recording:', error)
        addMessage('❌ Error: Could not access microphone', 'system')
        audioStatus.value = 'error'
      }
    }
    
    const stopRecording = () => {
      if (mediaRecorder && isRecording.value) {
        mediaRecorder.stop()
        stream.getTracks().forEach(track => track.stop())
        isRecording.value = false
        audioStatus.value = 'processing'
        addMessage('🔄 Processing audio...', 'system')
      }
    }
    
    const toggleRecording = () => {
      if (isRecording.value) {
        stopRecording()
      } else {
        startRecording()
      }
    }
    
    const processAudio = async (audioBlob) => {
      isProcessing.value = true
      
      try {
        const formData = new FormData()
        formData.append('audio', audioBlob, 'voice-message.wav')
        formData.append('timestamp', new Date().toISOString())
        
        const response = await axios.post('http://localhost:5678/webhook/voice-chat', formData, {
          headers: {
            'Content-Type': 'multipart/form-data'
          }
        })
        
        if (response.data.success) {
          transcription.value = response.data.transcription
          addMessage(response.data.transcription, 'user')
          await waitForAIResponse(response.data.requestId)
        } else {
          throw new Error(response.data.error)
        }
        
      } catch (error) {
        console.error('Error processing audio:', error)
        addMessage('❌ Error processing audio', 'system')
      } finally {
        isProcessing.value = false
        audioStatus.value = 'ready'
      }
    }
    
    const waitForAIResponse = async (requestId) => {
      try {
        const maxAttempts = 30
        let attempts = 0
        
        while (attempts < maxAttempts) {
          await new Promise(resolve => setTimeout(resolve, 2000))
          
          const response = await axios.get(`http://localhost:5678/webhook/ai-response/${requestId}`)
          
          if (response.data.response) {
            addMessage(response.data.response, 'ai')
            if (response.data.audioUrl) {
              playAudioResponse(response.data.audioUrl)
            }
            break
          }
          
          attempts++
        }
        
        if (attempts >= maxAttempts) {
          addMessage('⏰ Timeout: AI response not received', 'system')
        }
        
      } catch (error) {
        console.error('Error waiting for AI response:', error)
        addMessage('❌ Error: Could not get AI response', 'system')
      }
    }
    
    const playAudioResponse = (audioUrl) => {
      const audio = new Audio(audioUrl)
      audio.play().catch(error => {
        console.error('Error playing audio:', error)
      })
    }
    
    const connectToServer = async () => {
      try {
        const response = await axios.get('http://localhost:5678/webhook/health')
        connectionStatus.value = 'connected'
        addMessage('✅ Connected to n8n server', 'system')
      } catch (error) {
        connectionStatus.value = 'disconnected'
        addMessage('❌ Disconnected from n8n server', 'system')
      }
    }
    
    onMounted(() => {
      addMessage('👋 Welcome to ShopKeeping Voice Chat!', 'system')
      addMessage('Click the microphone button to start talking', 'system')
      connectToServer()
      setInterval(connectToServer, 30000)
    })
    
    return {
      messages,
      isRecording,
      isProcessing,
      transcription,
      connectionStatus,
      audioStatus,
      messagesContainer,
      toggleRecording,
      formatTime
    }
  }
}
</script>

<style scoped>
#app {
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  height: 100vh;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 20px;
}

.chat-container {
  background: white;
  border-radius: 20px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 600px;
  height: 80vh;
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

.header {
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  color: white;
  padding: 20px;
  text-align: center;
}

.header h1 {
  margin: 0 0 10px 0;
  font-size: 24px;
}

.header p {
  margin: 0;
  opacity: 0.9;
}

.chat-messages {
  flex: 1;
  padding: 20px;
  overflow-y: auto;
  background: #f8f9fa;
}

.message {
  display: flex;
  margin-bottom: 15px;
  align-items: flex-end;
}

.message.user {
  flex-direction: row-reverse;
}

.message-content {
  max-width: 70%;
  padding: 12px 16px;
  border-radius: 18px;
  position: relative;
}

.message.user .message-content {
  background: #667eea;
  color: white;
  margin-left: 10px;
}

.message.ai .message-content {
  background: white;
  color: #333;
  border: 1px solid #e9ecef;
  border-radius: 18px;
  margin-right: 10px;
}

.message.system .message-content {
  background: #6c757d;
  color: white;
  font-size: 14px;
  text-align: center;
  margin: 10px auto;
}

.message-text {
  margin-bottom: 5px;
}

.message-time {
  font-size: 12px;
  opacity: 0.7;
}

.message-avatar {
  font-size: 24px;
  width: 40px;
  height: 40px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #f8f9fa;
  border-radius: 50%;
}

.voice-controls {
  padding: 20px;
  background: white;
  border-top: 1px solid #e9ecef;
}

.record-btn {
  width: 100%;
  padding: 15px;
  border: none;
  border-radius: 25px;
  background: #28a745;
  color: white;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: all 0.3s ease;
}

.record-btn:hover:not(:disabled) {
  background: #218838;
  transform: translateY(-2px);
}

.record-btn.recording {
  background: #dc3545;
  animation: pulse 1.5s infinite;
}

.record-btn:disabled {
  background: #6c757d;
  cursor: not-allowed;
}

@keyframes pulse {
  0% { transform: scale(1); }
  50% { transform: scale(1.05); }
  100% { transform: scale(1); }
}

.processing {
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 15px;
  color: #6c757d;
}

.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid #e9ecef;
  border-top: 2px solid #667eea;
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-right: 10px;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}

.transcription {
  margin-top: 15px;
  padding: 10px;
  background: #e9ecef;
  border-radius: 10px;
  font-size: 14px;
}

.status {
  padding: 15px 20px;
  background: #f8f9fa;
  border-top: 1px solid #e9ecef;
  display: flex;
  justify-content: space-between;
}

.status-item {
  display: flex;
  align-items: center;
  gap: 8px;
}

.status-label {
  font-size: 12px;
  color: #6c757d;
}

.status-value {
  font-size: 12px;
  font-weight: bold;
  padding: 4px 8px;
  border-radius: 12px;
}

.status-value.connected {
  background: #d4edda;
  color: #155724;
}

.status-value.disconnected {
  background: #f8d7da;
  color: #721c24;
}

.status-value.recording {
  background: #fff3cd;
  color: #856404;
}

.status-value.processing {
  background: #cce5ff;
  color: #004085;
}

.status-value.error {
  background: #f8d7da;
  color: #721c24;
}

.status-value.ready {
  background: #d4edda;
  color: #155724;
}
</style>
