<template>
  <div class="row justify-center q-pt-xl">
    <q-card class="loginForm">
      <q-card-section class="q-gutter-md">
        <q-input outlined v-model="user.username" label="Username" stack-label dense />
        <q-input type="password" outlined v-model="user.password" label="Password" stack-label dense @keyup.enter="login" />
      </q-card-section>

      <q-separator />

      <q-card-actions vertical>
        <q-btn label="login" @click="login" no-caps dense flat color="primary" />
      </q-card-actions>
    </q-card>
  </div>
</template>

<script>
import md5 from "md5";

export default {
  data() {
    return {
      user: {},
    };
  },
  mounted() {
    console.log("mount login");

    this.$emit("isLogin", true);
  },
  methods: {
    async login() {
      var usr = {};
      usr.username = this.user.username;
      usr.password = md5(this.user.password);
      await this.$http.post("/login", usr, {}).then(async (result) => {
        await localStorage.setItem("token", result.data);
        // await this.$store.dispatch("getCurrentUser");
        this.$emit("isLogin", false);
        this.$emit("updateKurs");
        console.log('before routing to home');
        // await this.$router.push("/");
        this.$router.push("/");
        console.log('after routing to home');
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.loginForm {
  min-width: 320px;
}
</style>
