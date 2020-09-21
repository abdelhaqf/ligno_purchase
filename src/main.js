import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './quasar'
import axios from 'axios'
import Vue2Filters from 'vue2-filters'



Vue.prototype.$http = axios.create({
  baseURL: "http://localhost/ligno_purchase/api",
});


Vue.use(Vue2Filters)

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
