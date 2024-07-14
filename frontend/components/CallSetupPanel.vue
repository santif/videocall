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
let audioContext = null;
let analyser = null;
let microphoneStream = null;
let animationFrameId = null;

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
      audioLevel.value = sum / dataArray.length;
      animationFrameId = requestAnimationFrame(updateAudioLevel);
    };

    updateAudioLevel();
  } catch (error) {
    console.error("Error updating the stream", error);
  }
};

watch([selectedCamera, selectedMicrophone], updateStream);

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
      <div class="flex-1">
        <video class="w-full max-h-96 rounded-md shadow-md" autoplay playsinline muted ref="video"></video>
      </div>
      <div class="flex flex-col gap-4 flex-1">
        <DeviceSelect v-model="selectedCamera" :options="cameras" label="Camera" />
        <DeviceSelect v-model="selectedMicrophone" :options="microphones" label="Microphone" />
        <DeviceSelect v-model="selectedSpeaker" :options="speakers" label="Speaker" />
        <AudioLevelMeter :level="audioLevel" />
      </div>
    </div>
    <TextInput label="Name" />
    <TermsAndConditions />
    <div class="flex justify-center">
      <Button @click="onCallStart">Join</Button>
    </div>
  </div>
</template>
