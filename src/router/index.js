import Vue from "vue";
import VueRouter from "vue-router";
import axios from "axios";
Vue.use(VueRouter);

const routes = [
  {
    path: "/dashboard",
    name: "Home",
    component: () => import("../views/Home.vue"),
    meta: { access: ["PURCHASING", "CEO"] },
  },
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/Login.vue"),
    meta: { noAuth: true },
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
    path: "/spp/template",
    name: "SPPTemplate",
    component: () => import("../views/SPPTemplate.vue"),
    meta: { title: "Template SPP", path: ["SPP"], access: ["PURCHASING"] },
  },
  {
    path: "/approval/manager",
    name: "SPPApprove",
    component: () => import("../views/SPPApproval.vue"),
    meta: {
      title: "Persetujuan Manager",
      path: ["Persetujuan"],
      access: ["MANAGER"],
    },
  },
  {
    path: "/approval/purchasing",
    name: "SPPApprovePM",
    component: () => import("../views/SPPApprovalPM.vue"),
    meta: {
      title: "Persetujuan Manager Purchasing",
      path: ["Persetujuan"],
      access: ["PURCHASING MANAGER"],
    },
  },
  {
    path: "/spp/approved",
    name: "SPPApproved",
    component: () => import("../views/SPPApproved.vue"),
    meta: { title: "SPP Disetujui", path: [""], access: ["PURCHASING"] },
  },
  {
    path: "/po/create",
    name: "POCreate",
    component: () => import("../views/POCreate.vue"),
    meta: { title: "Form PO Baru", path: ["PO"], access: ["PURCHASING"] },
  },
  {
    path: "/po/list",
    name: "POList",
    component: () => import("../views/POList.vue"),
    meta: { title: "Daftar PO", path: ["PO"], access: ["PURCHASING"] },
  },
  {
    path: "/po/detail/:id",
    name: "PODetail",
    component: () => import("../views/PODetail.vue"),
    meta: { title: "PO Detail", path: ["PO"], access: ["PURCHASING"] },
  },
  {
    path: "/price/list",
    name: "PriceList",
    component: () => import("../views/PriceList.vue"),
    meta: { title: "List Harga", path: [""], access: ["PURCHASING", "CEO"] },
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
    meta: { title: "Notifikasi", path: [""] },
  },
  {
    path: "/print/:data",
    name: "print_preview",
    component: () => import("../views/PrintPreview.vue"),
  },
  {
    path: "/noaccess",
    meta: {
      noAuth: true,
    },
    component: () => import("../views/NoAccess.vue"),
  },
  {
    path: "/:pathMatch(.*)*",
    meta: {
      noAuth: true,
    },
    component: () => import("../views/NotFound.vue"),
  },
];

const router = new VueRouter({
  routes,
});

function checkAccess(user, access) {
  if (user?.dept == "IT" && user?.is_manager == "1") {
    return true;
  } else if (access.includes("PURCHASING") && user?.is_purchasing == "1") {
    return true;
  } else if (access.includes("MANAGER") && user?.is_manager == "1") {
    return true;
  } else if (
    access.includes("PURCHASING MANAGER") &&
    user?.is_purch_manager == "1"
  ) {
    return true;
  } else {
    return false;
  }
}

router.beforeEach(async (to, from, next) => {
  let token = localStorage.getItem("token-purchase");

  if (to.meta.noAuth) {
    next();
  } else if (token === null) {
    next("/login");
  } else {
    try {
      let resp = await axios.get(`${process.env.VUE_APP_BASE_URL}/user/info/`, {
        headers: {
          Authorization: "Bearer " + localStorage.getItem("token-purchase"),
        },
      });
      to.meta.currentUser = resp.data;
      if (to.meta?.access == null) {
        next();
      } else {
        let access = checkAccess(resp.data, to.meta.access);
        console.log(access);
        if (access) {
          next();
        } else {
          next("/noaccess");
        }
      }
    } catch (err) {
      console.log(err);
      localStorage.removeItem("token-purchase");
      next("/login");
    }
  }
});

export default router;
