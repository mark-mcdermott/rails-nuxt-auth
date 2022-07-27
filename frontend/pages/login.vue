<template>
  <v-layout>
    <v-flex>
      <Title :title="title"></Title>
      <v-card v-if="$auth.$state.loggedIn">
        <div v-if="!!error"></div>
        <v-alert type="error">{{error}}</v-alert>
        <v-card-text>
          Logged in as {{$auth.state.user.email}}
        </v-card-text>
        <v-card-actions>
          <v-btn @click="logout">Log out</v-btn>
        </v-card-actions>
      </v-card>
      <v-card v-else>
        <v-alert v-if="!!error" type="error">{{error}}</v-alert>
        <v-card-text>
          <v-form>
            <v-text-field v-model="email" label="Email" />
            <v-text-field v-model="password" label="Password" type="password" />
          </v-form>
          <v-card-actions>
            <v-btn @click="login">Log in</v-btn>
          </v-card-actions>
        </v-card-text>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
import Title from '@/components/Title';
export default {
  components: {Title},
  data () {
    return {
      title: 'Log In',
      email: '',
      password: '',
      error: null,
      value: ''
    }
  },
  methods: {
    login: function () {
      this.$auth.login({
        data: {
          user: {
            email: this.email,
            password: this.password
          }
        }
      }).catch(e => {this.error = e + ''})
    },
    logout: function () {
      this.$auth.logout().catch(e => {this.error = e + ''})
    }
  }
}
</script>