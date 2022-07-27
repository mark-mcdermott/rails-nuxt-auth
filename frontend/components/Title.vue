<template>
  <div>
    <h1>{{title}}</h1>
    <p v-if="$auth.$state.loggedIn">Logged In 👍</p>
    <p v-else>Logged Out 👎</p>
  </div>
</template>

<script>
export default {
  props: ['title']
}
</script>

<style scoped>
p { margin: 0 25px; }
</style>

