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
    path: "/spp/detail/:id",
    name: "SPPDetail",
    component: () => import("../views/SPPDetail.vue"),
  },
  {
    path: "/spp/approve",
    name: "SPPApprove",
    component: () => import("../views/SPPApprove.vue"),
  },
  {
    path: "/po/list",
    name: "POList",
    component: () => import("../views/POList.vue"),
  },
  {
    path: "/price/list",
    name: "PriceList",
    component: () => import("../views/PriceList.vue"),
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
