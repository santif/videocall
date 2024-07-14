<script setup>
import { ref, watch, onMounted } from 'vue';
import Select from '@/components/Select.vue';
import TextInput from '@/components/TextInput.vue';
import TermsAndConditions from '@/components/TermsAndConditions.vue';
import Button from '@/components/Button.vue';

defineProps(['onCallStart']);

const video = ref(null);
const selectedCamera = ref('');
const cameras = ref([]);
const selectedMicrophone = ref('');
const microphones = ref([]);
const selectedSpeaker = ref('');
const speakers = ref([]);

const getDevices = async () => {
  try {
    const devices = await navigator.mediaDevices.enumerateDevices();
    cameras.value = devices.filter(device => device.kind === 'videoinput').map(device => ({ deviceId: device.deviceId, label: device.label }));
    microphones.value = devices.filter(device => device.kind === 'audioinput').map(device => ({ deviceId: device.deviceId, label: device.label }));
    speakers.value = devices.filter(device => device.kind === 'audiooutput').map(device => ({ deviceId: device.deviceId, label: device.label }));
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
  } catch (error) {
    console.error("Error updating the stream", error);
  }
};

watch([selectedCamera, selectedMicrophone], updateStream);

onMounted(async () => {
  await getDevices();
  await updateStream();
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
        <Select v-model="selectedCamera" :options="cameras" label="Camera" />
        <Select v-model="selectedMicrophone" :options="microphones" label="Microphone" />
        <Select v-model="selectedSpeaker" :options="speakers" label="Speaker" />
      </div>
    </div>
    <TextInput label="Name" />
    <TermsAndConditions />
    <div class="flex justify-center">
      <Button @click="onCallStart">Join</Button>
    </div>
  </div>
</template>
