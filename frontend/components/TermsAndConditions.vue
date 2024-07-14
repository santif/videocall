<script setup>
import { ref, watch } from 'vue';

const accepted = ref(false);

const emit = defineEmits(['update:accepted']);

watch(accepted, (newValue) => {
  emit('update:accepted', newValue);
});
</script>

<template>
  <div class="flex items-center gap-2">
    <input type="checkbox" v-model="accepted" class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500" />
    <label class="text-gray-700">I agree to the terms and conditions</label>
  </div>
</template>
