import Vue from "vue";

import "./styles/quasar.scss";
import "@quasar/extras/roboto-font/roboto-font.css";
import "@quasar/extras/material-icons/material-icons.css";
import "@quasar/extras/material-icons-outlined/material-icons-outlined.css";
// import "@quasar/extras/material-icons-outlined";
import "@quasar/extras/fontawesome-v5/fontawesome-v5.css";

import { Quasar, QDialog, Notify, Loading, Dialog } from "quasar";

Vue.use(Quasar, {
  config: {},
  components: { QDialog },
  directives: {
    /* not needed if importStrategy is not 'manual' */
  },
  plugins: {
    Notify,
    Loading,
    Dialog,
  },
});
