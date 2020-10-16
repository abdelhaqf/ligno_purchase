<template>
  <div class="row  relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders">
      <q-card-section class="row">
        <q-select
          outlined
          dense
          stack-label
          class="col-3"
          v-model="selectOption"
          :options="option"
          map-options
          emit-value
          label="Product"
          @input="change()"
        />
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
      option: [],
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
  },
};
</script>

<style lang="scss" scoped></style>
