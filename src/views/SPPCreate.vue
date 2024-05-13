<template>
  <div class="q-px-lg rounded-borders full-width">
    <q-card flat bordered class="bg-white">
      <!-- form  -->

      <q-scroll-area style="height:calc(100vh - 225px)">
        <q-card-section class="q-gutter-y-md">
          <div class="row items-center">
            <div class="text-black" style="width: 125px;">
              Nama Barang
            </div>
            <div class="l-grow">
              <q-input
                outlined
                v-model="spp.item"
                v-if="showInput"
                dense
                class="l-grow"
                placeholder="Masukan Nama Barang"
              >
                <template v-slot:append>
                  <q-toggle
                    v-model="showInput"
                    color="green"
                    icon="add"
                    keep-color
                  />
                </template>
                <template v-slot:label>
                  1. Nama Barang
                  <a class="q-px-sm bg-info text-white rounded-borders"
                    >input baru</a
                  >
                </template>
              </q-input>
              <q-select
                v-else
                outlined
                dense
                v-model="spp.item"
                map-options
                emit-value
                use-input
                hide-selected
                fill-input
                @input-value="setModel"
                input-debounce="0"
                :options="filtered"
                @filter="filterOP"
                class="l-grow"
                placeholder="Pilih Nama Barang"
              >
                <template v-slot:append>
                  <q-toggle
                    v-model="showInput"
                    color="green"
                    icon="add"
                    keep-color
                  />
                </template>
              </q-select>
            </div>
          </div>

          <div class="row items-center q-gutter-x-xl">
            <div class="row items-center l-grow">
              <div style="width: 125px;">Qty</div>
              <q-input
                type="number"
                style="width:49%"
                outlined
                v-model="spp.qty"
                dense
                class="l-grow"
                placeholder="0"
              />
            </div>
            <div class="row items-center l-grow">
              <div style="width: 75px;">Satuan</div>
              <q-input
                style="width:49%"
                outlined
                v-model="spp.unit"
                dense
                class="l-grow"
                placeholder="e.g. kg / m / dus"
              >
              </q-input>
            </div>
          </div>
          <div class="row items-center">
            <div style="width: 125px;">Deadline</div>

            <q-field dense outlined class="l-grow">
              <template v-slot:prepend>
                <q-icon name="date_range" />
              </template>

              <template v-slot:control>
                <div class="self-center full-width no-outline" tabindex="0">
                  {{ date_model }}
                </div>
              </template>
              <q-popup-proxy
                style="width:fit-content"
                transition-show="scale"
                transition-hide="scale"
              >
                <q-date v-model="spp.deadline" :options="limitDate">
                  <div class="row items-center justify-end">
                    <q-btn v-close-popup label="Close" color="primary" flat />
                  </div>
                </q-date>
              </q-popup-proxy>
            </q-field>
          </div>
          <div class="row items-center">
            <div style="width: 125px;">CC</div>
            <q-select
              outlined
              dense
              emit-value
              map-options
              :options="listUser"
              v-model="spp.cc"
              class="l-grow"
              placeholder="Pilih Nama"
            ></q-select>
          </div>
          <div class="row items-start">
            <div class="q-mt-xs" style="width: 125px;">Keterangan</div>
            <q-input
              outlined
              v-model="spp.description"
              dense
              type="textarea"
              class="l-grow"
            />
          </div>
        </q-card-section>
      </q-scroll-area>
    </q-card>

    <q-footer style="max-width: 1440px;" class="q-mx-auto atas-radius bg-white">
      <q-card-section class="row justify-between">
        <q-btn
          outline
          label="Kembali"
          no-caps
          color="grey-8"
          to="/spp/list"
        ></q-btn>
        <div>
          <q-btn flat color="primary" label="Reset" @click="resetForm"></q-btn>
          <q-btn
            unelevated
            class="text-bold border-radius"
            color="primary"
            @click="createSPP()"
          >
            <div>Ajukan</div>
          </q-btn>
        </div>
      </q-card-section>
    </q-footer>

    <q-dialog v-model="dialogStep">
      <q-card>
        <q-card-section class="bg-blue-grey-1 q-pa-none">
          <q-card-section class="bg-blue-grey-5 row justify-between">
            <div class="text-h6  text-white">
              Petunjuk Pengisian
            </div>
            <q-btn icon="close" flat color="white" v-close-popup></q-btn>
          </q-card-section>
          <q-list separator>
            <q-item>
              <q-item-section>
                <q-item-label>1. Cari nama barang yang dibutuhkan</q-item-label>
                <q-item-label caption
                  >Bila tidak ditemukan, klik tombol plus disebelahnya untuk
                  input barang baru</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label
                  >2. Input qty/jumlah barang yang diminta</q-item-label
                >
                <q-item-label caption
                  >isi dengan bilangan bulat tanpa titik atau koma, misal:
                  1000000</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label
                  >3. Input satuan/unit dari qty barang yang
                  dicari</q-item-label
                >
                <q-item-label caption
                  >isi secara manual misal: kg, liter, ml, box, dus, buah, rim,
                  dll</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label
                  >4. Input deadline dari permintaan ini</q-item-label
                >
                <q-item-label caption
                  >isi sesuai format tahun/bulan/tanggal misal:
                  2020/03/09</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>5. Input CC(Copy Carbon)</q-item-label>
                <q-item-label caption
                  >Contoh, purchasing membuat SPP karena bag.produksi
                  berhalangan</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label
                  >6. Input keterangan tentang permintaan ini</q-item-label
                >
                <q-item-label caption
                  >isi dengan data tambahan seperti nama vendor, spesifikasi
                  barang, dll</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>7. Klik tombol ajukan</q-item-label>
                <q-item-label caption
                  >bila permintaan berhasil dikirim anda akan melihat pesan "SPP
                  Berhasil dibuat"</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>8. Selesai</q-item-label>
                <q-item-label caption
                  >Cek perkembangan SPP di menu "SPP Anda"</q-item-label
                >
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
      </q-card></q-dialog
    >
  </div>
</template>

<script>
import moment from "moment";

export default {
  data() {
    return {
      spp: {
        deadline: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
        item: "",
      },
      showInput: false,
      option: [],
      filtered: [],
      listUser: [],

      //new data
      dialogStep: false,
    };
  },
  mounted() {
    this.$http.get("/list_item", {}).then((result) => {
      this.option = result.data;
      this.option = this.option.filter(obj => obj.value !== "");
      if (this.option.length == 0) this.showInput = true;
    });
    this.getUsers();
  },
  computed: {
    date_model() {
      if (!this.spp.deadline) return "Pilih Tanggal Dibutuhkan";

      return moment(this.spp.deadline).format("DD MMMM YYYY");
    },
  },
  methods: {
    setModel (val) {
      this.spp.item = val
    },
    resetForm() {
      this.spp = {
        deadline: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
        item: "",
      };
    },
    async getUsers() {
      let result = await this.$http.get("/list/user", {});
      this.listUser = result.data;
      this.listUser.unshift({
        value: 0,
        label: "-",
        id_user: 0,
      });
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    createSPP() {
      this.spp.user_id = this.$store.state.currentUser.user_id;
      this.$http.post("/new_spp", this.spp, {}).then((result) => {
        this.spp = {
          deadline: moment()
            .add(1, "days")
            .format("YYYY/MM/DD"),
          item: "",
        };

        var history = {
          spp_id: result.data,
          status: "created",
          content: "Dibuat oleh " + this.$store.state.currentUser.username,
        };
        this.$http.post("/new_history", history, {}).then((result) => {});

        this.$q.notify("SPP Berhasil Dibuat!");

        var notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.$store.state.currentUser.manager_id,
          notif: this.$store.state.currentUser.username + " membuat SPP baru",
          note: "",
          spp_id: result.data,
          reference_page: "/spp/approval",
        };
        this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
      });
    },
    filterOP(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered = this.option.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.align-right {
  justify-content: flex-end;
}
</style>
