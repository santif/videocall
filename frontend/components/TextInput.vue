<script setup>
import { ref, watch } from 'vue';

const props = defineProps(['label']);
const inputValue = ref('');

const emit = defineEmits(['update:inputValue']);

watch(inputValue, (newValue) => {
  emit('update:inputValue', newValue);
});
</script>

<template>
  <div class="flex flex-col">
    <label class="text-gray-700 mb-2">{{ label }}</label>
    <input type="text" v-model="inputValue" class="p-2 border rounded-md shadow-sm" />
  </div>
</template>
