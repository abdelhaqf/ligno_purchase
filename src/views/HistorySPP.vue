<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-between q-gutter-x-md no-wrap">
        <q-input
          outlined
          dense
          v-model="searchTerm"
          clearable
          @clear="searchTerm = ''"
          placeholder="Cari Nama Barang"
          class="l-grow"
          @input="
            pagination.current = 1;
            replaceRoute();
            change();
          "
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
          class="l-grow"
          @clear="
            pagination.current = 1;
            replaceRoute();
            change();
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
              @input="
                pagination.current = 1;
                replaceRoute();
                change();
              "
              range
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
          v-model="selectVendor"
          map-options
          emit-value
          use-input
          hide-selected
          fill-input
          input-debounce="0"
          :options="filteredVD"
          @filter="filterVD"
          label="Pilih Vendor"
          class="l-grow"
          @input="
            pagination.current = 1;
            replaceRoute();
            change();
          "
        >
          <template v-slot:no-option>
            <q-item>
              <q-item-section class="text-grey">No results</q-item-section>
            </q-item>
          </template>
          <template v-slot:append>
            <q-btn
              v-if="selectVendor != null"
              icon="close"
              dense
              @click="
                selectVendor = null;
                pagination.current = 1;
                replaceRoute();
                change();
              "
              flat
              size="sm"
            ></q-btn>
          </template>
        </q-select>

        <q-select
          outlined
          dense
          v-model="selectUser"
          map-options
          emit-value
          use-input
          hide-selected
          fill-input
          input-debounce="0"
          :options="filteredUser"
          @filter="filterUser"
          label="Pilih User"
          class="l-grow"
          @input="
            pagination.current = 1;
            replaceRoute();
            change();
          "
        >
          <template v-slot:no-option>
            <q-item>
              <q-item-section class="text-grey">No results</q-item-section>
            </q-item>
          </template>
          <template v-slot:append>
            <q-btn
              v-if="selectUser != null"
              icon="close"
              dense
              @click="
                selectUser = null;
                pagination.current = 1;
                replaceRoute();
                change();
              "
              flat
              size="sm"
            ></q-btn>
          </template>
        </q-select>

        <q-select
          outlined
          dense
          label="Urut Per-"
          class="l-grow"
          v-model="selSort"
          :options="optSort"
          map-options
          emit-value
          @input="
            pagination.current = 1;
            replaceRoute();
            change();
          "
        ></q-select>
      </q-card-section>
      <div v-if="priceList.length">
        <q-markup-table
          flat
          square
          wrap-cells
          class="stickyTable"
          style="height:calc(100vh - 310px)"
        >
          <thead>
            <tr class="bg-blue-grey-14 text-white">
              <th class="text-left">No</th>
              <th class="text-left">Nomor PO</th>
              <th class="text-left">Tanggal PO</th>
              <th class="text-left">Nama User</th>
              <th class="text-left">Nama Vendor</th>
              <th class="text-left">Nama Items</th>
              <th class="text-right">Harga Items</th>
              <th class="text-center">Keterangan</th>
              <!-- <th class="text-center">Action</th> -->
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, i) in priceList" :key="i">
              <td class="text-center">
                {{ (pagination.current - 1) * 25 + i + 1 }}
              </td>
              <td class="text-left">{{ p.po_id }}</td>
              <td class="text-left">{{ momentFormatDate(p.po_date) }}</td>
              <td class="text-left">{{ p.user_name }}</td>
              <td class="text-left">
                <!-- {{ p.vendor }} -->
                <div class="l-wrap-cell" style="width: 150px !important;">
                  <span>
                    {{
                      p.vendor.length > 40 ? p.vendor.slice(0, 35) : p.vendor
                    }}
                  </span>
                  <span v-if="p.vendor.length > 40" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ p.vendor }}</q-tooltip
                    >
                  </span>
                </div>
              </td>
              <td class="text-left">
                <!-- {{ p.item }} -->
                <div class="l-wrap-cell" style="width: 200px !important;">
                  <span>
                    {{ p.item.length > 25 ? p.item.slice(0, 24) : p.item }}
                  </span>
                  <span v-if="p.item.length > 25" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ p.item }}</q-tooltip
                    >
                  </span>
                </div>
                <div class="text-grey">{{ p.qty }} {{ p.unit }}</div>
              </td>
              <td class="text-left">
                {{
                  setCurrency(
                    parseFloat(p.price) / parseFloat(p.qty),
                    p.currency
                  )
                }}
                / {{ p.unit }}
              </td>
              <td>
                <div
                  class="l-wrap-cell"
                  v-if="p.description"
                  style="width: 200px !important;"
                >
                  <span>
                    {{
                      p.description.length > 55
                        ? p.description.slice(0, 50)
                        : p.description
                    }}
                  </span>
                  <span v-if="p.description.length > 55" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ p.description }}</q-tooltip
                    >
                  </span>
                </div>
                <div v-else class="l-grow text-center">-</div>
              </td>
              <!-- <td class="text-center">
                <q-btn
                  label="Detail"
                  flat
                  no-caps
                  color="blue"
                  dense
                  :to="`/po/detail/${encodeURIComponent(p.po_id)}`"
                />
              </td> -->
            </tr>
          </tbody>
          <!-- <tbody v-else class="bg-green-1">
            <tr>
              <td class="text-center text-grey" colspan="99">
                tidak ada data, atau mungkin anda belum memilih
              </td>
            </tr>
          </tbody> -->
        </q-markup-table>
        <q-separator />
        <q-card-actions align="center">
          <q-pagination
            v-model="pagination.current"
            :max="pagination.max"
            input
            @input="
              replaceRoute();
              change();
            "
          ></q-pagination>
        </q-card-actions>
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
  </div>
</template>

<script>
import moment from "moment";
moment.locale("id");
export default {
  data() {
    return {
      searchTerm: "",
      date: "",
      option: [],
      filtered: [],
      // selectOption: null,
      priceList: [],
      optVendor: [],
      filteredVD: [],
      selectVendor: null,
      optUser: [],
      filteredUser: [],
      selectUser: null,

      optSort: [
        { label: "Tanggal PO ASC", value: "po_date ASC" },
        { label: "Tanggal PO DESC", value: "po_date DESC" },
        { label: "Harga Barang ASC", value: "item_price ASC" },
        { label: "Harga Barang DESC", value: "item_price DESC" },
      ],
      selSort: "po_date DESC",

      pagination: {
        current: 1,
        max: 1,
      },
    };
  },
  async mounted() {
    await this.fetchData();
    await this.replaceFilter();
    await this.change();
  },
  computed: {
    date_model() {
      if (!this.date) return "Pilih Tanggal PO";

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
  methods: {
    filterOP(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered = this.option.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    filterVD(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filteredVD = this.optVendor.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    filterUser(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filteredUser = this.optUser.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    async fetchData() {
      await this.$http.get("/list_item", {}).then((result) => {
        this.option = result.data;
      });
      await this.$http.get("/list_vendor", {}).then((result) => {
        this.optVendor = result.data;
      });
      await this.$http.get("/list/user", {}).then((result) => {
        this.optUser = result.data;
        this.filteredUser = result.data;
      });
    },
    async change(val) {
      try {
        this.$q.loading.show();
        let payload = {
          vendor: this.selectVendor ? this.selectVendor : "",
          current: this.pagination.current,
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
          user: this.selectUser ? this.selectUser : "",
          sort: this.selSort ? this.selSort : "",
        };
        await this.$http.post("/pricelist/new", payload).then((result) => {
          this.priceList = result.data.items;

          this.pagination.max = Math.ceil(parseFloat(result.data.count / 25));
        });
        this.$q.loading.hide();
      } catch (err) {
        this.$q.loading.hide();
      }
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
          minimumFractionDigits: 3,
        });
        return formatter.format(price);
      }
    },
    momentFormatDate(date) {
      if (date) {
        return moment(date).format("DD MMM YYYY");
      }
      return "-";
    },
    replaceRoute() {
      this.$router.replace({
        path: `/history/spp?vendor=${encodeURIComponent(
          this.selectVendor
        )}&search=${
          this.searchTerm ? encodeURIComponent(this.searchTerm) : ""
        }&date=${
          this.date
            ? typeof this.date === "string"
              ? moment(this.date).format("YYYY-MM-DD")
              : moment(this.date.from).format("YYYY-MM-DD") +
                "to" +
                moment(this.date.to).format("YYYY-MM-DD")
            : ""
        }&page=${this.pagination.current}&user=${
          this.selectUser ? encodeURIComponent(this.selectUser) : ""
        }&sort=${this.selSort}`,
      });
    },
    async replaceFilter() {
      if (this.$route.query?.vendor) {
        this.selectVendor =
          this.$route.query.vendor == "null" ? null : this.$route.query.vendor;
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
      if (this.$route.query?.user) {
        this.selectUser =
          this.$route.query.user == "" ? null : this.$route.query.user;
      }
      if (this.$route.query?.sort) {
        this.selSort = this.$route.query.sort;
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.l-wrap-cell {
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
