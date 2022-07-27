<template>
  <Title :title="title"></Title>
</template>

<script>
import Title from '@/components/Title';
export default {
  components: {Title},
  data() {
    return {
      title: 'Really Cool Site'
    }
  }
}
</script>

