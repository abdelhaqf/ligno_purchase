<template>
    <div class="row relative q-px-lg ">
        <q-card flat bordered class="col-12 bg-white rounded-borders">
            <!-- table control -->
            <q-card-section class="column q-gutter-y-sm">
                <div class="row items-center" >
                    <div class="col-2">Jenis PO</div>
                    <div class="q-gutter-sm">
                        <q-radio v-model="jenisPO" val="po" label="PO" />
                        <q-radio v-model="jenisPO" val="nonpo" label="Non-PO" />
                    </div>
                </div>
                <div class="row items-center" >
                    <div class="col-2">Nama PO</div>
                    <q-input
                        outlined
                        dense
                        placeholder="Input Nama"
                        class="l-grow border-card"
                        v-model="namaPO"
                    ></q-input>
                </div>
                <div class="row items-center" >
                    <div class="col-2">Nama Vendor</div>   
                    <div class="l-grow">
                        <q-input
                            outlined
                            v-model="spp.item"
                            v-if="showInput"
                            dense
                            class="l-grow"
                            placeholder="Pilih Nama Vendor"
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
                        </tbody>
                    </q-markup-table>
                </div>

            </q-card-section>
        </q-card>
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
                    @click="toPreview"
                    no-caps
                >
                </q-btn>
                <q-btn
                    unelevated
                    label="Submit"
                    color="blue"
                    @click="confirmApprove = true"
                    no-caps
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
        po_id: "",
      },
      showInput: false,
      namaPO : "",
      namaVendor : "",
      jenisPO : "po",
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
    };
  },
  mounted() {
    
  },
  computed: {
    date_model() {
      if (!this.spp.deadline) return "Pilih Tanggal Dibutuhkan";

      return moment(this.spp.deadline).format("DD MMMM YYYY");
    },
  },
  methods: {
    filterOP(val, update, abort) {
      update(() => {
        const needle = val.toLowerCase();
        this.filtered = this.option.filter(
          (v) => v.label.toLowerCase().indexOf(needle) > -1
        );
      });
    },
  },
}
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
</style>