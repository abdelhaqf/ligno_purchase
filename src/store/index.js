import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.prototype.$http = axios.create({
  baseURL: process.env.VUE_APP_BASE_URL,
});
Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentUser: null,
    countOfInformationCategory: [],
    printData: [],
  },
  mutations: {
    getCurrentUser(state, user) {
      state.currentUser = user;
    },
    setPrintData(state, data) {
      console.log("run");
      state.printData = data;
    },
  },
  actions: {
    async getCurrentUser(context) {
      if (!localStorage.getItem("token-purchase")) {
        context.commit("getCurrentUser", null);
        return null;
      }
      await Vue.prototype.$http
        .get("/user/info/", {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token-purchase"),
          },
        })
        .then((result) => {
          context.commit("getCurrentUser", result.data);
        })
        .catch((error) => {
          localStorage.removeItem("token-purchase");
          this.$router.push("/login");
        });
    },
    sendPrintData(context, data) {
      context.commit("setPrintData", data);
    },
  },
  getters: {
    getPrintData(state) {
      return state.printData;
    },
  },
  modules: {},
});
