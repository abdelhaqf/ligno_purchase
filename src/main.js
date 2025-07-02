import Vue from "vue";
import App from "./App.vue";
import router from "./router";
import store from "./store";
import "./quasar";
import axios from "axios";
import Vue2Filters from "vue2-filters";

// import money from 'v-money'

Vue.prototype.$http = axios.create({
  baseURL: process.env.VUE_APP_BASE_URL,
});

Vue.prototype.$http_formulation = axios.create({
  baseURL: process.env.VUE_APP_FORMULATION_URL,
});

Vue.use(require("vue-moment"));
Vue.use(Vue2Filters);

Vue.config.productionTip = false;

Vue.directive("can", {
  bind: async (el, binding, vnode) => {
    // vuex diisi saat sukses login
    let resp = await axios.get(`${process.env.VUE_APP_BASE_URL}/user/info/`, {
      headers: {
        Authorization: "Bearer " + localStorage.getItem("token-purchase"),
      },
    });

    let user = resp.data;
    if (user?.dept == "IT" && user?.is_manager == "1") {
      return;
    } else if (user?.user_id == 19) {
      return; // admin user
    } else if (
      binding.value.includes("PURCHASING") &&
      user?.is_purchasing == "1"
    ) {
      return;
    } else if (binding.value.includes("MANAGER") && user?.is_manager == "1") {
      return;
    } else if (
      binding.value.includes("PURCHASING MANAGER") &&
      user?.is_purch_manager == "1"
    ) {
      return;
    } else {
      vnode.elm.style.display = "none";
    }
  },
});

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
