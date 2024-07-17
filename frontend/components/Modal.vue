<template>
  <transition name="modal">
    <div v-if="props.visible" class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div class="bg-white rounded-lg shadow-lg w-11/12 md:w-1/2 lg:w-1/3 p-6">
        <div class="flex justify-between items-center mb-4">
          <h2 class="text-xl font-bold">
            <slot name="title"></slot>
          </h2>
          <button @click="close" class="text-gray-500 hover:text-gray-700">&times;</button>
        </div>
        <div class="mb-4">
          <slot name="content"></slot>
        </div>
        <div class="flex justify-end">
          <slot name="footer"></slot>
        </div>
      </div>
    </div>
  </transition>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  visible: {
    type: Boolean,
    default: false
  }
});

const emit = defineEmits(['close', 'accept']);

const close = () => {
  emit('close');
};

const accept = () => {
  emit('accept');
};
</script>

<style scoped>
.modal-enter-active, .modal-leave-active {
  transition: opacity 0.3s ease;
}
.modal-enter-from, .modal-leave-to {
  opacity: 0;
}
</style>
