<template>
  <div class="row relative">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn label="Detail" @click="showDetail()" />
      </div>
      <q-markup-table separator="cell"  flat square dense>
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
          <tr v-for="(d, index) in sppList" :key="d.spp_id">
            <td>
              <q-radio v-model="slcIndex" :val="index" />
            </td>
            <td>
               {{ d.name }} 
              <q-chip color="grey-7" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td>{{ formatDate(d.create_at)}}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }}</td>
            <td style="width: 100px;">
              {{ d.deadline }}
              <q-badge :color="getColor(d.status)" text-color="white" dense size="sm">{{d.status}}</q-badge>
            </td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>

    <q-dialog v-model="show_detail" persistent transition-show="flip-down" transition-hide="flip-up">
      <q-card style="min-width: 350px;">
        <q-bar class="bg-primary text-white">
          <div>NO SPP: {{selected.spp_id}}</div>

          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-bar>
        <q-card-section class="">
          <q-list>
            <q-item>
              <q-item-section>
                <q-item-label caption>Requester</q-item-label>
                <q-item-label>{{selected.name}}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Request Date</q-item-label>
                <q-item-label>{{selected.create_at}}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Deadline</q-item-label>
                <q-item-label>{{selected.deadline}}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Item</q-item-label>
                <q-item-label>{{selected.item}}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Quantity</q-item-label>
                <q-item-label>{{selected.qty}} {{selected.unit}}</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Description</q-item-label>
                <q-item-label
                  >{{selected.description}}</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Arrival Estimation</q-item-label>
                <q-item-label
                  >{{selected.est_arrival}}</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Status</q-item-label>
                <q-item-label>
                  {{status_note}}
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
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
      sppList:[], slcIndex: '',
      show_detail: false,    
      selected : {},  
    };
  },
  mounted(){
    this.fetchData()
  },
  methods:{
    showDetail(){
      this.selected = this.sppList[this.slcIndex]
      this.show_detail = true
    },


    fetchData(){
      this.sppList = []
      this.$http.get('/spp', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){
          if(result.data[i].user_id == this.$store.state.currentUser.user_id)
            {
              result.data[i].status = this.status(result.data[i])
              this.sppList.push(result.data[i])
            }
        }
      })
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    formatDate(dt){
      return moment(dt).format('YYYY-MM-DD');
    },
    status(val){
      if(val.manager_approve == 0){
        return 'waiting'
      }
      else if(val.manager_approve == -1){
        return 'rejected'
      }
      else if(val.purch_manager_approve == 0){
        return 'waiting'
      }
      else if(val.purch_manager_approve == -1){
        return 'rejected'
      }
      else if(val.is_received == 0) {
        return 'process'
      }
      else if(val.is_received == 1) {
        return 'process'
      }
      
      else if(val.is_received == 2) {
        return 'done'
      }
    },
    getColor(val){
      if(val == 'done')
        return 'positive'
      else if(val == 'rejected')
        return 'red-7'
      else if(val == 'process')
        return 'primary'
      else return 'orange'
      
    }
  },
  computed:{
    status_note(){
      if(this.selected.manager_approve == 0){
        return 'Menunggu persetujuan manager'
      }
      else if(this.selected.manager_approve == -1){
        return 'Ditolak oleh manager'
      }
      else if(this.selected.purch_manager_approve == 0){
        return 'Menunggu persetujuan manager purchasing'
      }
      else if(this.selected.purch_manager_approve == -1){
        return 'Ditolak oleh manager purchasing'
      }
      else if(this.selected.is_received == 0) {
        return 'Sedang diproses oleh ' + this.selected.handler_name
      }
      else if(this.selected.is_received == 1) {
        return 'Barang sudah diterima sebagian ['+this.selected.handler_name +']'
      }
      
      else if(this.selected.is_received == 2) {
        return 'Barang sudah diterima'
      }
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

.v-money{
  line-height: 1; font-size: 14px;
  border: 1px solid silver;
  border-radius: 5px;
  padding: 10px 10px;
  box-sizing: border-box;
  width: 130px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}

</style>
