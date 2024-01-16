<template>
  <div class="row justify-center q-pa-lg">
    <q-card
      flat
      bordered
      v-if="!formPO"
      class="col-12 bg-white rounded-borders"
    >
      <!-- table control -->
      <q-card-section class="q-pa-md row justify-between items-center">
        <div class="q-gutter-md">
          <q-btn
            color="primary"
            label="Buat PO"
            @click="openForm"
            :disable="!selectCount"
          />
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
        <div class="row q-gutter-sm">
          <q-btn
            outline
            label="print"
            icon="print"
            color="secondary"
            @click="toPreview"
            :disable="!selectCount"
          ></q-btn>
          <q-select
            outlined
            label="Urut Per-"
            map-options
            emit-value
            :options="[
              { label: 'Pengajuan', value: 'create_at' },
              { label: 'Deadline', value: 'deadline' },
            ]"
            v-model="selOrder"
            @input="fetchData"
          ></q-select>
        </div>
      </q-card-section>
      <!-- table header  -->
      <q-markup-table bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">User</th>
            <th class="text-left">Tanggal Pengajuan</th>
            <th class="text-left">Pelaksana</th>
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
              <q-chip color="accent" text-color="white" dense size="sm">{{
                d.dept
              }}</q-chip>
            </td>
            <td class="text-left">{{ d.create_at | moment("DD MMM YYYY") }}</td>
            <td class="text-left">{{ d.handler_name }}</td>
            <td class="text-left" style="width: 100px;">
              {{ d.deadline | moment("DD MMM YYYY") }}
            </td>
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
    <q-card flat bordered v-if="formPO">
      <q-card-section class="q-pb-none text-bold text-h6"
        >PO Baru</q-card-section
      >
      <div class="q-pa-md q-gutter-md">
        <div class="row full-width q-gutter-x-md">
          <q-select
            outlined
            dense
            v-model="type"
            :options="['PO', 'Non-PO']"
            @input="changeType()"
            style="width:150px"
          />

          <q-input
            outlined
            v-model="po.po_id"
            label="Nomor PO"
            stack-label
            dense
            v-if="type == 'PO'"
            style="flex-grow: 99;"
          />
          <q-input
            outlined
            v-model="po.po_id"
            label="Nomor non-PO"
            readonly
            stack-label
            dense
            v-else
            style="flex-grow: 99;"
          />
        </div>
        <div class="full-width q-pl-md">
          <q-input
            outlined
            v-model="po.vendor"
            label="Nama Vendor"
            stack-label
            dense
            v-if="showInput"
          >
            <template v-slot:append>
              <q-toggle
                v-model="showInput"
                color="green"
                icon="add"
                keep-color
              />
            </template>
            <template v-slot:label>
              Nama Vendor
              <a class="q-px-sm bg-info text-white rounded-borders"
                >input baru</a
              >
            </template>
          </q-input>
          <q-select
            v-else
            stack-label
            outlined
            dense
            v-model="po.vendor"
            map-options
            emit-value
            use-input
            hide-selected
            fill-input
            input-debounce="0"
            :options="filteredVD"
            @filter="filterVD"
            label="Nama Vendor"
          >
            <template v-slot:append>
              <q-toggle
                v-model="showInput"
                color="green"
                icon="add"
                keep-color
              />
            </template>
          </q-select>
        </div>
        <div class="row justify-between items-center">
          <q-input
            outlined
            v-model="po.po_date"
            mask="date"
            label
            dense
            style="width:49%"
          >
            <template v-slot:append>
              <q-icon name="event" class="cursor-pointer">
                <q-popup-proxy
                  ref="qDateProxy"
                  transition-show="scale"
                  transition-hide="scale"
                >
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
              <a class="q-px-sm bg-info text-white rounded-borders"
                >tahun / bulan / tanggal</a
              >
            </template>
          </q-input>
          <q-select
            outlined
            v-model="curr"
            dense
            label="Currency"
            :options="['IDR', 'USD']"
            @input="chgCurrency"
            style="width:49%"
          />
        </div>
      </div>
      <q-markup-table separator="cell" bordered flat square dense>
        <thead class="bg-primary text-white">
          <tr>
            <th class="text-left">No</th>
            <th class="text-left">Nama Barang</th>
            <th class="text-left">Harga</th>
            <th class="text-left">Est.Arrival</th>
            <!-- <th class="text-left">RM Refrence</th> -->
          </tr>
        </thead>
        <tbody class="bg-white">
          <tr v-for="(x, i) in sppSelect" :key="i">
            <td>{{ i + 1 }}</td>
            <td style="width: 250px;">
              {{ x.item }} ({{ x.qty }} {{ x.unit }})
            </td>
            <td style="padding: 0px;">
              <money v-model="x.price" v-bind="money" class="q-mx-sm"></money>
            </td>
            <td>
              <q-input
                outlined
                dense
                bg-color="white"
                v-model="x.est_arrival"
                readonly
              >
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy
                      ref="qDateProxy"
                      transition-show="scale"
                      transition-hide="scale"
                    >
                      <q-date minimal v-model="x.est_arrival">
                        <div class="row items-center justify-end">
                          <q-btn
                            v-close-popup
                            label="Close"
                            color="primary"
                            flat
                          />
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
            </td>
            <!-- <td>
              <q-select
                outlined
                dense
                bg-color="white"
                :options="filtered_formulation_rm"
                use-input
                map-options
                emit-value
                hide-selected
                fill-input
                input-debounce="0"
                v-model="x.id_rm"
                @filter="filterRM"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey"
                      >No results</q-item-section
                    >
                  </q-item>
                </template>
                <template v-slot:append>
                  <q-btn
                    v-if="x.id_rm"
                    icon="close"
                    dense
                    @click="x.id_rm = null"
                    flat
                    size="sm"
                  ></q-btn>
                </template>
              </q-select>
            </td> -->
          </tr>
        </tbody>
      </q-markup-table>

      <q-card-actions class="q-gutter-md row justify-end">
        <q-btn flat color="primary" label="Kembali" @click="closeForm" />
        <q-btn unelevated color="primary" label="Submit" @click="createPO()" />
      </q-card-actions>
    </q-card>

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
              <q-item-label
                >{{ selected.qty }} {{ selected.unit }}</q-item-label
              >
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Description</q-item-label>
              <q-item-label>{{ selected.description }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Kategori Barang/Jasa</q-item-label>
              <q-item-label>{{ selected.kategori }}</q-item-label>
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

        <q-card-section class="q-pt-none"
          >Anda belum memilih SPP yang akan dijadikan PO.</q-card-section
        >

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
          <q-input
            class="col-4"
            outlined
            dense
            type="textarea"
            v-model="content"
          />
        </q-card-section>

        <q-card-actions align="between" class="text-primary">
          <q-btn flat color="negative" label="Cancel" v-close-popup />
          <q-btn
            flat
            color="positive"
            label="OK"
            @click="cancelSPP()"
            v-close-popup
          />
        </q-card-actions>
      </q-card>
    </q-dialog>

    <q-dialog v-model="dialogConfirm" persistents>
      <q-card>
        <q-card-section class="bg-grey-2 row items-center justify-between ">
          <div class="text-h6 text-bold">Konfirmasi Pembuatan PO</div>
          <q-btn icon="close" flat v-close-popup></q-btn>
        </q-card-section>
        <q-card-section>
          <div class="q-pb-sm">
            Apa Anda yakin akan membuat PO untuk {{ sppSelect.length }} SPP
            terpilih?
          </div>
          <div v-if="curr == 'USD'" class="row justify-between items-center">
            <div>
              Masukan Kurs Berlaku
            </div>
            <money v-model="kurs" v-bind="money_kurs"></money>
          </div>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn
            unelevated
            color="primary"
            label="SIMPAN"
            @click="
              allowed = true;
              createPO();
            "
            v-close-popup
          ></q-btn>
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
import { Money } from "v-money";
import axios from "axios";
import { mapActions } from "vuex";
export default {
  components: { Money },
  data() {
    return {
      roman: [
        "",
        "I",
        "II",
        "III",
        "IV",
        "V",
        "VI",
        "VII",
        "VIII",
        "IX",
        "X",
        "XI",
        "XII",
      ],
      sppList: [],
      sppSelect: [],
      po: {
        po_date: moment().format("YYYY/MM/DD"),
        po_id: "",
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
        masked: false,
      },
      confirmCancel: false,
      content: "",
      selOrder: "create_at",

      // new data
      formulation_rm: [],
      filtered_formulation_rm: [],

      allowed: false,
      dialogConfirm: false,
      kurs: 0,
      money_kurs: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      showInput: false,
      optVendor: [],
      filteredVD: [],
    };
  },
  async mounted() {
    await this.getVendor();
    await this.fetchData();
  },
  methods: {
    ...mapActions(["sendPrintData"]),
    filterVD(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filteredVD = this.optVendor.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    async getVendor() {
      await this.$http.get("/list_vendor", {}).then((result) => {
        this.optVendor = result.data;
        this.filteredVD = result.data;
      });
    },
    async fetchData() {
      this.sppList = [];
      await this.$http
        .get(
          "/spp_approved/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager +
            "/" +
            this.selOrder,

          {}
        )
        .then((result) => {
          for (var i = 0; i < result.data.length; i++) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        });
    },
    async toPreview() {
      let temp = this.sppList.filter((val) => {
        return val.select;
      });

      let result = temp.map((a) => a.spp_id);

      console.log(result);

      let route = this.$router.resolve({ path: "/print" });
      window.open(`${route.href}/${JSON.stringify(result)}`);
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
              .format("YYYY/MM/DD"),
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
      if (!this.allowed) {
        this.dialogConfirm = true;
        return;
      }

      this.po.user_id = this.$store.state.currentUser.user_id;
      try {
        this.$q.loading.show();

        await this.$http.post("/new_po", this.po, {}).then(async (result) => {
          for (var i = 0; i < this.sppSelect.length; i++) {
            this.sppSelect[i].po_id = this.po.po_id;

            let temp = JSON.parse(JSON.stringify(this.sppSelect[i]));
            if (temp.id_rm) {
              delete temp.id_rm;
            }

            await this.$http
              .put("/update_spp/" + this.sppSelect[i].spp_id, temp, {})
              .then((result) => {});

            var history = {
              spp_id: this.sppSelect[i].spp_id,
              status: "process",
              content: "Sudah dibuat PO dengan nomor: " + this.po.po_id,
            };
            this.$http.post("/new_history", history, {}).then((result) => {});

            var notifikasi = {
              from_id: this.$store.state.currentUser.user_id,
              to_id: this.sppSelect[i].user_id,
              notif: "PO telah dibuat",
              note: "Sudah dibuat PO dengan nomor: " + this.po.po_id,
              spp_id: this.sppSelect[i].spp_id,
              reference_page: "/spp/list",
            };
            this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
          }

          this.formPO = false;
          this.po = {
            po_date: moment().format("YYYY/MM/DD"),
          };
          this.fetchData();
        });

        await this.sync_formula();

        await this.$root.$emit("refresh");
        this.sppSelect = [];
        this.allowed = false;
        this.$q.loading.hide();
        this.$q.notify("Berhasil membuat PO!");
      } catch (err) {
        console.log(err);
        this.$q.loading.hide();
      }
    },
    async sync_formula() {
      let temp = this.sppSelect.filter((val) => {
        return val.id_rm;
      });

      if (temp.length > 0) {
        for (let i = 0; i < temp.length; i++) {
          let item = temp[i];
          let payload = {
            id: item.id_rm,
            new_price: item.price,
          };

          if (item.currency == "USD") {
            payload.new_price = parseFloat(this.kurs * item.price).toFixed(2);
          }

          payload.new_price =
            parseFloat(payload.new_price) / parseFloat(item.qty);

          await this.$http_formulation.put("/purchase/rm/price", payload);
        }
      }
    },
    changeType() {
      if (this.type == "PO")
        this.po.po_id = `OP/CM/${moment().format("YY")}/${moment().format(
          "MM"
        )}/`;
      else this.po.po_id = "NON-PO/" + this.sppSelect[0].spp_id;
    },
    cancelSPP() {
      var data = {
        purch_manager_cancel: 1,
        note: this.content,
      };
      this.$http
        .put("/update_spp/" + this.selected.spp_id, data, {})
        .then((result) => {
          this.$root.$emit("refresh");
          this.fetchData();
        });

      var history = {
        spp_id: this.selected.spp_id,
        status: "canceled",
        content: this.content,
      };
      this.$http.post("/new_history", history, {}).then((result) => {});
      this.$q.notify("SPP berhasil dibatalkan!");
    },
    showHistory() {
      this.$http
        .get("/spp_history/" + this.selected.spp_id, {})
        .then((result) => {
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
    },
    filterRM(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered_formulation_rm = this.formulation_rm.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter((e) => e.select === true);
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
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
