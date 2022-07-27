<template>
  <div>
    <Title :title="title"></Title>
    <div v-if="!!data">
      <h3>Public Data:</h3>
      <ul>
        <li v-for="datum in data" :key="datum.datum">{{ datum.datum }}</li>
      </ul>
    </div>
  </div>
</template>

<script>
import Title from '@/components/Title';
export default {
  components: {Title},
  data() {
    return {
      title: 'Public Data',
      data: []
    }
  },
  mounted() {
    try {
      this.$axios.$get('public_data')
      .then((data) => {
        this.data = data;
      });
      // this.$router.push('/')
    } catch(e) {
      this.error = e + ''
    }
  }
}
</script>

<style lang="scss" scoped>
  h3 {
     margin: 40px 20px 20px 40px; 
  }
  ul { 
   margin: 20px 20px 20px 60px; 
    li { 
      margin: 10px 0;
    }
  }
</style>

