<template>
  <div class="row  relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders">
      <q-card-section class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Update" @click="openForm" />
      </q-card-section>
      <q-markup-table bordered flat square dense>
        <thead class="bg-green-4 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">PO Number</th>
            <th class="text-left">PO Date</th>
            <th class="text-left">Handle By</th>
            <th class="text-left">Vendor</th>
            <th class="text-right">value</th>
          </tr>
        </thead>
        <tbody v-if="poList.length" class="bg-green-1">
          <tr v-for="d in poList" :key="d.id">
            <td>
              <q-radio v-model="slcPO" :val="d.po_id" />
            </td>
            <td class="text-left">
              {{ d.po_id }} 
              <q-chip :color="(d.is_received=='fully received'?'grey-7':'orange')" text-color="white" dense size="sm">{{ d.is_received }}</q-chip>
            </td>
            <td class="text-left">{{ d.po_date | moment('DD MMM YYYY')}}</td>
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

    
    <div class="container" v-if="show_detail">
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
      show_detail: false,
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
        return
      }
      else{
        this.$http.post('/podetail_byid', {po_id : this.slcPO}, {})
        .then (result => {
          this.selected = result.data
          this.show_detail = true
        })
      }
    },
    closeForm(){
      this.show_detail = false
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
        
        let history = {
              spp_id: this.selected[i].spp_id,
              status: 'process',
              content: this.selected[i].note
        }
        if(this.selected[i].is_received == 2){
          history.status = 'done'
        }
        this.$http.post('/new_history', history, {})
        .then (result => {
        })

      }
      this.show_detail = false
      await this.fetchData()
      await this.$root.$emit('refresh')
      this.$q.notify('Data PO berhasil diubah!')

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
