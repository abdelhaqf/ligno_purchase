import Vue from "vue";
import VueRouter from "vue-router";

Vue.use(VueRouter);

const routes = [
  {
    path: "/",
    name: "Home",
    component: () => import("../views/Home.vue"),
  },
  {
    path: "/login",
    name: "Login",
    component: () => import("../views/Login.vue"),
  },
  {
    path: "/spp/create",
    name: "SPPCreate",
    component: () => import("../views/SPPCreate.vue"),
  },
  {
    path: "/spp/list",
    name: "SPPList",
    component: () => import("../views/SPPList.vue"),
  },
  {
    path: '/spp/approval',
    name: 'SPPApprove',
    component: () => import('../views/SPPApproval.vue')
  },
  {
    path: '/spp/approval-pm',
    name: 'SPPApprovePM',
    component: () => import('../views/SPPApprovalPM.vue')
  },
  {
    path: '/spp/approved',
    name: 'SPPApproved',
    component: () => import('../views/SPPApproved.vue')
  },
  {
    path: '/po/list',
    name: 'POList',
    component: () => import('../views/POList.vue')
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
];

const router = new VueRouter({
  routes,
});
router.beforeEach((to, from, next) => {
  if (to.name != "Login") {
    if (!localStorage.getItem("token")) {
      next({ name: "Login" });
    } else {
      next();
    }
  }
  if (to.name == "Login") {
    if (localStorage.getItem("token")) {
      next({ name: "Home" });
    } else {
      next();
    }
  }
});

export default router;
