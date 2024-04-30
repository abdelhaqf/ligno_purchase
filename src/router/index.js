import Vue from "vue";
import VueRouter from "vue-router";
import axios from "axios";
Vue.use(VueRouter);

const routes = [
  {
    path: "/dashboard",
    name: "Home",
    component: () => import("../views/Home.vue"),
  },
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/Login.vue"),
  },
  {
    path: "/spp/list",
    name: "SPPList",
    component: () => import("../views/SPPList.vue"),
    meta: { title: "Daftar SPP", path: ["SPP"] },
  },
  {
    path: "/spp/create",
    name: "SPPCreate",
    component: () => import("../views/SPPCreate.vue"),
    meta: { title: "SPP Baru", path: ["SPP", "Daftar SPP"] },
  },
  {
    path: "/spp/detail/:id",
    name: "SPPDetail",
    component: () => import("../views/SPPDetail.vue"),
    meta: { title: "SPP Detail", path: ["SPP", "Daftar SPP"] },
  },
  {
    path: "/approval/manager",
    name: "SPPApprove",
    component: () => import("../views/SPPApproval.vue"),
    meta: { title: "Persetujuan Manager", path: ["Persetujuan"] },
  },
  {
    path: "/approval/purchasing",
    name: "SPPApprovePM",
    component: () => import("../views/SPPApprovalPM.vue"),
    meta: { title: "Persetujuan Manager Purchasing", path: ["Persetujuan"] },
  },
  {
    path: "/spp/approved",
    name: "SPPApproved",
    component: () => import("../views/SPPApproved.vue"),
    meta: { title: "SPP Disetujui", path: [""] },
  },
  {
    path: "/po/create",
    name: "POCreate",
    component: () => import("../views/POCreate.vue"),
    meta: { title: "Form PO Baru", path: ["SPP Disetujui"] },
  },
  {
    path: "/po/list/:status/:vendor/:category/:kategori",
    name: "POList",
    component: () => import("../views/POList.vue"),
  },
  {
    path: "/price/list",
    name: "PriceList",
    component: () => import("../views/PriceList.vue"),
  },
  {
    path: "/report",
    name: "Report",
    component: () => import("../views/Report.vue"),
  },
  {
    path: "/notification",
    name: "notification",
    component: () => import("../views/Notification.vue"),
  },
  {
    path: "/print/:data",
    name: "print_preview",
    component: () => import("../views/PrintPreview.vue"),
  },
];

const router = new VueRouter({
  routes,
});
router.beforeEach(async (to, from, next) => {
  if (to.name != "Login") {
    if (!localStorage.getItem("token-purchase")) {
      next({ name: "Login" });
    } else {
      // await axios
      //   .get(`${process.env.VUE_APP_BASE_URL}/user/info/`, {
      //     headers: {
      //       Authorization: "Bearer " + localStorage.getItem("token-purchase"),
      //     },
      //   })
      //   .then((result) => {
      //     console.log("user obtained");
      //     to.meta.currentUser = result.data;
      //   });
      next();
    }
  } else {
    next();
  }
  // if (to.name == "Login") {
  //   if (localStorage.getItem("token-purchase")) {
  //     next({ name: "Home" });
  //   } else {
  //     next();
  //   }
  // }
});

export default router;
