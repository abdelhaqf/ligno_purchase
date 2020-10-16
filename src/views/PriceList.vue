<template>
  <div class="row  relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders">
      <q-card-section class="row">
        <q-select
          outlined dense
          v-model="selectOption"
          map-options emit-value
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
              <q-item-section class="text-grey">
                No results
              </q-item-section>
            </q-item>
          </template>
        </q-select>
        
      </q-card-section>
      <q-markup-table flat dense square>
        <thead class="bg-green-4 text-white">
          <th class="text-left">PO</th>
          <th class="text-left">PO Date</th>
          <th class="text-left">Vendor</th>
          <th class="text-right">Price</th>
          <th class="text-right">Qty</th>
        </thead>
        <tbody v-if="priceList.length" class="bg-green-1">
          <tr v-for="p in priceList" :key="p.id">
            <td class="text-left">{{ p.po_id }}</td>
            <td class="text-left">{{ p.po_date }}</td>
            <td class="text-left">{{ p.vendor }}</td>
            <td class="text-right">{{ setCurrency(parseFloat(p.price) / parseFloat(p.qty), p.currency) }} / {{ p.unit }}</td>
            <td class="text-right">{{ p.qty }}</td>
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
      option: [], filtered: [],
      selectOption: null,
      priceList: [],
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.$http.get("/list_item", {}).then((result) => {
        this.option = result.data;
      });
    },
    change(val) {
      this.$http.get("/pricelist/" + this.selectOption, {}).then((result) => {
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
    filterOP (val, update, abort) {
      update(() => {
        const needle = val.toLowerCase()
        this.filtered = this.option.filter(v => v.label.toLowerCase().indexOf(needle) > -1)
      })
    },
  },
};
</script>

<style lang="scss" scoped></style>
