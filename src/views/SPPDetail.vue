<template>
  <div class="q-px-lg rounded-borders full-width">
    <q-card flat bordered class="bg-white">
      <!-- form  -->

      <q-item class="q-py-md">
        <q-item-section side>
          <q-btn flat icon="arrow_back" @click="$router.go(-1)" dense></q-btn>
        </q-item-section>
        <q-item-section>
          <div class="text-bold l-text-detail">SPP #{{ spp.spp_id }}</div>
          <div class="text-grey-6">
            Diajukan pada
            <span class="text-bold">
              {{ momentFormatDateTime(spp.create_at) }}
            </span>
          </div>
        </q-item-section>
        <q-item-section side>
          <q-select
            v-if="spp.po_id"
            outlined
            dense
            v-model="isReceived"
            :options="receivedOption"
            map-options
            emit-value
            @input="updateStatus"
          ></q-select>
        </q-item-section>
      </q-item>
      <q-separator size="2px" inset></q-separator>
      <q-card-section class="q-ma-md bg-grey-2 column q-gutter-y-sm">
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Pembuat</div>
          <div class="text-bold text-right">{{ spp.name }}</div>
        </div>
        <!-- <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Deadline</div>
          <div class="text-bold text-right">
            {{ momentFormatDate(spp.deadline) }}
          </div>
        </div> -->
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Urgency</div>
          <div class="text-bold text-right">{{ spp.urgency ? spp.urgency : "-" }}</div>
        </div>
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">
            Estimasi Ketibaan
          </div>
          <div class="text-bold text-right">
            {{ momentFormatDate(spp.est_arrival) }}
          </div>
        </div>
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Nama Barang</div>
          <div class="text-bold text-right">{{ `${spp.item}` }}</div>
        </div>
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Jumlah</div>
          <div class="text-bold text-right">{{ `${spp.qty} ${spp.unit}` }}</div>
        </div>
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Keterangan</div>
          <div class="text-bold text-right">{{ spp.description }}</div>
        </div>
      </q-card-section>
      <q-scroll-area style="height:calc(100vh - 510px)" class="q-px-md">
        <div class="text-bold l-text-detail">SPP History</div>
        <q-timeline layout="comfortable" side="right">
          <q-timeline-entry
            :color="i == 0 ? 'positive' : 'grey-6'"
            v-for="(val, i) in spp.history"
            :key="i"
          >
            <template v-slot:title>
              <div
                class="l-text-detail text-capitalize text-bold"
                style="line-height: 1.4;"
              >
                {{ val.status }}
              </div>
            </template>
            <template v-slot:subtitle>
              <div class="text-left">
                {{ momentFormatDateTimeSimple(val.create_at) }}
              </div>
            </template>
            <div>{{ val.content }}</div>
          </q-timeline-entry>
        </q-timeline>
      </q-scroll-area>
      <q-separator/>
      <q-card-section
        v-if="
          ($route.query.approval == 'manager' &&
            $store.state.currentUser.user_id == spp.manager_id) ||
            ($route.query.approval == 'purchasing' &&
              $store.state.currentUser.is_purch_manager == 1)
        "
        class="row justify-end q-gutter-x-md"
      >
        <q-btn
          unelevated
          label="Tolak"
          color="negative"
          @click="promptReject = true"
          no-caps
        ></q-btn>
        <q-btn
          unelevated
          label="Setujui"
          color="positive"
          @click="promptApprove = true"
          no-caps
        ></q-btn>
      </q-card-section>
      <q-card-section v-else class="row justify-end">
        <q-btn
          unelevated
          color="primary"
          text-color="white"
          label="Ajukan Ulang"
          @click="
            reorderList();
            showDialogReorder();
          "
          no-caps
        ></q-btn>
      </q-card-section>
    </q-card>

    <!-- <q-footer
      class="atas-radius bg-white q-mx-auto"
      style="max-width: 1440px !important;"
    >
      <q-card-section
        v-if="
          ($route.query.approval == 'manager' &&
            $store.state.currentUser.user_id == spp.manager_id) ||
            ($route.query.approval == 'purchasing' &&
              $store.state.currentUser.is_purch_manager == 1)
        "
        class="row justify-end q-gutter-x-md"
      >
        <q-btn
          unelevated
          label="Tolak"
          color="negative"
          @click="promptReject = true"
          no-caps
        ></q-btn>
        <q-btn
          unelevated
          label="Setujui"
          color="positive"
          @click="promptApprove = true"
          no-caps
        ></q-btn>
      </q-card-section>
      <q-card-section v-else class="row justify-end">
        <q-btn
          unelevated
          color="primary"
          text-color="white"
          label="Ajukan Ulang"
          @click="
            reorderList();
            showDialogReorder();
          "
          no-caps
        ></q-btn>
      </q-card-section>
    </q-footer> -->

    <q-dialog v-model="promptApprove" persistent>
      <q-card
        style="min-width: 400px;"
        v-if="$route.query.approval == 'purchasing'"
      >
        <q-card-section class="column">
          <div class="l-text-subtitle text-bold">Pilih PIC</div>
          <div>Pilih Staff yang ditugaskan untuk melakukan PO</div>
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
            @click="approve"
            v-close-popup
            :disable="!selKategori"
            style="width: calc(50% - 16px)"
          />
        </q-card-actions>
      </q-card>

      <q-card
        style="max-width: 400px;"
        v-if="$route.query.approval == 'manager'"
      >
        <q-card-section class="row justify-center q-pb-none">
          <q-avatar
            color="grey-3"
            text-color="positive"
            size="75px"
            font-size="35px"
            icon="border_color"
          ></q-avatar>
        </q-card-section>
        <q-card-section class="q-pt-none text-center">
          <div class="l-text-subtitle text-bold">Terima SPP</div>
          <div class="">
            Apakah Anda yakin ingin menyetujui SPP untuk
            <span class="text-bold">{{ spp.item }}</span> sejumlah
            <span class="text-bold">{{ spp.qty }} {{ spp.unit }}</span
            >?
          </div>
          <div class="q-py-sm">
            Pilih Tingkat Kepentingan
            <q-select
              outlined
              dense
              v-model="urgency"
              :options="OptUrgency"
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
            @click="approve"
            :disable="urgency == ''"
            v-close-popup
            style="width: calc(50% - 16px)"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>

    <q-dialog v-model="promptReject" persistent>
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
          <div class="">
            Apakah Anda yakin ingin Menolak SPP untuk
            <span class="text-bold">{{ spp.item }}</span> sejumlah
            <span class="text-bold">{{ spp.qty }} {{ spp.unit }}</span
            >? Berikan alasan anda!
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
            @click="approve"
            v-close-popup
            style="width: calc(50% - 16px)"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import dialogReorderPO from "../components/dialogReorderPO.vue";
import moment from "moment";
moment.locale("id");
export default {
  data() {
    return {
      spp: {},
      isReceived: "0",
      receivedOption: [
        { label: "fully received", value: "2" },
        { label: "half received", value: "1" },
        { label: "not received", value: "0" },
      ],

      aproover: {},

      handleBy: {},
      option: [],

      optionKategori: [],
      selKategori: null,

      promptApprove: false,
      promptReject: false,
      content: "",
      urgency: "",
      OptUrgency: [
        "HIGH",
        "MIDDLE",
        "LOW"
      ],
    };
  },
  async mounted() {
    await this.getKategori();
    await this.getSPP();
    if (this.$route.query.approval) {
      await this.getUser();
    }
  },
  computed: {},
  methods: {
    async getUser() {
      await this.$http.get("/list_user", {}).then((result) => {
        this.option = result.data;
        this.handleBy = result.data[0];
      });
    },
    async getSPP() {
      let result = await this.$http.get(
        `/spp/detail/${this.$route.params.id}`,
        {}
      );
      this.spp = result.data;
      this.isReceived = result.data.is_received;
    },
    async getKategori() {
      let resp = await this.$http.get("/kategori");
      let kategori = resp.data.map((a) => a["name"]);
      this.optionKategori = kategori;
    },
    async updateStatus() {
      this.$q.loading.show();
      var data = { spp_id: this.spp.spp_id, is_received: this.isReceived };
      this.spp.is_received = this.isReceived;

      await this.$http
        .put("/update_spp/" + this.spp.spp_id, data, {})
        .then(async (result) => {
          let history = {
            spp_id: this.spp.spp_id,
            status: "process",
            content:
              "update oleh pembuat SPP (" +
              this.$store.state.currentUser.username +
              ")",
          };
          if (this.isReceived == 2) {
            history.status = "done";
          }
          this.$http.post("/new_history", history, {}).then((result) => {});

          var info = "";
          if (this.isReceived == 2) info = "barang sudah diterima penuh";
          if (this.isReceived == 1) info = "barang sudah diterima sebagian";

          var notifikasi = {
            from_id: this.$store.state.currentUser.user_id,
            to_id: this.spp.handle_by,
            notif: "Konfirmasi penerimaan oleh pemohon",
            note: info,
            spp_id: this.spp.spp_id,
            reference_page: "/po/list",
          };
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          notifikasi.to_id = 4; // Notif ke Manager purchasing
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          this.$q.notify({
            icon: "done",
            color: "positive",
            message: "Status penerimaan sudah diubah",
          });

          await this.getSPP();
        });
      this.$q.loading.hide();
    },
    momentFormatDateTime(date) {
      if (date) {
        return moment(date).format("dddd, DD MMM YYYY HH:mm");
      }
      return "-";
    },
    momentFormatDateTimeSimple(date) {
      if (date) {
        return moment(date).format("dddd, DD-MM-YY HH:mm");
      }
      return "-";
    },
    momentFormatDate(date) {
      if (date) {
        return moment(date).format("dddd, DD MMM YYYY");
      }
      return "-";
    },
    async approve() {
      let data = {};
      if (this.$route.query.approval == "manager") {
        data = {
          manager_approve: 1,
          urgency: this.urgency,
        };
      } else if (this.$route.query.approval == "purchasing") {
        data = {
          purch_manager_approve: 1,
          handle_by: this.handleBy.value,
          kategori: this.selKategori,
        };
      }

      await this.$http
        .put("/update_spp/" + this.spp.spp_id, data, {})
        .then((result) => {});

      let history = {};

      if (this.$route.query.approval == "manager") {
        history = {
          spp_id: this.spp.spp_id,
          status: "waiting",
          content: "Disetujui manager, menunggu persetujuan manager purchasing",
        };
      }
      if (this.$route.query.approval == "purchasing") {
        history = {
          spp_id: this.spp.spp_id,
          status: "process",
          content:
            "Sudah disetujui manager purchasing, diproses oleh: " +
            this.handleBy.label,
        };
      }
      await this.$http.post("/new_history", history, {}).then((result) => {});

      let notifikasi = {};
      if (this.$route.query.approval == "manager") {
        notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: 4, //Diisi dengan user_id menager purchasing
          notif: "SPP dari " + this.spp.name + " menunggu persetujuan",
          note: this.spp.note,
          spp_id: this.spp.spp_id,
          reference_page: "/approval/purchasing",
        };
      }
      if (this.$route.query.approval == "purchasing") {
        notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.spp.user_id,
          notif: "SPP Anda sudah disetujui manager purchasing",
          note: "Dalam proses pencarian vendor",
          spp_id: this.spp.spp_id,
          reference_page: "/spp/list",
        };
      }

      this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
    },

    async reject() {
      let data = {};
      if (this.$route.query.approval == "manager") {
        data = {
          manager_approve: -1,
          note: this.content,
        };
      } else if (this.$route.query.approval == "purchasing") {
        data = {
          purch_manager_approve: -1,
          note: this.content,
        };
      }
      await this.$http
        .put("/update_spp/" + this.spp.spp_id, data, {})
        .then((result) => {});

      let history = {};
      if (this.$route.query.approval == "manager") {
        history = {
          spp_id: this.spp.spp_id,
          status: "rejected",
          content: "SPP ditolak manager: " + this.content,
        };
      } else if (this.$route.query.approval == "purchasing") {
        history = {
          spp_id: this.spp.spp_id,
          status: "rejected",
          content: "SPP ditolak manager purchasing: " + this.content,
        };
      }
      await this.$http.post("/new_history", history, {}).then((result) => {});

      let notifikasi = {};
      if (this.$route.query.approval == "manager") {
        notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.spp.user_id,
          notif: "SPP Anda ditolak manager",
          note: this.content,
          spp_id: this.spp.spp_id,
          reference_page: "/spp/list",
        };
      } else if (this.$route.query.approval == "purchasing") {
        notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.spp.user_id,
          notif: "SPP Anda ditolak manager purchasing",
          note: this.spp.note,
          spp_id: this.spp.spp_id,
          reference_page: "/spp/list",
        };
      }

      this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
    },

    reorderList() {
      this.newSpp = [];

      let temp = {};
      temp.item = this.spp.item;
      temp.qty = this.spp.qty;
      temp.unit = this.spp.unit;
      temp.cc = this.spp.cc;
      // temp.deadline =
      //   this.spp.deadline >= moment().format("YYYY-MM-DD")
      //     ? moment(this.spp.deadline).format("YYYY/MM/DD")
      //     : moment().format("YYYY/MM/DD");
      temp.description = this.spp.description;
      temp.user_id = this.$store.state.currentUser.user_id;

      this.newSpp.push(temp);
    },

    showDialogReorder() {
      this.$q
        .dialog({
          component: dialogReorderPO,
          parent: this,
          newSpp: this.newSpp,
          from: "spp_detail",
          style: "border: 2px solid black",
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
  },
};
</script>

<style lang="scss">
.q-timeline__subtitle {
  width: 175px !important;
  padding-right: 0 !important;
}
.q-timeline__title {
  margin-bottom: 0px !important;
}
.q-timeline__content {
  padding-bottom: 16px !important;
}
</style>

<style lang="scss" scoped>
.align-right {
  justify-content: flex-end;
}
</style>
