<script lang="ts" setup>
import { ref, onMounted } from 'vue';

const videoElement = ref<HTMLVideoElement | null>(null);

onMounted(async () => {
  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true });
    console.dir(stream);
    if (videoElement && videoElement.value) {
      videoElement.value.srcObject = stream;
    }
  } catch (error) {
    console.error("Error accessing the camera", error);
  }
});
</script>

<template>
    
</template>