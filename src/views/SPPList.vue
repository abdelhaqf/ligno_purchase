<template>
  <div class="row relative">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Buat PO" @click="openForm" />
        <q-btn label="Detail" />
      </div>
      <q-markup-table separator="cell"  flat square>
        <thead class="bg-green text-white">
          <tr>
            <th style="width:10px;"></th>
            <th>user</th>
            <th>date</th>
            <th>item</th>
            <th>qty</th>
            <th>deadline</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="d in sppList" :key="d.spp_id">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td>
              {{ d.name }} <q-chip color="teal" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td>{{ d.create_at }}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }}</td>
            <td>{{ d.deadline }}</td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>
    <div class="container" v-if="formPO">
      <div class="formPO">
          <div class="row">
            <div class="col-6">
              <div class="bg-green text-white text-h6 q-pa-md">PO Baru</div>
              <div class="q-pa-md q-gutter-md ">
                <q-input outlined v-model="po.po_id" label="No PO" stack-label dense />
                <q-input outlined v-model="po.vendor" label="Vendor" stack-label dense />
                <q-input outlined v-model="po.po_date" label="PO Date" stack-label dense readonly />
                <q-date v-model="po.po_date" minimal :options="limitDate" />
                <div class="q-gutter-md row justify-end">
                  <q-btn color="grey" label="Kembali" @click="formPO = false" />
                  <q-btn color="primary" label="Submit" @click="createPO()" />
                </div>
              </div>
            </div>
          </div>

      </div>
    </div>
    <q-dialog v-model="alert">
      <q-card>
        <q-card-section>
          <div class="text-h6">PO Kosong</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          Anda belum memilih SPP yang akan dijadikan PO.
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
      sppList:[],
      po:{
        po_date: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),

      },
      formPO: false,
      alert: false,
    };
  },
  mounted(){
    this.$http.get('/spp', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){

          result.data[i].select = false
          this.sppList.push(result.data[i])
        }
      })
  },
  methods:{
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    openForm(){
      var count = this.sppList.filter(spp => spp.select === true)
      if(count.length > 0){
        this.formPO = true
      }
      else{
        this.alert = true
      }
    },
    createPO(){
      this.$http.post('/new_po', this.po, {})
      .then (result => {
        for(var i = 0; i < this.sppList.length; i++){
          let data = {po_id: this.po.po_id}
          if(this.sppList[i].select ==  true){
              this.$http.put('/spp_byid/' + this.sppList[i].spp_id, data, {})
              .then (result => {
    
              })
          }
        }
        this.formPO = false
        this. po = {po_date: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),}
        
      })
    }

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
