<script setup>
import { ref, onMounted } from 'vue'
defineProps(['onCallStart'])

const video = ref(null)
const selectedCamera = ref('');
const cameras = ref([]);
const selectedMicrophone = ref('');
const microphones = ref([]);
const selectedSpeaker = ref('');
const speakers = ref([]);

onMounted(async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
    console.dir(stream);
    if (video && video.value) {
      video.value.srcObject = stream;
    }
  } catch (error) {
    console.error("Error accessing the camera", error);
  }
});
</script>

<template>
  <div class="flex flex-col gap-4">
    <div>
      <h1>Welcome</h1>
    </div>
    <div class="flex flex-row gap-4">
      <div>
        <video class="h-40" autoplay playsinline muted ref="video"></video>
      </div>
      <div class="flex flex-col gap-4">
        <div>
          <Select v-model="selectedCamera" :options="cameras" label="Camera" />
        </div>
        <div>
          <Select v-model="selectedMicrophone" :options="microphones" label="Microphone" />
        </div>
        <div>
          <Select v-model="selectedSpeaker" :options="speakers" label="Speaker" />
        </div>
      </div>
    </div>
    <div>
      <TextInput label="Name" />
    </div>
    <div>
      <TermsAndConditions />
    </div>
    <div>
      <Button @click="onCallStart">Start Call</Button>
    </div>
  </div>
</template>
