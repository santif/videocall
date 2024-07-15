<template>
    <div class="audio-meter">
      <div 
        v-for="i in segments" 
        :key="i" 
        :class="getSegmentClass(i)" 
        class="segment"
      ></div>
    </div>
  </template>
  
  <script setup lang="ts">
  import { defineProps, computed } from 'vue';
  
  const props = defineProps({
    level: {
      type: Number,
      required: true,
    },
  });
  
  const segments = 20; // Número de segmentos
  
  const segmentLevels = computed(() => {
    return Array.from({ length: segments }, (_, i) => (i + 1) * (100 / segments));
  });
  
  const getSegmentClass = (index: number) => {
    const level = (index + 1) * (100 / segments);
    if (props.level >= level) {
      if (index >= segments - 4) return 'segment active bg-red-500';
      if (index >= segments - 8) return 'segment active bg-yellow-400';
      return 'segment active bg-green-400';
    }
    return 'segment bg-gray-200';
  };
  </script>
  
  <style scoped>
  .audio-meter {
    @apply flex items-center gap-0.5 h-1;
  }
  
  .segment {
    @apply flex-1 h-1 transition-colors duration-100 ease-in-out;
  }
  </style>
  