<template>
  <div class="row justify-center q-pa-lg">
    <q-card v-if="!formPO" class="col-12 bg-white rounded-borders">
      <!-- table control -->
      <q-card-section class="q-pa-md row justify-between">
        <div class="q-gutter-md">
          <q-btn color="primary" label="Buat PO" @click="openForm" :disable="!selectCount" />
          <q-btn
            flat
            color="secondary"
            label="Detail"
            :disabled="selectCount != 1"
            @click="show_detail = true"
          />
          <q-btn
            flat
            color="secondary"
            label="History"
            :disabled="selectCount != 1"
            @click="showHistory()"
          />
          <q-btn
            class="q-ml-xl"
            color="negative"
            label="Batalkan"
            :disabled="selectCount != 1"
            @click="confirmCancel = true"
          />
        </div>
        <div></div>
      </q-card-section>
      <!-- table header  -->
      <q-markup-table bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">User</th>
            <th class="text-left">Tanggal Pengajuan</th>
            <th class="text-left">Deadline</th>
            <th class="text-left">Barang</th>
            <th class="text-right">Jumlah</th>
          </tr>
        </thead>
        <tbody v-if="sppList.length" class="bg-blue-grey-1">
          <tr v-for="d in sppList" :key="d.spp_id">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td class="text-left">
              {{ d.name }}
              <q-chip color="accent" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td class="text-left">{{ d.create_at | moment("DD MMM YYYY") }}</td>
            <td class="text-left" style="width: 100px;">{{ d.deadline | moment("DD MMM YYYY") }}</td>
            <td class="text-left">{{ d.item }}</td>
            <td class="text-right">{{ d.qty }} {{ d.unit }}</td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">tidak ada data</td>
          </tr>
        </tbody>
      </q-markup-table>
      <q-card-section></q-card-section>
    </q-card>

    <!-- form PO baru -->
    <q-card v-if="formPO">
      <q-card-section class="bg-primary text-white text-h6">PO Baru</q-card-section>
      <div class="q-pa-md q-gutter-md">
        <div class="row">
          <q-input
            class="col-10"
            outlined
            v-model="po.po_id"
            label="Nomor PO"
            stack-label
            dense
            v-if="type == 'PO'"
          />
          <q-input
            class="col-10"
            outlined
            v-model="po.po_id"
            label="Nomor non-PO"
            readonly
            stack-label
            dense
            v-else
          />
          <div class="col-2">
            <q-select
              class="q-ml-sm"
              outlined
              dense
              v-model="type"
              :options="['PO', 'Non-PO']"
              @input="changeType()"
            />
          </div>
        </div>
        <div class="row">
          <q-input
            class="col-10"
            outlined
            v-model="po.vendor"
            label="Nama Vendor"
            stack-label
            dense
          />
          <div class="col-2">
            <q-select
              class="q-ml-sm"
              outlined
              dense
              v-model="curr"
              :options="['IDR', 'USD']"
              @input="chgCurrency"
            />
          </div>
        </div>
        <q-input outlined v-model="po.po_date" mask="date" :rules="['date']" label>
          <template v-slot:append>
            <q-icon name="event" class="cursor-pointer">
              <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                <q-date minimal v-model="po.po_date" :options="limitDate">
                  <div class="row items-center justify-end">
                    <q-btn v-close-popup label="Close" color="primary" flat />
                  </div>
                </q-date>
              </q-popup-proxy>
            </q-icon>
          </template>
          <template v-slot:label>
            Tanggal PO
            <a class="q-px-sm bg-info text-white rounded-borders">tahun / bulan / tanggal</a>
          </template>
        </q-input>
      </div>
      <q-markup-table separator="cell" bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th class="text-left">No</th>
            <th class="text-left">Nama Barang</th>
            <th class="text-left">Harga</th>
            <th class="text-left">Est.Arrival</th>
          </tr>
        </thead>
        <tbody class="bg-blue-grey-1">
          <tr v-for="(x, i) in sppSelect" :key="i">
            <td>{{ i + 1 }}</td>
            <td style="width: 250px;">{{ x.item }} ({{x.qty}} {{x.unit}})</td>
            <td style="padding: 0px;">
              <money v-model="x.price" v-bind="money"></money>
            </td>
            <td style="padding: 0px;">
              <q-input filled square bg-color="white" v-model="x.est_arrival">
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                      <q-date minimal v-model="x.est_arrival">
                        <div class="row items-center justify-end">
                          <q-btn v-close-popup label="Close" color="primary" flat />
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </td>
          </tr>
        </tbody>
      </q-markup-table>

      <q-card-actions class="q-gutter-md row justify-end">
        <q-btn flat color="secondary" label="Kembali" @click="closeForm" />
        <q-btn flat color="primary" label="Submit" @click="createPO()" />
      </q-card-actions>
    </q-card>

    <q-dialog v-model="show_detail" persistent transition-show="scale" transition-hide="scale">
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
              <q-item-label caption>Requester</q-item-label>
              <q-item-label>{{ selected.name }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Request Date</q-item-label>
              <q-item-label>{{ selected.create_at }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Deadline</q-item-label>
              <q-item-label>{{ selected.deadline }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Item</q-item-label>
              <q-item-label>{{ selected.item }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Quantity</q-item-label>
              <q-item-label>{{ selected.qty }} {{ selected.unit }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Description</q-item-label>
              <q-item-label>{{ selected.description }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-separator spaced />
          <q-item v-if="selected.est_arrival">
            <q-item-section>
              <q-item-label caption>Arrival Estimation</q-item-label>
              <q-item-label>{{ selected.est_arrival }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Status</q-item-label>
              <q-item-label>{{ status_note }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-card>
    </q-dialog>

    <q-dialog v-model="show_history" persistent transition-show="scale" transition-hide="scale">
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-secondary text-white row">
          <div>NO SPP: {{ history[0] ? history[0].spp_id : "" }}</div>
          <q-space />
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-card-section class="q-px-xl q-my-sm" style="height: 450px; overflow: auto;">
          <q-timeline>
            <q-timeline-entry
              v-for="x in history"
              :key="x.id"
              :title="x.status"
              :subtitle="dateHistory(x.create_at)"
              :color="getColor(x.status)"
              :icon="getIcon(x.status)"
            >
              <div>{{ x.content }}</div>
            </q-timeline-entry>
          </q-timeline>
        </q-card-section>
      </q-card>
    </q-dialog>

    <q-dialog v-model="alert">
      <q-card>
        <q-card-section>
          <div class="text-h6">PO Kosong</div>
        </q-card-section>

        <q-card-section class="q-pt-none">Anda belum memilih SPP yang akan dijadikan PO.</q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="OK" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>

    <q-dialog v-model="confirmCancel" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-negative text-white">
          <div class="text-bold">Alasan Pembatalan SPP</div>
        </q-card-section>

        <q-card-section class>
          <q-input class="col-4" outlined dense type="textarea" v-model="content" />
        </q-card-section>

        <q-card-actions align="between" class="text-primary">
          <q-btn flat color="negative" label="Cancel" v-close-popup />
          <q-btn flat color="positive" label="OK" @click="cancelSPP()" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
import { Money } from "v-money";

export default {
  components: { Money },
  data() {
    return {
      sppList: [],
      sppSelect: [],
      po: {
        po_date: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
        po_id: ""
      },
      formPO: false,
      alert: false,

      show_detail: false,
      history: [],
      show_history: false,
      selected: {},
      curr: "IDR",
      type: "PO",
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false
      },
      confirmCancel: false,
      content: ""
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.sppList = [];
      this.$http
        .get(
          "/spp_approved/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager,

          {}
        )
        .then(result => {
          for (var i = 0; i < result.data.length; i++) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        });
    },
    openForm() {
      for (var i = 0; i < this.sppList.length; i++) {
        if (this.sppList[i].select == true) {
          let data = {
            spp_id: this.sppList[i].spp_id,
            item: this.sppList[i].item,
            qty: this.sppList[i].qty,
            unit: this.sppList[i].unit,
            price: 0,
            currency: "IDR",
            est_arrival: moment()
              .add(1, "days")
              .format("YYYY/MM/DD")
          };
          this.sppSelect.push(data);
        }
      }

      if (this.sppSelect.length > 0) {
        // this.po.po_id = this.sppSelect[0].spp_id;
        this.changeType();

        this.formPO = true;
        this.curr = "IDR";
        this.chgCurrency();
      } else {
        this.alert = true;
      }
    },
    closeForm() {
      this.formPO = false;
      this.sppSelect = [];
    },
    async createPO() {
      this.po.user_id = this.$store.state.currentUser.user_id;
      await this.$http.post("/new_po", this.po, {}).then(async result => {
        for (var i = 0; i < this.sppSelect.length; i++) {
          this.sppSelect[i].po_id = this.po.po_id;

          await this.$http
            .put(
              "/update_spp/" + this.sppSelect[i].spp_id,
              this.sppSelect[i],
              {}
            )
            .then(result => {});

          var history = {
            spp_id: this.sppSelect[i].spp_id,
            status: "process",
            content: "Sudah dibuat PO dengan nomor: " + this.po.po_id
          };
          this.$http.post("/new_history", history, {}).then(result => {});

          var notifikasi = {
            from_id: this.$store.state.currentUser.user_id,
            to_id: this.sppSelect[i].user_id,
            notif: "PO telah dibuat",
            note: "Sudah dibuat PO dengan nomor: " + this.po.po_id,
            spp_id: this.sppSelect[i].spp_id,
            reference_page: "/spp/list"
          };
          this.$http.post("/notifikasi", notifikasi, {}).then(result => {});
        }

        this.formPO = false;
        this.po = {
          po_date: moment()
            .add(1, "days")
            .format("YYYY/MM/DD")
        };
        this.fetchData();
      });
      await this.$root.$emit("refresh");
      this.sppSelect = [];
      this.$q.notify("Berhasil membuat PO!");
    },
    changeType() {
      if (this.type == "PO") this.po.po_id = "-";
      else this.po.po_id = "NON-PO/" + this.sppSelect[0].spp_id;
    },
    cancelSPP() {
      var data = {
        purch_manager_cancel: 1,
        note: this.content
      };
      this.$http
        .put("/update_spp/" + this.selected.spp_id, data, {})
        .then(result => {
          this.$root.$emit("refresh");
          this.fetchData();
        });

      var history = {
        spp_id: this.selected.spp_id,
        status: "canceled",
        content: this.content
      };
      this.$http.post("/new_history", history, {}).then(result => {});
      this.$q.notify("SPP berhasil dibatalkan!");
    },
    showHistory() {
      this.$http
        .get("/spp_history/" + this.selected.spp_id, {})
        .then(result => {
          this.history = result.data;
        });
      this.show_history = true;
    },
    chgCurrency() {
      for (var i = 0; i < this.sppSelect.length; i++) {
        this.sppSelect[i].currency = this.curr;
      }

      if (this.curr == "IDR") {
        this.money.precision = 0;
        this.money.prefix = "Rp ";
      } else {
        this.money.precision = 2;
        this.money.prefix = "$ ";
      }
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    formatDate(dt) {
      return moment(dt).format("YYYY-MM-DD");
    },
    dateHistory(dt) {
      return moment(dt).format("DD MMMM YYYY");
    },
    getColor(val) {
      if (val == "done") return "positive";
      else if (val == "rejected" || val == "canceled") return "red-7";
      else if (val == "process") return "primary";
      else return "orange";
    },
    getIcon(val) {
      if (val == "done") return "done_all";
      else if (val == "rejected") return "error_outline";
      else if (val == "process") return "hourglass_bottom";
      else if (val == "created") return "library_add";
      else if (val == "canceled") return "close";
      else return "pending_actions";
    }
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter(e => e.select === true);
      var count = data.length;

      if (data[0]) this.selected = data[0];

      return count;
    },
    status_note() {
      if (this.selected.manager_approve == 0) {
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
        return "Barang sudah diterima sebagian";
      } else if (this.selected.is_received == 2) {
        return "Barang sudah diterima";
      }
    }
  }
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
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
