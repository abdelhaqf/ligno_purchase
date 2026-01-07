<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <q-tabs
        v-model="is_received"
        dense
        class="text-grey q-mt-sm"
        active-color="blue"
        indicator-color="blue"
        align="left"
        narrow-indicator
        @input="
          pagination.current = 1;
          replaceRoute();
          fetchData();
        "
      >
        <q-tab
          name="not"
          no-caps
          :label="'Belum Diterima (' + countNot + ')'"
        />
        <q-tab
          name="half"
          no-caps
          :label="'Diterima Sebagian (' + countPartial + ')'"
        />
        <q-tab
          name="suspend"
          no-caps
          :label="'Suspended (' + countSuspend + ')'"
        />
        <q-tab name="fully" no-caps label="Sudah Diterima" />
        <q-tab name="closed" no-caps label="Ditutup" />
      </q-tabs>
      <q-separator />
      <div class="row q-ma-md items-center q-gutter-x-md">
        <q-input
          outlined
          dense
          v-model="searchTerm"
          @input="
            pagination.current = 1;
            replaceRoute();
            fetchData();
          "
          clearable
          @clear="searchTerm = ''"
          placeholder="Cari Nomor PO"
          style="width: 20%;"
        >
          <template v-slot:prepend>
            <q-icon name="search"></q-icon>
          </template>
        </q-input>

        <q-field
          v-model="date"
          clearable
          dense
          outlined
          style="width: 20%;"
          @clear="
            pagination.current = 1;
            replaceRoute();
            fetchData();
          "
        >
          <template v-slot:prepend>
            <q-icon name="date_range" />
          </template>

          <template v-slot:control>
            <div class="self-center full-width no-outline" tabindex="0">
              {{ date_model }}
            </div>
          </template>
          <q-popup-proxy
            style="width:fit-content"
            transition-show="scale"
            transition-hide="scale"
          >
            <q-date
              v-model="date"
              range
              @input="
                pagination.current = 1;
                replaceRoute();
                fetchData();
              "
            >
              <div class="row items-center justify-end">
                <q-btn v-close-popup label="Close" color="primary" flat />
              </div>
            </q-date>
          </q-popup-proxy>
        </q-field>
        <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optSort"
            v-model="selSort"
            @input="
                pagination.current = 1;
                fetchData();
              "
            label="Urutkan"
            style="width: 20%;"
          ></q-select>
        <q-btn
          unelevated
          label="Filter"
          color="white"
          text-color="black"
          outline
          style="color: black;"
          no-caps
          icon="filter_list"
          @click="dialogFilter = true"
        ></q-btn>
      </div>
      <div v-if="poList.length">
        <q-markup-table
          wrap-cells
          flat
          class="stickyTable"
          style="height: calc(100vh - 355px);"
        >
          <!-- table head -->
          <thead class="text-white">
            <tr>
              <th class="q-px-xs">No</th>
              <th>No PO</th>
              <th>Tanggal PO</th>
              <th>PIC</th>
              <th>Vendor</th>
              <th>Items</th>
              <th>Kategori Biaya</th>
              <th>Est. Arrival</th>
              <th>Status</th>
              <th class="q-mx-sm">Action</th>
            </tr>
          </thead>
          <!-- table body  -->
          <tbody>
            <tr
              v-for="(d, i) in poList"
              :key="i"
            >
              <td class="text-center q-px-xs">
                {{ (pagination.current - 1) * pagination.limit + i + 1 }}
              </td>
              <td class="text-left">
                {{ d.po_id }}
              </td>
              <td class="text-center">
                {{ momentFormatDate(d.po_date) }}
              </td>
              <td class="text-left">
                {{ d.handler_name }}
              </td>
              <td class="text-left">
                <!-- {{ d.vendor }} -->
                <div>
                  <span>
                    {{
                      d.vendor.length > 20 ? d.vendor.slice(0, 13) : d.vendor
                    }}
                  </span>
                  <span v-if="d.vendor.length > 20" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ d.vendor }}</q-tooltip
                    >
                  </span>
                </div>
              </td>
              <td class="text-left">
                <!-- {{ d.item }} -->
                <div>
                  <span>
                    {{ d.item.length > 20 ? d.item.slice(0, 13) : d.item }}
                  </span>
                  <span v-if="d.item.length > 20" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ d.item }}</q-tooltip
                    >
                  </span>
                  <span>{{
                    d.spp_count > 1 ? "(+" + (d.spp_count - 1) + ")" : ""
                  }}</span>
                </div>
              </td>
              <td class="text-center">
                {{ d.cost_category }}
              </td>
              <td class="text-center no-wrap" :style="isPastEstimation(d.est_arrival) &&
                  (is_received == 'not' ||
                    is_received == 'half' ||
                    is_received == 'suspend') ? 'color: red; vertical-align: middle;' : ''">
                    <q-icon
                      v-if="isPastEstimation(d.est_arrival) &&
                        (is_received == 'not' ||
                        is_received == 'half' ||
                        is_received == 'suspend')
                      "
                      style="color: white; background-color: red; border-radius: 50%; font-size: 10px;"
                      name="priority_high"
                      class="q-ma-sm q-pa-xs"
                    ></q-icon>
                    <span>{{ momentFormatDate(d.est_arrival) }}</span>
                
              </td>
              <td class="text-center">
                <!-- <q-btn
                  v-if="d.is_received == 'not received'"
                  unelevated
                  label="NOT"
                  color="negative"
                  disable
                  no-caps
                  rounded
                >
                </q-btn>
                <q-btn
                  v-else
                  unelevated
                  label="RECEIVED"
                  color="positive"
                  disable
                  no-caps
                  rounded
                >
                </q-btn> -->
                <div
                  v-if="d.is_received == 'not received'"
                  class="bg-red-2 items-center text-center q-py-xs"
                  style="border-radius: 1000px; width: 80px; height: 32px; color: red;"
                >
                  NOT
                </div>
                <div
                  v-else-if="d.is_received == 'suspended'"
                  class="bg-yellow-2 items-center text-center q-py-xs"
                  style="border-radius: 1000px; width: 100px; height: 32px; color: orange;"
                >
                  SUSPENDED
                </div>
                <div
                  v-else-if="d.is_received == 'closed'"
                  class="bg-grey-2 items-center text-center q-py-xs"
                  style="border-radius: 1000px; width: 100px; height: 32px; color: dark;"
                >
                  CLOSED
                </div>
                <div
                  v-else-if="d.is_received == 'fully received'"
                  class="bg-green-2 items-center text-center q-py-xs"
                  style="border-radius: 1000px; width: 100px; height: 32px; color: green;"
                >
                  RECEIVED
                </div>
              </td>
              <td class="text-center q-mx-lg">
                <q-btn
                  label="Detail"
                  flat
                  no-caps
                  color="blue"
                  dense
                  :to="`/po/detail/${encodeURIComponent(d.po_id)}`"
                />
              </td>
            </tr>
          </tbody>
        </q-markup-table>

        <q-separator />

        <q-card-section class="flex flex-center q-py-sm">
          <q-pagination
            input
            :max="pagination.max"
            v-model="pagination.current"
            @input="replaceRoute();
                    fetchData();"
          ></q-pagination>
        </q-card-section>
      </div>

      <q-card-section
        class="column items-center justify-center"
        style="height: calc(100vh - 275px);"
        v-else
      >
        <q-img width="400px" :src="`./empty.png`"></q-img>
        <div class="l-text-title text-bold">Data Tidak Ditemukan</div>
      </q-card-section>
    </q-card>

    <q-dialog v-model="dialogFilter" position="bottom" persistent>
      <q-card style="width: 400px">
        <q-card-section class="row justify-between items-center">
          <div class="text-h6">Filter</div>
          <q-btn
            flat
            dense
            icon="close"
            v-close-popup
            @click="replaceFilter"
          ></q-btn>
        </q-card-section>

        <q-separator />

        <q-card-section
          class="q-gutter-y-sm"
          style="background-color: #F9F9F9;"
        >
          <!-- <q-select
            label="Status"
            outlined
            v-model="is_received"
            :options="receivedOption"
            map-options
            emit-value
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
          </q-select> -->
          <div>Kategori Biaya</div>
          <q-select
            use-chips
            multiple
            clearable
            @clear="selCat = null"
            label="Pilih Kategori Biaya"
            outlined
            v-model="selCat"
            :options="cost_ctg"
            class="bg-white"
          >
          </q-select>
          <div>Nama Vendor</div>
          <q-select
            outlined
            v-model="selVendor"
            map-options
            emit-value
            use-input
            hide-selected
            fill-input
            clearable
            input-debounce="0"
            :options="filVendor"
            @filter="filterVD"
            label="Pilih Nama Vendor"
            class="bg-white"
          >
            <template v-slot:no-option>
              <q-item>
                <q-item-section class="text-grey">No results</q-item-section>
              </q-item>
            </template>
            <!-- <template v-slot:append>
              <q-btn
                v-if="selVendor != null"
                icon="close"
                dense
                flat
                size="sm"
              ></q-btn>
            </template> -->
          </q-select>
          <div>Kategori Barang atau Jasa</div>
          <q-select
            outlined
            v-model="selKategori"
            :options="kategori"
            label="Pilih Kategori Barang atau Jasa"
            class="bg-white"
            clearable
          >
            <!-- <template v-slot:append>
              <q-btn
                v-if="selKategori != null"
                icon="close"
                dense
                flat
                size="sm"
              ></q-btn>
            </template> -->
          </q-select>
        </q-card-section>
        <q-card-section class="row justify-center items-center">
          <q-btn
            v-close-popup
            style="width: 100%;"
            color="primary"
            noCaps
            :label="
              this.selCat
                ? `Pilih Filter (${this.selCat.length})`
                : `Pilih Filter`
            "
            @click="
              // selVendor = null;
              // selCat = null;
              // selKategori = null;
              replaceRoute();
              fetchData();
            "
          >
          </q-btn>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
import { Money } from "v-money";
import rm from "../store/rm.json";
export default {
  components: { Money },
  data() {
    return {
      date: "",
      searchTerm: "",
      poList: [],

      dialogFilter: false,
      filterOption: [],
      filter: "",

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

      kategori: [],

      optVendor: [],
      filVendor: [],

      selVendor: null,
      is_received: "not",
      selCat: null,
      selKategori: null,

      countNot: "",
      countPartial: "",
      countSuspend: "",

      pagination: {
        max: 2,
        current: 1,
        limit: 25,
      },

      show_detail: false,
      optSort: [
        { label: "Tanggal PO Terdekat", value: "po_date DESC" },
        { label: "Tanggal PO Terlama", value: "po_date ASC" },
        { label: "Nomor PO Terkecil", value: "po_id ASC" },
        { label: "Nomor PO Terbesar", value: "po_id DESC" },
        { label: "Est. Arrival Terdekat", value: "est_arrival ASC" },
        { label: "Est. Arrival Terlama", value: "est_arrival DESC" },
      ],
      selSort: "po_date DESC",
    };
  },
  async created() {
    await this.replaceFilter();
    await this.getKategori();

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
    // getLabelColor(label) {
    //   if (label == "fully received") return "positive";
    //   else if (label == "half received") return "warning";
    //   else if (label == "not received") return "negative";
    //   else if (label == "suspended") return "accent";
    //   else if (label == "closed") return "dark";
    //   else return "primary";
    // },
    async getKategori() {
      let resp = await this.$http.get("/kategori");
      let kategori = resp.data.map((a) => a["name"]);
      this.kategori = kategori;
    },
    isPastEstimation(est_date) {
      if (moment().isAfter(moment(est_date))) return true;
      return false;
    },
    momentFormatDate(date) {
      if (date) {
        return moment(date).format("DD MMM YYYY");
      }
      return "-";
    },
    async fetchData() {
      this.poList = [];

      // let q_filter = `?search=${this.searchTerm ? this.searchTerm : ""}&date=${this.date ? moment(this.date).format("YYYY-MM-DD") : ""}`;
      // console.log(q_filter);
      // let q_filter = `?search=${
      //   this.searchTerm ? this.searchTerm : ""}`;

      let category = [];
      if (this.selCat) {
        for (var i = 0; i < this.selCat.length; i++) {
          category.push(encodeURI(this.selCat[i]));
        }

        category = category.join(",");
      }

      let payload = {
        is_rcv: this.is_received == "null" ? "" : this.is_received,
        vendor: this.selVendor == null ? "" : this.selVendor,
        cat: this.selCat ? category : "",
        kategori: this.selKategori == null ? "" : this.selKategori,
        search: this.searchTerm ? this.searchTerm : "",
        // date: this.date ? moment(this.date).format("YYYY-MM-DD") : "",
        date: this.date
          ? typeof this.date === "string"
            ? moment(this.date).format("YYYY-MM-DD")
            : {
                from: moment(this.date.from).format("YYYY-MM-DD"),
                to: moment(this.date.to).format("YYYY-MM-DD"),
              }
          : "",
        current: this.pagination.current,
        limit: this.pagination.limit,
        sort:  this.selSort,
      };

      await this.$http
        .post(`/po`, payload, {
          headers: {
            Authorization: "Bearer " + localStorage.getItem("token-purchase"),
          },
        })
        .then((result) => {
          let total_count = result.data.poList[0]
            ? parseInt(result.data.poList[0].total_count)
            : 0;
          this.pagination.max = Math.ceil(total_count / this.pagination.limit);

          this.countNot = result.data["not received"];
          this.countPartial = result.data["half received"];
          this.countSuspend = result.data["suspended"];

          this.poList = JSON.parse(JSON.stringify(result.data.poList));
        });

      // temporary
      this.formulation_rm = JSON.parse(JSON.stringify(rm));
      this.filtered_formulation_rm = JSON.parse(JSON.stringify(rm));
      // await this.$http_formulation.get(`/purchase/rm/all`).then((resp) => {
      //   this.formulation_rm = resp.data;
      //   this.filtered_formulation_rm = resp.data;
      // });
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
      let category = [];
      if (this.selCat) {
        for (var i = 0; i < this.selCat.length; i++) {
          category.push(encodeURI(this.selCat[i]));
        }

        category = category.join(",");
      }

      this.$router.replace({
        path: `/po/list?status=${this.is_received}&vendor=${
          encodeURIComponent(this.selVendor)
        }&category=${this.selCat ? category : null}&kategori=${
          encodeURIComponent(this.selKategori)
        }&search=${this.searchTerm ? encodeURIComponent(this.searchTerm) : ""}&date=${
          this.date
            ? typeof this.date === "string"
              ? moment(this.date).format("YYYY-MM-DD")
              : moment(this.date.from).format("YYYY-MM-DD") +
                "to" +
                moment(this.date.to).format("YYYY-MM-DD")
            : ""
        }&page=${this.pagination.current}`,
      });
    },
    async replaceFilter() {
      if (this.$route.query.category) {
        this.selCat =
          this.$route.query.category == "null"
            ? null
            : this.$route.query.category.split(",");
      }

      if (this.$route.query?.vendor) {
        this.selVendor =
          this.$route.query.vendor == "null" ? null : this.$route.query.vendor;
      }

      if (this.$route.query?.kategori) {
        this.selKategori =
          this.$route.query.kategori == "null"
            ? null
            : this.$route.query.kategori;
      }

      if (this.$route.query?.status) {
        this.is_received = this.$route.query.status;
      }

      if (this.$route.query?.search) {
        this.searchTerm = this.$route.query.search;
      }

      if (this.$route.query?.date) {
        // this.date = this.$route.query.date;
        this.date = this.$route.query.date.includes("to")
          ? {
              from: this.$route.query.date.split("to")[0],
              to: this.$route.query.date.split("to")[1],
            }
          : this.$route.query.date;
      }
      if (this.$route.query?.page) {
        this.pagination.current = this.$route.query.page;
      } 
    },
  },
  computed: {
    date_model() {
      if (!this.date) return "Pilih Tanggal Dibuat";

      if (this.date.from) {
        return (
          moment(this.date.from).format("DD MMMM YYYY") +
          " - " +
          moment(this.date.to).format("DD MMMM YYYY")
        );
      } else {
        return moment(this.date).format("DD MMMM YYYY");
      }
    },
    selectCount() {
      var count = this.selCat.length;

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
  width: 100px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
