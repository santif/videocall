<script lang="ts" setup>
import { defineProps } from 'vue'

defineProps(['label'])
</script>

<template>
    <input type="text" class="border border-gray-300 rounded-md p-2 w-full" :placeholder="label" />
</template>