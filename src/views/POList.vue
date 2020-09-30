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
              <q-checkbox v-model="d.select" />
            </td>
            <td>
              {{ d.po_id }} <q-chip color="teal" text-color="white" dense size="sm">{{ d.is_received }}</q-chip>
            </td>
            <td>{{ d.po_date }}</td>
            <td>{{ d.name }}</td>
            <td>{{ d.vendor }}</td>
            <td>{{ d.total_price }}</td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>

    
    <div class="container" v-if="showDetail">
      <div class="showDetail">
        <div class="row">
          <div class="col-12">
            <div class="bg-green text-white text-h6 q-pa-md">Detail PO Nomor:  {{selected[0].po_id}} </div>
            <div class="q-pa-md q-gutter-md ">
              <q-markup-table separator="cell"  flat square dense>
                <thead class="bg-green text-white">
                  <tr>
                    <th>SPP Number</th>
                    <th>PO Date</th>
                    <th>Request By</th>
                    <th>Handle By</th>
                    <th>Vendor</th>
                    <th>value</th>
                    <th>Received</th>
                    <th>Note</th>
                  </tr>
                </thead>
                <tbody>
                  <tr v-for="d in selected" :key="d.id">
                    <td>
                      {{ d.spp_id }}
                    </td>
                    <td>{{ d.po_date }}</td>
                    <td>{{ d.name }}</td>
                    <td>{{ d.handle_by }}</td>
                    <td>{{ d.vendor }}</td>
                    <td>{{ d.price }}</td>
                    <td style="padding:0px;">
                      <q-select 
                        outlined  dense 
                        v-model="d.is_received"
                        :options="is_received"
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

      selected: [],
      is_received: [
        { label: "no", value: "0" },
        { label: "partial", value: "1" },
        { label: "full", value: "2" },
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
        for(var i = 0; i < result.data.length;i++){

          result.data[i].select = false
          this.poList.push(result.data[i])
        }
      })
    },
    openForm(){
      var data = this.poList.filter(e => e.select === true)
      if(data.length == 1){
        this.$http.post('/podetail_byid', {po_id : data[0].po_id}, {})
        .then (result => {
          this.selected = result.data
          this.showDetail = true
        })
      }
      else if(data.length == 0){
        this.alert = true
      }
      else {
        this.alert = true
      }
    },
    closeForm(){
      this.showDetail = false
    },
    updateSPP(){
      for(var i = 0; i< this.selected.length; i++){
        let newData = {
          is_received : this.selected[i].is_received,
          note: this.selected[i].note
        }
        
        this.$http.put('/update_spp/' + this.selected[i].spp_id, newData, {})
        .then (result => {
          
        })
      }
      this.showDetail = false
      this.fetchData()
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
