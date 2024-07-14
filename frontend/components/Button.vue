<script setup>
const props = defineProps(['label']);
const emit = defineEmits(['click']);
</script>

<template>
  <button @click="$emit('click')"
          class="px-4 py-2 bg-blue-600 text-white rounded-md shadow-sm hover:bg-blue-700">
    <slot></slot>
  </button>
</template>
