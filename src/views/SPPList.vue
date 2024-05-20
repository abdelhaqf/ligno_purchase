<template>
  <div class="row relative q-px-lg ">
    <q-card flat square class="col-12 bg-white rounded-borders">
      <!-- toolbar -->
      <q-card-section class="row justify-between items-center">
        <div class="row q-gutter-x-md">
          <q-field
            dense
            outlined
            style="width: 225px;"
            v-model="selDate"
            clearable
            @clear="fetchData"
          >
            <template v-slot:prepend>
              <q-icon name="date_range" />
            </template>

            <template v-slot:control>
              <div class="self-center full-width no-outline" tabindex="0">
                {{ date_model }}
              </div>
            </template>

            <q-popup-proxy transition-show="scale" transition-hide="scale">
              <q-date range v-model="selDate" @input="pagination.current = 1;
                                                      fetchData();">
                <div class="row items-center justify-end">
                  <q-btn v-close-popup label="Close" color="primary" flat />
                </div>
              </q-date>
            </q-popup-proxy>
          </q-field>
          <q-input
            outlined
            dense
            placeholder="Cari Nama Barang"
            style="width: 275px;"
            v-model="searchTerm"
            @input="
              pagination.current = 1;
              fetchData();"
            clearable
            @clear="searchTerm = ''"
          >
            <template class="q-pt-none" v-slot:prepend>
              <q-icon name="search"></q-icon>
            </template>
          </q-input>
        </div>

        <q-btn label="SPP Baru" icon="add" color="primary" to="/spp/create" unelevated />
      </q-card-section>

      <!-- table  -->
      <q-markup-table class="stickyTable" style="height: calc(100vh - 320px);">
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:25px;">No</th>
            <th>Dibuat</th>
            <th>Deadline</th>
            <th>Barang</th>
            <th>Jumlah</th>
            <th style="width: 250px;">Ket</th>
            <th>Status</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody v-if="sppList.length" separator="horizontal">
          <tr v-for="(d, index) in sppList" :key="d.spp_id">
            <td class="text-center">
              <!-- <q-radio v-model="slcIndex" :val="index" /> -->
              {{ (pagination.current - 1) * pagination.limit + index + 1 }}
            </td>
            <td class="text-center">
              {{ d.create_at | moment("DD MMM YYYY") }}
            </td>
            <td class="text-center">
              {{ d.deadline | moment("DD MMM YYYY") }}
            </td>
            <td class="text-left l-grow">{{ d.item }}</td>
            <td class="text-center">{{ d.qty }} {{ d.unit }}</td>
            <td>
              <div class="l-wrap-cell">
                <span>
                  {{
                    d.description.length > 70
                      ? d.description.slice(0, 63)
                      : d.description
                  }}
                </span>
                <span v-if="d.description.length > 70" class=" no-wrap ">
                  ...
                  <q-tooltip
                    content-style="width:300px"
                    content-class="l-text-detail bg-white text-black shadow-2"
                    >{{ d.description }}</q-tooltip
                  >
                </span>
              </div>
            </td>
            <td>
              <div
                class="capsule text-white q-px-md q-mx-auto"
                style="width: fit-content;"
                :class="`bg-${getColor(d.status)}`"
              >
                {{ d.status }}
              </div>
            </td>
            <td class="text-center">
              <q-btn
                flat
                no-caps
                label="Detail"
                color="primary"
                :to="`/spp/detail/${d.spp_id}`"
              ></q-btn>
            </td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">tidak ada data</td>
          </tr>
        </tbody>
      </q-markup-table>

      <q-card-section class="row justify-center q-py-sm">
        <q-pagination
          input
          :max="pagination.max"
          v-model="pagination.current"
          @input="fetchData"
        ></q-pagination>
      </q-card-section>
    </q-card>

    <!-- detail  -->
    <q-dialog
      v-model="show_detail"
      persistent
      transition-show="scale"
      transition-hide="scale"
    >
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-primary text-white row">
          <div>NO SPP: {{ selected.spp_id }}</div>

          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-list>
          <q-item>
            <q-item-section>
              <q-item-label caption>Yang Mengajukan</q-item-label>
              <q-item-label>{{ selected.name }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Pada Tanggal</q-item-label>
              <q-item-label>{{
                selected.create_at | moment(" hh:mm, DD MMM YYYY ")
              }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Deadline</q-item-label>
              <q-item-label>{{ selected.deadline }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Nama Barang</q-item-label>
              <q-item-label>{{ selected.item }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Jumlah</q-item-label>
              <q-item-label
                >{{ selected.qty }} {{ selected.unit }}</q-item-label
              >
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section v-if="show_detail">
              <q-item-label caption>Keterangan</q-item-label>
              <q-item-label v-if="selected.description.length">{{
                selected.description
              }}</q-item-label>
              <q-item-label v-else>-</q-item-label>
            </q-item-section>
          </q-item>
          <q-separator spaced />
          <q-item v-if="selected.est_arrival">
            <q-item-section>
              <q-item-label caption>Perkiraan Barang Tiba</q-item-label>
              <q-item-label>{{ selected.est_arrival }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Status Saat Ini</q-item-label>
              <q-item-label>{{ status_note }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section v-show="selected.po_id">
              <q-item-label caption>Konfirmasi Penerimaan</q-item-label>
              <q-item-label>
                <q-select
                  outlined
                  dense
                  v-model="isReceived"
                  :options="receivedOption"
                  map-options
                  emit-value
                  @input="updateStatus"
                />
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-card>
    </q-dialog>

    <!-- history  -->
    <q-dialog
      v-model="show_history"
      persistent
      transition-show="scale"
      transition-hide="scale"
    >
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-secondary text-white row">
          <div>NO SPP: {{ history[0] ? history[0].spp_id : "" }}</div>
          <q-space />
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-card-section
          class="q-px-xl q-my-sm"
          style="height: 450px; overflow: auto;"
        >
          <q-timeline>
            <q-timeline-entry
              v-for="x in history"
              :key="x.id"
              :title="x.status"
              :subtitle="x.create_at | moment('DD MMM YYYY')"
              :color="getColor(x.status)"
              :icon="getIcon(x.status)"
            >
              <div>{{ x.content }}</div>
            </q-timeline-entry>
          </q-timeline>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
export default {
  data() {
    return {
      sppList: [],
      slcIndex: -1,
      show_detail: false,
      history: [],
      show_history: false,
      selected: {},
      filterOption: [],
      filter: "",
      isReceived: 0,
      receivedOption: [
        { label: "fully received", value: "2" },
        { label: "half received", value: "1" },
        { label: "not received", value: "0" },
      ],

      selDate: null,
      searchTerm: "",
      pagination: {
        max: 1,
        current: 1,
        limit: 25,
      },
    };
  },
  mounted() {
    this.$http
      .get("/list_month_user", {
        headers: {
          Authorization: "Bearer " + localStorage.getItem("token-purchase"),
        },
      })
      .then((result) => {
        this.filterOption = result.data;
        this.filter = result.data[0].value;
        this.filterOption.unshift({ value: "%25", label: "all" });

        this.fetchData();
      });
  },
  methods: {
    showDialogPlugin() {
      this.$q
        .dialog({
          component: dialogPulginContoh,
          parent: this,
          text: [{ nama: "kikiuw" }],
        })
        .onOk((val) => {
          console.log("OK was clicked on dialog, sambil bawa", val);
        })
        .onCancel(() => {
          console.log("Cancel was clicked on dialog");
        })
        .onDismiss(() => {
          console.log("OK or cancel was clicked on dialog");
        });
    },
    fetchData() {
      this.sppList = [];
      let q_filter = `?current=${this.pagination.current}&limit=${
        this.pagination.limit
      }&search=${this.searchTerm ? this.searchTerm : ""}`;

      if (this.selDate) {
        if (this.selDate.from) {
          q_filter = `${q_filter}&from=${moment(this.selDate.from).format(
            "YYYY-MM-DD"
          )}&to=${moment(this.selDate.to).format("YYYY-MM-DD")}`;
        } else {
          q_filter = `${q_filter}&date=${moment(this.selDate).format(
            "YYYY-MM-DD"
          )}`;
        }
      }

      this.$http
        .get(
          `/spp/list/${this.$store.state.currentUser.user_id}${q_filter}`,
          {}
        )
        .then((result) => {
          for (var i = 0; i < result.data.length; i++) {
            if (i == 0) {
              let total_count = parseInt(result.data[i].total_count);
              this.pagination.max = Math.ceil(
                total_count / this.pagination.limit
              );
            }
            result.data[i].status = this.status(result.data[i]);
            this.sppList.push(result.data[i]);
          }
        });
    },
    showDetail() {
      this.selected = this.sppList[this.slcIndex];
      this.isReceived = this.selected.is_received;
      this.show_detail = true;
    },
    updateStatus() {
      var data = { spp_id: this.selected.spp_id, is_received: this.isReceived };
      this.selected.is_received = this.isReceived;

      this.$http
        .put("/update_spp/" + this.selected.spp_id, data, {})
        .then((result) => {
          let history = {
            spp_id: this.selected.spp_id,
            status: "process",
            content:
              "update oleh pembuat SPP (" +
              this.$store.state.currentUser.username +
              ")",
          };
          if (this.isReceived == 2) {
            history.status = "done";
          }
          this.$http.post("/new_history", history, {}).then((result) => {});

          var info = "";
          if (this.isReceived == 2) info = "barang sudah diterima penuh";
          if (this.isReceived == 1) info = "barang sudah diterima sebagian";

          var notifikasi = {
            from_id: this.$store.state.currentUser.user_id,
            to_id: this.selected.handle_by,
            notif: "Konfimrasi penerimaan oleh pemohon",
            note: info,
            spp_id: this.selected.spp_id,
            reference_page: "/po/list",
          };
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          notifikasi.to_id = 1; // Notif ke Manager purchasing
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          this.$q.notify({
            icon: "done",
            color: "positive",
            message: "Status penerimaan sudah diubah",
          });

          this.fetchData();
        });
    },
    showHistory() {
      this.$http
        .get("/spp_history/" + this.sppList[this.slcIndex].spp_id, {})
        .then((result) => {
          this.history = result.data;
        });
      this.show_history = true;
    },
    status(val) {
      if (val.purch_manager_cancel == 1) {
        return "canceled";
      } else if (val.manager_approve == 0) {
        return "waiting";
      } else if (val.manager_approve == -1) {
        return "rejected";
      } else if (val.purch_manager_approve == 0) {
        return "waiting";
      } else if (val.purch_manager_approve == -1) {
        return "rejected";
      } else if (val.is_received == 0) {
        return "process";
      } else if (val.is_received == 1) {
        return "process";
      } else if (val.is_received == 2) {
        return "done";
      } else if (val.is_received == 300) {
        return "suspended";
      } else if (val.is_received == 40000) {
        return "closed";
      }
    },
    getColor(val) {
      if (val == "done") return "positive";
      else if (val == "rejected" || val == "canceled") return "red-7";
      else if (val == "process") return "primary";
      else if (val == "suspended") return "accent";
      else if (val == "closed") return "black";
      else return "orange";
    },
    getIcon(val) {
      if (val == "done") return "done_all";
      else if (val == "rejected") return "error_outline";
      else if (val == "process") return "hourglass_bottom";
      else if (val == "created") return "library_add";
      else if (val == "canceled") return "close";
      else if (val == "suspended") return "alarm";
      else if (val == "closed") return "highlight_off";
      else return "pending_actions";
    },
  },
  computed: {
    status_note() {
      if (this.selected.purch_manager_cancel == 1) {
        return "SPP dibatalkan oleh manager purchasing";
      } else if (this.selected.manager_approve == 0) {
        return "Menunggu persetujuan manager";
      } else if (this.selected.manager_approve == -1) {
        return "Ditolak oleh manager";
      } else if (this.selected.purch_manager_approve == 0) {
        return "Menunggu persetujuan manager purchasing";
      } else if (this.selected.purch_manager_approve == -1) {
        return "Ditolak oleh manager purchasing";
      } else if (this.selected.is_received == 0) {
        return "Sedang diproses oleh " + this.selected.handler_name;
      } else if (this.selected.is_received == 1) {
        return (
          "Barang sudah diterima sebagian [" + this.selected.handler_name + "]"
        );
      } else if (this.selected.is_received == 2) {
        return "Barang sudah diterima";
      }
    },
    date_model() {
      if (!this.selDate) return "Pilih Tanggal Dibuat";

      if (this.selDate.from) {
        return (
          moment(this.selDate.from).format("DD MMMM YYYY") +
          " - " +
          moment(this.selDate.to).format("DD MMMM YYYY")
        );
      } else {
        return moment(this.selDate).format("DD MMMM YYYY");
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.container {
  width: 100%;
  height: 100%;
  background-color: white;
  position: absolute;
  z-index: 1000;
  left: 0px;
  top: 0px;
}

.v-money {
  line-height: 1;
  font-size: 14px;
  border: 1px solid silver;
  border-radius: 5px;
  padding: 10px 10px;
  box-sizing: border-box;
  width: 130px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
.l-wrap-cell {
  width: 250px !important;
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
<style lang="scss">
.q-timeline__title {
  font-size: 16px;
}
</style>
