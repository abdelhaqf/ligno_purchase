<template>
  <div class="row justify-center q-pt-xl">
    <q-card class="loginForm">
      <q-card-section class="q-gutter-md">
        <q-input
          outlined
          v-model="user.username"
          label="Username"
          stack-label
          dense
        />
        <q-input
          type="password"
          outlined
          v-model="user.password"
          label="Password"
          stack-label
          dense
          @keyup.enter="login"
        />
      </q-card-section>

      <q-separator />

      <q-btn
        no-caps
        dense
        class="full-width no-border-radius"
        label="login"
        @click="login"
        color="primary"
      />
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
    this.$emit("isLogin", true);
  },
  methods: {
    async login() {
      var usr = {};
      usr.username = this.user.username;
      usr.password = md5(this.user.password);
      await this.$http
        .post("/login", usr, {})
        .then(async (result) => {
          await localStorage.setItem("token-purchase", result.data);
          this.$emit("isLogin", false);
          this.$emit("updateKurs");

          this.$http
            .get("/user/info/", {
              headers: {
                Authorization:
                  "Bearer " + localStorage.getItem("token-purchase"),
              },
            })
            .then((resp) => {
              if (resp.data.is_purchasing == 1 || resp.data.username == "ceo")
                this.$router.push("/dashboard");
              else this.$router.push("/spp/create");
            });
          this.$q.notify({ message: "Login Berhasil!", color: "positive" });
        })
        .catch((err) => {
          this.$q.notify({ message: "Login Gagal!", color: "negative" });
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
