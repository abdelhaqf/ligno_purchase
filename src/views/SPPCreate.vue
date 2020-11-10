<template>
  <div class="row justify-center q-py-lg rounded-borders">
    <q-card class=" bg-white">
      <!-- form  -->
      <q-card-section horizontal class="q-pa-none">
        <!-- petunjuk pengisian  -->
        <q-card-section class="bg-blue-grey-1 q-pa-none">
          <q-card-section class="text-h6 bg-blue-grey-5 text-white">
            Petunjuk Pengisian
          </q-card-section>
          <q-list separator>
            <q-item>
              <q-item-section>
                <q-item-label>1. Cari nama barang yang dibutuhkan</q-item-label>
                <q-item-label caption>
                  Bila tidak ditemukan, klik tombol plus disebelahnya untuk input barang baru
                </q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>2. Input qty/jumlah barang yang diminta</q-item-label>
                <q-item-label caption>isi dengan bilangan bulat tanpa titik atau koma, misal: 1000000</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>3. Input satuan/unit dari qty barang yang dicari</q-item-label>
                <q-item-label caption>isi secara manual misal: kg, liter, ml, box, dus, buah, rim, dll</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>4. Input deadline dari permintaan ini</q-item-label>
                <q-item-label caption>isi sesuai format tahun/bulan/tanggal misal: 2020/03/09</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>5. Input keterangan tentang permintaan ini</q-item-label>
                <q-item-label caption
                  >isi dengan data tambahan seperti nama vendor, spesifikasi barang, dll</q-item-label
                >
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>6. Klik tombol ajukan</q-item-label>
                <q-item-label caption>
                  bila permintaan berhasil dikirim anda akan melihat pesan "SPP Berhasil dibuat"
                </q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label>7. Selesai</q-item-label>
                <q-item-label caption>Cek perkembangan SPP di menu "SPP Anda"</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <q-card-section class="q-pa-none">
          <!-- form SPP -->
          <q-card-section class="bg-primary text-white text-h6">SPP Baru</q-card-section>
          <q-card-section class="q-gutter-md ">
            <div class="row">
              <q-input
                outlined
                v-model="spp.item"
                label="1. Nama Barang"
                class="col-10"
                stack-label
                v-if="showInput"
                dense
              >
                <template v-slot:label>
                  1. Nama Barang <a class="q-px-sm bg-info text-white rounded-borders">input baru</a>
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
                class="col-10"
              >
                <template v-slot:no-option>
                  <q-item>
                    <q-item-section class="text-grey">
                      No results
                    </q-item-section>
                  </q-item>
                </template>
              </q-select>
              <q-toggle v-model="showInput" color="green" icon="add" keep-color />
            </div>

            <div>
              <div class="row q-col-gutter-sm">
                <q-input type="number" class="col-7" outlined v-model="spp.qty" label="2. Qty" stack-label dense />
                <q-input class="col-5" outlined v-model="spp.unit" label="" stack-label dense>
                  <template v-slot:label>
                    3. Satuan <a class="q-px-sm bg-info text-white rounded-borders">kg / m / dus</a>
                  </template>
                </q-input>
              </div>
            </div>
            <q-input outlined v-model="spp.deadline" mask="date" :rules="['date']" label="">
              <template v-slot:append>
                <q-icon name="event" class="cursor-pointer">
                  <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                    <q-date minimal v-model="spp.deadline">
                      <div class="row items-center justify-end">
                        <q-btn v-close-popup label="Close" color="primary" flat />
                      </div>
                    </q-date>
                  </q-popup-proxy>
                </q-icon>
              </template>
              <template v-slot:label>
                4. Deadline <a class="q-px-sm bg-info text-white rounded-borders">tahun / bulan / tanggal</a>
              </template>
            </q-input>

            <q-input
              outlined
              v-model="spp.description"
              class="q-mb-lg"
              label="5. Keterangan"
              stack-label
              dense
              type="textarea"
            />
          </q-card-section>
          <q-card-actions>
            <q-btn flat class="full-width" color="primary" label="Ajukan" @click="createSPP()" />
          </q-card-actions>
        </q-card-section>
      </q-card-section>
    </q-card>
  </div>
</template>

<script>
// @ is an alias to /src
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
    };
  },
  mounted() {
    this.$http.get("/list_item", {}).then((result) => {
      this.option = result.data;
      if(this.option.length == 0) 
        this.showInput = true
    });
  },
  methods: {
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
      });
    },
    filterOP(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered = this.option.filter((v) => v.label.toLowerCase().indexOf(needle) > -1);
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
