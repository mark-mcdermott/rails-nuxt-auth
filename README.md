### Source
based on https://medium.com/@fishpercolator/how-to-separate-frontend-backend-with-rails-api-nuxt-js-and-devise-jwt-cf7dd9da9d16

Here are changes I had to do from their tutorial (or stuff that wasn't obvious to me at first).

### Notes
- i didn't use docker. i just ran front and backend locally.
- uncomment rack-cors & jbuilder in backend Gemfile
- they are right that you can't make the tweaks to ApplicationController until after devise is installed. Make them after you install devise.
- my axios port in nuxt.config.js was 3000 
- make sure your nuxt.config.js modules look like this:
```
  modules: [
    '@nuxtjs/vuetify',
    '@nuxtjs/axios',
    '@nuxtjs/auth'
  ],
```
- change the v-alerts in the login template to this:
`<v-alert type="error">{{error}}</v-alert>`
- make sure you create the create/show .json.jbuilder files in app/views/devise/sessions/
- change all `$auth.state` references to `$auth.$state`
- change everything that says blacklist to denylist
  - the model file is called jwt_denylist.rb so the model generate line is `rails g model jwt_denylist jti:string:index exp:datetime`
  - the line in the model is `include Devise::JWT::RevocationStrategies::Denylist`
  - the migration will look like this:
  ```
  class CreateJwtDenylists < ActiveRecord::Migration[7.0]
    def change
      create_table :jwt_denylists do |t|
        t.string :jti, null: false
        t.datetime :exp, null: false
      end
      add_index :jwt_denylists, :jti
    end
  end
  ```
- user.rb looks like this:
```
class User < ApplicationRecord
  devise :database_authenticatable, 
         :registerable,
         :jwt_authenticatable, 
         jwt_revocation_strategy: JwtDenylist
end
```
- rails has changed some of the `secrets` to `credential`. The line to get the secret is still `rails secret`, though. The line to open the credential file in VS Code is `EDITOR='code --wait' rails credentials:edit`. The line to add in the credentials file will be `jwt_secret: <your secret>`, so for example: 
```
jwt_secret: 45a7335169c37a67c314671b698cfffeba735e46959a641479749aadce63fad7c430484f90be041a7c3d9b99b2480f687df6e22610b98e15f07006c1ae4eacff
```
Then the lines to add in `app/config/initializers/devise.rb` are
```
config.jwt do |jwt|
  jwt.secret = Rails.application.credentials.jwt_secret
end
```
and you can add those right after the `config.mailer` line on line 28.
- your sign in postman call will look like this https://share.cleanshot.com/wjRlEC
- to scope resources to /api in routes.rb, it will look like this:
```
Rails.application.routes.draw do  
  scope :api, defaults: {format: :json} do
    resources :private_data
    resources :public_data
    resources :examples
    devise_for :users, controllers: {sessions: 'sessions'}
    devise_scope :user do
      get 'users/current', to: 'sessions#show'
    end
  end
end

```
- i had to add the following three lines to backend/config/application.rb at line 25 to get rid of a "Your application has sessions disabled" error:
```
config.session_store :cookie_store, key: '_interslice_session'
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use config.session_store, config.session_options
```

### To Setup A Registration Page 
- With Devise there is no need to setup a registration controller in Rails. Rails is waiting for a POST on /users (actually on /api/users in our case because we've "scoped" our users resource to /api/ in routes.rb) with the content like this: `user: { email: test@example.com, password: 12345678 }` and it will add it automatically in the database when received.
- I used this for the signup page in Nuxt:
```
<template>
  <v-layout>
    <v-flex>
      <h1>Sign Up</h1>
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
```

### To Test/Demonstrate the Public/Private Routes Working Correctly
in `/backend`:
- `rails g scaffold PublicData datum:string`
- `rails db:migrate`
- `rails g scaffold PrivateData datum:string`
- `rails db:migrate`
- You can make a `db/seeds.rb` file like this:
```
PublicDatum.create(datum: "Public Datum 1")
PublicDatum.create(datum: "Public Datum 2")
PublicDatum.create(datum: "Public Datum 3")
PublicDatum.create(datum: "Public Datum 4")
PublicDatum.create(datum: "Public Datum 5")
PrivateDatum.create(datum: "Private Datum 1")
PrivateDatum.create(datum: "Private Datum 2")
PrivateDatum.create(datum: "Private Datum 3")
PrivateDatum.create(datum: "Private Datum 4")
PrivateDatum.create(datum: "Private Datum 5")
```
 and then run `rails db:seed` to seed the db
- I used a `layouts/default.vue` file like this. It has the navbar with links to the public/private pages.
```
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
```
- Then in `backend/app/controllers/private_data_controller.rb` I inserted this on line 2: 
```
before_action :authenticate_user!
``` 
- You can test the front and backend authentication by at first not having `before_action :authenticate_user!` in private_data_controller.rb and also not having `v-if="$auth.$state.loggedIn"` in the NuxtLink to the Private Data page in `layouts/default.vue`. So the "private data" will show completely publicly in that case. Then add `before_action :authenticate_user!` on the backend to private_data_controller.rb. Now when you load the page, you should get a 401 unauthorized error in the console and the data won't load. Then add `v-if="$auth.$state.loggedIn"` in the NuxtLink in the Private Data page and now the link won't show in the navbar if you're not logged in.

### To Run 
- `cd backend && bundle`
- `rails db:drop db:create db:migrate` 
- delete `backend/config/credentials.yml.enc`
- `rails secret` and copy the the long output string 
- `EDITOR='code --wait' rails credentials:edit` or `EDITOR="nano" rails credentials:edit`
  - if VS Code asks you if you want to open the encrypted file, click `OK`
  - delete the commented lines 
  - for the first line, add `jwt_secret=<secret>` where `<secret>` is the long string you copied above
  - save the file and close it
- `rails s`
- in another tab, `cd frontend && yarn && npm run dev`
- when frontend is done check for the url/port it says it's listening on and go there in your browser. it will be `http://localhost:<port>` but the port is chosen randomly each time
- if you can't login but it's giving you 200 status on the backend when you try, try the db and credential parts above again