<script lang="ts" setup>

const startCall = () => {
    console.log('Call started!')
}
</script>

<template>
  <CallSetupPanel :onCallStart="startCall" />
</template>
