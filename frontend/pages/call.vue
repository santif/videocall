<script lang="ts" setup>

const startCall = () => {
    console.log('Call started!')
}
</script>

<template>
  <div>
    <h1>Videocall</h1>
    <video></video>
    <Button @click="startCall">Start Call</Button>
  </div>
</template>
