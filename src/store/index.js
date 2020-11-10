import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.prototype.$http = axios.create({
  baseURL: "http://192.168.100.209/ligno_purchase/api",
});
Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    currentUser: null,
    countOfInformationCategory: [],
  },
  mutations: {
    getCurrentUser(state, user) {
      state.currentUser = user;
    },
  },
  actions: {
    async getCurrentUser(context) {
      if (!localStorage.getItem("token")) {
        context.commit("getCurrentUser", null);
        return null;
      }
      await Vue.prototype.$http
        .get("/user/info/", {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token"),
          },
        })
        .then((result) => {
          context.commit("getCurrentUser", result.data);
        })
        .catch(error => {
          // console.log('error');
          localStorage.removeItem("token");
          this.$router.push("/login");
         })
    },
  },
  modules: {},
});
