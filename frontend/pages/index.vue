<template>
  <div>
    <h1>Really Cool Site</h1>
    <p v-if="$auth.$state.loggedIn">Logged In 👍</p>
    <p v-else>Logged Out 👎</p>
  </div>
</template>

<style scoped>
p { margin: 0 25px; }
</style>