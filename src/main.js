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

new Vue({
  router,
  store,
  render: (h) => h(App),
}).$mount("#app");
