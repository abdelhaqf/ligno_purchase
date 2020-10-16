<template>
  <div class="row justify-center q-py-lg rounded-borders">
    <q-card class=" bg-white">
      <q-card-section class="bg-green-4 text-white text-h6">SPP Baru</q-card-section>
      <!-- form  -->
      <q-card-section class="q-gutter-md ">
        <q-input outlined v-model="spp.item" label="Nama Barang" stack-label v-if="showInput" dense>
          <template v-slot:append>
            <q-btn round dense flat icon="arrow_drop_down" no-caps @click="showInput = !showInput" />
          </template>
        </q-input>
        <q-select
          class="col-4"
          v-else
          outlined
          dense
          stack-label
          v-model="spp.item"
          :options="option"
          map-options
          emit-value
          label="Nama Barang"
        >
          <template v-slot:option="scope">
            <q-item v-bind="scope.itemProps" v-on="scope.itemEvents">
              <q-item-section class="text-grey text-italic" v-if="scope.opt.value == ''" @click="test()">
                {{ scope.opt.label }}
              </q-item-section>
              <q-item-section v-else>
                {{ scope.opt.label }}
              </q-item-section>
            </q-item>
          </template>
        </q-select>

        <div>
          <div class="row q-col-gutter-sm">
            <q-input type="number" class="col-7" outlined v-model="spp.qty" label="Qty" stack-label dense />
            <q-input class="col-5" outlined v-model="spp.unit" label="Satuan (kg/ml/buah)" stack-label dense />
          </div>
        </div>
        <!-- old qdate  -->
        <!-- <q-input outlined v-model="spp.deadline" label="Deadline" stack-label dense readonly />
        <q-date v-model="spp.deadline" minimal :options="limitDate" /> -->
        <!-- new qdate  -->
        <q-input outlined v-model="spp.deadline" mask="date" :rules="['date']" label="Deadline (tahun/bulan/tanggal)">
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
        </q-input>

        <q-input
          outlined
          v-model="spp.description"
          class="q-mb-lg"
          label="Keterangan"
          stack-label
          dense
          type="textarea"
        />
      </q-card-section>
      <q-btn class="full-width no-border-radius" color="primary" label="Ajukan" @click="createSPP()" />
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
      },
      showInput: false,
      option: [],
    };
  },
  mounted() {
    this.$http.get("/list_item", {}).then((result) => {
      this.option = result.data;
      this.option.unshift({
        value: "",
        label: " input baru",
      });
    });
  },
  methods: {
    test() {
      this.showInput = true;
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
        };
        // this.spp = result.data

        var history = {
          spp_id: result.data,
          status: "created",
          content: "Dibuat oleh " + this.$store.state.currentUser.username,
        };
        this.$http.post("/new_history", history, {}).then((result) => {});

        this.$q.notify("SPP Berhasil Dibuat!");
        // this.$router.push('/spp/list')
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
