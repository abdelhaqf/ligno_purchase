<template>
  <div class="row relative q-px-lg ">
    <q-card
      flat
      bordered
      v-if="!formPO"
      class="col-12 bg-white rounded-borders"
    >
      <!-- table control -->
      <q-card-section class="row justify-between q-gutter-x-md">
        <div>
          <q-input
            outlined
            dense
            v-model="searchTerm"
            @input="fetchData"
            clearable
            @clear="searchTerm = ''"
            placeholder="Cari Nama Barang"
            style="width: 400px;"
          >
            <template v-slot:prepend>
              <q-icon name="search"></q-icon>
            </template>
          </q-input>
        </div>
        
        <div class="row items-center q-gutter-x-sm">
          <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optDept"
            v-model="selDivisi"
            clearable
            @clear="selDivisi = ''"
            @input="fetchData"
            label="Pilih Divisi"
            style="width: 230px;"
          ></q-select>
          <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optSort"
            v-model="selSort"
            @input="fetchData"
            label="Urutkan"
            style="width: 230px;"
          ></q-select>
        </div>
        
      </q-card-section>
      <!-- <q-card-section class="q-pa-md row justify-between items-center">
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
      </q-card-section> -->
      <!-- table header  -->
      <q-markup-table
        v-if="sppList.length"
        class="stickyTable"
        style="height: calc(100vh - 275px);"
      >
        <!-- table head -->
        <thead class="text-white">
          <tr>
            <th style="width:20px;">
              <q-checkbox v-model="check_all" @input="checkAll"></q-checkbox>
            </th>
            <th>User</th>
            <th>Divisi</th>
            <th>PIC</th>
            <th>Tanggal Pengajuan</th>
            <th>Deadline</th>
            <th>Barang</th>
            <th>Jumlah</th>
            <th>Action</th>
          </tr>
        </thead>
        <!-- table body  -->
        <tbody>
          <tr v-for="(d, i) in sppList" :key="i">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td class="text-left">
              {{ d.name }}
            </td>
            <td class="text-left">
              {{ d.dept }}
            </td>
            <td class="text-left">
              {{ d.handler_name }}
            </td>
            <td class="text-center" style="width:150px">
              {{ d.create_at | moment("DD MMM YYYY") }}
            </td>
            <td class="text-center" style="width:150px">
              {{ d.deadline | moment("DD MMM YYYY") }}
            </td>
            <td class="text-left">{{ d.item }}</td>
            <td class="text-center">{{ d.qty }} {{ d.unit }}</td>
            <td class="text-center">
              <q-btn-dropdown flat dense dropdown-icon="more_horiz">
                <q-list>
                  <q-item
                    clickable
                    v-close-popup
                    @click="
                      clearSelect(i);
                      confirmApprove = true;
                    "
                  >
                    Buat PO
                  </q-item>
                  <q-item
                    clickable
                    v-close-popup
                    @click="
                      clearSelect(i);
                      toPreview();
                      "
                  >
                    Print
                  </q-item>
                </q-list>
              </q-btn-dropdown>
            </td>
          </tr>
        </tbody>
      </q-markup-table>
      <q-card-section
        class="column items-center justify-center"
        style="height: calc(100vh - 275px);"
        v-else
      >
        <q-img width="400px" :src="`./empty.png`"></q-img>
        <div class="l-text-title text-bold">Data Tidak Ditemukan</div>
      </q-card-section>
      <!-- <q-markup-table bordered flat square dense>
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
      </q-markup-table> -->
      <q-card-section></q-card-section>
    </q-card>

    <q-footer
      v-if="selectCount > 0"
      style="max-width: 1440px;"
      class="q-mx-auto atas-radius bg-white"
    >
      <q-card-section class="row justify-between items-center">
        <div class="l-text-subtitle text-bold text-black">
          {{ selectCount }} PO Dipilih
        </div>
        <div class="row justify-end items-center q-gutter-x-md">
          <q-btn
            unelevated
            label="Print"
            color="white" 
            text-color="black" 
            outline style="color: black;"
            @click="toPreview"
            no-caps
            icon="print"
          >
          </q-btn>
          <q-btn
            unelevated
            label="Buat PO"
            color="blue"
            @click="confirmApprove = true"
            no-caps
            icon="edit"
          >
          </q-btn>
        </div>
      </q-card-section>
    </q-footer>

    <!-- form PO baru -->
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
      option: [],

      optSort: [
        { label: "Deadline Terdekat", value: "deadline ASC" },
        { label: "Deadline Terlama", value: "deadline DESC" },
        { label: "Pengajuan Terdekat", value: "create_at ASC" },
        { label: "Pengajuan Terlama", value: "create_at DESC" },
      ],
      selSort: "deadline ASC",

      selDivisi: "",
      optDept: [],

      searchTerm: "",
      check_all: false,


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
    this.fetchData();
    this.getDept();
  },
  watch: {
    sppList: {
      deep: true,
      handler(val) {
        let rows = JSON.parse(JSON.stringify(this.sppList));
        let checked = val.filter((el) => el.select);
        let unchecked = val.filter((el) => !el.select);

        if (checked.length == rows.length) {
          this.check_all = true;
        } else if (unchecked.length == rows.length) {
          this.check_all = false;
        } else {
          this.check_all = null;
        }
      },
    },
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
    clearSelect(idx) {
      let temp = JSON.parse(JSON.stringify(this.sppList));
      for (let i in temp) {
        if (i == idx) temp[i].select = true;
        else temp[i].select = false;
      }
      this.sppList = temp;
    },
    checkAll(val) {
      let temp = JSON.parse(JSON.stringify(this.sppList));
      for (let item of temp) {
        item.select = val;
      }
      this.sppList = temp;
    },
    fetchData() {
      this.sppList = [];
      let q_filter = `?sort=${this.selSort}&search=${
        this.searchTerm ? this.searchTerm : ""
      }&dept=${this.selDivisi ? this.selDivisi : ""}`;

      this.$http
        .get(
          "/spp_approved/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager
            + q_filter,

          {}
        )
        .then((result) => {
          for (var i = 0; i < result.data.length; i++) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        });
    },
    async getDept() {
      // let resp = this.$http.get("/dept")
      this.$http.get("/dept").then((resp) => {
        let dept = resp.data.map((a) => a.dept);
        this.optDept = dept
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

          // await this.$http_formulation.put("/purchase/rm/price", payload);
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
