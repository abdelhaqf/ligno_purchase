<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Setuju" />
        <q-btn label="Tolak" />
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
              <q-checkbox v-model="d.select" dense />
            </td>
            <td>
              {{ d.name }} <q-chip color="grey-7" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td>{{ d.create_at }}</td>
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
                <q-item-label
                  >{{selected.description}}</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Status</q-item-label>
                <q-item-label>
                  - disetujui manager <span :style="(selected.manager_approve==1?'color: green;':'color: red;')" >{{(selected.manager_approve==1?'&#10004;':'&#10008;')}}</span><br>
                  - disetujui manager purchasing <span  :style="(selected.purch_manager_approve==1?'color: green;':'color: red;')" >{{(selected.purch_manager_approve==1?'&#10004;':'&#10008;')}}</span>
                  </q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Tolak" color="primary" v-close-popup />
          <q-btn flat label="Setuju" color="primary" v-close-popup />
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
      sppList: [],
      selected: {},
    };
  },
  mounted() {
    this.fetchData()
  },
  methods: {
    fetchData(){
      this.sppList = []
      this.$http.get('/spp', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){
          result.data[i].select = false
          this.sppList.push(result.data[i])
        }
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
    }

  }
};
</script>

<style lang="scss" scoped></style>
