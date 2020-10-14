<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn label="Update" @click="openForm" />
      </div>
      <q-markup-table separator="cell"  flat square dense>
        <thead class="bg-green text-white">
          <tr>
            <th style="width:10px;"></th>
            <th>PO Number</th>
            <th>PO Date</th>
            <th>Handle By</th>
            <th>Vendor</th>
            <th>value</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="d in poList" :key="d.id">
            <td>
              <q-radio v-model="slcPO" :val="d.po_id" />
            </td>
            <td>
              {{ d.po_id }} <q-chip color="grey-7" text-color="white" dense size="sm">{{ d.is_received }}</q-chip>
            </td>
            <td>{{ d.po_date }}</td>
            <td>{{ d.handler_name }}</td>
            <td>{{ d.vendor }}</td>
            <td>{{ setCurrency(d.total_price, d.currency) }}</td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>

    
    <div class="container" v-if="showDetail">
      <div class="showDetail">
        <div class="row">
          <div class="col-12">
            <div class="text-grey-8 text-h6 q-pa-md">Detail PO Nomor:  {{selected[0].po_id}} </div>
            <div class="q-pa-md">
              <table>
                <tr>
                  <td>PO Date</td>
                  <td>: {{selected[0].po_date}}</td>
                </tr>
                <tr>
                  <td>Handle By</td>
                  <td>: {{selected[0].handler_name}}</td>
                </tr>
                <tr>
                  <td>Vendor</td>
                  <td>: {{selected[0].vendor}}</td>
                </tr>
              </table>
            </div>
            <div class="q-pa-md q-gutter-md ">
              <q-markup-table separator="cell"  flat square dense>
                <thead class="bg-green text-white">
                  <tr>
                    <th>SPP Number</th>
                    <th>Request By</th>
                    <th>Item</th>
                    <th>Qty</th>
                    <th>value</th>
                    <th>Est Arrival</th>
                    <th>Received</th>
                    <th>COA</th>
                    <th>Note</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="d in selected" :key="d.id">
                    <td>
                      {{ d.spp_id }}
                    </td>
                    <td>{{ d.name }}</td>
                    <td>{{ d.item }}</td>
                    <td>{{ d.qty }} {{d.unit}} </td>
                    <td>{{ setCurrency(d.price, d.currency) }}</td>
                    <td>{{ d.est_arrival }}</td>
                    <td style="padding:0px;">
                      <q-select 
                        outlined  dense 
                        v-model="d.is_received"
                        :options="is_received"
                        emit-value
                        map-options
                      />
                    </td>
                    <td style="padding:0px;">
                      <q-select 
                        outlined  dense 
                        v-model="d.coa"
                        :options="is_COA"
                        emit-value
                        map-options
                      />
                    </td>
                    <td style="padding: 0px;">
                      <q-input v-model="d.note" outlined dense />
                    </td>
                  </tr>
                </tbody>
              </q-markup-table>

              <div class="q-gutter-md row justify-end">
                <q-btn color="grey" label="Kembali" @click="closeForm" />
                <q-btn color="primary" label="Update" @click="updateSPP()" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <q-dialog v-model="alert">
      <q-card>
        <q-card-section>
          <div class="text-h6"></div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          Pilih hanya 1 PO yang akan diupdate.
        </q-card-section>

        <q-card-actions align="right">
          <q-btn flat label="OK" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
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
      is_COA:[
        {label: 'no', value: "0"},
        {label: 'yes', value: "1"}
      ],
      alert: false,
      showDetail: false,
    };
  },
  mounted(){
    this.fetchData()

  },
  methods:{
    fetchData(){
      this.poList = []
      this.$http.get('/po', {})
      .then (result => {
        for(var i = 0; i < result.data.length; i++){
          if(this.$store.state.currentUser.is_purch_manager=='1' ||
             result.data[i].user_id == this.$store.state.currentUser.user_id)
          {
            this.poList.push(result.data[i])
          }
        }
      })
    },
    openForm(){
      if(!this.slcPO){
        this.alert = true
      }
      else{
        this.$http.post('/podetail_byid', {po_id : this.slcPO}, {})
        .then (result => {
          this.selected = result.data
          this.showDetail = true
        })
      }
    },
    closeForm(){
      this.showDetail = false
    },
    async updateSPP(){
      for(var i = 0; i< this.selected.length; i++){
        let data = {
          is_received : this.selected[i].is_received,
          coa: this.selected[i].coa,
          note: this.selected[i].note
        }
        
        await this.$http.put('/update_spp/' + this.selected[i].spp_id, data, {})
        .then (result => {
          
        })
      }
      this.showDetail = false
      await this.fetchData()
      await this.$root.$emit('refresh')
    },
    setCurrency(price, cur) {
      if(cur == 'IDR'){
        const formatter = new Intl.NumberFormat('ID', {
          style: 'currency',
          currency: 'IDR',
          currencyDisplay: "symbol",
          minimumFractionDigits: 0
        })
        return formatter.format(price)
      }
      else if (cur == 'USD'){
        const formatter = new Intl.NumberFormat('US', {
          style: 'currency',
          currency: 'USD',
          currencyDisplay: "symbol",
          minimumFractionDigits: 2
        })
        return formatter.format(price)
      }
    },
  },
  computed:{

  }
};
</script>

<style lang="scss" scoped>
.container{
  width: 100%; height: 100%;
  background-color: white;
  position: absolute;
  z-index: 1000;
  left: 0px; top: 0px;
}
</style>
