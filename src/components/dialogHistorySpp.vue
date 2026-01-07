<template>
  <q-dialog ref="dialog" @hide="onDialogHide" persistent>
    <q-card class="my-font" style="min-width: 800px !important;">
      <q-card-section class="q-py-sm row justify-between items-center">
        <div class="text-h6 text-weight-bold">History Pembelian Barang</div>
        <q-btn dense flat icon="close" @click="onCancelClick()" />
      </q-card-section>
      <q-separator />
      <q-card-section>
        <q-markup-table
          v-if="priceList.length"
          wrap-cells
          flat
          bordered
          class="stickyTable l-grow"
        >
          <!-- table head -->
          <thead class="text-white">
            <tr>
              <th>No PO</th>
              <th>Tanggal PO</th>
              <th>Nama Vendor</th>
              <th>Jumlah Pembelian</th>
              <th>Harga Item</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(p, i) in priceList" :key="i">
              <td class="text-left">{{ p.po_id }}</td>
              <td class="text-left">{{ momentFormatDate(p.po_date) }}</td>
              <td class="text-left">{{ p.vendor }}</td>
              <td>{{ p.qty }} {{ p.unit }}</td>
              <td class="text-left">
                {{
                  setCurrency(
                    parseFloat(p.price) / parseFloat(p.qty),
                    p.currency
                  )
                }}
                / {{ p.unit }}
              </td>
            </tr>
          </tbody>
        </q-markup-table>
        <div class="text-h6 text-center" v-else>
          Belum Ada Histori Pembelian
        </div>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import moment from "moment";
export default {
  props: ["spp"],
  data() {
    return {
      spp: "",
      priceList: [],
    };
  },
  mounted() {
    this.spp = this.$props.spp[0];
    this.fetchData();
  },
  methods: {
    show() {
      this.$refs.dialog.show();
    },
    hide() {
      this.$refs.dialog.hide();
    },

    onDialogHide() {
      this.$emit("hide");
    },

    onOKClick() {
      this.hide();
    },

    onCancelClick() {
      this.hide();
    },

    async fetchData() {
      console.log(this.spp.item);
      try {
        this.$q.loading.show();
        let payload = {
          // vendor: "",
          current: 1,
          search: this.spp.item,
          // date: "",
        };
        await this.$http.post("/pricelist/new", payload).then((result) => {
          this.priceList = result.data.items;
        });
        this.$q.loading.hide();
      } catch (err) {
        this.$q.loading.hide();
      }
    },
    momentFormatDate(date) {
      if (date) {
        return moment(date).format("DD MMM YYYY");
      }
      return "-";
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
  },
};
</script>
