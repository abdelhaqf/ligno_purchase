<template>
  <q-dialog ref="dialog" @hide="onDialogHide">
    <q-card style="width:425px" v-if="selSPP">
      <q-card-section class="row justify-between items-center">
        <div class="text-bold text-h6">Sinkronisasi Harga RM</div>
        <div>Sinkronkan harga barang dengan Raw Material Terdaftar</div>
      </q-card-section>
      <q-card-section class=" bg-grey-2 column q-gutter-y-sm">
        <div class="row justify-between">
          <div>Nomor SPP</div>
          <div class="text-bold">{{ selSPP.spp_id }}</div>
        </div>
        <div class="row justify-between">
          <div>Nama Barang</div>
          <div class="text-bold">{{ selSPP.item }}</div>
        </div>
        <div class="row justify-between">
          <div>Harga PO</div>
          <div class="text-bold">
            {{
              setCurrency(
                parseFloat(selSPP.price / selSPP.qty),
                selSPP.currency
              )
            }}
          </div>
        </div>
      </q-card-section>
      <q-card-section class="column q-gutter-y-sm">
        <div class="text-body1">Raw Material</div>
        <div class="row items-center">
          <div style="width:150px;">Nama RM</div>
          <q-select
            outlined
            dense
            bg-color="white"
            :options="filtered_rm"
            use-input
            map-options
            emit-value
            hide-selected
            fill-input
            input-debounce="0"
            v-model="selSPP.id_rm"
            @filter="filterRM"
            style="flex-grow: 99;"
          >
            <template v-slot:no-option>
              <q-item>
                <q-item-section class="text-grey">No results</q-item-section>
              </q-item>
            </template>
            <template v-slot:append>
              <q-btn
                v-if="selSPP.id_rm"
                icon="close"
                dense
                @click="selSPP.id_rm = null"
                flat
                size="sm"
              ></q-btn>
            </template>
          </q-select>
        </div>
        <div class="row items-center">
          <div style="width:150px;">Harga Sinkron</div>

          <money
            style="flex-grow: 99;"
            v-model="selSPP.syncPrice"
            v-bind="money"
          ></money>
        </div>
      </q-card-section>
      <q-card-section class="q-py-none">
        <q-checkbox dense v-model="selSPP.confirmed">
          <template v-slot:default>
            <div class="l-text-description">
              Saya yakin akan melakukan penyesuaian harga RM terpilih dengan
              harga yang telah ditentukan
            </div>
          </template>
        </q-checkbox>
      </q-card-section>

      <q-card-section
        class="row items-center q-gutter-x-sm q-pa-sm justify-between"
      >
        <q-btn
          unelevated
          outline
          class="l-grow"
          label="Cancel"
          no-caps
          @click="onCancelClick"
        ></q-btn>
        <q-btn
          unelevated
          class="l-grow"
          color="primary"
          label="SINKRON HARGA"
          :disable="isAllowed"
          @click="syncFormulation"
        ></q-btn>
      </q-card-section>
    </q-card>
  </q-dialog>
</template>

<script>
import { Money } from "v-money";
export default {
  props: ["spp"],
  components: { Money },
  data() {
    return {
      selSPP: null,
      rm: [],
      filtered_rm: [],
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
    };
  },
  async mounted() {
    this.selSPP = this.$props.spp;
    await this.getRM();
  },
  computed: {
    isAllowed() {
      let temp = JSON.parse(JSON.stringify(this.selSPP));
      console.log(temp);

      if (temp.id_rm && temp.syncPrice > 0 && temp.confirmed) {
        return false;
      }
      return true;
    },
  },
  methods: {
    setCurrency(price, cur) {
      if (cur == "IDR") {
        const formatter = new Intl.NumberFormat("ID", {
          style: "currency",
          currency: "IDR",
          currencyDisplay: "symbol",
          minimumFractionDigits: 0,
        });
        return formatter.format(price);
      } else if (cur == "USD") {
        const formatter = new Intl.NumberFormat("US", {
          style: "currency",
          currency: "USD",
          currencyDisplay: "symbol",
          minimumFractionDigits: 3,
        });
        return formatter.format(price);
      }
    },
    async getRM() {
      await this.$http_formulation.get(`/purchase/rm/all`).then((resp) => {
        this.rm = resp.data;
        this.filtered_rm = resp.data;
      });
    },
    filterRM(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered_rm = this.rm.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    async syncFormulation() {
      try {
        this.$q.loading.show();
        let payload = {
          id: this.selSPP.id_rm,
          new_price: this.selSPP.syncPrice,
          id_spp: this.selSPP.spp_id,
        };

        await this.$http.put("/sync_formula/po", payload);

        await this.$http_formulation.put("/purchase/rm/price", payload);
        this.$q.notify({
          message: "Harga Berhasil Di Sinkronisasi!",
          color: "positive",
        });

        this.$q.loading.hide();
        this.onOKClick();
      } catch (err) {
        console.log(err);
        this.$q.notify({
          message: "Harga Gagal Di Sinkronisasi!",
          color: "negative",
        });
        this.$q.loading.hide();
      }
    },
    show() {
      this.$refs.dialog.show();
    },
    hide() {
      this.$refs.dialog.hide();
    },

    onDialogHide() {
      this.$emit("hide");
    },

    onOKClick() {
      this.$emit("ok", "ayam");
      this.hide();
    },

    onCancelClick() {
      this.hide();
    },
  },
};
</script>
<style lang="scss" scoped>
.v-money {
  line-height: 1;
  font-size: 14px;
  border: 1px solid silver;
  border-radius: 5px;
  padding: 10px 10px;
  box-sizing: border-box;
  width: 100px;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
</style>
