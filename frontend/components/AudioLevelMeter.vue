<template>
    <div class="audio-meter" :style="{ width: level + '%' }"></div>
</template>

<script setup>
import { ref, watchEffect } from 'vue';

defineProps({
    level: {
        type: Number,
        required: true,
    },
});
</script>

<style scoped>
.audio-meter {
    height: 10px;
    background-color: green;
    transition: width 0.1s ease-in-out;
}
</style>