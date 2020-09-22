<template>
  <div class="container">
    <div class="row q-col-gutter-sm q-pa-md">
      <q-input  outlined v-model="user.username" label="Username" stack-label dense />
      <q-input type="password" outlined v-model="user.password" label="Password" stack-label dense />
      <div>
        <q-btn label="login" @click="login" no-caps dense />
      </div>
    </div>
  </div>
</template>

<script>
import md5 from 'md5'

export default {
  data(){
    return{
      user: {},
    }
  },
  mounted(){

  },
  methods:{
    login(){
      var usr = {}
      usr.username = this.user.username
      usr.password = md5(this.user.password)
      this.$http.post('/login', usr, {})
      .then (result => {
        localStorage.setItem('token', result.data)
        this.$router.push('/')
      })
    }
    

  }
}
</script>

<style lang="scss" scoped>
.container{
  position: fixed;
  height: 100vh; width: 100vw;
  left: 0px;z-index: 1000;
  background-color: azure;
}
  
</style>
