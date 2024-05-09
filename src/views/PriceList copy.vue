<template>
  <div class="row relative q-px-lg q-pt-lg">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <q-card-section class="text-h6 text-bold q-pb-none"
        >LIST HARGA</q-card-section
      >
      <q-card-section class="row justify-between">
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
          style="width:49%"
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
          style="width:49%"
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
      <q-markup-table
        flat
        square
        class="stickyTable"
        style="height:calc(100vh - 230px)"
      >
        <thead>
          <tr class="bg-blue-grey-14 text-white">
            <th class="text-left">No</th>
            <th class="text-left">Nomer PO</th>
            <th class="text-left">Tanggal PO</th>
            <th class="text-left">Nama Vendor</th>
            <th class="text-right">Harga Satuan</th>
            <th class="text-right">Jumlah Pembelian</th>
          </tr>
        </thead>
        <tbody v-if="priceList.length" class="bg-blue-grey-1">
          <tr
            v-for="(p, i) in priceList"
            :key="i"
            :class="{ 'bg-white': i % 2 == 0 }"
          >
            <td class="text-center">
              {{ (pagination.current - 1) * 25 + i + 1 }}
            </td>
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
      </q-markup-table>
      <q-card-actions align="right">
        <q-pagination
          v-model="pagination.current"
          :max="pagination.max"
          input
          @input="change()"
        ></q-pagination>
      </q-card-actions>
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
          item: this.selectOption,
          vendor: this.selectVendor,
          current: this.pagination.current,
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
  },
};
</script>

<style lang="scss" scoped></style>
