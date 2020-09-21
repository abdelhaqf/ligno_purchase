<template>
  <q-layout view="hHh LpR fFf">
    <q-drawer v-if="isLogin" show-if-above v-model="left" side="left" bordered>
      <q-item clickable v-ripple v-for="m in menu" :key="m.title" :to="m.link">
        <q-item-section>{{ m.title }}</q-item-section>
      </q-item>
    </q-drawer>

    <q-page-container>
      <q-scroll-area visible="false" :thumb-style="thumbStyle" :bar-style="barStyle" style="height: 100vh;">
        <router-view />
      </q-scroll-area>
    </q-page-container>
  </q-layout>
</template>

<script>
export default {
  data() {
    return {
      isLogin: true,
      left: false,
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
};
</script>
