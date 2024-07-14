<script lang="ts" setup>

const startCall = () => {
    console.log('Call started!')
}
</script>

<template>
  <div class="p-4">
    <CallSetupPanel :onCallStart="startCall" />
  </div>
</template>
