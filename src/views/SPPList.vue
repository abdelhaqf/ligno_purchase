<template>
  <div class="row relative q-px-lg q-pt-lg">
    <q-card class="col-12 bg-white rounded-borders">
      <!-- toolbar -->
      <q-card-section class="q-pa-md row justify-between">
        <div class="q-gutter-md">
          <q-btn label="Detail" color="primary" @click="showDetail()" :disable="slcIndex < 0" />
          <q-btn flat label="History" color="secondary" @click="showHistory()" :disable="slcIndex <0" />
        </div>
        <div>
          <q-select 
          outlined dense v-model="filter" 
          :options="filterOption"
          map-options emit-value
          @input="fetchData"
          />
        </div>
      </q-card-section>

      <!-- table  -->
      <q-markup-table bordered dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <!-- <th class="text-left">user</th> -->
            <th class="text-left">Dibuat</th>
            <th class="text-left">Deadline</th>
            <th class="text-left">Barang</th>
            <th class="text-right">Jumlah</th>
          </tr>
        </thead>
        <tbody v-if="sppList.length" class="bg-blue-grey-1">
          <tr v-for="(d, index) in sppList" :key="d.spp_id">
            <td>
              <q-radio v-model="slcIndex" :val="index" />
            </td>
            <!-- <td class="text-left">{{ d.name }}</td> -->
            <td class="text-left">
              {{ d.create_at | moment("DD MMM YYYY") }}
              <q-badge :color="getColor(d.status)" text-color="white" dense size="sm">{{ d.status }}</q-badge>
            </td>
            <td class="text-left" style="width: 100px;">
              {{ d.deadline | moment("DD MMM YYYY") }}
            </td>
            <td class="text-left">{{ d.item }}</td>
            <td class="text-right">{{ d.qty }} {{ d.unit }}</td>
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

    <!-- detail  -->
    <q-dialog v-model="show_detail" persistent transition-show="scale" transition-hide="scale" v-if="show_detail">
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-primary text-white row">
          <div>NO SPP: {{ selected.spp_id }}</div>

          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-list>
          <q-item>
            <q-item-section>
              <q-item-label caption>Yang Mengajukan</q-item-label>
              <q-item-label>{{ selected.name }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Pada Tanggal</q-item-label>
              <q-item-label>{{ selected.create_at | moment(" hh:mm, DD MMM YYYY ") }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Deadline</q-item-label>
              <q-item-label>{{ selected.deadline }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Nama Barang</q-item-label>
              <q-item-label>{{ selected.item }}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Jumlah</q-item-label>
              <q-item-label>{{ selected.qty }} {{ selected.unit }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section v-if="show_detail">
              <q-item-label caption>Keterangan</q-item-label>
              <q-item-label v-if="selected.description.length">{{ selected.description }}</q-item-label>
              <q-item-label v-else>-</q-item-label>
            </q-item-section>
          </q-item>
          <q-separator spaced />
          <q-item v-if="selected.est_arrival">
            <q-item-section>
              <q-item-label caption>Perkiraan Barang Tiba</q-item-label>
              <q-item-label>{{ selected.est_arrival }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Status Saat Ini</q-item-label>
              <q-item-label>
                {{ status_note }}
              </q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section v-show="selected.po_id">
              <q-item-label caption>Konfirmasi Penerimaan</q-item-label>
              <q-item-label>
                <q-select 
                  outlined dense v-model="isReceived" 
                  :options="receivedOption"
                  map-options emit-value
                  @input="updateStatus"
                  />
              </q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
      </q-card>
    </q-dialog>

    <!-- history  -->
    <q-dialog v-model="show_history" persistent transition-show="scale" transition-hide="scale">
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-secondary text-white row">
          <div>NO SPP: {{ history[0] ? history[0].spp_id : "" }}</div>
          <q-space />
          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-card-section class="q-px-xl q-my-sm" style="height: 450px; overflow: auto;">
          <q-timeline>
            <q-timeline-entry
              v-for="x in history"
              :key="x.id"
              :title="x.status"
              :subtitle="x.create_at | moment('DD MMM YYYY')"
              :color="getColor(x.status)"
              :icon="getIcon(x.status)"
            >
              <div>
                {{ x.content }}
              </div>
            </q-timeline-entry>
          </q-timeline>
        </q-card-section>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from 'moment'

export default {
  data() {
    return {
      sppList: [],
      slcIndex: -1,
      show_detail: false,
      history: [],
      show_history: false,
      selected: {},
      filterOption:[], filter: '',
      isReceived: 0,
      receivedOption:[
        { label: "fully received", value: '2' },
        { label: "half received", value: '1' },
        { label: "not received", value: '0' },
      ],
    };
  },
  mounted() {

    this.$http.get("/list_month_user", {
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
      console.log(this.filter)
      this.sppList = [];
      this.$http.get("/spp_byuserid/" + this.$store.state.currentUser.user_id+'/'+this.filter, {}).then((result) => {
        for (var i = 0; i < result.data.length; i++) {
          result.data[i].status = this.status(result.data[i]);
          this.sppList.push(result.data[i]);
        }
      });
    },
    showDetail() {
      this.selected = this.sppList[this.slcIndex];
      this.isReceived = this.selected.is_received
      this.show_detail = true;
    },
    updateStatus(){
      var data = { spp_id:  this.selected.spp_id, is_received: this.isReceived}
      this.selected.is_received = this.isReceived

      this.$http.put("/update_spp/" + this.selected.spp_id, data, {})
      .then((result) => {
        let history = {
          spp_id: this.selected.spp_id,
          status: "process",
          content: "update oleh pembuat SPP (" + this.$store.state.currentUser.username + ")",
        };
        if (this.isReceived == 2) {
          history.status = "done";
        }
        this.$http.post("/new_history", history, {}).then((result) => {});
        
        this.$q.notify({
          icon: "done",
          color: "positive",
          message: "Status penerimaan sudah diubah",
        });

        this.fetchData()
      });

    },
    showHistory() {
      this.$http.get("/spp_history/" + this.sppList[this.slcIndex].spp_id, {}).then((result) => {
        this.history = result.data;
      });
      this.show_history = true;
    },
    status(val) {
      if (val.purch_manager_cancel == 1) {
        return "canceled";
      } else if (val.manager_approve == 0) {
        return "waiting";
      } else if (val.manager_approve == -1) {
        return "rejected";
      } else if (val.purch_manager_approve == 0) {
        return "waiting";
      } else if (val.purch_manager_approve == -1) {
        return "rejected";
      } else if (val.is_received == 0) {
        return "process";
      } else if (val.is_received == 1) {
        return "process";
      } else if (val.is_received == 2) {
        return "done";
      }
    },
    getColor(val) {
      if (val == "done") return "positive";
      else if (val == "rejected" || val == "canceled") return "red-7";
      else if (val == "process") return "primary";
      else return "orange";
    },
    getIcon(val) {
      if (val == "done") return "done_all";
      else if (val == "rejected") return "error_outline";
      else if (val == "process") return "hourglass_bottom";
      else if (val == "created") return "library_add";
      else if (val == "canceled") return "close";
      else return "pending_actions";
    },
  },
  computed: {
    status_note() {
      if (this.selected.purch_manager_cancel == 1) {
        return "SPP dibatalkan oleh manager purchasing";
      } else if (this.selected.manager_approve == 0) {
        return "Menunggu persetujuan manager";
      } else if (this.selected.manager_approve == -1) {
        return "Ditolak oleh manager";
      } else if (this.selected.purch_manager_approve == 0) {
        return "Menunggu persetujuan manager purchasing";
      } else if (this.selected.purch_manager_approve == -1) {
        return "Ditolak oleh manager purchasing";
      } else if (this.selected.is_received == 0) {
        return "Sedang diproses oleh " + this.selected.handler_name;
      } else if (this.selected.is_received == 1) {
        return "Barang sudah diterima sebagian [" + this.selected.handler_name + "]";
      } else if (this.selected.is_received == 2) {
        return "Barang sudah diterima";
      }
    },
  },
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
  width: 130px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
<style>
.q-timeline__title {
  font-size: 16px;
}
</style>
