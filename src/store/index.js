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
      console.log('state change')
      state.currentUser = user;
    },
  },
  actions: {
    async getCurrentUser(context) {
      if (!localStorage.getItem("token")) {
        context.commit("getCurrentUser", null);
        return null;
      }
      console.log('creating http req')
      await Vue.prototype.$http
        .get("/user/info/", {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token"),
          },
        })
        .then((result) => {
          console.log('commiting to vuex')
          context.commit("getCurrentUser", result.data);
        })
        .catch(error => { })
    },
  },
  modules: {},
});
