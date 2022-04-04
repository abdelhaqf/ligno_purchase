<template>
  <div class="row relative q-px-lg q-pt-lg">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <q-card-section class="row q-gutter-x-sm">
        <q-select
          outlined
          dense
          v-model="selectOption"
          map-options
          emit-value
          use-input
          hide-selected
          fill-input
          input-debounce="0"
          :options="filtered"
          @filter="filterOP"
          label="Nama Barang"
          class="col-3"
          @input="change()"
        >
          <template v-slot:no-option>
            <q-item>
              <q-item-section class="text-grey">No results</q-item-section>
            </q-item>
          </template>
          <template v-slot:append>
            <q-btn
              v-if="selectOption != null"
              icon="close"
              dense
              @click="
                selectOption = null;
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
          v-model="selectVendor"
          map-options
          emit-value
          use-input
          hide-selected
          fill-input
          input-debounce="0"
          :options="filteredVD"
          @filter="filterVD"
          label="Nama Vendor"
          class="col-3"
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
      <q-markup-table flat dense square>
        <thead class="bg-blue-grey-14 text-white">
          <th class="text-left">Nomer PO</th>
          <th class="text-left">Tanggal PO</th>
          <th class="text-left">Nama Vendor</th>
          <th class="text-right">Harga Satuan</th>
          <th class="text-right">Jumlah Pembelian</th>
        </thead>
        <tbody v-if="priceList.length" class="bg-blue-grey-1">
          <tr v-for="p in priceList" :key="p.id">
            <td class="text-left">{{ p.po_id }}</td>
            <td class="text-left">{{ p.po_date }}</td>
            <td class="text-left">{{ p.vendor }}</td>
            <td class="text-right">
              {{
                setCurrency(parseFloat(p.price) / parseFloat(p.qty), p.currency)
              }}
              / {{ p.unit }}
            </td>
            <td class="text-right">{{ p.qty }} {{ p.unit }}</td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">
              tidak ada data, atau mungkin anda belum memilih
            </td>
          </tr>
        </tbody>
        <q-card-section></q-card-section>
      </q-markup-table>
    </q-card>
  </div>
</template>

<script>
export default {
  data() {
    return {
      option: [],
      filtered: [],
      selectOption: null,
      priceList: [],
      optVendor: [],
      filteredVD: [],
      selectVendor: null,
    };
  },
  mounted() {
    this.fetchData();
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
    fetchData() {
      this.$http.get("/list_item", {}).then((result) => {
        this.option = result.data;
      });
      this.$http.get("/list_vendor", {}).then((result) => {
        this.optVendor = result.data;
      });
    },
    change(val) {
      this.$http
        .get(
          "/pricelist/" +
            encodeURIComponent(this.selectOption) +
            "/" +
            encodeURIComponent(this.selectVendor),
          {}
        )
        .then((result) => {
          this.priceList = result.data;
        });
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
  },
};
</script>

<style lang="scss" scoped></style>
