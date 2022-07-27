<template>
  <v-layout>
    <v-flex>
      <Title :title="title"></Title>
      <v-card>
        <v-alert v-if="!!error" type="error">{{error}}</v-alert>
        <v-card-text>
          <v-form>
            <v-text-field v-model="email" label="Email" />
            <v-text-field v-model="password" label="Password" type="password" />
          </v-form>
          <v-card-actions>
            <v-btn @click="signup">Sign Up</v-btn>
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
      title: 'Sign Up',
      email: '',
      password: '',
      error: null,
      value: ''
    }
  },
  methods: {
    async signup() {
      try {
        await this.$axios.$post('users', {
          user: { email: this.email, password: this.password }
        })
        this.$router.push('/')
      } catch(e) {
        this.error = e + ''
      }
    }
  }
}
</script>