<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
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

      <!-- table header  -->
      <q-markup-table
        v-if="sppList.length"
        class="stickyTable"
        style="height: calc(100vh - 280px);"
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
                      createPO();
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
            outline
            style="color: black;"
            @click="toPreview"
            no-caps
            icon="print"
          >
          </q-btn>
          <q-btn
            unelevated
            label="Buat PO"
            color="blue"
            @click="createPO"
            no-caps
            icon="edit"
          >
          </q-btn>
        </div>
      </q-card-section>
    </q-footer>
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
      sppList: [],
      sppSelect: [],
      sppSelectID: [],

      show_detail: false,
      history: [],
      show_history: false,
      selected: {},

      po: {
        po_date: moment().format("YYYY/MM/DD"),
        po_id: "",
      },

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
    async getDept() {
      // let resp = this.$http.get("/dept")
      this.$http.get("/dept").then((resp) => {
        let dept = resp.data.map((a) => a.dept);
        this.optDept = dept;
      });
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
            this.$store.state.currentUser.is_purch_manager +
            q_filter,

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
    changeType() {
      if (this.type == "PO")
        this.po.po_id = `OP/CM/${moment().format("YY")}/${moment().format(
          "MM"
        )}/`;
      else this.po.po_id = "NON-PO/" + this.sppSelect[0].spp_id;
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
    createPO() {
      for (var i = 0; i < this.sppList.length; i++) {
        if (this.sppList[i].select == true) {
          this.sppSelectID.push(this.sppList[i].spp_id);
        }
      }

      if (this.sppSelect.length > 0) {
        this.changeType();

        this.curr = "IDR";
        this.chgCurrency();
      }

      this.$router.push(`/po/create?ids=${this.sppSelectID.join(",")}`);
    },
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter((e) => e.select === true);
      var count = data.length;

      if (data[0]) this.selected = data[0];

      return count;
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
