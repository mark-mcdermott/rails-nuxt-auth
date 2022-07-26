based on https://medium.com/@fishpercolator/how-to-separate-frontend-backend-with-rails-api-nuxt-js-and-devise-jwt-cf7dd9da9d16

Here are changes I had to do from their tutorial (or stuff that wasn't obvious to me at first).

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
- change everything that says blacklist to denylist
  - the model file is called jwt_denylist.rb
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
- your sign in postman call will look like this https://share.cleanshot.com/wjRlEC

*** To Run 
- `cd backend && bundle && rails s`
- in another tab, `cd frontend && yarn && npm run dev`