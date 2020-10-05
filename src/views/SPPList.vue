<template>
  <div class="row relative">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Buat PO" @click="openForm" v-if="$store.state.currentUser.is_purchasing == 1" />
        <q-btn label="Detail" :disabled="selectCount != 1" @click="showDetail = true" />
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

              <div>
                <q-markup-table separator="cell"  flat square>
                  <thead class="bg-green text-white">
                    <tr>
                      <th>No</th>
                      <th>Item</th>
                      <th>Price</th>
                      <th>Curr</th>
                      <th>Est_Arrival</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr v-for="(x,i) in sppSelect" :key="i">
                      <td>{{i+1}}</td>
                      <td>{{x.item}}</td>
                      <td style="padding: 0px;"><q-input outlined v-model="x.price" dense /></td>
                      <td style="padding: 0px; width: 30px !important;">
                        <q-input outlined v-model="x.currency" dense />
                      </td>
                      <td style="padding: 0px;">
                        <q-input outlined v-model="x.est_arrival" dense >
                          <template v-slot:append>
                            <q-icon name="event" class="cursor-pointer">
                              <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                                <q-date v-model="x.est_arrival">
                                  <div class="row items-center justify-end">
                                    <q-btn v-close-popup label="Close" color="primary" flat />
                                  </div>
                                </q-date>
                              </q-popup-proxy>
                            </q-icon>
                          </template>
                        </q-input>
                      </td>
                    </tr>
                  </tbody>
                </q-markup-table>
                <table>
                  <tr>
                  </tr>
                </table>
              </div>

              <div class="q-gutter-md row justify-end">
                <q-btn color="grey" label="Kembali" @click="closeForm" />
                <q-btn color="primary" label="Submit" @click="createPO()" />
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <q-dialog v-model="showDetail" persistent transition-show="flip-down" transition-hide="flip-up">
      <q-card >
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
                <q-item-label caption>Status</q-item-label>
                <q-item-label>
                  {{status}}
                </q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <!-- <q-card-actions align="right">
          <q-btn flat label="Tolak" color="primary" v-close-popup />
          <q-btn flat label="Setuju" color="primary" v-close-popup />
        </q-card-actions> -->
      </q-card>
    </q-dialog>

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
      sppSelect:[],
      po:{
        po_date: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
      },
      formPO: false,
      alert: false,


      showDetail: false,    
      selected : {},  
    };
  },
  mounted(){
    this.fetchData()
  },
  methods:{
    fetchData(){
      this.sppList = []
      this.$http.get('/spp', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){
          if(result.data[i].user_id == this.$store.state.currentUser.user_id || result.data[i].handle_by == this.$store.state.currentUser.user_id){
            result.data[i].select = false
            this.sppList.push(result.data[i])
          }
        }
      })
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    openForm(){
      for(var i = 0; i < this.sppList.length; i++){
          if(this.sppList[i].select ==  true){
            let data = {
              spp_id: this.sppList[i].spp_id,
              item: this.sppList[i].item,
              price: 0,
              currency: 'IDR',
              est_arrival: moment().add(1, "days").format("YYYY-MM-DD")
            }
            this.sppSelect.push(data)
          }
      }
      if(this.sppSelect.length > 0){
        this.formPO = true
      }
      else{
        this.alert = true
      }
    },
    closeForm(){
      this.formPO = false
      this.sppSelect = []
    },
    createPO(){
      this.po.user_id = this.$store.state.currentUser.user_id
      this.$http.post('/new_po', this.po, {})
      .then (result => {
        for(var i = 0; i < this.sppSelect.length; i++){

          this.sppSelect[i].po_id = this.po.po_id

          console.log(this.sppSelect[i]);

          this.$http.put('/update_spp/' + this.sppSelect[i].spp_id, this.sppSelect[i], {})
          .then (result => {

          })

        }
        this.formPO = false
        this. po = {po_date: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),}
          this.fetchData()
        
      })
    },

  },
  computed:{
    selectCount(){
      var data = this.sppList.filter(e => e.select === true)
      var count = data.length

      if(data[0])
        this.selected = data[0]

      return count
    },
    status(){
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
      else {
        return 'Sedang diproses oleh ' + this.selected.handler_name
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

</style>
