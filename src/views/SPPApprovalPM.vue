<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Setuju" @click="promptApprove = true" />
        <q-btn label="Tolak" @click="promptReject=true" />
        <q-btn label="Detail" :disabled="selectCount != 1" @click="showDetail = true" />
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
            <td>{{ formatDate(d.create_at) }}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }}</td>
            <td>{{ d.deadline }}</td>
          </tr>
        </tbody>
      </q-markup-table>
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
          <q-btn flat label="Tolak" color="primary" @click="promptReject=true" v-close-popup />
          <q-btn flat label="Setuju" color="primary" @click="promptApprove = true"  />
        </q-card-actions>
      </q-card>
    </q-dialog>

    <q-dialog v-model="promptApprove" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section>
          <div class="text-h6">Handled By</div>
        </q-card-section>

        <q-card-section class="q-pt-none">
          <q-select class="col-4"
          outlined dense
          hide-dropdown-icon
          v-model="handleBy" :options="option" 
          map-options emit-value
          />
        </q-card-section>

        <q-card-actions align="right" class="text-primary">
          <q-btn flat label="Cancel" v-close-popup />
          <q-btn flat label="OK" @click="approveSelected()" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="promptReject" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section>
          <div class="text-h6">Rejected Reason</div>
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
      showDetail: false,
      promptApprove: false, handleBy: '4',
      promptReject: false, content: '',
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
          if(result.data[i].manager_approve == 1 && result.data[i].purch_manager_approve == 0){
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
        purch_manager_approve: 1,
        handle_by : this.handleBy
      }

      await this.$http.put('/update_spp/' + val.spp_id, data, {})
      .then (result => {
        
      })
    },
    async reject(val){
      var history = {
        spp_id: val.spp_id,
        content: this.content
      }
      this.$http.post('/new_history', history, {})
      .then (result => {
      })
      var data = {
        purch_manager_approve: -1,
        note: this.content
      }
      await this.$http.put('/update_spp/' + val.spp_id, data, {})
      .then (result => {
        
      })
    },
    async approveSelected(){
      this.showDetail = false
      var data = this.sppList.filter(e => e.select === true)
      for(var i = 0; i<data.length; i++){
        await this.approve(data[i])
      }
      await this.fetchData()
      await this.$root.$emit('refresh')
    },
    async rejectSelected(){
      var data = this.sppList.filter(e => e.select === true)
      for(var i = 0; i<data.length; i++){
        await this.reject(data[i])
      }
      await this.fetchData()
      await this.$root.$emit('refresh')
    },
    formatDate(dt){
      return moment(dt).format('YYYY-MM-DD');
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
