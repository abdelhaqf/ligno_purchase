<template>
  <q-layout view="hHh LpR fFf">
    <q-drawer v-if="!isLogin" show-if-above v-model="left" side="left" bordered>
      <q-item>
        <q-item-section avatar>
          <q-avatar>
            <img src="https://cdn.quasar.dev/img/boy-avatar.png" />
          </q-avatar>
        </q-item-section>
        <q-item-section v-if="$store.state.currentUser">
          <q-item-label>
            {{ $store.state.currentUser.username }}
          </q-item-label>
          <q-item-label caption>
            {{ $store.state.currentUser.dept }}
          </q-item-label>
        </q-item-section>
        <q-item-section side>
          <q-item-label caption><q-btn flat label="logout" size="sm" color="negative" @click="logout"/></q-item-label>
        </q-item-section>
      </q-item>

      <q-separator />
      <q-item clickable v-ripple v-for="m in menu" :key="m.title" :to="m.link">
        <q-item-section>
          <q-item-label class="row items-center">
            <div>{{ m.title }}</div>
            <div style="height: 30px; padding: 0 5px;">
              <q-badge color="orange"  v-if="m.count> 0">{{m.count}}</q-badge>
            </div>
          </q-item-label>
        </q-item-section>
      </q-item>
      <q-separator />
      <q-card class="relative-position" flat>
        <q-card-section class="q-pb-none">
          <div class="text-h6">Currency</div>
        </q-card-section>

        <q-card-section>
          <transition appear enter-active-class="animated fadeIn" leave-active-class="animated fadeOut">
            <div v-if="showKurs">
              <q-list bordered separator>
                <q-item>
                  <q-item-section>
                    <q-item-label>BCA</q-item-label>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Rp {{ kurs.Jsondata.bcarate | number("0,0") }}</q-item-label>
                    <q-item-label caption>{{ kurs.Jsondata.date3 }}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label>BI</q-item-label>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Rp {{ kurs.Jsondata.birate | number("0,0") }}</q-item-label>
                    <q-item-label caption>{{ kurs.Jsondata.date2 }}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label>MenKeu</q-item-label>
                  </q-item-section>
                  <q-item-section>
                    <q-item-label>Rp {{ kurs.Jsondata.menkeurate | number("0,0") }}</q-item-label>
                    <q-item-label caption>{{ kurs.Jsondata.date1 }}</q-item-label>
                  </q-item-section>
                </q-item>
              </q-list>
            </div>
          </transition>
        </q-card-section>

        <q-inner-loading :showing="isLoading">
          <q-spinner-gears size="50px" color="primary" />
        </q-inner-loading>
      </q-card>
    </q-drawer>

    <q-page-container>
      <q-scroll-area :visible="false" :thumb-style="thumbStyle" :bar-style="barStyle" style="height: 100vh;">
        <router-view @isLogin="toggleLogin" @updateKurs="updateKurs" />
      </q-scroll-area>
    </q-page-container>
  </q-layout>
</template>

<script>
import axios from "axios";
import { mapState, mapActions } from "vuex";


export default {
  data() {
    return {
      isLogin: false,
      left: false,
      isLoading: false,
      showKurs: false,
      kurs: [],
      count: {},
      menu: [
      ],
      thumbStyle: {
        right: "4px",
        borderRadius: "5px",
        backgroundColor: "#027be3",
        width: "5px",
        opacity: 0.75,
      },

      barStyle: {
        right: "2px",
        borderRadius: "9px",
        backgroundColor: "#027be3",
        width: "9px",
        opacity: 0.2,
      },
    };
  },
  mounted() {
    this.$root.$on('refresh', async ()=>{
      // this.menu = []
      console.log('emit refresh')
      await this.fetchData()
    })

    console.log(5);
    this.preRun()
    
  },
  methods: {
    ...mapActions(["getCurrentUser"]),

    async preRun(){
      console.log('prerun before getuser');
      await this.getCurrentUser();
      this.fetchData()
      console.log('prerun after getuser');

      if (!this.$store.state.currentUser) {
        this.logout()
        this.$router.push("/login").catch(() => {});
        this.isLogin = true;
      } 
      else {
        
        this.isLogin = false;
        this.isLoading = true;
        this.updateKurs();
      }
    },

    fetchData(){
      this.menu = []
      console.log('start fetch data');
      this.menu.push({
                  title: "Buat SPP",
                  link: "/spp/create",
                })

      this.$http.get('/count_data/' 
                      + this.$store.state.currentUser.user_id+'/'
                      + this.$store.state.currentUser.is_purch_manager, {})
        .then (result => {
          this.count = result.data
          this.menu.push({
            title: "SPP",
            link: "/spp/list",
          })
          if(this.$store.state.currentUser.is_manager=='1'){
            this.menu.push({
              title: "Persetujuan Manager",
              link: "/spp/approval",
              count: result.data.count_approve
            })
          }
          if(this.$store.state.currentUser.is_purch_manager=='1'){
            this.menu.push({
              title: "Persetujuan Manager Purchasing",
              link: "/spp/approval-pm",
              count: result.data.count_approvePM
            })
          }
          if(this.$store.state.currentUser.is_purchasing=='1'){
            this.menu.push({
              title: "SPP Disetujui",
              link: "/spp/approved",
              count: result.data.count_spp
            })
            this.menu.push({
              title: "PO",
              link: "/po/list",
              count: result.data.count_po
            })
            this.menu.push({
              title: "List Harga",
              link: "/price/list",
            })
          }

        })
    },
    toggleLogin(val) {
      this.isLogin = val
      if(this.isLogin == false)
      this.preRun()
    },
    updateKurs() {
      // this.menu = []
      this.isLoading = true;
      axios.get("http://192.168.100.209/lignoapp/kurs_api").then((result) => {
        this.kurs = result.data;
        this.isLoading = false;
        this.showKurs = true;

        // this.fetchData()
      });
    },
    logout() {
      localStorage.removeItem("token");
      this.$router.push("/login");
    },
  },
  computed: mapState(["currentUser"]),

};
</script>
