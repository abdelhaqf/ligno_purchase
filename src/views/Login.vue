<template class="q-pa-none">
  <div class="row my-font" style="height: 100vh;">
    <div style="width: 50%;" class="bg-white column items-center justify-center"> 
      <q-img
          :src="require('@/assets/login_bg.png') "
          style="max-height: 100vh; max-width: 80vh;"
        />
    </div>
    <div style="width: 50%;" class="bg-grey-2 column justify-center">
      <q-card class="loginForm bg-grey-2 q-pa-lg" flat>
        <q-card-section class="column items-center q-gutter-y-md">
          <q-img
            :src="require('@/assets/Logo_Ligno.png') "
            style="max-width: 180px;"
          />
          <div style="max-width: 50vh;" class="column" >
            <div class="text-h4 text-weight-bold text-center">
              Selamat Datang Di Ligno app <span style="color: #0288D1;">Purchase</span>
            </div>
            <div class="text-right">
              <q-img
                :src="require('@/assets/Line.png') "
                style="max-width: 180px;"
              />
            </div>
          </div>
        </q-card-section>
        <q-card-section class="column q-gutter-y-md q-mt-md q-mx-lg">
          <div>
            <div>Username</div>
            <q-input
              outlined
              v-model="user.username"
              placeholder="Masukkan Username Anda"
              dense
              @keyup.enter="$refs.pass.focus()"
              class="q-mt-xs bg-white"
              autofocus
            />
          </div>

          <div>
            <div>Password</div>
            <q-input
              ref="pass"
              outlined
              v-model="user.password"
              placeholder="Masukkan Password Anda"
              dense
              @keyup.enter="login"
              class="q-mt-xs bg-white"
              :type="isPwd ? 'password' : 'text'"
            >
            <template v-slot:append>
              <q-icon
                :name="isPwd ? 'visibility_off' : 'visibility'"
                class="cursor-pointer"
                @click="isPwd = !isPwd"
              />
            </template>
            </q-input>
          </div>

          <q-btn
          no-caps
          dense
          class="full-width no-border-radius q-mt-lg q-pa-xs"
          label="Login"
          @click="login"
          color="blue-7"
        />
        </q-card-section>

        
    </q-card>
    </div>
  </div>
</template>

<script>
import md5 from "md5";

export default {
  data() {
    return {
      user: {},
      isPwd: true,
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
