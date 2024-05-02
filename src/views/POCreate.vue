<template>
    <div class="row relative q-px-lg ">
        <q-card flat bordered class="col-12 bg-white rounded-borders">
            <!-- table control -->
            <q-card-section class="column q-gutter-y-sm">
                <div class="row items-center" >
                    <div class="col-2">Jenis PO</div>
                    <div class="q-gutter-sm">
                        <q-radio v-model="type" val="po" label="PO" />
                        <q-radio v-model="type" val="nonpo" label="Non-PO" />
                    </div>
                </div>
                <div class="row items-center" >
                    <div class="col-2">Nomor PO</div>
                    <q-input
                        outlined
                        v-model="po.po_id"
                        label="Nomor PO"
                        stack-label
                        dense
                        v-if="type == 'po'"
                        class="l-grow border-card"
                    />
                    <q-input
                        outlined
                        v-model="po.po_id"
                        label="Nomor non-PO"
                        readonly
                        stack-label
                        dense
                        v-else
                        class="l-grow border-card"
                    />
                </div>
                <div class="row items-center" >
                    <div class="col-2">Nama Vendor</div>   
                    <div class="l-grow">
                        <q-input
                            outlined
                            v-model="po.vendor"
                            label="Nama Vendor"
                            stack-label
                            dense
                            v-if="showInput"
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
                            Nama Vendor
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
                            v-model="po.vendor"
                            map-options
                            emit-value
                            use-input
                            hide-selected
                            fill-input
                            input-debounce="0"
                            :options="filteredVD"
                            @filter="filterVD"
                            label="Nama Vendor"
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
                <div class="row l-grow items-center q-gutter-x-xl" >
                    <div class="l-grow row">
                        <div class="col-4">Tanggal PO</div>
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
                    <div class="l-grow row q-pl-lg">
                        <div class="col-2">Currency</div>
                        <q-select
                            outlined
                            v-model="curr"
                            dense
                            label="Currency"
                            :options="['IDR', 'USD']"
                            @input="chgCurrency"
                            class="l-grow"
                        />
                    </div>
                </div>
                <div class="row items-center" >
                    <div class="col-2">Daftar PO</div>
                    <div class="l-grow row justify-end items-center q-gutter-x-md">
                        <money v-model="price" v-bind="money" class="q-mx-md l-grow"></money>
                        <q-input
                            outlined
                            v-model="po.po_date"
                            mask="date"
                            label
                            dense
                            style="width:49%"
                        >
                            <template v-slot:append>
                            <q-icon name="event" class="cursor-pointer">
                                <q-popup-proxy
                                ref="qDateProxy"
                                transition-show="scale"
                                transition-hide="scale"
                                >
                                <q-date minimal v-model="po.po_date" :options="limitDate">
                                    <div class="row items-center justify-end">
                                    <q-btn v-close-popup label="Close" color="primary" flat />
                                    </div>
                                </q-date>
                                </q-popup-proxy>
                            </q-icon>
                            </template>
                            <template v-slot:label>
                            Tanggal PO
                            <a class="q-px-sm bg-info text-white rounded-borders"
                                >tahun / bulan / tanggal</a
                            >
                            </template>
                        </q-input>
                        <q-btn
                            unelevated
                            label="Ubah Massal"
                            color="blue"
                            no-caps
                        >
                        </q-btn>
                    </div>
                </div>
                <div class="row">
                    <div class="col-2"></div>
                    <q-markup-table
                        class="stickyTable l-grow"
                        style="height: calc(100vh - 275px);"
                    >
                        <!-- table head -->
                        <thead class="text-white">
                        <tr>
                            <th style="width:20px;">
                            <q-checkbox v-model="check_all" @input="checkAll"></q-checkbox>
                            </th>
                            <th>No</th>
                            <th>Deadline</th>
                            <th>Harga</th>
                            <th>Est. Arrival</th>
                            <th>Action</th>
                        </tr>
                        </thead>
                        <!-- table body  -->
                        <tbody>
                            <tr v-for="(x, i) in sppSelect" :key="i">
                                <td>
                                    <q-checkbox v-model="x.select" />
                                </td>
                                <td class="text-center">{{ i + 1 }}</td>
                                <td style="width: 250px;">
                                {{ x.item }} ({{ x.qty }} {{ x.unit }})
                                </td>
                                <td style="padding: 0px;">
                                    <money v-model="x.price" v-bind="money" class="q-mx-sm"></money>
                                </td>
                                <td>
                                    <q-input
                                        outlined
                                        dense
                                        bg-color="white"
                                        v-model="x.est_arrival"
                                        readonly
                                    >
                                        <template v-slot:append>
                                        <q-icon name="event" class="cursor-pointer">
                                            <q-popup-proxy
                                            ref="qDateProxy"
                                            transition-show="scale"
                                            transition-hide="scale"
                                            >
                                            <q-date minimal v-model="x.est_arrival">
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
                                    </q-input>
                                </td>
                                <td class="text-center">
                                    <q-btn
                                    label="Hapus"
                                    flat
                                    no-caps
                                    color="blue"
                                    dense
                                    @click="deleteSPPItem(i)"
                                    />
                                </td>
                            </tr>
                        </tbody>
                    </q-markup-table>
                </div>

            </q-card-section>
        </q-card>

        <q-dialog v-model="dialogConfirm" persistents>
            <q-card>
                <q-card-section class="bg-grey-2 row items-center justify-between ">
                <div class="text-h6 text-bold">Konfirmasi Pembuatan PO</div>
                <q-btn icon="close" flat v-close-popup></q-btn>
                </q-card-section>
                <q-card-section>
                <div class="q-pb-sm">
                    Apa Anda yakin akan membuat PO untuk {{ sppSelect.length }} SPP
                    terpilih?
                </div>
                <div v-if="curr == 'USD'" class="row justify-between items-center">
                    <div>
                    Masukan Kurs Berlaku
                    </div>
                    <money v-model="kurs" v-bind="money_kurs"></money>
                </div>
                </q-card-section>
                <q-card-actions align="right">
                <q-btn
                    unelevated
                    color="primary"
                    label="SIMPAN"
                    @click="
                    allowed = true;
                    createPO();
                    "
                    v-close-popup
                ></q-btn>
                </q-card-actions>
            </q-card>
        </q-dialog>

        <q-footer
            style="max-width: 1440px;"
            class="q-mx-xl atas-radius bg-white"
            >
            <q-card-section class="row justify-end items-center">
                <div class="row justify-end items-center q-gutter-x-md">
                <q-btn
                    unelevated
                    label="Kembali"
                    color="white" 
                    text-color="black" 
                    outline style="color: black;"
                    @click="$router.go(-1)"
                    no-caps
                >
                </q-btn>
                <q-btn
                    unelevated
                    label="Submit"
                    color="blue"
                    no-caps
                    @click="createPO()"
                >
                </q-btn>
                </div>
            </q-card-section>
            </q-footer>
    </div>
</template>

<script>
import moment from "moment";
import { Money } from "v-money";
export default {
  components: { Money },
  data() {
    return {
      spp: {
        deadline: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
        item: "",
      },
      po: {
        po_date: moment().format("YYYY/MM/DD"),
        po_id: `OP/CM/${moment().format("YY")}/${moment().format("MM")}/`,
      },
      showInput: false,
      namaPO : "",
      namaVendor : "",
      type : "po",
      curr: "IDR",
      money: {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      },
      price: 0,
      check_all: false,
      selected: {},
      sppSelect: [],
      sppSelectID: [],
      optVendor: [],
      filteredVD: [],
      allowed: false,
      dialogConfirm: false,
    };
  },
  async mounted() {
    await this.fetchData();
    await this.getVendor();
  },
  watch: {
    sppSelect: {
      deep: true,
      handler(val) {
        let rows = JSON.parse(JSON.stringify(this.sppSelect));
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
    type: {
        deep: true,
        handler(val) {
            if (this.type == "po")
                this.po.po_id = `OP/CM/${moment().format("YY")}/${moment().format(
                "MM"
                )}/`;
            else this.po.po_id = "NON-PO/" + this.sppSelect[0].spp_id;
        }
    }
  },
  computed: {
    date_model() {
      if (!this.spp.deadline) return "Pilih Tanggal Dibutuhkan";

      return moment(this.spp.deadline).format("DD MMMM YYYY");
    },
  },
  methods: {
    async fetchData() {
        this.sppSelectID = this.$route.query.ids.split(",");
        for (var i = 0; i < this.sppSelectID.length; i++) {
            let result = await this.$http.get(
                `/spp/detail/${this.sppSelectID[i]}`,
                {}
            );
            // console.log(result.data);
            result.data.select = false;
            this.sppSelect.push(result.data);
        }
        console.log(this.sppSelect);
    },
    deleteSPPItem(index) {
      this.sppSelect.splice(index, 1);
    },
    hasHistory () { return window.history.length > 2 },
    chgCurrency() {
      for (var i = 0; i < this.sppSelect.length; i++) {
        this.sppSelect[i].currency = this.curr;
      }

      if (this.curr == "IDR") {
        this.money.precision = 0;
        this.money.prefix = "Rp ";
      } else {
        this.money.precision = 2;
        this.money.prefix = "$ ";
      }
    },
    clearSelect(idx) {
      let temp = JSON.parse(JSON.stringify(this.sppSelect));
      for (let i in temp) {
        if (i == idx) temp[i].select = true;
        else temp[i].select = false;
      }
      this.sppSelect = temp;
    },
    checkAll(val) {
      let temp = JSON.parse(JSON.stringify(this.sppSelect));
      for (let item of temp) {
        item.select = val;
      }
      this.sppSelect = temp;
    },
    filterVD(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filteredVD = this.optVendor.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
    async getVendor() {
      await this.$http.get("/list_vendor", {}).then((result) => {
        this.optVendor = result.data;
        this.filteredVD = result.data;
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
    async createPO() {
      if (!this.allowed) {
        this.dialogConfirm = true;
        return;
      }

      this.po.user_id = this.$store.state.currentUser.user_id;
      try {
        this.$q.loading.show();

        await this.$http.post("/new_po", this.po, {}).then(async (result) => {
          for (var i = 0; i < this.sppSelect.length; i++) {
            this.sppSelect[i].po_id = this.po.po_id;

            let temp = JSON.parse(JSON.stringify(this.sppSelect[i]));
            if (temp.id_rm) {
              delete temp.id_rm;
            }

            await this.$http
              .put("/update_spp/" + this.sppSelect[i].spp_id, temp, {})
              .then((result) => {});

            var history = {
              spp_id: this.sppSelect[i].spp_id,
              status: "process",
              content: "Sudah dibuat PO dengan nomor: " + this.po.po_id,
            };
            this.$http.post("/new_history", history, {}).then((result) => {});

            var notifikasi = {
              from_id: this.$store.state.currentUser.user_id,
              to_id: this.sppSelect[i].user_id,
              notif: "PO telah dibuat",
              note: "Sudah dibuat PO dengan nomor: " + this.po.po_id,
              spp_id: this.sppSelect[i].spp_id,
              reference_page: "/spp/list",
            };
            this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
          }

          this.formPO = false;
          this.po = {
            po_date: moment().format("YYYY/MM/DD"),
          };
          this.fetchData();
        });

        await this.sync_formula();

        await this.$root.$emit("refresh");
        this.sppSelect = [];
        this.allowed = false;
        this.$q.loading.hide();
        this.$q.notify("Berhasil membuat PO!");
      } catch (err) {
        console.log(err);
        this.$q.loading.hide();
      }
    },
    async sync_formula() {
      let temp = this.sppSelect.filter((val) => {
        return val.id_rm;
      });

      if (temp.length > 0) {
        for (let i = 0; i < temp.length; i++) {
          let item = temp[i];
          let payload = {
            id: item.id_rm,
            new_price: item.price,
          };

          if (item.currency == "USD") {
            payload.new_price = parseFloat(this.kurs * item.price).toFixed(2);
          }

          payload.new_price =
            parseFloat(payload.new_price) / parseFloat(item.qty);

          // await this.$http_formulation.put("/purchase/rm/price", payload);
        }
      }
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    formatDate(dt) {
      return moment(dt).format("YYYY-MM-DD");
    },
    dateHistory(dt) {
      return moment(dt).format("DD MMMM YYYY");
    },
    changeType() {
      if (this.type == "PO")
        this.po.po_id = `OP/CM/${moment().format("YY")}/${moment().format(
          "MM"
        )}/`;
      else this.po.po_id = "NON-PO/" + this.sppSelect[0].spp_id;
    },
  },
}
</script>

<style lang="scss" scoped>

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
</style>