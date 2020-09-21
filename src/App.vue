<template>
  <q-layout view="hHh LpR fFf">
    <q-drawer v-if="isLogin" show-if-above v-model="left" side="left" bordered>
      <q-item clickable v-ripple v-for="m in menu" :key="m.title" :to="m.link">
        <q-item-section>{{ m.title }}</q-item-section>
      </q-item>

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
                    <q-item-label>Rp {{kurs.Jsondata.bcarate | number('0,0')}}</q-item-label>
                    <q-item-label caption>{{kurs.Jsondata.date3}}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label>BI</q-item-label>
                  </q-item-section>
                   <q-item-section>
                    <q-item-label>Rp {{kurs.Jsondata.birate | number('0,0')}}</q-item-label>
                    <q-item-label caption>{{kurs.Jsondata.date2}}</q-item-label>
                  </q-item-section>
                </q-item>
                <q-item>
                  <q-item-section>
                    <q-item-label>MenKeu</q-item-label>
                  </q-item-section>
                   <q-item-section>
                    <q-item-label>Rp {{kurs.Jsondata.menkeurate | number('0,0')}}</q-item-label>
                    <q-item-label caption>{{kurs.Jsondata.date1}}</q-item-label>
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
        <router-view />
      </q-scroll-area>
    </q-page-container>
  </q-layout>
</template>

<script>
import axios from "axios";


export default {
  data() {
    return {
      isLogin: true,
      left: false,
      isLoading: false,
      showKurs: false,
      kurs: [],
      menu: [
        {
          title: "Buat SPP",
          link: "/spp/create",
        },
        {
          title: "List SPP",
          link: "/spp/list",
        },
        {
          title: "Persetujuan Manager",
          link: "/spp/approve",
        },
        {
          title: "List PO",
          link: "/po/list",
        },
        {
          title: "List Harga",
          link: "/price/list",
        },
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
    this.isLoading = true;
    this.updateKurs();
  },
  methods: {
    updateKurs() {
      axios.get("http://192.168.100.209/lignoapp/kurs_api").then((result) => {
        this.kurs = result.data;
        // console.log(result)
        this.isLoading = false;
        this.showKurs = true;
      });
    },
  },
};
</script>
