<template>
  <q-layout view="hHh LpR fFf" class="bg-grey-2 my-font l-text-body">
    <q-header
      v-if="this.$route.name != 'Login'"
      unelevated
      class="bg-white text-black"
      style="box-shadow: 0 8px 28px 0 #f1f1f1  !important"
    >
      <q-toolbar class="q-py-xs">
        <q-img
          :src="`./Logo/ligno.png`"
          height="40px"
          width="115px"
          fit="contain"
        ></q-img>
        <q-space></q-space>
        <div class="relative-position q-mr-lg">
          <q-btn
            flat
            dense
            color="black"
            icon="notifications"
            @click="$router.push('/notification')"
          />
          <q-chip
            v-show="count_notif > 0"
            dense
            size="sm"
            style="top:5px;"
            class="absolute-center text-white"
            color="red-8"
            >{{ count_notif > 99 ? "99+" : count_notif }}</q-chip
          >
        </div>
        <div class="row items-center q-gutter-x-sm">
          <q-avatar>
            <img :src="'./avatar.png'" />
          </q-avatar>
          <q-btn-dropdown
            flat
            no-caps
            dropdown-icon="keyboard_arrow_down"
            dense
          >
            <template v-slot:label>
              <div class="text-left">
                <div class="text-bold">
                  {{ curUser ? curUser.name : "" }}
                </div>
                <div class="l-text-thin text-grey-6" style="line-height: 14px;">
                  {{ curUser ? curUser.dept : "" }}
                </div>
              </div>
            </template>

            <q-card class="row no-wrap all-radius column" style="width: 250px;">
              <q-card-section class="column items-center q-gutter-y-sm">
                <q-avatar size="72px">
                  <img :src="'./avatar.png'" />
                </q-avatar>
                <div class="text-center">
                  <div class="text-bold l-text-detail">
                    {{ curUser ? curUser.name : "" }}
                  </div>
                  <div
                    class="l-text-thin text-grey-6"
                    style="line-height: 14px;"
                  >
                    {{ curUser ? curUser.dept : "" }}
                  </div>
                </div>
              </q-card-section>

              <q-btn
                dense
                flat
                class="q-px-md q-py-xs"
                icon="lock"
                label="Ubah Sandi"
                no-caps
                align="left"
                v-close-popup
              />
              <q-separator size="1px" color="grey-4"></q-separator>
              <q-btn
                dense
                flat
                class="q-px-md q-py-xs"
                icon="logout"
                label="Logout"
                color="negative"
                no-caps
                align="left"
                v-close-popup
                @click="logout"
              />
            </q-card>
          </q-btn-dropdown>
        </div>
        <!-- <q-btn flat @click="logout" label="Keluar" no-caps icon="logout" /> -->
      </q-toolbar>
      <q-separator />
    </q-header>

    <!-- left drawer  -->
    <q-drawer
      v-if="!isLogin && $route.name != 'print_preview'"
      show-if-above
      v-model="left"
      side="left"
      bordered
      class="column"
      :mini="miniState"
      @mouseover="miniState = false"
      @mouseout="miniState = true"
      mini-to-overlay
    >
      <q-list class="column" style="height: 100%;">
        <!-- <q-item
          clickable
          v-ripple
          v-for="m in menu"
          :key="m.title"
          :to="m.link"
          :active="$route.name == m.name"
          class="inactive-menu"
          :active-class="
            miniState ? 'text-primary' : 'text-primary active-menu'
          "
        >
          <q-item-section avatar>
            <q-icon :name="m.icon" />
          </q-item-section>
          <q-item-section>
            <q-item-label class="row items-center">
              <div>{{ m.title }}</div>

              <q-badge
                rounded
                color="pink"
                class="q-ml-sm round-radius"
                v-if="m.count > 0"
                :label="m.count"
              ></q-badge>
            </q-item-label>
          </q-item-section>
        </q-item> -->
        <q-item
          clickable
          v-ripple
          :active="$route.name == 'Dashboard'"
          class="inactive-menu"
          :active-class="
            miniState ? 'text-primary' : 'text-primary active-menu'
          "
          to="/dashboard"
          v-can="['PURCHASING', 'PURCHASING MANAGER']"
        >
          <q-item-section avatar>
            <q-icon name="dashboard" />
          </q-item-section>
          <q-item-section>
            <q-item-label class="row items-center">
              <div>Dashboard</div>
            </q-item-label>
          </q-item-section>
        </q-item>
        <q-expansion-item
          class="cursor-pointer"
          :class="
            $route.name == 'SPPList' ||
            $route.name == 'SPPCreate' ||
            $route.name == 'SPPDetail'
              ? 'text-primary'
              : ''
          "
        >
          <template v-slot:header>
            <q-item-section avatar>
              <q-icon name="list_alt" />
            </q-item-section>
            <q-item-section>
              <q-item-label>SPP</q-item-label>
            </q-item-section>
          </template>
          <q-item
            active-class="active-menu"
            :active="$route.name == 'SPPList'"
            to="/spp/list"
            clickable
          >
            <q-item-section avatar></q-item-section>
            <q-item-section
              :class="$route.name == 'SPPList' ? 'text-primary' : 'text-black'"
              >List SPP Anda</q-item-section
            >
          </q-item>
          <q-item
            active-class="active-menu"
            :active="$route.name == 'SPPCreate'"
            to="/spp/create"
            clickable
          >
            <q-item-section avatar></q-item-section>
            <q-item-section
              :class="
                $route.name == 'SPPCreate' ? 'text-primary' : 'text-black'
              "
              >Buat SPP</q-item-section
            >
          </q-item>
        </q-expansion-item>
        <q-expansion-item
          class="cursor-pointer"
          :class="
            $route.name == 'SPPApprove' || $route.name == 'SPPApprovePM'
              ? 'text-primary'
              : ''
          "
          v-can="['PURCHASING', 'MANAGER']"
        >
          <template v-slot:header>
            <q-item-section avatar>
              <q-icon name="assignment_turned_in"> </q-icon>
              <q-chip
                v-if="
                  miniState &&
                    (count.count_approve > 0 || count.count_approvePM > 0)
                "
                dense
                size="sm"
                style="top:10px;right:3px"
                class="absolute-center text-white"
                color="red-8"
                >{{
                  parseInt(count.count_approve + count.count_approvePM)
                }}</q-chip
              >
            </q-item-section>
            <q-item-section>
              <q-item-label>
                Persetujuan &nbsp;
                <q-badge
                  class="q-ml-sm"
                  v-if="
                    !miniState &&
                      (count.count_approve > 0 || count.count_approvePM > 0)
                  "
                  rounded
                  color="red-8"
                  :label="parseInt(count.count_approve + count.count_approvePM)"
                ></q-badge>
              </q-item-label>
            </q-item-section>
          </template>
          <q-item
            active-class="active-menu"
            :active="$route.name == 'SPPApprove'"
            to="/approval/manager"
            clickable
            v-can="['MANAGER']"
          >
            <q-item-section avatar></q-item-section>
            <q-item-section
              :class="
                $route.name == 'SPPApprove' ? 'text-primary' : 'text-black'
              "
            >
              <q-item-label>
                Pers. Manager
                <q-badge
                  v-if="count.count_approve > 0"
                  rounded
                  color="red-8"
                  :label="count.count_approve"
                  class="q-ml-sm"
                ></q-badge>
              </q-item-label>
            </q-item-section>
          </q-item>
          <q-item
            active-class="active-menu"
            :active="$route.name == 'SPPApprovePM'"
            to="/approval/purchasing"
            clickable
            v-can="['PURCHASING MANAGER']"
          >
            <q-item-section avatar></q-item-section>
            <q-item-section
              :class="
                $route.name == 'SPPApprovePM' ? 'text-primary' : 'text-black'
              "
            >
              <q-item-label>
                Pers. Man. Purchasing
                <q-badge
                  v-if="count.count_approvePM > 0"
                  rounded
                  color="red-8"
                  :label="count.count_approvePM"
                  class="q-ml-sm"
                ></q-badge>
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-expansion-item>
        <q-item
          clickable
          v-ripple
          :active="$route.name == 'SPPApproved'"
          class="inactive-menu"
          :active-class="
            miniState ? 'text-primary' : 'text-primary active-menu'
          "
          to="/spp/approved"
          v-can="['PURCHASING', 'PURCHASING MANAGER']"
        >
          <q-item-section avatar>
            <q-icon name="fact_check" />
            <q-chip
              v-if="miniState && count.count_spp > 0"
              dense
              size="sm"
              style="top:10px;right:3px"
              class="absolute-center text-white"
              color="red-8"
              >{{ count.count_spp }}</q-chip
            >
          </q-item-section>
          <q-item-section>
            <q-item-label class="row items-center">
              SPP Disetujui
              <q-badge
                class="q-ml-sm"
                v-if="count.count_spp > 0"
                rounded
                color="red-8"
                :label="count.count_spp"
              ></q-badge>
            </q-item-label>
          </q-item-section>
        </q-item>
        <q-item
          clickable
          v-ripple
          :active="$route.name == 'POList'"
          class="inactive-menu"
          :active-class="
            miniState ? 'text-primary' : 'text-primary active-menu'
          "
          to="/po/list/null/null/null/null"
          v-can="['PURCHASING', 'PURCHASING MANAGER']"
        >
          <q-item-section avatar>
            <q-icon name="shopping_bag" />
            <q-chip
              v-if="miniState && count.count_spp > 0"
              dense
              size="sm"
              style="top:10px;right:3px"
              class="absolute-center text-white"
              color="red-8"
              >{{ count.count_po }}</q-chip
            >
          </q-item-section>
          <q-item-section>
            <q-item-label class="row items-center">
              List PO
              <q-badge
                class="q-ml-sm"
                v-if="count.count_po > 0"
                rounded
                color="red-8"
                :label="count.count_po"
              ></q-badge>
            </q-item-label>
          </q-item-section>
        </q-item>
        <q-item
          clickable
          v-ripple
          :active="$route.name == 'PriceList'"
          class="inactive-menu"
          :active-class="
            miniState ? 'text-primary' : 'text-primary active-menu'
          "
          to="/price/list"
          v-can="['PURCHASING', 'PURCHASING MANAGER']"
        >
          <q-item-section avatar>
            <q-icon name="price_check" />
          </q-item-section>
          <q-item-section>
            <q-item-label class="row items-center">
              <div>Daftar Harga</div>
            </q-item-label>
          </q-item-section>
        </q-item>
        <!-- menus -->
        <q-separator />
        <div style="flex-grow: 99 !important;"></div>
        <!-- <q-separator />
        <q-item clickable v-ripple>
          <q-item-section avatar>
            <q-icon name="keyboard_arrow_left" color="indigo-2" />
          </q-item-section>
          <q-item-label class="row items-center">Tutup Menu</q-item-label>
        </q-item> -->
      </q-list>
    </q-drawer>

    <q-page-container
      class="q-mx-auto q-py-md"
      style="max-width: 1440px;"
    >
      <q-card-section class="q-px-lg">
        <div>
          <q-breadcrumbs>
            <q-breadcrumbs-el
              class="text-grey-8"
              v-for="(el, i) in routeMeta ? routeMeta.path : []" :key="i"
              :label="el"
            />
            <q-breadcrumbs-el
              class="text-primary"
              :label="routeMeta ? routeMeta.title : ''"
            />
          </q-breadcrumbs>
        </div>
        <div
          class="l-text-title text-bold"
          style="line-height: 1.2 !important;"
        >
          {{ routeMeta ? routeMeta.title : "" }}
        </div>
      </q-card-section>
      <router-view
        v-if="$route.name == 'Login' || $store.state.currentUser"
        @isLogin="toggleLogin"
        @updateKurs="updateKurs"
      />
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
      count: {
        count_approve: 0,
        count_approvePM: 0,
        count_po: 0,
        count_spp: 0,
      },
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
      miniState: true,

      curRoute: {},
      routeMeta: null,
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
    $route(to, from) {
      if (to) {
        this.routeMeta = JSON.parse(JSON.stringify(to.meta));
      }
    },
    $store(to, from) {
      console.log("prev", from);
      console.log("next", to);
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
          name: "Home",
        });
      }
      // this.menu.push({
      //   icon: "create",
      //   title: "Buat SPP",
      //   link: "/spp/create",
      // });

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

          // this.menu.push({
          //   icon: "inbox",
          //   title: "SPP Anda",
          //   link: "/spp/list",
          // });
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
              link: "/po/list/null/null/null/null",
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
  computed: {
    ...mapState(["currentUser"]),
    curUser() {
      if (this.$store.state.currentUser) {
        return this.$store.state.currentUser;
      }
      return false;
    },
  },
};
</script>
<style lang="scss">
@import "@/styles/quasar.scss";
.stickyTable {
  .q-table__top,
  .q-table__bottom,
  thead tr:first-child th {
    background-color: #f0faff;
    color: black;
    text-align: center;
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

@font-face {
  font-family: mainfont;
  src: url(./styles/fonts/Oxygen-Regular.ttf);
}

@font-face {
  font-family: mainfont;
  src: url("./styles/fonts/Oxygen-Bold.ttf");
  font-weight: 700;
}
@font-face {
  font-family: mainfont;
  src: url("./styles/fonts/Oxygen-Regular.ttf");
  font-weight: 400;
}
@font-face {
  font-family: mainfont;
  src: url("./styles/fonts/Oxygen-Light.ttf");
  font-weight: 300;
}

.my-font {
  font-family: "mainfont";
  letter-spacing: 1px !important;
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
.l-text-thin {
  font-weight: 300 !important;
}
.l-text-thinner {
  font-weight: 200 !important;
}

.border-card {
  border-radius: 10px !important;
}

.long-text-dots {
  text-overflow: ellipsis;
  white-space: nowrap;
  overflow: hidden;
}

.kiri-radius {
  border: 1px solid #bbbbbb;
  border-radius: 8px 0 0 8px !important;
}

.kanan-radius {
  border: 1px solid #bbbbbb;
  border-radius: 0 8px 8px 0 !important;
}
.atas-radius {
  border: 1px solid #bbbbbb;
  border-radius: 8px 8px 0 0 !important;
}
.bawah-radius {
  border: 1px solid #bbbbbb;
  border-radius: 0 0 8px 8px !important;
}

.all-radius {
  border: 1px solid #bbbbbb;
  border-radius: 8px 8px 8px 8px !important;
}

.active-menu {
  padding-left: 14px !important;
  border-left: 2px solid $primary !important;
  background-color: #e6f3fa !important;
}

.inactive-menu {
  border-left: none;
}

.l-text-header {
  font-size: 48px !important;
  line-height: 1.8;
}

.l-text-title {
  font-size: 36px !important;
  line-height: 1.8;
}

.l-text-subtitle {
  font-size: 24px !important;
  line-height: 1.8;
}

.l-text-detail {
  font-size: 16px !important;
  line-height: 1.8;
}

.l-text-body {
  font-size: 13px !important;
  line-height: 1.8;
}

.l-text-description {
  font-size: 11px !important;
  line-height: 1.8;
}

.round-radius {
  border-radius: 500px !important;
}

.capsule {
  border-radius: 50px;
}

.l-grow {
  flex-grow: 99 !important;
}

button {
  letter-spacing: 1px !important;
}
</style>
