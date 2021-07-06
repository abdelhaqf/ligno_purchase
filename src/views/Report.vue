<template>
  <div class="q-pa-md">
    <div class="text-h6">{{date | moment('MMMM YYYY')}}</div>
    <div class="row q-gutter-xl">
      <q-card>
        <q-card-section>{{summary.count_spp}}</q-card-section>
        <q-card-section>SPP Diproses</q-card-section>
      </q-card>
      <q-card>
        <q-card-section>{{summary.on_process}}</q-card-section>
        <q-card-section>SPP Dalam Persetujuan</q-card-section>
      </q-card>
      <q-card>
        <q-card-section>{{setCurrency(summary.value_idr, 'IDR')}}</q-card-section>
        <q-card-section>Pembelian (IDR)</q-card-section>
      </q-card>
      <q-card>
        <q-card-section>{{setCurrency(summary.value_usd, 'USD')}}</q-card-section>
        <q-card-section>Pembelian (USD)</q-card-section>
      </q-card>
    </div>
    <div class="q-pa-md">
      <div>
        Filter
        <div class="row q-gutter-sm">
          <div class="col-8">
            <q-select
              outlined
              dense
              label="Summary Type"
              v-model="summaryType"
              :options="['per hari', 'per bulan']"
              @input="changeType"
            />
          </div>
          <div class="col-8">
            <div v-if="!showListMonth" class="row">
              <q-input outlined dense class="col-5" v-model="dateFrom" label="Tanggal Dari">
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                      <q-date minimal v-model="dateFrom" mask="YYYY-MM-DD">
                        <div class="row items-center justify-end">
                          <q-btn v-close-popup label="Close" color="primary" flat />
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
              <q-input outlined dense class="col-5" v-model="dateTo" label="Tanggal Sampai">
                <template v-slot:append>
                  <q-icon name="event" class="cursor-pointer">
                    <q-popup-proxy ref="qDateProxy" transition-show="scale" transition-hide="scale">
                      <q-date minimal v-model="dateTo" mask="YYYY-MM-DD">
                        <div class="row items-center justify-end">
                          <q-btn v-close-popup label="Close" color="primary" flat />
                        </div>
                      </q-date>
                    </q-popup-proxy>
                  </q-icon>
                </template>
              </q-input>
              <q-btn dense outline class="col-2" @click="showDaily" label="OK" />
            </div>
            <div v-else class="row">
              <q-select
                outlined
                dense
                class="col-5"
                label="Bulan Dari"
                v-model="monthFrom"
                :options="listMonth"
                emit-value
                map-options
              />
              <q-select
                outlined
                dense
                class="col-5"
                label="Bulan Sampai"
                v-model="monthTo"
                :options="listMonth"
                emit-value
                map-options
              />
              <q-btn dense outline style="width: 100px;" @click="showMonthly" label="OK" />
            </div>
          </div>
        </div>
      </div>
      <div>{{listSummary}}</div>
    </div>
  </div>
</template>

<script>
import moment from "moment";

export default {
  data() {
    return {
      summary: {},
      listSummary: [],
      date: new Date(),
      summaryType: "",
      listMonth: [],
      showListMonth: false,
      monthFrom: "",
      monthTo: "",
      dateFrom: "",
      dateTo: ""
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    fetchData() {
      this.$http.get("/summary", {}).then(result => {
        this.summary = result.data;
      });

      this.$http.get("/list_month", {}).then(result => {
        this.listMonth = result.data;
      });
    },
    showDaily() {
      var from = this.dateFrom + " 00:00";
      var to = this.dateTo + " 23:59";
      this.$http.get("/daily_summary/" + from + "/" + to, {}).then(result => {
        this.listSummary = result.data;
      });
    },
    showMonthly() {
      var from =
        this.monthFrom.substring(0, 4) +
        "-" +
        this.monthFrom.split("-")[1] +
        "-01 00:00";
      var to =
        this.monthTo.substring(0, 4) +
        "-" +
        this.monthTo.split("-")[1] +
        "-31 23:59";

      this.$http.get("/monthly_summary/" + from + "/" + to, {}).then(result => {
        this.listSummary = result.data;
      });
    },
    changeType() {
      if (this.summaryType == "per hari") this.showListMonth = false;
      else this.showListMonth = true;
    },
    setCurrency(price, cur) {
      if (cur == "IDR") {
        const formatter = new Intl.NumberFormat("ID", {
          style: "currency",
          currency: "IDR",
          currencyDisplay: "symbol",
          minimumFractionDigits: 0
        });
        return formatter.format(price);
      } else if (cur == "USD") {
        const formatter = new Intl.NumberFormat("US", {
          style: "currency",
          currency: "USD",
          currencyDisplay: "symbol",
          minimumFractionDigits: 2
        });
        return formatter.format(price);
      }
    }
  }
};
</script>

<style lang="scss" scoped>
</style>