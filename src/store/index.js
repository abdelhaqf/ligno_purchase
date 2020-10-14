import Vue from "vue";
import Vuex from "vuex";
import axios from "axios";

Vue.prototype.$http = axios.create({
  baseURL: "http://localhost/ligno_purchase/api",
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
      console.log(1);
      await Vue.prototype.$http
        .get("/user/info/", {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token"),
          },
        })
        .then((result) => {
          context.commit("getCurrentUser", result.data);
          console.log('2');
        })
        .catch(error => {
         })
    },
  },
  modules: {},
});
