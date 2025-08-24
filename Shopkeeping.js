<template>
  <div class="app">
    <h1>🎙️ Shopkeeping Voice Assistant</h1>

    <div class="status">
      <p>Connection: {{ connectionStatus }}</p>
      <p v-if="isProcessing">⏳ Processing your audio...</p>
    </div>

    <div class="chat-box">
      <div v-for="(msg, index) in messages" :key="index" :class="['message', msg.sender]">
        <strong>{{ msg.sender }}:</strong> {{ msg.text }}
      </div>
    </div>

    <div class="controls">
      <button @click="startRecording" :disabled="isRecording">🎤 Start</button>
      <button @click="stopRecording" :disabled="!isRecording">⏹️ Stop</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import axios from 'axios'

const connectionStatus = ref('disconnected')
const isRecording = ref(false)
const isProcessing = ref(false)
const messages = ref([])
const transcription = ref('')
let mediaRecorder
let audioChunks = []

// ✅ Add chat message
const addMessage = (text, sender) => {
  messages.value.push({ text, sender })
}

// ✅ Start audio recording
const startRecording = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ audio: true })
    mediaRecorder = new MediaRecorder(stream)
    audioChunks = []

    mediaRecorder.ondataavailable = event => {
      if (event.data.size > 0) audioChunks.push(event.data)
    }

    mediaRecorder.onstop = () => {
      const audioBlob = new Blob(audioChunks, { type: 'audio/wav' })
      processAudio(audioBlob)
    }

    mediaRecorder.start()
    isRecording.value = true
    addMessage('🎤 Recording started...', 'system')
  } catch (error) {
    console.error('Mic error:', error)
    addMessage('❌ Could not access microphone', 'system')
  }
}

// ✅ Stop audio recording
const stopRecording = () => {
  if (mediaRecorder && isRecording.value) {
    mediaRecorder.stop()
    isRecording.value = false
    addMessage('🛑 Recording stopped', 'system')
  }
}

// ✅ Send audio to n8n webhook
const processAudio = async (audioBlob) => {
  isProcessing.value = true
  try {
    const formData = new FormData()
    formData.append('audio', audioBlob, 'voice-message.wav')

    const response = await axios.post(
      'https://hunzalakhan.app.n8n.cloud/webhook-test/Shopkeeping',
      formData,
      { headers: { 'Content-Type': 'multipart/form-data' } }
    )

    if (response.data.transcription) {
      transcription.value = response.data.transcription
      addMessage(response.data.transcription, 'user')
    }

    if (response.data.response) {
      addMessage(response.data.response, 'ai')
    }

    if (response.data.audioUrl) {
      playAudioResponse(response.data.audioUrl)
    }
  } catch (error) {
    console.error('Error processing audio:', error)
    addMessage('❌ Error sending audio to n8n', 'system')
  } finally {
    isProcessing.value = false
  }
}

// ✅ Play AI voice reply (if provided)
const playAudioResponse = (url) => {
  const audio = new Audio(url)
  audio.play()
}

// ✅ Test server connection
const connectToServer = async () => {
  try {
    await axios.get('https://hunzalakhan.app.n8n.cloud/webhook-test/Shopkeeping')
    connectionStatus.value = 'connected'
    addMessage('✅ Connected to n8n server', 'system')
  } catch (error) {
    connectionStatus.value = 'disconnected'
    addMessage('❌ Could not connect to n8n server', 'system')
  }
}

// Auto-connect when app loads
connectToServer()
</script>

<style>
.app {
  font-family: Arial, sans-serif;
  max-width: 600px;
  margin: auto;
  padding: 20px;
}

.status {
  margin-bottom: 10px;
}

.chat-box {
  border: 1px solid #ccc;
  padding: 10px;
  height: 250px;
  overflow-y: auto;
  margin-bottom: 10px;
}

.message {
  margin: 5px 0;
}
.message.user {
  color: blue;
}
.message.ai {
  color: green;
}
.message.system {
  color: gray;
  font-style: italic;
}

.controls button {
  margin-right: 10px;
  padding: 10px;
}
</style>
