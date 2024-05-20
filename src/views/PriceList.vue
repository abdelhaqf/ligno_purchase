<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-between no-wrap">
        <q-input
          outlined
          dense
          v-model="searchTerm"
          clearable
          @clear="searchTerm = ''"
          placeholder="Cari Nama Barang"
          style="width: 30%;"
          @input="pagination.current = 1; change();"
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
          style="width: 33%;"
          @clear="pagination.current = 1; change()"
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
            <q-date v-model="date" @input="pagination.current = 1; change()" range>
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
          style="width:33%"
          @input="change()"
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
                change();
              "
              flat
              size="sm"
            ></q-btn>
          </template>
        </q-select>
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
              <th class="text-left">Nama Vendor</th>
              <th class="text-left">Nama Items</th>
              <th class="text-right">Harga Items</th>
              <th class="text-center">Keterangan</th>
              <th class="text-center">Action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, i) in priceList" :key="i">
              <td class="text-center">
                {{ (pagination.current - 1) * 25 + i + 1 }}
              </td>
              <td class="text-left">{{ p.po_id }}</td>
              <td class="text-left">{{ momentFormatDate(p.po_date) }}</td>
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
              <td class="text-center">
                <q-btn
                  label="Detail"
                  flat
                  no-caps
                  color="blue"
                  dense
                  :to="`/po/detail/${encodeURIComponent(p.po_id)}`"
                />
              </td>
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
            @input="change()"
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

      pagination: {
        current: 1,
        max: 1,
      },
    };
  },
  async mounted() {
    await this.fetchData();
    await this.change();
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
  methods: {
    filterOP(val, update, abort) {
      console.log(this.option);
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
    async fetchData() {
      await this.$http.get("/list_item", {}).then((result) => {
        this.option = result.data;
      });
      await this.$http.get("/list_vendor", {}).then((result) => {
        this.optVendor = result.data;
      });
    },
    async change(val) {
      try {
        this.$q.loading.show();
        let payload = {
          vendor: this.selectVendor,
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
          minimumFractionDigits: 2,
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
