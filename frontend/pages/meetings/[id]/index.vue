<script lang="ts" setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import CallSetupPanel from '@/components/CallSetupPanel.vue';

const route = useRoute();
const router = useRouter();
const meetingId = route.params.id as string;

const meetingStatus = ref<string | null>(null);
const userSetupComplete = ref<boolean>(false);

const fetchMeetingDetails = async () => {
  // Simula la llamada al backend para obtener el estado de la reunión y la configuración del usuario
  // Aquí deberías reemplazar esto con una llamada real a tu backend
  const response = await fetch(`/api/v1/meetings/${meetingId}`);
  const data = await response.json();
  meetingStatus.value = data.status;
  userSetupComplete.value = data.userSetupComplete;
};

onMounted(() => {
  fetchMeetingDetails();
});

const startCall = () => {
  userSetupComplete.value = true;
  // Aquí puedes agregar lógica para iniciar la llamada, si es necesario
};

</script>

<template>
  <div class="p-4">
    <template v-if="meetingStatus === 'ended'">
      <MeetingSummary :meetingId="meetingId" />
    </template>
    <template v-else-if="meetingStatus === 'ready' || meetingStatus === 'ongoing'">
      <template v-if="!userSetupComplete">
        <CallSetupPanel :onCallStart="startCall" />
      </template>
      <template v-else>
        <CallPanel :meetingId="meetingId" />
      </template>
    </template>
    <template v-else>
      <p>La reunión no está disponible.</p>
    </template>
  </div>
</template>
