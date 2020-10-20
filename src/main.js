import Vue from 'vue'
import App from './App.vue'
import router from './router'
import store from './store'
import './quasar'
import axios from 'axios'
import Vue2Filters from 'vue2-filters'
// import money from 'v-money'

Vue.prototype.$http = axios.create({
  baseURL: "http://localhost/ligno_purchase/api",
});

Vue.use(require('vue-moment'));
Vue.use(Vue2Filters)
// Vue.use(money, {
//   decimal: ',',
//   thousands: '.',
//   prefix: 'Rp ',
//   suffix: '',
//   precision: 0,
//   masked: false
// })

Vue.config.productionTip = false

new Vue({
  router,
  store,
  render: h => h(App)
}).$mount('#app')
