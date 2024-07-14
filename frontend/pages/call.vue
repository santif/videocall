<script lang="ts" setup>

import { ref } from 'vue'

const startCall = () => {
    console.log('Call started!')
}
</script>

<template>
  <div>
    <h1>Videocall</h1>
    <button variant="destructive" @click="startCall">Start Call</button>
  </div>
</template>
