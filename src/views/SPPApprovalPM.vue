<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <!-- toolbar  -->
      <q-card-section class="row justify-between q-gutter-x-md">
        <div>
          <q-input
            outlined
            dense
            v-model="searchTerm"
            @input="fetchData"
            clearable
            @clear="searchTerm = ''"
            placeholder="Cari Nama Barang"
            style="width: 400px;"
          >
            <template v-slot:prepend>
              <q-icon name="search"></q-icon>
            </template>
          </q-input>
        </div>

        <div class="row items-center q-gutter-x-sm">
          <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optUrgency"
            v-model="selUrgency"
            clearable
            @clear="selUrgency = ''"
            @input="fetchData"
            label="Pilih Urgency"
            style="width: 230px;"
          ></q-select>
          <!-- <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optDept"
            v-model="selDivisi"
            clearable
            @clear="selDivisi = ''"
            @input="fetchData"
            label="Pilih Divisi"
            style="width: 230px;"
          ></q-select> -->
          <q-select
            outlined
            dense
            emit-value
            map-options
            :options="optSort"
            v-model="selSort"
            @input="fetchData"
            label="Urutkan"
            style="width: 230px;"
          ></q-select>
        </div>
      </q-card-section>
      <q-card-section class="q-pa-none" v-if="sppList.length">
        <q-markup-table
          flat
          class="stickyTable"
          :style="selectCount > 0? 'height: calc(100vh - 325px);' : 'height: calc(100vh - 250px);'"
        >
          <!-- table head -->
          <thead class="text-white">
            <tr>
              <th style="width:20px;">
                <q-checkbox v-model="check_all" @input="checkAll"></q-checkbox>
              </th>
              <th>User</th>
              <!-- <th>Divisi</th> -->
              <th>Tanggal Pengajuan</th>
              <th>Urgency</th>
              <th>Barang</th>
              <th style="width: 200px !important;">Keterangan</th>
              <th>Action</th>
            </tr>
          </thead>
          <!-- table body  -->
          <tbody>
            <tr v-for="(d, i) in sppList" :key="i">
              <td>
                <q-checkbox v-model="d.select" />
              </td>
              <td class="text-left">
                {{ d.name }}
              </td>
              <!-- <td class="text-left" style="vertical-align: top;">
                {{ d.dept }}
              </td> -->
              <td class="text-center">
                <div>{{ d.create_at | moment("DD MMM YYYY") }}</div>
                <!-- <div class="text-grey">Deadline</div>
                <div>{{ d.deadline | moment("DD MMM YYYY") }}</div> -->
              </td>
              <td>
                {{ d.urgency }}
              </td>
              <td class="text-left">
                <div class="l-wrap-cell" style="width: 200px !important;">
                  <span>
                    {{ d.item.length > 55 ? d.item.slice(0, 50) : d.item }}
                  </span>
                  <span v-if="d.item.length > 55" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ d.item }}</q-tooltip
                    >
                  </span>
                </div>
                <div class="text-grey">{{ d.qty }} {{ d.unit }}</div>
              </td>
              <td class="text-left">
                <div class="l-wrap-cell" style="width: 200px !important;">
                  <span>
                    {{
                      d.description.length > 55
                        ? d.description.slice(0, 50)
                        : d.description
                    }}
                  </span>
                  <span v-if="d.description.length > 55" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ d.description }}</q-tooltip
                    >
                  </span>
                </div>
              </td>
              <td class="text-center">
                <q-btn-dropdown flat dense dropdown-icon="more_horiz">
                  <q-list>
                    <q-item
                      :to="`/spp/detail/${d.spp_id}?approval=purchasing`"
                      clickable
                      v-close-popup
                    >
                      Detail
                    </q-item>
                    <q-item
                      clickable
                      class="text-positive text-bold"
                      v-close-popup
                      @click="
                        clearSelect(i);
                        confirmApprove = true;
                      "
                    >
                      Setujui
                    </q-item>
                    <q-item
                      clickable
                      class="text-negative text-bold"
                      v-close-popup
                      @click="
                        clearSelect(i);
                        confirmReject = true;
                      "
                    >
                      Tolak
                    </q-item>
                  </q-list>
                </q-btn-dropdown>
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-card-section>
      
      <q-card-section
        class="column items-center justify-center"
        style="height: calc(100vh - 250px);"
        v-else
      >
        <q-img width="400px" :src="`./empty.png`"></q-img>
        <div class="l-text-title text-bold">Data Tidak Ditemukan</div>
      </q-card-section>

      <q-separator></q-separator>
      <q-card-section v-if="selectCount > 0" class="row justify-between items-center">
        <div class="l-text-subtitle text-bold text-black">
          {{ selectCount }} PO Dipilih
        </div>
        <div class="row justify-end items-center q-gutter-x-md">
          <q-btn
            unelevated
            icon="close"
            label="Tolak"
            color="negative"
            @click="confirmReject = true"
            no-caps
          ></q-btn>
          <q-btn
            unelevated
            icon="done"
            label="Setujui"
            color="positive"
            @click="confirmApprove = true"
            no-caps
          ></q-btn>
        </div>
      </q-card-section>

    </q-card>

    <!-- <q-footer
      v-if="selectCount > 0"
      style="max-width: 1440px;"
      class="q-mx-auto atas-radius bg-white"
    >
      <q-card-section class="row justify-between items-center">
        <div class="l-text-subtitle text-bold text-black">
          {{ selectCount }} PO Dipilih
        </div>
        <div class="row justify-end items-center q-gutter-x-md">
          <q-btn
            unelevated
            label="Tolak"
            color="negative"
            @click="confirmReject = true"
            no-caps
          ></q-btn>
          <q-btn
            unelevated
            label="Setujui"
            color="positive"
            @click="confirmApprove = true"
            no-caps
          ></q-btn>
        </div>
      </q-card-section>
    </q-footer> -->

    <!-- persetujuan -->
    <q-dialog v-model="confirmApprove" persistent>
      <q-card style="max-width: 400px;">
        <q-card-section class="column">
          <div class="l-text-subtitle text-bold">Pilih PIC</div>
          <div v-if="selectCount == 1">
            Pilih Staff yang ditugaskan untuk melakukan Pembelian SPP
            <span class="text-bold">{{ this.selected.item }}</span> sejumlah
            <span class="text-bold"
              >{{ this.selected.qty }} {{ this.selected.unit }}</span
            >?
          </div>
          <div v-else>
            Pilih Staff yang ditugaskan untuk melakukan Pembelian
            <span class="text-bold">{{ selectCount }} SPP</span> terpilih?
          </div>
        </q-card-section>
        <q-separator></q-separator>

        <q-card-section class="column q-gutter-y-sm">
          <div class="column q-gutter-y-xs">
            <div class="text-black">Staff</div>
            <q-select
              class="col-4"
              outlined
              dense
              v-model="handleBy"
              :options="option"
              map-options
            />
          </div>
          <div class="column q-gutter-y-xs">
            <div class="text-black">Kategori</div>
            <q-select
              class="col-4"
              outlined
              dense
              v-model="selKategori"
              :options="optionKategori"
            />
          </div>
        </q-card-section>

        <q-card-actions align="between" class="q-gutter-x-sm bg-grey-3 q-pa-md">
          <q-btn
            outline
            label="Batal"
            dense
            class="l-grow"
            color="grey-8"
            no-caps
            v-close-popup
            style="width: calc(50% - 16px)"
          />
          <q-btn
            dense
            unelevated
            no-caps
            color="primary"
            label="Ya, Setujui SPP"
            class=" l-grow"
            @click="approveSelected()"
            v-close-popup
            :disable="!selKategori"
            style="width: calc(50% - 16px)"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>

    <!-- penolakan  -->
    <q-dialog v-model="confirmReject" persistent>
      <q-card style="min-width: 350px;">
        <q-card-section class="row justify-center q-pb-none">
          <q-avatar
            color="grey-3"
            text-color="negative"
            size="75px"
            font-size="35px"
            icon="priority_high"
          ></q-avatar>
        </q-card-section>
        <q-card-section class="q-pt-none text-center">
          <div class="l-text-subtitle text-bold">Tolak SPP</div>
          <div v-if="selectCount == 1">
            Apakah Anda yakin ingin menolak SPP untuk
            <span class="text-bold">{{ this.selected.item }}</span> sejumlah
            <span class="text-bold"
              >{{ this.selected.qty }} {{ this.selected.unit }}</span
            >? Berikan Alasan Anda!
          </div>
          <div v-else>
            Apakah Anda yakin ingin menolak
            <span class="text-bold">{{ selectCount }} SPP</span> terpilih?
            Beikan Alasan Anda!
          </div>
        </q-card-section>

        <q-separator></q-separator>
        <q-card-section class="column q-gutter-y-xs">
          <div class="text-black">Alasan</div>
          <q-input
            outlined
            stack-label
            v-model="content"
            type="textarea"
            placeholder="e.g. Stok Barang Masih Ada"
          />
        </q-card-section>

        <q-card-actions align="between" class="q-gutter-x-sm bg-grey-3 q-pa-md">
          <q-btn
            outline
            label="Batal"
            dense
            class="l-grow"
            color="grey-8"
            no-caps
            v-close-popup
            style="width: calc(50% - 16px)"
          />
          <q-btn
            dense
            unelevated
            no-caps
            color="primary"
            label="Ya, Tolak SPP"
            class=" l-grow"
            @click="rejectSelected()"
            v-close-popup
            style="width: calc(50% - 16px)"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";
import axios from "axios";
export default {
  data() {
    return {
      show_detail: false,
      history: [],
      show_history: false,
      confirmApprove: false,
      confirmReject: false,
      handleBy: {},
      content: "",
      sppList: [],
      selected: {},
      option: [],

      optSort: [
        // { label: "Deadline Terdekat", value: "deadline ASC" },
        // { label: "Deadline Terlama", value: "deadline DESC" },
        { label: "Pengajuan Terdekat", value: "create_at ASC" },
        { label: "Pengajuan Terlama", value: "create_at DESC" },
      ],
      selSort: "create_at ASC",

      selDivisi: "",
      optDept: [],

      searchTerm: "",
      check_all: false,

      optionKategori: [],
      selKategori: null,

      selUrgency: null,
      optUrgency: [
        "HIGH",
        "MIDDLE",
        "LOW",
      ],
    };
  },
  async mounted() {
    this.getKategori();

    this.fetchData();
    // this.getDept();
  },
  watch: {
    sppList: {
      deep: true,
      handler(val) {
        let rows = JSON.parse(JSON.stringify(this.sppList));
        let checked = val.filter((el) => el.select);
        let unchecked = val.filter((el) => !el.select);

        if (checked.length == rows.length) {
          this.check_all = true;
        } else if (unchecked.length == rows.length) {
          this.check_all = false;
        } else {
          this.check_all = null;
        }
      },
    },
  },
  methods: {
    async getKategori() {
      let resp = await this.$http.get("/kategori");
      let kategori = resp.data.map((a) => a["name"]);
      this.optionKategori = kategori;
    },
    clearSelect(idx) {
      let temp = JSON.parse(JSON.stringify(this.sppList));
      for (let i in temp) {
        if (i == idx) temp[i].select = true;
        else temp[i].select = false;
      }
      this.sppList = temp;
    },
    checkAll(val) {
      let temp = JSON.parse(JSON.stringify(this.sppList));
      for (let item of temp) {
        item.select = val;
      }
      this.sppList = temp;
    },
    fetchData() {
      this.sppList = [];
      console.log(this.selDivisi);
      let q_filter = `?sort=${this.selSort}&search=${
        this.searchTerm ? this.searchTerm : "" //}&dept=${this.selDivisi ? this.selDivisi : ""
      }&urgency=${this.selUrgency ? this.selUrgency : ""}`;
      this.$http.get(`/spp-approval${q_filter}`, {}).then((result) => {
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
      this.$http.get("/list_user", {}).then((result) => {
        this.option = result.data;
        this.handleBy = result.data[0];
      });
    },
    // async getDept() {
    //   // let resp = this.$http.get("/dept")
    //   this.$http.get("/dept").then((resp) => {
    //     let dept = resp.data.map((a) => a.dept);
    //     this.optDept = dept;
    //   });
    // },

    async approve(val) {
      var data = {
        purch_manager_approve: 1,
        handle_by: this.handleBy.value,
        kategori: this.selKategori,
      };
      await this.$http
        .put("/update_spp/" + val.spp_id, data, {})
        .then((result) => {});

      var history = {
        spp_id: val.spp_id,
        status: "process",
        content:
          "Sudah disetujui manager purchasing, diproses oleh: " +
          this.handleBy.label,
      };
      await this.$http.post("/new_history", history, {}).then((result) => {});
      var notifikasi = {
        from_id: this.$store.state.currentUser.user_id,
        to_id: val.user_id,
        notif: "SPP Anda sudah disetujui manager purchasing",
        note: "Dalam proses pencarian vendor",
        spp_id: val.spp_id,
        reference_page: "/spp/list",
      };
      this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

      notifikasi.to_id = this.handleBy.value;
      notifikasi.notif = "SPP Baru perlu di proses";
      notifikasi.reference_page = "/spp/approved";
      notifikasi.note = "";

      this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
    },

    async reject(val) {
      var data = {
        purch_manager_approve: -1,
        note: this.content,
      };
      await this.$http
        .put("/update_spp/" + val.spp_id, data, {})
        .then((result) => {});

      var history = {
        spp_id: val.spp_id,
        status: "rejected",
        content: "SPP ditolak manager purchasing: " + this.content,
      };
      await this.$http.post("/new_history", history, {}).then((result) => {});
      var notifikasi = {
        from_id: this.$store.state.currentUser.user_id,
        to_id: val.user_id,
        notif: "SPP Anda ditolak manager purchasing",
        note: val.note,
        spp_id: val.spp_id,
        reference_page: "/spp/list",
      };
      this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
    },

    async approveSelected() {
      this.show_detail = false;
      var data = this.sppList.filter((e) => e.select === true);
      for (var i = 0; i < data.length; i++) {
        await this.approve(data[i]);
      }
      await this.fetchData();
      await this.$root.$emit("refresh");
      this.selKategori = null;
      this.$q.notify("SPP berhasil disetujui!");
    },

    async rejectSelected() {
      var data = this.sppList.filter((e) => e.select === true);
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
        .then((result) => {
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
    },
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter((e) => e.select === true);
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
    },
  },
};
</script>

<style lang="scss" scoped>
.l-wrap-cell {
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
