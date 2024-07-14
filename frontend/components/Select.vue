<script setup>
import { ref, watch } from 'vue';

const props = defineProps(['label', 'modelValue', 'options']);
const emit = defineEmits(['update:modelValue']);
const selectedOption = ref(props.modelValue);

watch(() => props.modelValue, (newValue) => {
  selectedOption.value = newValue;
});

watch(selectedOption, (newValue) => {
  emit('update:modelValue', newValue);
});
</script>

<template>
  <div class="flex flex-col">
    <label class="text-gray-700 mb-2">{{ label }}</label>
    <select v-model="selectedOption" class="p-2 border rounded-md shadow-sm">
      <option v-for="option in options" :key="option.deviceId" :value="option.deviceId">
        {{ option.label || option.deviceId }}
      </option>
    </select>
  </div>
</template>
