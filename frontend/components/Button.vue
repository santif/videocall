<script setup>
const props = defineProps({
  label: String,
  disabled: {
    type: Boolean,
    default: false
  }
});
const emit = defineEmits(['click']);
</script>

<template>
  <button @click="$emit('click')"
          :disabled="props.disabled"
          :class="['px-4 py-2 rounded-md shadow-sm', 
                   props.disabled ? 'bg-gray-400 cursor-not-allowed' : 'bg-blue-600 hover:bg-blue-700 text-white']">
    <slot></slot>
  </button>
</template>

<style scoped>
.cursor-not-allowed {
  cursor: not-allowed;
}
</style>
