<template>
  <div class="row relative q-px-lg q-pt-lg">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <!-- toolbar  -->
      <q-card-section class="q-pa-md row justify-between">
        <div class="q-gutter-md">
          <q-btn color="negative" label="Tolak" @click="promptReject=true" :disable="!selectCount" />
          <q-btn
            color="positive"
            label="Setuju"
            @click="promptApprove = true"
            :disable="!selectCount"
          />
          <q-btn
            flat
            color="secondary"
            class="q-ml-xl"
            label="Detail"
            :disabled="selectCount != 1"
            @click="show_detail = true"
          />
          <q-btn
            flat
            color="secondary"
            label="History"
            :disabled="selectCount != 1"
            @click="showHistory()"
          />
        </div>
        <div></div>
      </q-card-section>
      <q-markup-table flat square dense>
        <!-- table head  -->
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:10px;"></th>
            <th class="text-left">User</th>
            <th class="text-left">Tanggal Pengajuan</th>
            <th class="text-left">Deadline</th>
            <th class="text-left">Barang</th>
            <th class="text-right">Jumlah</th>
          </tr>
        </thead>
        <!-- table body  -->
        <tbody v-if="sppList.length" class="bg-blue-grey-1">
          <tr v-for="d in sppList" :key="d.id">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td class="text-left">
              {{ d.name }}
              <q-chip color="accent" text-color="white" dense size="sm">{{ d.dept }}</q-chip>
            </td>
            <td class="text-left">{{ d.create_at |moment('DD MMM YYYY') }}</td>
            <td class="text-left">{{ d.deadline |moment('DD MMM YYYY')}}</td>
            <td class="text-left">{{ d.item }}</td>
            <td class="text-right">{{ d.qty }} {{d.unit}}</td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">tidak ada data</td>
          </tr>
        </tbody>
        <q-card-section></q-card-section>
      </q-markup-table>
    </q-card>

    <!-- detail  -->
    <q-dialog v-model="show_detail" persistent transition-show="scale" transition-hide="scale">
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
              <q-item-label caption>Requester</q-item-label>
              <q-item-label>{{selected.name}}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Request Date</q-item-label>
              <q-item-label>{{selected.create_at}}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Deadline</q-item-label>
              <q-item-label>{{selected.deadline}}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Item</q-item-label>
              <q-item-label>{{selected.item}}</q-item-label>
            </q-item-section>
            <q-item-section side>
              <q-item-label caption>Quantity</q-item-label>
              <q-item-label>{{selected.qty}} {{selected.unit}}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>Description</q-item-label>
              <q-item-label>{{selected.description}}</q-item-label>
            </q-item-section>
          </q-item>
          <q-separator spaced />
          <q-item>
            <q-item-section>
              <q-item-label caption>Status</q-item-label>
              <q-item-label>{{status}}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
        <q-separator spaced />
        <q-card-actions align="between">
          <q-btn flat label="Tolak" color="negative" @click="promptReject=true" v-close-popup />
          <q-btn flat label="Setuju" color="positive" @click="promptApprove = true" />
        </q-card-actions>
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
              :subtitle="dateHistory(x.create_at)"
              :color="getColor(x.status)"
              :icon="getIcon(x.status)"
            >
              <div>{{x.content}}</div>
            </q-timeline-entry>
          </q-timeline>
        </q-card-section>
      </q-card>
    </q-dialog>
    <q-dialog v-model="promptApprove" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-primary text-white">
          <q-item-label class>Tugaskan Kepada</q-item-label>
        </q-card-section>
        <q-separator></q-separator>

        <q-card-section class="column q-gutter-y-sm">
          <div class="row q-gutter-x-sm items-center">
            <div style="width:150px">Staff</div>
            <q-select class="col-4" outlined dense v-model="handleBy" :options="option" map-options style="flex-grow: 99;" />
          </div>
          <div class="row q-gutter-x-sm items-center">
            <div style="width:150px">Kategori Barang/Jasa</div>
            <q-select class="col-4" outlined dense v-model="selKategori" :options="optionKategori" style="flex-grow: 99;" />
          </div>
        </q-card-section>

        <q-card-actions align="between" class="text-primary">
          <q-btn flat color="negative" label="Cancel" v-close-popup />
          <q-btn flat color="positive" label="OK" @click="approveSelected()" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
    <q-dialog v-model="promptReject" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section class="bg-primary text-white">
          <div>Penolakan SPP</div>
        </q-card-section>

        <q-card-section>
          <q-input
            class="col-4"
            outlined
            stack-label
            v-model="content"
            type="textarea"
            label="Alasan Penolakan"
          />
        </q-card-section>

        <q-card-actions align="between" class="text-primary">
          <q-btn flat color="negative" label="Cancel" v-close-popup />
          <q-btn flat color="positive" label="OK" @click="rejectSelected()" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
export default {
  data() {
    return {
      show_detail: false,
      history: [],
      show_history: false,
      promptApprove: false,
      handleBy: {},
      promptReject: false,
      content: "",
      sppList: [],
      selected: {},
      option: [],
      
      optionKategori:[
        "Keperluan & Peralatan Produksi",
        "Packing Barang",
        "Makan & Minum",
        "Perbaikan Kendaraan (Produksi/Gudang)",
        "Perbaikan Kendaraan (Marketing)",
        "Perbaikan Kendaraan (Umum & Adm)",
        "Iklan & Promosi",
        "Perjalanan Dinas",
        "Entertainment",
        "Pendidikan & Latihan",
        "R&D",
        "Materai & Fotocopy",
        "ATK & Keperluan Kantor",
        "Surat & Izin-izin",
        "Sumbangan",
        "Raw Material",
        "Perbaikan Gudang",
      ],
      selKategori:null
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.sppList = [];
      this.$http.get("/spp-approval", {}).then(result => {
        for (var i = 0; i < result.data.length; i++) {
          if (
            result.data[i].manager_approve == 1 &&
            result.data[i].purch_manager_approve == 0
          ) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        }
      });
      this.$http.get("/list_user", {}).then(result => {
        this.option = result.data;
        this.handleBy = result.data[0];
      });
    },
    async approve(val) {
      var data = {
        purch_manager_approve: 1,
        handle_by: this.handleBy.value,
        kategori : this.selKategori
      };
      await this.$http
        .put("/update_spp/" + val.spp_id, data, {})
        .then(result => {});

      var history = {
        spp_id: val.spp_id,
        status: "process",
        content:
          "Sudah disetujui manager purchasing, diproses oleh: " +
          this.handleBy.label
      };
      await this.$http.post("/new_history", history, {}).then(result => {});
      var notifikasi = {
        from_id: this.$store.state.currentUser.user_id,
        to_id: val.user_id,
        notif: "SPP Anda sudah disetujui manager purchasing",
        note: "Dalam proses pencarian vendor",
        spp_id: val.spp_id,
        reference_page: "/spp/list"
      };
      this.$http.post("/notifikasi", notifikasi, {}).then(result => {});

      notifikasi.to_id = this.handleBy.value;
      notifikasi.notif = "SPP Baru perlu di proses";
      notifikasi.reference_page = "/spp/approved";
      notifikasi.note = "";

      this.$http.post("/notifikasi", notifikasi, {}).then(result => {});
    },
    async reject(val) {
      var data = {
        purch_manager_approve: -1,
        note: this.content
      };
      await this.$http
        .put("/update_spp/" + val.spp_id, data, {})
        .then(result => {});

      var history = {
        spp_id: val.spp_id,
        status: "rejected",
        content: "SPP ditolak manager purchasing: " + this.content
      };
      await this.$http.post("/new_history", history, {}).then(result => {});
      var notifikasi = {
        from_id: this.$store.state.currentUser.user_id,
        to_id: val.user_id,
        notif: "SPP Anda ditolak manager purchasing",
        note: val.note,
        spp_id: val.spp_id,
        reference_page: "/spp/list"
      };
      this.$http.post("/notifikasi", notifikasi, {}).then(result => {});
    },
    async approveSelected() {
      this.show_detail = false;
      var data = this.sppList.filter(e => e.select === true);
      for (var i = 0; i < data.length; i++) {
        
        await this.approve(data[i]);
      }
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.selKategori = null
      this.$q.notify("SPP berhasil disetujui!");
    },
    async rejectSelected() {
      var data = this.sppList.filter(e => e.select === true);
      for (var i = 0; i < data.length; i++) {
        await this.reject(data[i]);
      }
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.$q.notify("SPP ditolak!");
    },
    showHistory() {
      this.$http
        .get("/spp_history/" + this.selected.spp_id, {})
        .then(result => {
          this.history = result.data;
        });
      this.show_history = true;
    },
    formatDate(dt) {
      return moment(dt).format("YYYY-MM-DD");
    },
    dateHistory(dt) {
      return moment(dt).format("DD MMMM YYYY");
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
    }
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter(e => e.select === true);
      var count = data.length;

      if (data[0]) this.selected = data[0];

      return count;
    },
    status() {
      if (this.selected.manager_approve == 0) {
        return "Menunggu persetujuan manager";
      } else if (this.selected.manager_approve == -1) {
        return "Ditolak oleh manager";
      } else if (this.selected.purch_manager_approve == 0) {
        return "Menunggu persetujuan manager purchasing";
      } else if (this.selected.purch_manager_approve == -1) {
        return "Ditolak oleh manager purchasing";
      } else {
        return "Sedang diproses oleh " + this.selected.handler_name;
      }
    }
  }
};
</script>

<style lang="scss" scoped></style>
