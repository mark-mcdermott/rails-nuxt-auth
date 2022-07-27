<template>
  <div>
    <v-layout>
      <v-flex>
        <v-toolbar>
          <v-toolbar-title><NuxtLink to="/">Cool Guy Site 😎</NuxtLink></v-toolbar-title>
          <v-spacer />
          <NuxtLink to="/public-data">Public Data</NuxtLink>
          <NuxtLink v-if="$auth.$state.loggedIn" to="/private-data">Private Data</NuxtLink>
          <NuxtLink v-if="!$auth.$state.loggedIn" to="/signup">Sign Up</NuxtLink>
          <NuxtLink v-if="!$auth.$state.loggedIn" to="/login">Log In</NuxtLink>
          <a v-if="$auth.$state.loggedIn" @click.prevent="logout">Log Out</a>
        </v-toolbar>
        <nuxt/>
      </v-flex>
    </v-layout>
  </div>
</template>

<script>
export default {
  methods: {
    logout: function () {
      this.$auth.logout().catch(e => {this.error = e + ''})
    }
  }
}
</script>

<style>
html {
  font-family: "Source Sans Pro", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 16px;
  color: #333;
}
h1 { margin: 20px; font-size: 65px; font-weight: bold; }
header a { margin: 0 10px; text-decoration: none; color: #333; font-weight: bold; }
</style>

