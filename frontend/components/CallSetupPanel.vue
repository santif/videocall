<script setup>
import { ref, onMounted } from 'vue'
defineProps(['onCallStart'])
const video = ref(null)

onMounted(async () => {
  const um = await navigator.mediaDevices.getUserMedia({ video: true, audio: true })
  video.value.srcObject = um
})
</script>

<template>
    <div>
        <h1>Videocall</h1>
        <video autoplay playsinline muted ref="video" style="width: 500px; height: 500px;"></video>
        <TermsAndConditions />
        <Button @click="onCallStart">Start Call</Button>
    </div>
</template>