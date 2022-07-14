<template>
  <div class="q-pa-lg rounded-borders full-width">
    <q-card flat bordered class="bg-white">
      <!-- form  -->

      <q-card-section class="q-pa-none">
        <!-- form SPP -->
        <q-card-section class="row justify-between">
          <div class=" text-h6">
            SPP Baru
          </div>
          <q-btn
            flat
            color="primary"
            label="lihat cara membuat spp"
            icon="description"
            @click="dialogStep = true"
          ></q-btn>
        </q-card-section>
        <q-card-section class="q-gutter-md">
          <div>
            <q-input
              outlined
              v-model="spp.item"
              label="1. Nama Barang"
              stack-label
              v-if="showInput"
              dense
              class="full-width"
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
              stack-label
              outlined
              dense
              v-model="spp.item"
              map-options
              emit-value
              use-input
              hide-selected
              fill-input
              input-debounce="0"
              :options="filtered"
              @filter="filterOP"
              label="1. Nama Barang"
              class="full-width"
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

          <div class="row justify-between">
            <q-input
              type="number"
              style="width:49%"
              outlined
              v-model="spp.qty"
              label="2. Qty"
              stack-label
              dense
            />
            <q-input
              style="width:49%"
              outlined
              v-model="spp.unit"
              label
              stack-label
              dense
            >
              <template v-slot:label>
                3. Satuan
                <a class="q-px-sm bg-info text-white rounded-borders"
                  >kg / m / dus</a
                >
              </template>
            </q-input>
          </div>
          <div class="row justify-between">
            <q-input
              outlined
              v-model="spp.deadline"
              mask="date"
              label
              style="width:49%"
            >
              <template v-slot:append>
                <q-icon name="event" class="cursor-pointer">
                  <q-popup-proxy
                    ref="qDateProxy"
                    transition-show="scale"
                    transition-hide="scale"
                  >
                    <q-date minimal v-model="spp.deadline">
                      <div class="row items-center justify-end">
                        <q-btn
                          v-close-popup
                          label="Close"
                          color="primary"
                          flat
                        />
                      </div>
                    </q-date>
                  </q-popup-proxy>
                </q-icon>
              </template>
              <template v-slot:label>
                4. Deadline
                <a class="q-px-sm bg-info text-white rounded-borders"
                  >tahun / bulan / tanggal</a
                >
              </template>
            </q-input>
            <q-select
              outlined
              stack-label
              emit-value
              map-options
              label="5. cc"
              :options="listUser"
              v-model="spp.cc"
              style="width:49%"
            ></q-select>
          </div>
          <q-input
            outlined
            v-model="spp.description"
            class="q-mb-lg"
            label="6. Keterangan"
            stack-label
            dense
            type="textarea"
          />
        </q-card-section>
        <q-card-actions class="q-px-md" align="right">
          <q-btn flat color="primary" label="Reset" @click="resetForm"></q-btn>
          <q-btn
            unelevated
            class=" no-border-radius"
            color="primary"
            label="Ajukan"
            @click="createSPP()"
          />
        </q-card-actions>
      </q-card-section>
    </q-card>
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
      if (this.option.length == 0) this.showInput = true;
    });
    this.getUsers();
  },
  methods: {
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
