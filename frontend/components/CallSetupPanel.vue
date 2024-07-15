<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';

defineProps(['onCallStart']);

const video = ref(null);
const selectedCamera = ref('');
const cameras = ref([]);
const selectedMicrophone = ref('');
const microphones = ref([]);
const selectedSpeaker = ref('');
const speakers = ref([]);
const audioLevel = ref(0);
const showModal = ref(false);
let audioContext = null;
let analyser = null;
let microphoneStream = null;
let animationFrameId = null;

const userName = ref('');
const termsAccepted = ref(false);
const joinButtonDisabled = ref(true);

const getDevices = async () => {
  try {
    const devices = await navigator.mediaDevices.enumerateDevices();
    cameras.value = devices.filter(device => device.kind === 'videoinput').map(device => ({ deviceId: device.deviceId, label: device.label }));
    microphones.value = devices.filter(device => device.kind === 'audioinput').map(device => ({ deviceId: device.deviceId, label: device.label }));
    speakers.value = devices.filter(device => device.kind === 'audiooutput').map(device => ({ deviceId: device.deviceId, label: device.label }));

    // Set default devices
    if (cameras.value.length > 0) {
      selectedCamera.value = cameras.value[0].deviceId;
    }
    if (microphones.value.length > 0) {
      selectedMicrophone.value = microphones.value[0].deviceId;
    }
    if (speakers.value.length > 0) {
      selectedSpeaker.value = speakers.value[0].deviceId;
    }
  } catch (error) {
    console.error("Error accessing media devices", error);
  }
};

const updateStream = async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({
      video: { deviceId: selectedCamera.value ? { exact: selectedCamera.value } : undefined },
      audio: { deviceId: selectedMicrophone.value ? { exact: selectedMicrophone.value } : undefined }
    });
    if (video.value) {
      video.value.srcObject = stream;
    }

    if (audioContext) {
      audioContext.close();
    }

    audioContext = new (window.AudioContext || window.webkitAudioContext)();
    analyser = audioContext.createAnalyser();
    microphoneStream = audioContext.createMediaStreamSource(stream);
    microphoneStream.connect(analyser);
    analyser.fftSize = 256;

    const dataArray = new Uint8Array(analyser.frequencyBinCount);

    const updateAudioLevel = () => {
      analyser.getByteFrequencyData(dataArray);
      const sum = dataArray.reduce((a, b) => a + b, 0);
      const average = sum / dataArray.length;
      audioLevel.value = Math.round((average / 255) * 100);
      animationFrameId = requestAnimationFrame(updateAudioLevel);
    };

    updateAudioLevel();
  } catch (error) {
    console.error("Error updating the stream", error);
  }
};

const checkJoinButtonState = () => {
  joinButtonDisabled.value = !(userName.value && termsAccepted.value);
};

const showTermsAndConditions = () => {
  showModal.value = true;
};

const handleAccept = () => {
  termsAccepted.value = true;
  showModal.value = false;
};

watch([selectedCamera, selectedMicrophone], updateStream);
watch([userName, termsAccepted], checkJoinButtonState);

onMounted(async () => {
  await getDevices();
  await updateStream();
});

onUnmounted(() => {
  if (animationFrameId) {
    cancelAnimationFrame(animationFrameId);
  }
  if (audioContext) {
    audioContext.close();
  }
});
</script>

<template>
  <div class="flex flex-col gap-6 p-4 bg-gray-100 rounded-md shadow-md">
    <h1 class="text-2xl font-bold mb-4">Welcome</h1>
    <div class="flex flex-col md:flex-row gap-4">
      <div class="flex-1 relative max-h-96">
        <video class="w-full h-full rounded-md shadow-md" autoplay playsinline muted ref="video"></video>
        <div class="absolute bottom-2 left-2 bg-black bg-opacity-50 text-white p-2 rounded-md z-50">
          {{ userName }}
        </div>
      </div>
      <div class="flex flex-col gap-4 flex-1">
        <DeviceSelect v-model="selectedCamera" :options="cameras" label="Camera" />
        <DeviceSelect v-model="selectedMicrophone" :options="microphones" label="Microphone" />
        <AudioLevelMeter :level="audioLevel" />
        <DeviceSelect v-model="selectedSpeaker" :options="speakers" label="Speaker" />
      </div>
    </div>
    <TextInput v-model="userName" label="Name" />
    <div class="flex items-center gap-2">
      <input type="checkbox" v-model="accepted" class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500" />
      <label class="text-gray-700">I agree to the terms and conditions</label>
      <a href="#" class="text-blue-600 hover:underline" @click="showTermsAndConditions">Read more</a>
    </div>
    <div class="flex justify-center">
      <Button :disabled="joinButtonDisabled" @click="onCallStart">Join</Button>
    </div>
  </div>

  <Modal v-if="showModal" @close="showModal = false" @accept="handleAccept">
    <template #title>Terms and Conditions</template>
    <template #content>
      <!-- Contenido del modal con los términos y condiciones -->
      <p>Your terms and conditions go here...</p>
    </template>
    <template #footer>
      <Button @click="handleAccept">Accept</Button>
    </template>
  </Modal>
</template>
