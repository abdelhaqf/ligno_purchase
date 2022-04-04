<template>
  <div class="q-pa-md">
    <div class="row q-pa-md justify-between">
      <div class="text-h6 text-grey-5">DASHBOARD LIGNO PURCHASE</div>
      <div>
        <q-select
          dense
          outlined
          label="Tampilan Data"
          v-model="selectedShow"
          :options="showOption"
          map-options
          emit-value
          style="width: 200px;"
          class="bg-white"
          @input="fetchData"
        />
      </div>
    </div>

    <div class="row q-pa-md q-gutter-md justify-between">
      <q-card flat bordered class="summary-card">
        <q-card-section :class="classSummary">{{
          summary.count_spp
        }}</q-card-section>
        <q-card-section class="q-pt-none text-caption"
          >SPP Diproses</q-card-section
        >
      </q-card>
      <q-card flat bordered class="summary-card">
        <q-card-section :class="classSummary">{{
          summary.on_process
        }}</q-card-section>
        <q-card-section class="q-pt-none text-caption"
          >SPP Dalam Persetujuan</q-card-section
        >
      </q-card>
      <q-card flat bordered class="summary-card">
        <q-card-section :class="classSummary">{{
          setCurrency(summary.value_idr, "IDR")
        }}</q-card-section>
        <q-card-section class="q-pt-none text-caption"
          >Pembelian (IDR)</q-card-section
        >
      </q-card>
      <q-card flat bordered class="summary-card">
        <q-card-section :class="classSummary">{{
          setCurrency(summary.value_usd, "USD")
        }}</q-card-section>
        <q-card-section class="q-pt-none text-caption"
          >Pembelian (USD)</q-card-section
        >
      </q-card>
    </div>

    <div class="row q-pa-md q-gutter-md">
      <q-card flat bordered class="col">
        <q-card-section>
          <v-chart
            :options="option50"
            theme="default"
            :autoresize="true"
            @click="handleClick50"
          />
        </q-card-section>
      </q-card>
    </div>

    <div class="row q-pa-md q-gutter-md">
      <q-card flat bordered class="col">
        <q-card-section>
          <v-chart
            :options="option80"
            theme="default"
            :autoresize="true"
            @click="handleClick80"
          />
        </q-card-section>
      </q-card>
    </div>

    <div class="row q-pa-md q-gutter-md">
      <q-card flat bordered class="col">
        <q-card-section>
          <v-chart
            ref="chart1"
            :options="optionBydept"
            theme="default"
            :autoresize="true"
            @click="handleClickByDept"
          />
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>

<script>
import ECharts from "vue-echarts";
import * as echart from "echarts";
import "echarts/lib/chart/pie";
import "echarts/lib/component/tooltip";
import "echarts/lib/component/title";
import "echarts/lib/component/legend";
import moment from "moment";

const colorPalette = [
  "#1976D2",
  "#21BA45",
  "#26A69A",
  "#9C27B0",
  "#C10015",
  "#31CCEC",
  "#F2C037",
];

export default {
  components: {
    "v-chart": ECharts,
  },
  data() {
    return {
      myChart: null,
      classSummary: "text-h4 text-center text-blue-5 text-weight-bold",
      showOption: [
        { value: new Date().getFullYear(), label: "Tahun Ini" },
        { value: new Date().getMonth() + 1, label: "Bulan Ini" },
      ],
      selectedShow: new Date().getFullYear(),
      summary: {},
      listSummary: [],
      date: new Date(),

      totalPrice: 0,
      report: [],
      report_80: [],
      report_50: [],
      report_bydept: [],
      total_80: 0,
      total_50: 0,
      total_bydept: 0,
      option50: {
        title: {
          text: "DATA 50 % PENGELUARAN BELANJA",
          left: "center",
        },
        tooltip: {
          trigger: "item",
          // formatter: "{b}<br/>Rp {c} ({d}%)",
          formatter: (param, ticket) => {
            return (
              param.name +
              "<br>" +
              this.setCurrency(param.value, "IDR") +
              " (" +
              param.percent +
              "%)"
            );
          },
        },
        emphasis: {
          label: {
            show: true,
            fontSize: "20",
            fontWeight: "bold",
          },
        },
        legend: {
          orient: "horizontal",
          bottom: 10,
          data: [],
        },
        series: [
          {
            type: "pie",
            radius: ["45%", "70%"],
            center: ["50%", "50%"],
            selectedMode: "single",
            data: [],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
        color: colorPalette,
      },
      option80: {
        title: {
          text: "DATA 80 % PENGELUARAN BELANJA",
          left: "center",
        },
        tooltip: {
          trigger: "item",
          // formatter: "{b}<br/>Rp {c} ({d}%)",
          formatter: (param, ticket) => {
            return (
              param.name +
              "<br>" +
              this.setCurrency(param.value, "IDR") +
              " (" +
              param.percent +
              "%)"
            );
          },
        },
        emphasis: {
          label: {
            show: true,
            fontSize: "20",
            fontWeight: "bold",
          },
        },
        series: [
          {
            type: "pie",
            radius: ["45%", "70%"],
            center: ["50%", "50%"],
            selectedMode: "single",
            data: [],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
        color: colorPalette,
      },
      optionBydept: {
        title: {
          text: "Data Belanja Per Departemen",
          left: "center",
        },

        tooltip: {
          trigger: "item",
          // formatter: "{b}<br/>Rp {c} ({d}%)",
          formatter: (param, ticket) => {
            return (
              param.name +
              "<br>" +
              this.setCurrency(param.value, "IDR") +
              " (" +
              param.percent +
              "%)"
            );
          },
        },
        emphasis: {
          label: {
            show: true,
            fontSize: "20",
            fontWeight: "bold",
          },
        },
        series: [
          {
            type: "pie",
            radius: ["45%", "70%"],
            center: ["50%", "50%"],
            selectedMode: "single",
            data: [],
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
        color: colorPalette,
      },
    };
  },
  mounted() {
    if (
      this.$store.state.currentUser.is_purchasing == 1 ||
      this.$store.state.currentUser.username == "ceo"
    ) {
      this.fetchData();
      // this.myChart = echart.init();

      // this.myChart.on("click", (params) => {
      //   console.log(params);
      // });
      // console.log(this.$refs.chart1);
      // console.log(ECharts);
      // ECharts.refresh();
    } else {
      this.$router.push("/spp/create");
    }
  },
  methods: {
    handleClick50(...args) {
      let temp = args[0];
      let name = temp.name.split("/");
      if (name.length > 1) {
        name = name.join("%2F");
      } else {
        name = name.join("");
      }
      this.$router.push(`/po/list/null/${name}/null`);
    },
    handleClick80(...args) {
      let temp = args[0];
      let name = temp.name.split("/");
      if (name.length > 1) {
        name = name.join("%2F");
      } else {
        name = name.join("");
      }
      this.$router.push(`/po/list/null/${name}/null`);
    },
    handleClickByDept(...args) {
      let temp = args[0];
      let name = temp.name.split("/");
      if (name.length > 1) {
        name = name.join("%2F");
      } else {
        name = name.join("");
      }
      this.$router.push(`/po/list/null/null/${name}`);
    },
    fetchData() {
      this.report_50 = [];
      this.option50.series[0].data = [];
      this.report_80 = [];
      this.option80.series[0].data = [];
      this.report_bydept = [];
      this.optionBydept.series[0].data = [];

      var dt = new Date().getFullYear();
      if (dt == this.selectedShow) {
        this.showByYear(this.selectedShow);
      } else {
        this.showByMonth(this.selectedShow);
      }
    },
    showByYear(val) {
      this.$http.get("/yearly_summary", {}).then((result) => {
        this.summary = result.data;
      });

      this.$http.get("/yearly_total_price", {}).then((result) => {
        this.totalPrice = parseInt(result.data.total);
        var margin_80 = this.totalPrice * 0.8;
        var margin_50 = this.totalPrice * 0.5;

        this.$http.get("/yearly_data_report", {}).then((result) => {
          this.report = result.data;
          this.total_80 = 0;
          this.total_50 = 0;
          for (var i = 0; i < result.data.length; i++) {
            if (this.total_80 < margin_80) {
              this.total_80 += parseInt(result.data[i].price);
              this.report_80.push(result.data[i]);
              this.option80.series[0].data.push({
                value: result.data[i].price,
                name: result.data[i].vendor,
              });
            }

            if (this.total_50 < margin_50) {
              this.total_50 += parseInt(result.data[i].price);
              this.report_50.push(result.data[i]);
              this.option50.series[0].data.push({
                value: result.data[i].price,
                name: result.data[i].vendor,
              });
              this.option50.legend.data.push(result.data[i].vendor);
            }
          }
          this.option80.title.text =
            "80% Pengeluaran (" +
            this.setCurrency(this.total_80, "IDR") +
            " dari " +
            this.setCurrency(this.totalPrice, "IDR") +
            " )";
          this.option50.title.text =
            "50% Pengeluaran (" +
            this.setCurrency(this.total_50, "IDR") +
            " dari " +
            this.setCurrency(this.totalPrice, "IDR") +
            " )";
        });

        this.$http.get("/yearly_dept_report", {}).then((resp) => {
          for (var i = 0; i < resp.data.length; i++) {
            this.report_bydept.push(resp.data[i]);
            this.optionBydept.series[0].data.push({
              value: resp.data[i].price,
              name: resp.data[i].cost_category.toUpperCase(),
            });
          }
        });
      });
    },
    showByMonth(val) {
      this.$http.get("/monthly_summary", {}).then((result) => {
        this.summary = result.data;
      });

      this.$http.get("/monthly_total_price", {}).then((result) => {
        this.totalPrice = parseInt(result.data.total);
        var margin_80 = this.totalPrice * 0.8;
        var margin_50 = this.totalPrice * 0.5;

        this.$http.get("/monthly_data_report", {}).then((result) => {
          this.report = result.data;
          this.total_80 = 0;
          this.total_50 = 0;
          for (var i = 0; i < result.data.length; i++) {
            if (this.total_80 < margin_80) {
              this.total_80 += parseInt(result.data[i].price);
              this.report_80.push(result.data[i]);
              this.option80.series[0].data.push({
                value: result.data[i].price,
                name: result.data[i].vendor,
              });
            }

            if (this.total_50 < margin_50) {
              this.total_50 += parseInt(result.data[i].price);
              this.report_50.push(result.data[i]);
              this.option50.series[0].data.push({
                value: result.data[i].price,
                name: result.data[i].vendor,
              });
              this.option50.legend.data.push(result.data[i].vendor);
            }
          }
          this.option50.title.text =
            "80% Pengeluaran (" +
            this.setCurrency(this.total_80, "IDR") +
            " dari " +
            this.setCurrency(this.totalPrice, "IDR") +
            " )";
          this.option80.title.text =
            "50% Pengeluaran (" +
            this.setCurrency(this.total_50, "IDR") +
            " dari " +
            this.setCurrency(this.totalPrice, "IDR") +
            " )";
        });
      });
    },
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
          minimumFractionDigits: 2,
        });
        return formatter.format(price);
      }
    },
  },
};
</script>

<style lang="scss" scoped>
.summary-card {
  min-width: 150px;
  text-align: center;
  color: grey;
}
</style>
