<template>
  <div class="row relative q-px-lg q-pt-lg">
    <q-card
      flat
      bordered
      class="col-12 bg-white rounded-borders"
      v-if="!show_detail"
    >
      <q-card-section class="q-pa-md q-gutter-md row justify-between">
        <q-btn
          unelevated
          color="primary"
          @click="dialogFilter = true"
          label="FILTER"
        ></q-btn>
        <q-select
          outlined
          dense
          v-model="filter"
          :options="filterOption"
          map-options
          emit-value
          @input="fetchData"
        />
      </q-card-section>
      <q-markup-table bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;">
              <q-btn
                flat
                dense
                icon="keyboard_arrow_down"
                size="xs"
                @click="sortBy = ''"
              ></q-btn>
            </th>
            <th class="text-left">PO Number</th>
            <th class="text-left">
              PO Date
              <q-btn
                flat
                dense
                icon="keyboard_arrow_down"
                size="xs"
                @click="sortBy = 'po_date'"
              ></q-btn>
            </th>
            <th class="text-left">Handle By</th>
            <th class="text-left">Vendor</th>
            <th class="text-left">Items</th>
            <th class="text-left">
              Cost Category

              <q-btn
                flat
                dense
                icon="keyboard_arrow_up"
                size="xs"
                @click="sortBy = 'cost_category'"
              ></q-btn>
            </th>
            <th class="text-left">
              Est. Arrival
              <q-btn
                flat
                dense
                icon="keyboard_arrow_up"
                size="xs"
                @click="sortBy = 'est_arrival'"
              ></q-btn>
            </th>
            <th class="text-right">value</th>
          </tr>
        </thead>
        <tbody v-if="poList.length" class="bg-blue-grey-1">
          <tr
            v-for="d in sortedListPO"
            :key="d.id"
            :class="{ 'bg-red-2': isPastEstimation(d.est_arrival) }"
          >
            <td style="padding: 0px;">
              <q-btn
                color="primary"
                size="md"
                icon="launch"
                class="full-width q-py-sm"
                flat
                @click="openForm(d.po_id)"
              />
            </td>
            <td class="text-left col">
              <div>{{ d.po_id }}</div>
              <q-chip
                :color="getLabelColor(d.is_received)"
                text-color="white"
                dense
                size="sm"
                >{{ d.is_received }}</q-chip
              >
            </td>
            <td class="text-left">{{ d.po_date | moment("DD MMM YYYY") }}</td>
            <td class="text-left">{{ d.handler_name | truncate(8) }}</td>
            <td class="text-left">{{ d.vendor | truncate(11) }}</td>
            <td class="text-left col">
              {{ d.item | truncate(20)
              }}{{ d.spp_count > 1 ? " [+" + (d.spp_count - 1) + "]" : "" }}
            </td>
            <td>{{ d.cost_category }}</td>
            <td class="text-left col">
              {{ d.est_arrival | moment("DD MMM YYYY") }}
            </td>
            <td class="text-right">
              {{ setCurrency(d.total_price, d.currency) }}
            </td>
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

    <!-- detail PO  -->
    <q-card flat bordered v-if="show_detail" class="col-12">
      <q-card-section class="bg-primary text-white"
        >Detail PO : {{ selected[0].po_id }}</q-card-section
      >

      <q-card-section class="q-pa-md">
        <table>
          <tr>
            <td class="text-caption">PO Date</td>
            <td class="q-px-sm">:</td>
            <td>{{ selected[0].po_date | moment("DD MMM YYYY") }}</td>
          </tr>
          <tr>
            <td class="text-caption">Handle By</td>
            <td class="q-px-sm">:</td>

            <td>{{ selected[0].handler_name }}</td>
          </tr>
          <tr>
            <td class="text-caption">Vendor</td>
            <td class="q-px-sm">:</td>

            <td>{{ selected[0].vendor }}</td>
          </tr>
          <tr>
            <td class="text-caption">Kategori Biaya</td>
            <td class="q-px-sm">:</td>

            <td>
              <q-select
                outlined
                dense
                v-model="selected[0].cost_category"
                :options="cost_ctg"
              />
            </td>
          </tr>
        </table>
      </q-card-section>
      <q-markup-table separator="cell" bordered flat dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th class="text-left">SPP</th>
            <th class="text-left">Request By</th>
            <th class="text-left">Item</th>
            <th class="text-right">Qty</th>
            <th class="text-right">value</th>
            <th class="text-left">Est Arrival</th>
            <th class="text-left">Received</th>
            <!-- <th class="text-left">COA</th> -->
            <th class="text-left">Note</th>
            <th class="text-center"></th>
          </tr>
        </thead>
        <tbody class="bg-blue-grey-1">
          <tr v-for="(d, i) in selected" :key="i">
            <td class="text-left">{{ d.spp_id }}</td>
            <td class="text-left">{{ d.name }}</td>
            <td class="text-left">
              <div v-if="!onEdit">{{ d.item }}</div>
              <q-input
                v-else
                outlined
                dense
                v-model="edited[i].item"
                class="bg-white"
              />
            </td>
            <td class="text-right">
              <div v-if="!onEdit">{{ d.qty }} {{ d.unit }}</div>
              <div v-else class style="width: 60px;">
                <q-input
                  outlined
                  dense
                  class="bg-white"
                  v-model="edited[i].qty"
                />
                <q-input
                  outlined
                  dense
                  class="bg-white"
                  v-model="edited[i].unit"
                />
              </div>
            </td>
            <td class="text-right">
              <div v-if="!onEdit">{{ setCurrency(d.price, d.currency) }}</div>
              <div v-else class="row" style="width: 100px;">
                <money
                  v-if="edited[i].currency == 'USD'"
                  v-model="edited[i].price"
                  v-bind="moneyUSD"
                ></money>
                <money v-else v-model="edited[i].price" v-bind="money"></money>
              </div>
            </td>
            <td class="text-left">
              <div v-if="!onEdit">
                {{ d.est_arrival | moment("DD MMM YYYY") }}
              </div>
              <div v-else class="row" style="width: 100px;">
                <q-input
                  outlined
                  dense
                  class="bg-white"
                  v-model="edited[i].est_arrival"
                ></q-input>
              </div>
            </td>
            <td class="text-left bg-white" style="padding:0px;">
              <q-option-group
                v-model="d.is_received"
                :options="isReceivedOption"
              />
            </td>
            <!-- <td class="text-left bg-white" style="padding:0px;">
              <q-option-group class v-model="d.coa" :options="is_COA" />
            </td> -->
            <td class="text-left" style="padding: 0px;">
              <q-input
                square
                filled
                class="q-ma-sm"
                type="textarea"
                bg-color="white"
                v-model="d.note"
                dense
              />
            </td>
            <td class="text-center">
              <q-btn
                v-if="!d.sync"
                unelevated
                dense
                label="SYNC HARGA"
                color="primary"
                @click="
                  selSPP = JSON.parse(JSON.stringify(d));
                  selSPP.i = i;
                  confirmed = false;
                  dialogSync = true;
                "
              ></q-btn>
              <q-btn
                v-else
                unelevated
                dense
                icon="verified"
                color="positive"
                label="Synced"
              >
                <q-tooltip>
                  <div>Synced On {{ momentFilter(d.sync) }}</div>
                </q-tooltip>
              </q-btn>
            </td>
          </tr>
        </tbody>
      </q-markup-table>

      <q-card-actions class="row justify-end">
        <q-btn
          flat
          style="width: 100px;"
          color="grey"
          label="Kembali"
          @click="closeForm"
        />
        <q-btn
          flat
          style="width: 100px;"
          color="secondary"
          label="Edit"
          @click="onEdit = true"
        />
        <q-btn
          flat
          style="width: 100px;"
          color="primary"
          label="Simpan"
          @click="updateSPP()"
        />
      </q-card-actions>
    </q-card>
    <q-dialog v-model="dialogFilter" position="bottom">
      <q-card style="width: 300px">
        <q-card-section class="row justify-between items-center">
          <div class="text-h6">Filter</div>
        </q-card-section>
        <q-card-section class="q-gutter-y-sm">
          <q-select
            label="Status"
            outlined
            v-model="is_received"
            :options="receivedOption"
            map-options
            emit-value
            @input="
              replaceRoute();
              fetchData();
            "
          >
            <template v-slot:option="scope">
              <q-item v-bind="scope.itemProps" v-on="scope.itemEvents">
                <q-item-section>
                  <q-badge
                    :color="getLabelColor(scope.opt.label)"
                    text-color="white"
                    dense
                    >{{ scope.opt.label }}</q-badge
                  >
                </q-item-section>
              </q-item>
            </template>
          </q-select>
          <q-select
            label="Cost Category"
            outlined
            v-model="selCat"
            :options="cost_ctg"
            @input="
              replaceRoute();
              fetchData();
            "
          >
            <template v-slot:append>
              <q-btn
                v-if="selCat != null"
                icon="close"
                dense
                @click="
                  selCat = null;
                  replaceRoute();
                  fetchData();
                "
                flat
                size="sm"
              ></q-btn>
            </template>
          </q-select>
          <q-select
            outlined
            v-model="selVendor"
            map-options
            emit-value
            use-input
            hide-selected
            fill-input
            input-debounce="0"
            :options="filVendor"
            @filter="filterVD"
            label="Nama Vendor"
            class="col-3"
            @input="
              replaceRoute();
              fetchData();
            "
          >
            <template v-slot:no-option>
              <q-item>
                <q-item-section class="text-grey">No results</q-item-section>
              </q-item>
            </template>
            <template v-slot:append>
              <q-btn
                v-if="selVendor != null"
                icon="close"
                dense
                @click="
                  selVendor = null;
                  replaceRoute();
                  fetchData();
                "
                flat
                size="sm"
              ></q-btn>
            </template>
          </q-select>
        </q-card-section>
        <q-card-section class="row justify-end">
          <q-btn label="close" color="primary" v-close-popup></q-btn>
        </q-card-section>
      </q-card>
    </q-dialog>
    <q-dialog v-model="dialogSync">
      <q-card style="width:425px">
        <q-card-section class="row justify-between items-center bg-grey-2">
          <div class="text-bold text-h6">Sinkronisasi Harga RM</div>
          <q-btn icon="close" flat v-close-popup></q-btn>
        </q-card-section>
        <q-card-section>
          <q-markup-table separator="none" flat>
            <tr>
              <td>Nomor SPP</td>
              <td>:</td>
              <td>{{ selSPP.spp_id }}</td>
            </tr>
            <tr>
              <td>Item</td>
              <td>:</td>
              <td>{{ selSPP.item }}</td>
            </tr>
            <tr>
              <td>Harga PO/{{ selSPP.unit }}</td>
              <td>:</td>
              <td>
                {{
                  setCurrency(
                    parseFloat(selSPP.price / selSPP.qty),
                    selSPP.currency
                  )
                }}
              </td>
            </tr>
          </q-markup-table>
        </q-card-section>
        <q-card-section class="column q-gutter-y-sm">
          <div class="text-body1 text-bold">Sync Harga</div>
          <div class="row items-center">
            <div style="width:150px;">Nama RM</div>
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
              v-model="selSPP.id_rm"
              @filter="filterRM"
              style="flex-grow: 99;"
            >
              <template v-slot:no-option>
                <q-item>
                  <q-item-section class="text-grey">No results</q-item-section>
                </q-item>
              </template>
              <template v-slot:append>
                <q-btn
                  v-if="selSPP.id_rm"
                  icon="close"
                  dense
                  @click="selSPP.id_rm = null"
                  flat
                  size="sm"
                ></q-btn>
              </template>
            </q-select>
          </div>
          <div class="row items-center">
            <div style="width:150px;">Harga Sinkron</div>

            <money
              style="flex-grow: 99;"
              v-model="selSPP.syncPrice"
              v-bind="money"
            ></money>
          </div>
        </q-card-section>
        <q-card-section>
          <q-checkbox
            dense
            v-model="confirmed"
            label="Saya yakin akan melakukan penyesuaian harga RM terpilih dengan
            harga yang telah ditentukan"
          ></q-checkbox>
        </q-card-section>
        <q-card-actions align="stretch">
          <q-btn
            unelevated
            class="full-width"
            color="primary"
            label="SINKRON HARGA"
            :disable="isAllowed"
            @click="syncFormulation"
          ></q-btn>
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
      dialogFilter: false,

      sortBy: "",
      poList: [],
      slcPO: null,
      selected: [],
      isReceivedOption: [
        { label: "no", value: "0" },
        { label: "partial", value: "1" },
        { label: "full", value: "2" },
        { label: "suspended", value: "300" },
        { label: "closed", value: "40000" },
      ],
      is_received: "notz",
      receivedOption: [
        { label: "show all", value: "null" },
        { label: "fully received", value: "fully" },
        { label: "half received", value: "half" },
        { label: "not received", value: "not" },
        { label: "suspended", value: "suspended" },
        { label: "closed", value: "closed" },
      ],
      is_COA: [
        { label: "no", value: "0" },
        { label: "yes", value: "1" },
      ],
      show_detail: false,
      filterOption: [],
      filter: "",

      onEdit: false,
      edited: [],
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      moneyUSD: {
        decimal: ",",
        thousands: ".",
        prefix: "$ ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      curr: "IDR",
      cost_ctg: [
        "BELUM DIKATEGORIKAN",
        "Marketing/Sales",
        "RnD",
        "Produksi/Gudang",
        "Purchasing/Accounting",
        "Lab Pusat",
        "Lab Beton",
        "IT",
        "Umum/HRD",
        "Maintenance",
      ],

      optVendor: [],
      filVendor: [],
      selVendor: null,

      selCat: null,

      // new data
      formulation_rm: [],
      filtered_formulation_rm: [],
      dialogSync: false,
      selSPP: {},
      confirmed: false,
    };
  },
  async created() {
    if (this.$route.params.category != "null") {
      this.selCat = this.$route.params.category;
    }

    if (this.$route.params?.vendor != "null") {
      this.selVendor = this.$route.params.vendor;
    }
    this.is_received = this.$route.params.status;
    await this.$http
      .get("/list_month_po", {
        headers: {
          Authorization: "Bearer " + localStorage.getItem("token-purchase"),
        },
      })
      .then((result) => {
        this.filterOption = result.data;
        this.filter = "%";
        this.filterOption.unshift({ value: "%", label: "all" });
      });

    await this.$http
      .get(`/list_vendor`, {
        headers: {
          Authorization: "Bearer " + localStorage.getItem("token-purchase"),
        },
      })
      .then((resp) => {
        this.optVendor = resp.data;
      });

    await this.fetchData();
  },
  methods: {
    momentFilter(date) {
      return moment(date).format("DD MMM YYYY");
    },
    async syncFormulation() {
      try {
        this.$q.loading.show();
        let payload = {
          id: this.selSPP.id_rm,
          new_price: this.selSPP.syncPrice,
          id_spp: this.selSPP.spp_id,
        };

        await this.$http.put("/sync_formula/po", payload);

        await this.$http_formulation.put("/purchase/rm/price", payload);
        this.$q.notify({
          message: "Harga Berhasil Di Sinkronisasi!",
          color: "positive",
        });

        await this.openForm(this.selSPP.po_id);
        this.dialogSync = false;
        this.$q.loading.hide();
      } catch (err) {
        console.log(err);
        this.$q.notify({
          message: "Harga Gagal Di Sinkronisasi!",
          color: "negative",
        });
        this.$q.loading.hide();
      }
    },
    filterRM(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered_formulation_rm = this.formulation_rm.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    filterVD(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filVendor = this.optVendor.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    replaceRoute() {
      let the_cat = null;
      if (this.selCat) {
        the_cat = this.selCat.split("/");
        if (the_cat.length > 1) {
          the_cat = the_cat.join("%2F");
        } else {
          the_cat = the_cat.join("");
        }
      }

      this.$router.replace({
        path: `/po/list/${this.is_received}/${this.selVendor}/${the_cat}`,
      });
    },
    isPastEstimation(est_date) {
      if (moment().isAfter(moment(est_date))) return true;
      return false;
    },
    getLabelColor(label) {
      if (label == "fully received") return "positive";
      else if (label == "half received") return "warning";
      else if (label == "not received") return "negative";
      else if (label == "suspended") return "accent";
      else if (label == "closed") return "dark";
      else return "primary";
    },
    async fetchData() {
      this.poList = [];

      let payload = {
        is_rcv: this.is_received,
        filter: this.filter,
        vendor: this.selVendor,
        cat: this.selCat,
      };

      await this.$http
        .post(`/po`, payload, {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token-purchase"),
          },
        })
        .then((result) => {
          for (var i = 0; i < result.data.length; i++) {
            this.poList.push(result.data[i]);
          }
        });
      await this.$http_formulation.get(`/purchase/rm/all`).then((resp) => {
        this.formulation_rm = resp.data;
        this.filtered_formulation_rm = resp.data;
      });
    },
    async openForm(id) {
      this.edited = [];
      await this.$http
        .post("/podetail_byid", { po_id: id }, {})
        .then((result) => {
          this.selected = result.data;
          this.show_detail = true;
          for (var i = 0; i < this.selected.length; i++) {
            this.edited.push({
              item: this.selected[i].item,
              qty: this.selected[i].qty,
              unit: this.selected[i].unit,
              price: this.selected[i].price,
              currency: this.selected[i].currency,
              est_arrival: this.selected[i].est_arrival,
            });
          }
        });
    },
    closeForm() {
      this.show_detail = false;
      this.onEdit = false;
    },
    async updateSPP() {
      for (var i = 0; i < this.selected.length; i++) {
        let data = {
          is_received: this.selected[i].is_received,
          coa: this.selected[i].coa,
          note: this.selected[i].note,
          cost_category: this.selected[0].cost_category,

          item: this.edited[i].item,
          qty: this.edited[i].qty,
          unit: this.edited[i].unit,
          price: this.edited[i].price,
          est_arrival: this.edited[i].est_arrival,
        };
        var note_add = "";
        if (this.selected[i].item != this.edited[i].item) {
          note_add =
            note_add +
            ", nama item: " +
            this.selected[i].item +
            " => " +
            this.edited[i].item;
        }
        if (this.selected[i].qty != this.edited[i].qty) {
          note_add =
            note_add +
            ", qty: " +
            this.selected[i].qty +
            " => " +
            this.edited[i].qty;
        }
        if (this.selected[i].unit != this.edited[i].unit) {
          note_add =
            note_add +
            ", unit: " +
            this.selected[i].unit +
            " => " +
            this.edited[i].unit;
        }
        if (this.selected[i].price != this.edited[i].price) {
          note_add =
            note_add +
            ", harga: " +
            this.selected[i].price +
            " => " +
            this.edited[i].price;
        }
        if (note_add != "")
          data.revision = this.$store.state.currentUser.username;

        await this.$http
          .put("/update_spp/" + this.selected[i].spp_id, data, {})
          .then((result) => {});

        let history = {
          spp_id: this.selected[i].spp_id,
          status: "process",
          content: this.selected[i].note + note_add,
        };
        if (this.selected[i].is_received == 2) {
          history.status = "done";
        }
        if (this.selected[i].is_received == 300) {
          history.status = "suspended";
        }
        if (this.selected[i].is_received == 40000) {
          history.status = "closed";
        }
        this.$http.post("/new_history", history, {}).then((result) => {});
        var info = "";
        if (this.selected[i].is_received == 2)
          info = "barang sudah diterima penuh";
        if (this.selected[i].is_received == 1)
          info = "barang sudah diterima sebagian";
        if (this.selected[i].is_received == 300)
          info = "PO sementara di suspend";
        if (this.selected[i].is_received == 40000)
          info = "PO dinyatakan closed";
        var notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.selected[i].user_id,
          notif: "Konfirmasi Penerimaan barang",
          note: info,
          spp_id: this.selected[i].spp_id,
          reference_page: "/spp/list",
        };
        if (info != 0) {
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          notifikasi.to_id = 1; // Notif ke Manager purchasing
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
        }
      }
      this.show_detail = false;
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.$q.notify("Data PO berhasil diubah!");
      this.onEdit = false;
    },
    setCurrency(price, cur) {
      if (cur == "IDR") {
        const formatter = new Intl.NumberFormat("ID", {
          style: "currency",
          currency: "IDR",
          currencyDisplay: "symbol",
          minimumFractionDigits: 0,
        });
        return formatter.format(price);
      } else if (cur == "USD") {
        const formatter = new Intl.NumberFormat("US", {
          style: "currency",
          currency: "USD",
          currencyDisplay: "symbol",
          minimumFractionDigits: 2,
        });
        return formatter.format(price);
      }
    },
    chgCurrency() {
      if (this.curr == "IDR") {
        this.money.precision = 0;
        this.money.prefix = "Rp ";
      } else {
        this.money.precision = 2;
        this.money.prefix = "$ ";
      }
    },
  },
  computed: {
    isAllowed() {
      let temp = JSON.parse(JSON.stringify(this.selSPP));

      if (!temp.id_rm || !temp.syncPrice || !this.confirmed) {
        return true;
      }
      return false;
    },
    sortedListPO() {
      let temp = this.poList.slice(0);
      if (this.sortBy == "est_arrival") {
        return temp.sort((a, b) => {
          let x = new Date(a.est_arrival);
          let y = new Date(b.est_arrival);
          return (y - x) * -1;
        });
      } else if (this.sortBy == "po_date") {
        return temp.sort((a, b) => {
          let x = new Date(a.po_date);
          let y = new Date(b.po_date);
          return y - x;
        });
      } else if (this.sortBy == "cost_category") {
        return temp.sort((a, b) => {
          let x = a.cost_category;
          let y = b.cost_category;
          return x.localeCompare(y);
        });
      } else {
        return this.poList;
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
  width: 100px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
