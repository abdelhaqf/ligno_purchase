<template>
  <div class="row relative q-px-lg ">
    <q-card flat bordered class="col-12 bg-white rounded-borders">
      <!-- table control -->
      <q-card-section class="row justify-between q-gutter-x-md no-wrap">
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
            outlinedfetchData
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
        <!-- table header  -->

        <q-scroll-area
          @scroll="getpos"
          class="l-grow q-pa-none"
          style="width: 100% !important;"
          :style="
            selectCount > 0
              ? 'height: calc(100vh - 325px);'
              : 'height: calc(100vh - 248px);'
          "
          ref="tableScroll"
        >
          <q-markup-table flat class="stickyTable" wrap-cells>
            <!-- table head -->
            <thead class="text-white">
              <tr>
                <th style="width:20px;">
                  <q-checkbox
                    v-model="check_all"
                    @input="checkAll"
                  ></q-checkbox>
                </th>
                <th>User</th>
                <!-- <th>Divisi</th> -->
                <th>PIC</th>
                <th>Tanggal Pengajuan</th>
                <th>Urgency</th>
                <th>Barang</th>
                <th>Keterangan</th>
                <th>Action</th>
              </tr>
            </thead>

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
                <td class="text-left">
                  {{ d.handler_name }}
                </td>
                <td class="text-center">
                  <div>{{ d.create_at | moment("DD MMM YYYY") }}</div>
                  <!-- <div class="text-grey">Deadline</div>
            <div>{{ d.deadline | moment("DD MMM YYYY") }}</div> -->
                </td>
                <td class="text-center">
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
                        clickable
                        v-close-popup
                        @click="
                          clearSelect(i);
                          createPO();
                        "
                      >
                        Buat PO
                      </q-item>
                      <q-item
                        clickable
                        v-close-popup
                        @click="
                          clearSelect(i);
                          showDialogHistory();
                        "
                      >
                        History
                      </q-item>
                      <q-item
                        clickable
                        v-close-popup
                        @click="
                          clearSelect(i);
                          confirmReject = true;
                        "
                      >
                        Tolak
                      </q-item>
                      <q-item
                        clickable
                        v-close-popup
                        @click="
                          clearSelect(i);
                          toPreview();
                        "
                      >
                        Print
                      </q-item>
                    </q-list>
                  </q-btn-dropdown>
                </td>
              </tr>
            </tbody>
          </q-markup-table>
        </q-scroll-area>
      </q-card-section>
      <!-- table header  -->

      <q-card-section
        class="column items-center justify-center"
        style="height: calc(100vh - 250px);"
        v-else
      >
        <q-img width="400px" :src="`./empty.png`"></q-img>
        <div class="l-text-title text-bold">Data Tidak Ditemukan</div>
      </q-card-section>

      <q-separator v-if="selectCount > 0" />
      <q-card-section
        v-if="selectCount > 0"
        class="row justify-between items-center"
      >
        <div class="l-text-subtitle text-bold text-black">
          {{ selectCount }} PO Dipilih
        </div>
        <div class="row justify-end items-center q-gutter-x-md">
          <q-btn
            unelevated
            label="Print"
            color="white"
            text-color="black"
            outline
            style="color: black;"
            @click="toPreview"
            no-caps
            icon="print"
          >
          </q-btn>
          <q-btn
            unelevated
            label="Tolak"
            color="negative"
            @click="confirmReject = true"
            icon="close"
            no-caps
          >
          </q-btn>
          <q-btn
            unelevated
            label="Buat PO"
            color="blue"
            @click="createPO"
            no-caps
            icon="edit"
          >
          </q-btn>
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
            label="Print"
            color="white"
            text-color="black"
            outline
            style="color: black;"
            @click="toPreview"
            no-caps
            icon="print"
          >
          </q-btn>
          <q-btn
            unelevated
            label="Tolak"
            color="negative"
            @click="confirmReject = true;"
            icon="close"
            no-caps
          >
          </q-btn>
          <q-btn
            unelevated
            label="Buat PO"
            color="blue"
            @click="createPO"
            no-caps
            icon="edit"
          >
          </q-btn>
        </div>
      </q-card-section>
    </q-footer> -->

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
          <div>
            Apakah Anda yakin ingin menolak
            <span class="text-bold">{{ selectCount }} SPP</span> terpilih?
            Berikan Alasan Anda!
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
import { Money } from "v-money";
import axios from "axios";
import { mapActions } from "vuex";
import dialogHistorySpp from "../components/dialogHistorySpp.vue";
export default {
  components: { Money },
  data() {
    return {
      sppList: [],
      sppSelectID: [],

      show_detail: false,
      history: [],
      show_history: false,
      selected: {},

      po: {
        po_date: moment().format("YYYY/MM/DD"),
        po_id: "",
      },

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

      curr: "IDR",
      type: "PO",
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      confirmCancel: false,
      content: "",
      selOrder: "create_at",

      // new data
      formulation_rm: [],
      filtered_formulation_rm: [],

      allowed: false,
      dialogConfirm: false,
      kurs: 0,
      money_kurs: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      showInput: false,
      optVendor: [],
      filteredVD: [],

      confirmReject: false,
      content: "",

      selUrgency: null,
      optUrgency: ["HIGH", "MIDDLE", "LOW"],

      myTimeout: null,
    };
  },
  async mounted() {
    await this.fetchData();
    if (this.$route.query.scroll) {
      this.$refs.tableScroll.setScrollPercentage(this.$route.query.scroll);
    }
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
    ...mapActions(["sendPrintData"]),
    getpos(pos) {
      try {
        this.$router
          .replace({
            path: `/spp/approved?scroll=${pos.verticalPercentage}`,
          })
          .catch((failure) => {
            return true;
          });
      } catch (err) {
        return true;
      }
    },
    showDialogHistory() {
      let temp = this.sppList.filter((val) => {
        return val.select;
      });

      this.$q
        .dialog({
          component: dialogHistorySpp,
          parent: this,
          spp: temp,
        })
        .onOk((val) => {
          console.log("OK was clicked on dialog: ", val);
        })
        .onCancel(() => {
          console.log("Cancel was clicked on dialog");
        })
        .onDismiss(() => {
          console.log("OK or cancel was clicked on dialog");
        });
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
    // async getDept() {
    //   // let resp = this.$http.get("/dept")
    //   this.$http.get("/dept").then((resp) => {
    //     let dept = resp.data.map((a) => a.dept);
    //     this.optDept = dept;
    //   });
    // },
    async fetchData() {
      this.sppList = [];
      let q_filter = `?sort=${this.selSort}&search=${
        this.searchTerm ? this.searchTerm : "" //}&dept=${this.selDivisi ? this.selDivisi : ""
      }&urgency=${this.selUrgency ? this.selUrgency : ""}`;

      await this.$http
        .get(
          "/spp_approved/" +
            this.$store.state.currentUser.user_id +
            "/" +
            this.$store.state.currentUser.is_purch_manager +
            q_filter,

          {}
        )
        .then((result) => {
          for (var i = 0; i < result.data.length; i++) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        });
    },
    async toPreview() {
      let temp = this.sppList.filter((val) => {
        return val.select;
      });

      let result = temp.map((a) => a.spp_id);

      console.log(result);

      let route = this.$router.resolve({ path: "/print" });
      window.open(`${route.href}/${JSON.stringify(result)}`);
    },
    createPO() {
      for (var i = 0; i < this.sppList.length; i++) {
        if (this.sppList[i].select == true) {
          this.sppSelectID.push(this.sppList[i].spp_id);
        }
      }

      this.$router.push(`/po/create?ids=${this.sppSelectID.join(",")}`);
    },
    cancelSPP(val) {
      var data = {
        purch_manager_cancel: 1,
        note: this.content,
      };
      this.$http.put("/update_spp/" + val.spp_id, data, {}).then((result) => {
        this.$root.$emit("refresh");
        this.fetchData();
      });

      var history = {
        spp_id: val.spp_id,
        status: "canceled",
        content: this.content,
      };
      this.$http.post("/new_history", history, {}).then((result) => {});
      // this.$q.notify("SPP berhasil dibatalkan!");
    },
    rejectSelected() {
      var data = this.sppList.filter((e) => e.select === true);
      for (var i = 0; i < data.length; i++) {
        this.cancelSPP(data[i]);
      }
      this.fetchData();
      this.$root.$emit("refresh");
      this.$q.notify("SPP ditolak!");
    },
  },
  computed: {
    selectCount() {
      var data = this.sppList.filter((e) => e.select === true);
      var count = data.length;

      if (data[0]) this.selected = data[0];

      return count;
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
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
.l-wrap-cell {
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
