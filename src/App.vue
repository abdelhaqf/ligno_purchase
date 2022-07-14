<template>
  <q-layout view="hHh LpR fFf" class="bg-grey-1">
    <!-- left drawer  -->
    <q-drawer
      v-if="!isLogin && $route.name != 'print_preview'"
      content-class="bg-grey-2"
      show-if-above
      v-model="left"
      side="left"
      bordered
    >
      <!-- current user  -->
      <q-item class="bg-blue-2">
        <q-item-section avatar>
          <q-avatar>
            <img :src="'./avatar.png'" />
          </q-avatar>
        </q-item-section>
        <q-item-section v-if="$store.state.currentUser">
          <q-item-label class="text-subtitle2">{{
            $store.state.currentUser.username | capitalize
          }}</q-item-label>
          <q-item-label caption>{{
            $store.state.currentUser.dept
          }}</q-item-label>
        </q-item-section>
        <q-item-section class="relative-position">
          <q-btn
            flat
            dense
            color="indigo-4"
            icon="notifications"
            @click="$router.push('/notification')"
          />
          <q-chip
            v-show="count_notif > 0"
            dense
            size="sm"
            style="top:5px;"
            class="absolute-center text-white"
            color="orange-4"
            >{{ count_notif > 20 ? "20+" : count_notif }}</q-chip
          >
        </q-item-section>
        <q-item-section side>
          <q-item-label caption>
            <q-btn
              flat
              label="logout"
              size="sm"
              color="negative"
              @click="logout"
            />
          </q-item-label>
        </q-item-section>
      </q-item>
      <q-separator />
      <!-- menus -->
      <q-item clickable v-ripple v-for="m in menu" :key="m.title" :to="m.link">
        <q-item-section avatar>
          <q-icon :name="m.icon" color="indigo-2" />
        </q-item-section>
        <q-item-section>
          <q-item-label class="row items-center">
            <div>{{ m.title }}</div>
            <div style="height: 30px; padding: 0 5px;">
              <q-badge color="orange-4" v-if="m.count > 0">{{
                m.count
              }}</q-badge>
            </div>
          </q-item-label>
        </q-item-section>
      </q-item>
      <q-separator />
      <!-- <q-expansion-item label="Info Kurs" header-class="text-h6">
        <q-card class="relative-position bg-grey-2" flat>
          <q-card-section>
            <transition
              appear
              enter-active-class="animated fadeIn"
              leave-active-class="animated fadeOut"
            >
              <div v-if="showKurs">
                <q-list bordered separator class="bg-white rounded-borders">
                  <q-item>
                    <q-item-section>
                      <q-item-label class="text-subtitle2">BCA</q-item-label>
                    </q-item-section>
                    <q-item-section>
                      <q-item-label>Rp {{ kurs.Jsondata.bcarate | number("0,0") }}</q-item-label>
                      <q-item-label caption>{{ kurs.Jsondata.date3 }}</q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <q-item-label class="text-subtitle2">BI</q-item-label>
                    </q-item-section>
                    <q-item-section>
                      <q-item-label>Rp {{ kurs.Jsondata.birate | number("0,0") }}</q-item-label>
                      <q-item-label caption>{{ kurs.Jsondata.date2 }}</q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item>
                    <q-item-section>
                      <q-item-label class="text-subtitle2">MenKeu</q-item-label>
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
      </q-expansion-item> -->
    </q-drawer>

    <q-page-container>
      <!-- <q-scroll-area
        :visible="false"
        :thumb-style="thumbStyle"
        :bar-style="barStyle"
        style="height: 100vh;"
      > -->
      <router-view
        v-if="$route.name == 'Login' || $store.state.currentUser"
        @isLogin="toggleLogin"
        @updateKurs="updateKurs"
      />
      <!-- </q-scroll-area> -->
    </q-page-container>
  </q-layout>
</template>

<script>
import axios from "axios";
import { mapState, mapActions } from "vuex";
import Favico from "favico.js";
export default {
  data() {
    return {
      isLogin: false,
      left: false,
      isLoading: false,
      showKurs: false,
      kurs: [],
      count: {},
      menu: [],
      count_notif: 0,
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

      //interval var
      notifInterval: null,
      titleInterval: null,
      attention: 0,
      title: document.title,
      c: 0,
    };
  },
  async mounted() {
    this.$root.$on("refresh", async () => {
      // this.menu = []
      await this.fetchData();
    });

    if (localStorage.getItem("token-purchase") != "undefined") {
      this.$root.$on("notifikasi", async () => {
        this.$http
          .get("/count_notif/" + this.$store.state.currentUser.user_id, {})
          .then((result) => {
            this.count_notif = result.data.count;
          });
      });
      let token = localStorage.getItem("token-purchase") != "undefined";

      await this.preRun();
    }

    this.notifInterval = window.setInterval(async () => {
      if (this.$route.name != "Login" || this.$store.state.currentUser) {
        await this.reloadData();
      }
    }, 5000);
  },
  watch: {
    attention: (val) => {
      if (val > 0) {
        var favicon = new Favico({
          position: "up",
          animation: "popFade",
          bgColor: "#dd2c00",
          textColor: "#fff0e2",
        });
        favicon.badge(val);
      }
    },
  },
  methods: {
    ...mapActions(["getCurrentUser"]),
    async titleSettings() {
      this.c++;
      if (this.attention > 0) {
        if (this.c % 2 != 0) {
          document.title = `Ada ${this.attention} Approval!`;
        } else {
          document.title = this.title;
        }
      } else {
        document.title = this.title;
      }
    },
    async reloadData() {
      if (this.$route.name == "print_preview") {
        return;
      }
      await this.$http
        .get(
          "/count_data/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager,
          {}
        )
        .then((result) => {
          const audio = new Audio(
            `${process.env.VUE_APP_PUBLIC_URL}/music/notification.mp3`
          );

          let new_count =
            parseInt(result.data.count_approve) +
            parseInt(result.data.count_approvePM);
          if (new_count != this.attention) {
            audio.play();
          }
          this.attention = new_count;
          this.titleSettings();
          this.menu.forEach((x) => {
            if (x.link == "/spp/approval")
              this.$set(x, "count", result.data.count_approve);
            if (x.link == "/spp/approval-pm")
              this.$set(x, "count", result.data.count_approvePM);
            if (x.link == "/spp/approved")
              this.$set(x, "count", result.data.count_spp);
            if (x.link == "/po/list")
              this.$set(x, "count", result.data.count_po);
          });

          this.count = result.data;
        });
    },
    async preRun() {
      await this.getCurrentUser();
      this.fetchData();

      if (!this.$store.state.currentUser) {
        this.logout();
        this.$router.push("/login").catch(() => {});
        this.isLogin = true;
      } else {
        this.isLogin = false;
        this.isLoading = true;
        this.updateKurs();
      }
    },

    async fetchData() {
      if (this.$store.state.currentUser == null) return;
      this.menu = [];
      if (this.$store.state.currentUser?.is_purchasing == 1) {
        this.menu.push({
          icon: "dashboard",
          title: "Home",
          link: "/dashboard",
        });
      }
      this.menu.push({
        icon: "create",
        title: "Buat SPP",
        link: "/spp/create",
      });

      await this.$http
        .get(
          "/count_data/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager,
          {}
        )
        .then((result) => {
          this.count = result.data;
          this.menu.push({
            icon: "inbox",
            title: "SPP Anda",
            link: "/spp/list",
          });
          if (this.$store.state.currentUser.is_manager == "1") {
            this.menu.push({
              icon: "group",
              title: "Persetujuan Manager",
              link: "/spp/approval",
              count: result.data.count_approve,
            });
          }
          if (this.$store.state.currentUser.is_purch_manager == "1") {
            this.menu.push({
              icon: "how_to_reg",
              title: "Persetujuan Man.Purchasing",
              link: "/spp/approval-pm",
              count: result.data.count_approvePM,
            });
          }
          if (this.$store.state.currentUser.is_purchasing == "1") {
            this.menu.push({
              icon: "beenhere",
              title: "SPP Disetujui",
              link: "/spp/approved",
              count: result.data.count_spp,
            });
            this.menu.push({
              icon: "ballot",
              title: "PO",
              link: "/po/list/not/null/null",
              count: result.data.count_po,
            });
            this.menu.push({
              icon: "bar_chart",
              title: "List Harga",
              link: "/price/list",
            });
          }
        });

      await this.$http
        .get("/count_notif/" + this.$store.state.currentUser.user_id, {})
        .then((result) => {
          this.count_notif = result.data.count;
        });
    },
    toggleLogin(val) {
      this.isLogin = val;
      if (this.isLogin == false) this.preRun();
    },
    updateKurs() {
      // this.isLoading = true;
      // console.log("trying to update kurs...");
      // axios.get(process.env.VUE_APP_BASE_URL + "/../kurs_api").then(result => {
      //   this.kurs = result.data;
      //   this.isLoading = false;
      //   this.showKurs = true;
      //   console.log(this.kurs);
      //   console.log(this.kurs.Jsondata);
      // });
    },
    logout() {
      localStorage.removeItem("token-purchase");
      this.$router.push("/login");
    },
  },
  computed: mapState(["currentUser"]),
};
</script>
<style lang="scss">
.stickyTable {
  .q-table__top,
  .q-table__bottom,
  thead tr:first-child th {
    background-color: #027be3;
    color: white;
  }
  thead tr th {
    position: sticky;
    z-index: 1;
    font-weight: bold;
    // border: 0.1px solid grey;
  }
  thead tr:first-child th {
    top: 0;
  }
  &.q-table--loading thead tr:last-child th {
    top: 48px;
  }
}

@font-face {
  font-family: customfont;
  src: url(./css/fonts/times.ttf);
}
.printPaper {
  width: 190mm;
}

.my-font {
  font-family: "customfont";
}

.f10 {
  font-size: 10pt;
}
.f12 {
  font-size: 12pt;
}
.f14 {
  font-size: 14pt;
}
.f16 {
  font-size: 16pt;
}
.f18 {
  font-size: 18pt;
}
.f20 {
  font-size: 20pt;
}
</style>
