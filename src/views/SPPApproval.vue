<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Setuju" @click="confirmApprove = true" />
        <q-btn label="Tolak" @click="confirmReject = true" />
        <q-btn label="Detail" :disabled="selectCount != 1" @click="show_detail = true" />
        <q-btn label="History" :disabled="selectCount != 1" @click="showHistory()" />
      </div>
      <q-markup-table flat square dense>
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
          <tr v-for="d in sppList" :key="d.id">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td>
              {{ d.name }} <q-chip color="grey-7" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td>{{formatDate(d.create_at)}}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }} {{d.unit}}</td>
            <td>{{ d.deadline }}</td>
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
                <q-item-label>
                  {{selected.description}}
                </q-item-label>
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
        <q-card-actions align="right">
          <q-btn flat label="Tolak" color="primary" @click="confirmReject=true" v-close-popup />
          <q-btn flat label="Setuju" color="primary" @click="confirmApprove = true"  />
        </q-card-actions>
      </q-card>
    </q-dialog>
    
    <q-dialog v-model="show_history" persistent transition-show="flip-down" transition-hide="flip-up">
      <q-card style="min-width: 350px;">
        <q-bar class="bg-primary text-white">
          <div>NO SPP: {{history[0]?history[0].spp_id:''}}</div>
          <q-space />
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-bar>
        <q-card-section class="q-px-xl q-my-sm" style="height: 450px; overflow: auto;">
          <q-timeline>
            <q-timeline-entry v-for="x in history" :key="x.id"
              :title="x.status"
              :subtitle="dateHistory(x.create_at)"
              :color="getColor(x.status)"
              :icon="getIcon(x.status)"
            >
              <div>
                {{x.content}}
              </div>
            </q-timeline-entry>
          </q-timeline>
        </q-card-section>
      </q-card>
    </q-dialog>

    <q-dialog v-model="confirmApprove" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section>
          <div class="text-bold">Approve Confirmation</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          Setujui SPP yang dipilih?
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="OK" @click="approveSelected()" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="confirmReject" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section> 
          <div class="text-bold">Alasan Penolakan SPP</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-input class="col-4"
          outlined dense
          v-model="content"
          />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="OK" @click="rejectSelected()" v-close-popup />
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
      show_detail: false,
      history: [], show_history: false, 
      confirmApprove: false,
      confirmReject: false, content: '',
      sppList: [],
      selected: {},
      option:[],
    };
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    fetchData(){
      this.sppList = []
      this.$http.get('/spp-approval', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){
          if(result.data[i].manager_approve == 0 && result.data[i].manager_id == this.$store.state.currentUser.user_id){
            result.data[i].select = false
            this.sppList.push(result.data[i])
          }
        }
      })

      this.$http.get('/list_user', {})
      .then (result => {
        this.option = result.data
      })      
    },
    async approve(val){
      var data = {
        manager_approve: 1,
        handle_by : this.handleBy
      }
      await this.$http.put('/update_spp/' + val.spp_id, data, {})
      .then (result => {
        
      })

      var history = {
        spp_id: val.spp_id,
        status: 'waiting',
        content: 'Disetujui manager, menunggu persetujuan manager purchasing'
      }
      await this.$http.post('/new_history', history, {})
      .then (result => {
      })
    },
    async reject(val){
      var data = {
        manager_approve: -1,
        note: this.content
      }
      await this.$http.put('/update_spp/' + val.spp_id, data, {})
      .then (result => {
        
      })
      
      var history = {
        spp_id: val.spp_id,
        status: 'rejected',
        content: 'SPP ditolak manager: ' + this.content
      }
      await this.$http.post('/new_history', history, {})
      .then (result => {
      })
    },
    async approveSelected(){
      this.show_detail = false
      var data = this.sppList.filter(e => e.select === true)
      for(var i = 0; i<data.length; i++){
        await this.approve(data[i])
      }
      await this.fetchData()
      await this.$root.$emit('refresh')
      this.$q.notify('SPP berhasil disetujui!')
    },
    async rejectSelected(){
      var data = this.sppList.filter(e => e.select === true)
      for(var i = 0; i<data.length; i++){
        await this.reject(data[i])
      }
      await this.fetchData()
      await this.$root.$emit('refresh')
      this.$q.notify('SPP ditolak!')
    },
    showHistory(){
      this.$http.get('/spp_history/' + this.selected.spp_id, {})
      .then (result => {
        this.history = result.data
      })
      this.show_history = true
    },
    formatDate(dt){
      return moment(dt).format('YYYY-MM-DD');
    },
    dateHistory(dt){
      return moment(dt).format('DD MMMM YYYY');
    },
    getColor(val){
      if(val == 'done')
        return 'positive'
      else if(val == 'rejected' || val == 'canceled')
        return 'red-7'
      else if(val == 'process')
        return 'primary'
      else return 'orange'
    },
    getIcon(val){
      if(val == 'done')
        return 'done_all'
      else if(val == 'rejected')
        return 'error_outline'
      else if(val == 'process')
        return 'hourglass_bottom'
      else if(val == 'created')
        return 'library_add'
      else if(val == 'canceled')
        return 'close'
      else return 'pending_actions'
    }
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

<style lang="scss" scoped></style>
