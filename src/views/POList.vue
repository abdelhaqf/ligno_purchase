<template>
  <div class="row  relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders" v-if="!show_detail">
      <q-card-section class="q-pa-md q-gutter-md row justify-between">
        <q-select 
          outlined dense v-model="isReceived" 
          :options="receivedOption"
          map-options emit-value
          @input="fetchData"
        >
          <template v-slot:option="scope">
            <q-item
              v-bind="scope.itemProps"
              v-on="scope.itemEvents"
            >
              <q-item-section>
                <q-badge
                :color="
                  scope.opt.label== 'fully received'
                    ? 'positive'
                    : scope.opt.label == 'half received'
                    ? 'warning'
                    : scope.opt.label == 'not received'
                    ? 'negative'
                    : 'primary'
                "
                text-color="white"
                dense
                >{{ scope.opt.label }}
              </q-badge>
              </q-item-section>
            </q-item>
          </template>
        </q-select>
        <q-select 
          outlined dense v-model="filter" 
          :options="filterOption"
          map-options emit-value
          @input="fetchData"
          />
      </q-card-section>
      <q-markup-table bordered flat square dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">PO Number</th>
            <th class="text-left">PO Date</th>
            <th class="text-left">Handle By</th>
            <th class="text-left">Vendor</th>
            <th class="text-left">Items</th>
            <th class="text-right">value</th>
          </tr>
        </thead>
        <tbody v-if="poList.length" class="bg-blue-grey-1">
          <tr v-for="d in poList" :key="d.id">
            <td style="padding: 0px;">
              <q-btn color="primary" size="md" icon="launch" class="full-width q-py-sm" flat @click="openForm(d.po_id)" />
            </td>
            <td class="text-left col">
              <div>{{ d.po_id }}</div>
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
                >{{ d.is_received }}
              </q-chip>
            </td>
            <td class="text-left">{{ d.po_date | moment("DD MMM YYYY") }}</td>
            <td class="text-left">{{ d.handler_name | truncate(8) }}</td>
            <td class="text-left">{{ d.vendor | truncate(11) }}</td>
            <td class="text-left col"><div>{{ d.item}}{{d.spp_count>1?', more items... ' : ''}}</div></td>
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
          <tr v-for="(d, i) in selected" :key="i">
            <td class="text-left">
              {{ d.spp_id }}
            </td>
            <td class="text-left">{{ d.name }}</td>
            <td class="text-left">
              <div v-if="!onEdit">{{ d.item }}</div>
              <q-input v-else outlined dense v-model="edited[i].item" class="bg-white" />
            </td>
            <td class="text-right">
              <div v-if="!onEdit">{{ d.qty }} {{ d.unit }}</div>
              <div v-else class="" style="width: 60px;">
                <q-input outlined dense class="bg-white" v-model="edited[i].qty" />
                <q-input outlined dense class="bg-white" v-model="edited[i].unit" />
              </div>
            </td>
            <td class="text-right">
              <div v-if="!onEdit">{{ setCurrency(d.price, d.currency) }}</div>
              <div v-else class="row" style="width: 100px;">
                <money v-model="edited[i].price" v-bind="money"></money>
              </div>
            </td>
            <td class="text-left">{{ d.est_arrival | moment("DD MMM YYYY") }}</td>
            <td class="text-left bg-white" style="padding:0px;">
              <q-option-group v-model="d.is_received" :options="isReceivedOption"/>
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
        <q-btn flat style="width: 100px;" color="grey" label="Kembali" @click="closeForm" />
        <q-btn flat style="width: 100px;" color="secondary" label="Edit" @click="onEdit = true" />
        <q-btn flat style="width: 100px;" color="primary" label="Simpan" @click="updateSPP()" />
      </q-card-actions>
    </q-card>
  </div>
</template>

<script>
import moment from "moment";
import { Money } from "v-money";

export default {
  components: { Money },
  data() {
    return {
      poList: [],
      slcPO: null,
      selected: [],
      isReceivedOption: [
        { label: "no", value: "0" },
        { label: "partial", value: "1" },
        { label: "full", value: "2" },
      ], 
      isReceived: '%25',
      receivedOption:[
        { label: "show all", value: "%25" },
        { label: "fully received", value: "fully" },
        { label: "half received", value: "half" },
        { label: "not received", value: "not" },
      ],
      is_COA: [
        { label: "no", value: "0" },
        { label: "yes", value: "1" },
      ],
      show_detail: false,
      filterOption:[], filter: '',

      onEdit: false,
      edited: [],
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      curr: "IDR",

    };
  },
  mounted() {
    
    this.$http.get("/list_month_po", {
      headers: { Authorization: "Bearer " + localStorage.getItem('token-purchase') }
    }).then((result) => {
      this.filterOption = result.data
      this.filter = result.data[0].value
      this.filterOption.unshift({value: '%25', label: 'all' })
    
      this.fetchData();
    })
  },
  methods: {
    fetchData() {
      this.poList = [];
      this.$http.get("/po/" + this.isReceived + "/" + this.filter, {
        headers: { Authorization: "Bearer " + localStorage.getItem('token-purchase') }
      }).then((result) => {
        for (var i = 0; i < result.data.length; i++) {
            this.poList.push(result.data[i]);
        }
      });
    },
    openForm(id) {
      this.edited = []
      this.$http.post("/podetail_byid", { po_id: id }, {}).then((result) => {
        this.selected = result.data;
        this.show_detail = true;
        for(var i = 0; i < this.selected.length; i++){
          this.edited.push({
            item: this.selected[i].item,
            qty: this.selected[i].qty,
            unit: this.selected[i].unit,
            price: this.selected[i].price,
          })
        }
      });
    },
    closeForm() {
      this.show_detail = false;
      this.onEdit = false
    },
    async updateSPP() {
      for (var i = 0; i < this.selected.length; i++) {
        let data = {
          is_received: this.selected[i].is_received,
          coa: this.selected[i].coa,
          note: this.selected[i].note,
          
          item: this.edited[i].item,
          qty: this.edited[i].qty,
          unit: this.edited[i].unit,
          price: this.edited[i].price,
        };
        var note_add= ''
        if(this.selected[i].item != this.edited[i].item){
          note_add = note_add + ', nama item: ' + this.selected[i].item + ' => ' + this.edited[i].item
        }
        if(this.selected[i].qty != this.edited[i].qty){
          note_add = note_add + ', qty: ' + this.selected[i].qty + ' => ' + this.edited[i].qty
        }
        if(this.selected[i].unit != this.edited[i].unit){
          note_add = note_add + ', unit: ' + this.selected[i].unit + ' => ' + this.edited[i].unit
        }
        if(this.selected[i].price != this.edited[i].price){
          note_add = note_add + ', harga: ' + this.selected[i].price + ' => ' + this.edited[i].price
        }
        if(note_add != '') data.revision = this.$store.state.currentUser.username

        await this.$http.put("/update_spp/" + this.selected[i].spp_id, data, {}).then((result) => {});

        let history = {
          spp_id: this.selected[i].spp_id,
          status: "process",
          content: this.selected[i].note + note_add,
        };
        if (this.selected[i].is_received == 2) {
          history.status = "done";
        }
        this.$http.post("/new_history", history, {}).then((result) => {});
        var info = ''
        if(this.selected[i].is_received == 2)
          info = 'barang sudah diterima penuh'
        if(this.selected[i].is_received == 1)
          info = 'barang sudah diterima sebagian'

        var notifikasi ={
            from_id: this.$store.state.currentUser.user_id,
            to_id: this.selected[i].user_id,
            notif: 'Konfirmasi Penerimaan barang',
            note: info,
            spp_id: this.selected[i].spp_id ,
            reference_page: '/spp/list'
          }
        if(info != 0){
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
          
          notifikasi.to_id = 1 // Notif ke Manager purchasing
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
        }


      }
      this.show_detail = false;
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.$q.notify("Data PO berhasil diubah!");
      this.onEdit = false
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
    chgCurrency(i) {
      
      if (this.curr == "IDR") {
        this.money.precision = 0;
        this.money.prefix = "Rp ";
      } else {
        this.money.precision = 2;
        this.money.prefix = "$ ";
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
