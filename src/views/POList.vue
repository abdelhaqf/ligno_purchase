<template>
  <div class="row  relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders" v-if="!show_detail">
      <q-card-section class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Update" @click="openForm" />
      </q-card-section>
      <q-markup-table bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">PO Number</th>
            <th class="text-left">PO Date</th>
            <th class="text-left">Handle By</th>
            <th class="text-left">Vendor</th>
            <th class="text-right">value</th>
          </tr>
        </thead>
        <tbody v-if="poList.length" class="bg-blue-grey-1">
          <tr v-for="d in poList" :key="d.id">
            <td>
              <q-radio v-model="slcPO" :val="d.po_id" />
            </td>
            <td class="text-left">
              {{ d.po_id }}
              <q-chip
                :color="
                  d.is_received == 'fully received'
                    ? 'positive'
                    : d.is_received == 'half received'
                    ? 'warning'
                    : 'negative'
                "
                text-color="white"
                dense
                size="sm"
                >{{ d.is_received }}</q-chip
              >
            </td>
            <td class="text-left">{{ d.po_date | moment("DD MMM YYYY") }}</td>
            <td class="text-left">{{ d.handler_name }}</td>
            <td class="text-left">{{ d.vendor }}</td>
            <td class="text-right">{{ setCurrency(d.total_price, d.currency) }}</td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">
              tidak ada data
            </td>
          </tr>
        </tbody>
      </q-markup-table>
      <q-card-section></q-card-section>
    </q-card>

    <!-- detail PO  -->
    <q-card v-if="show_detail" class="col-12">
      <!-- <div class="row">
        <div class="col-12"> -->
      <q-card-section class="bg-primary text-white"> Detail PO : {{ selected[0].po_id }} </q-card-section>

      <q-card-section class="q-pa-md">
        <table>
          <tr>
            <td class="text-caption ">PO Date</td>
            <td>: {{ selected[0].po_date | moment("DD MMM YYYY") }}</td>
          </tr>
          <tr>
            <td class="text-caption ">Handle By</td>
            <td>: {{ selected[0].handler_name }}</td>
          </tr>
          <tr>
            <td class="text-caption ">Vendor</td>
            <td>: {{ selected[0].vendor }}</td>
          </tr>
        </table>
      </q-card-section>
      <!-- <div class="q-pa-md q-gutter-md "> -->
      <q-markup-table separator="cell" bordered flat dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th class="text-left">SPP Number</th>
            <th class="text-left">Request By</th>
            <th class="text-left">Item</th>
            <th class="text-right">Qty</th>
            <th class="text-right">value</th>
            <th class="text-left">Est Arrival</th>
            <th class="text-left">Received</th>
            <th class="text-left">COA</th>
            <th class="text-left">Note</th>
          </tr>
        </thead>
        <tbody class="bg-blue-grey-1">
          <tr v-for="d in selected" :key="d.id">
            <td class="text-left">
              {{ d.spp_id }}
            </td>
            <td class="text-left">{{ d.name }}</td>
            <td class="text-left">{{ d.item }}</td>
            <td class="text-right">{{ d.qty }} {{ d.unit }}</td>
            <td class="text-right">{{ setCurrency(d.price, d.currency) }}</td>
            <td class="text-left">{{ d.est_arrival | moment("DD MMM YYYY") }}</td>
            <td class="text-left bg-white" style="padding:0px;">
              <q-option-group v-model="d.is_received" :options="is_received"/>
            </td>
            <td class="text-left bg-white" style="padding:0px;">
              <q-option-group class="" v-model="d.coa" :options="is_COA"  />
            </td>
            <td class="text-left" style="padding: 0px;" >
              <q-input square filled type="textarea" bg-color="white" v-model="d.note" dense />
            </td>
          </tr>
        </tbody>
      </q-markup-table>

      <q-card-actions class="row justify-end">
        <q-btn flat color="secondary" label="Kembali" @click="closeForm" />
        <q-btn flat color="primary" label="Update" @click="updateSPP()" />
      </q-card-actions>
      <!-- </div> -->
      <!-- </div>
      </div> -->
    </q-card>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from "moment";
export default {
  data() {
    return {
      poList: [],
      slcPO: null,
      selected: [],
      is_received: [
        { label: "no", value: "0" },
        { label: "partial", value: "1" },
        { label: "full", value: "2" },
      ],
      is_COA: [
        { label: "no", value: "0" },
        { label: "yes", value: "1" },
      ],
      show_detail: false,
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.poList = [];
      this.$http.get("/po", {}).then((result) => {
        for (var i = 0; i < result.data.length; i++) {
          if (
            this.$store.state.currentUser.is_purch_manager == "1" ||
            result.data[i].user_id == this.$store.state.currentUser.user_id
          ) {
            this.poList.push(result.data[i]);
          }
        }
      });
    },
    openForm() {
      if (!this.slcPO) {
        return;
      } else {
        this.$http.post("/podetail_byid", { po_id: this.slcPO }, {}).then((result) => {
          this.selected = result.data;
          this.show_detail = true;
        });
      }
    },
    closeForm() {
      this.show_detail = false;
    },
    async updateSPP() {
      for (var i = 0; i < this.selected.length; i++) {
        let data = {
          is_received: this.selected[i].is_received,
          coa: this.selected[i].coa,
          note: this.selected[i].note,
        };

        await this.$http.put("/update_spp/" + this.selected[i].spp_id, data, {}).then((result) => {});

        let history = {
          spp_id: this.selected[i].spp_id,
          status: "process",
          content: this.selected[i].note,
        };
        if (this.selected[i].is_received == 2) {
          history.status = "done";
        }
        this.$http.post("/new_history", history, {}).then((result) => {});
      }
      this.show_detail = false;
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.$q.notify("Data PO berhasil diubah!");
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
  computed: {},
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
</style>
