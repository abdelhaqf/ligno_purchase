<template>
  <div class="q-pa-md my-font">
    <div class="row q-pa-sm justify-between items-center">
      <div class="text-h4 text-weight-bold">
        Selamat Datang <span>{{ curUser ? curUser.username : "" }}</span>
      </div>
      <div>
        <q-select
          dense
          outlined
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
      <q-card flat bordered class="l-grow">
        <q-card-section
          class="row justify-between text-left q-pb-none"
          style="min-width: 200px;"
        >
          <div>SPP Diproses</div>
          <div
            class="items-center text-center q-pa-xs"
            style="border-radius: 20%; background: #E0DCFE;"
          >
            <q-icon size="xs" color="deep-purple-13" name="list_alt" />
          </div>
        </q-card-section>
        <q-card-section class="text-left text-h4 text-weight-bold q-pt-sm">{{
          summary.count_spp
        }}</q-card-section>
      </q-card>

      <q-card flat bordered class="l-grow">
        <q-card-section
          class="row justify-between text-left q-pb-none"
          style="min-width: 250px;"
        >
          <div>SPP Dalam Persetujuan</div>
          <div
            class="items-center text-center q-pa-xs"
            style="border-radius: 20%; background: #E7FAFE;"
          >
            <q-icon size="xs" color="blue-12" name="o_assignment_turned_in" />
          </div>
        </q-card-section>
        <q-card-section class="text-left text-h4 text-weight-bold q-pt-sm">{{
          summary.on_process
        }}</q-card-section>
      </q-card>

      <q-card flat bordered class="l-grow">
        <q-card-section
          class="row justify-between text-left q-pb-none"
          style="min-width: 300px;"
        >
          <div>Pembelian (IDR)</div>
          <div
            class="items-center text-center q-pa-xs"
            style="border-radius: 20%; background: #FBEBEC;"
          >
            <q-icon size="xs" color="red-6" name="o_local_mall" />
          </div>
        </q-card-section>
        <q-card-section class="text-left text-h4 text-weight-bold q-pt-sm">{{
          setCurrency(summary.value_idr, "IDR")
        }}</q-card-section>
      </q-card>

      <q-card flat bordered class="l-grow">
        <q-card-section
          class="row justify-between text-left q-pb-none"
          style="min-width: 250px;"
        >
          <div>Pembelian (USD)</div>
          <div
            class="items-center text-center q-pa-xs"
            style="border-radius: 20%; background: #EAF6EC;"
          >
            <q-icon size="xs" color="green-6" name="attach_money" />
          </div>
        </q-card-section>
        <q-card-section class="text-left text-h4 text-weight-bold q-pt-sm">{{
          setCurrency(summary.value_usd, "USD")
        }}</q-card-section>
      </q-card>
    </div>

    <div class="row q-gutter-md q-pa-md l-grow no-wrap justify-between">
      <q-card flat bordered style="width: 53%;">
        <q-card-section>
          <v-chart
            ref="chart1"
            :options="optionByAct"
            theme="default"
            :autoresize="true"
            style="width: 100%;"
            class="q-mx-auto"
          />
        </q-card-section>
      </q-card>
      <q-card flat bordered style="width: 45%;">
        <q-card-section>
          <v-chart
            ref="chart1"
            :options="optionBydept"
            theme="default"
            :autoresize="true"
            :style="optionBydept.series[0].data.length ? 'width: 100%;' : 'width: 100%; height: 200px;'"
            class="q-mx-auto"
            @click="handleClickByDept"
          />
          <div v-if="!optionBydept.series[0].data.length" class="text-h5 text-bold text-center">Data Masih Kosong</div>
        </q-card-section>
      </q-card>
    </div>

    <div class="row q-gutter-md q-pa-md l-grow no-wrap justify-between">
      <q-card flat bordered style="width: 40%;">
        <q-card-section>
          <v-chart
            :options="option50"
            theme="default"
            :autoresize="true"
            :style="optionBydept.series[0].data.length ? 'width: 100%;' : 'width: 100%; height: 35px;'"
            class="q-mx-auto"
            @click="handleClick50"
          />
          <div v-if="!optionBydept.series[0].data.length" 
          class="text-h5 text-bold row items-center justify-center" 
            style="height: 200px; vertical-align: middle;">
            <div>Data Masih Kosong</div>
          </div>
        </q-card-section>
      </q-card>

      <q-card flat bordered style="width: 58%;">
        <q-card-section>
          <v-chart
            :options="option80"
            theme="default"
            :autoresize="true"
            :style="optionBydept.series[0].data.length ? 'width: 100%;' : 'width: 100%; height: 35px;'"
            class="q-mx-auto"
            @click="handleClick80"
          />
          <div v-if="!option80.series[0].data.length" 
            class="text-h5 text-bold row items-center justify-center" 
            style="height: 200px; vertical-align: middle;">
            <div>Data Masih Kosong</div>
          </div>
        </q-card-section>
      </q-card>
    </div>

    <div class="row q-gutter-md q-pa-md l-grow no-wrap">
      <q-card flat bordered class="l-grow">
        <q-card-section class="q-pa-md row justify-between no-wrap">
          <div class="text-h6 text-weight-bold">
            Persetujuan Man. Purchasing
          </div>
          <q-btn
            label="Lihat Semua"
            color="primary"
            flat
            dense
            no-caps
            icon-right="arrow_forward_ios"
            to="/approval/purchasing"
          />
        </q-card-section>
        <q-card-section class="q-pa-none" v-if="sppList.length">
          <q-markup-table wrap-cells flat class="stickyTable">
            <thead class="text-white">
              <tr>
                <th class="q-px-xs">No</th>
                <th>User</th>
                <th>Tanggal Pengajuan</th>
                <th>Deadline</th>
                <th>Barang</th>
                <th>Jumlah</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(d, i) in sppList" :key="i">
                <td>{{ i + 1 }}</td>
                <td class="text-left">
                  {{ d.name }}
                </td>
                <td class="text-center">
                  {{ d.create_at | moment("DD MMM YYYY") }}
                </td>
                <td class="text-center">
                  {{ d.deadline | moment("DD MMM YYYY") }}
                </td>
                <td class="text-left">{{ d.item }}</td>
                <td class="text-center">{{ d.qty }} {{ d.unit }}</td>
              </tr>
            </tbody>
          </q-markup-table>
        </q-card-section>
        <q-card-section
          class="text-center"
          v-else
        >
          <div>
            <q-img :src="`./empty.png`" style="width: 200px;"></q-img>
          </div>
          <div class="text-h6 text-bold">Data Masih Kosong</div>
        </q-card-section>
      </q-card>

      <q-card flat bordered class="l-grow">
        <q-card-section class="q-pa-md text-h6 text-weight-bold">
          Pengeluaran Per Kategori
        </q-card-section>
        <q-card-section class="q-pa-none" v-if="report_byKat.length">
          <q-markup-table wrap-cells flat class="stickyTable">
            <thead class="text-white">
              <tr>
                <th class="q-px-xs">No</th>
                <th>Kategori</th>
                <th>Total Pengeluaran</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(d, i) in report_byKat" :key="i">
                <td>{{ i + 1 }}</td>
                <td>
                  {{ d.kategori }}
                </td>
                <td>
                  {{
                    d.currency == "IDR"
                      ? setCurrency(parseInt(d.price), "IDR")
                      : setCurrency(parseInt(d.price), "USD")
                  }}
                </td>
              </tr>
            </tbody>
          </q-markup-table>
        </q-card-section>
        <q-card-section
          class="text-center"
          v-else
        >
          <div>
            <q-img :src="`./empty.png`" style="width: 200px;"></q-img>
          </div>
          <div class="text-h6 text-bold">Data Masih Kosong</div>
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
      showOption: [
        { value: new Date().getFullYear(), label: "Tahun Ini" },
        { value: new Date().getMonth() + 1, label: "Bulan Ini" },
      ],
      selectedShow: new Date().getFullYear(),
      summary: {},

      totalPrice: 0,
      report: [],

      option50: {
        title: {
          text: "DATA 50 % PENGELUARAN",
          left: "left",
          textStyle: {
            fontSize: 24, // Adjust the font size as needed
          },
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
          itemGap: 20,
        },
        series: [
          {
            type: "pie",
            radius: ["45%", "70%"],
            center: ["50%", "50%"],
            selectedMode: "single",
            data: [],
            label: {
              show: false,
            },
            labelLine: {
              show: false,
            },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
        color: ["#0288D1", "#8D47FF", "#47C8FF"],
      },
      report_50: [],
      total_50: 0,

      option80: {
        title: {
          text: "DATA 80 % PENGELUARAN",
          left: "left",
          textStyle: {
            fontSize: 24, // Adjust the font size as needed
          },
        },
        color: ["#0288D1"], 
        tooltip: {
          trigger: "item",
          // formatter: "{b}<br/>Rp {c} ({d}%)",
          formatter: (param, ticket) => {
            return (
              param.name +
              "<br>" +
              this.setCurrency(param.value, "IDR") +
              " (" +
              (param.value * 100 / this.total_80).toFixed(2) +
              "%)"
            );
          },
        },
        grid: {
          left: "5%",
          right: "5%",
          bottom: "3%",
          containLabel: true,
        },
        xAxis: {
          type: 'value',
          max: 'dataMax',
          // axisLine: { show: false },
          // axisLabel: { show: false },
          // axisTick: { show: false },
          // splitLine: { show: false },
        },
        yAxis: {
          type: "category",
          data: [],
          inverse: true,
          // axisLine: { show: false },
          // axisTick: { show: false },
          // splitLine: { show: false },
        },
        series: [
          {
            name: "Data",
            type: "bar",
            data: [],
            // label: {
            //   show: true,
            //   position: "insideRight",
            //   formatter: "{c}", // Display the x-axis value as label
            // },
            emphasis: {
              itemStyle: {
                shadowBlur: 10,
                shadowOffsetX: 0,
                shadowColor: "rgba(0, 0, 0, 0.5)",
              },
            },
          },
        ],
      },
      report_80: [],
      total_80: 0,

      optionBydept: {
        title: {
          text: "Data Belanja Per Departemen",
          left: "left",
          textStyle: {
            fontSize: 24, // Adjust the font size as needed
          },
        },
        legend: {
          orient: "vertical",
          right: 15,
          top: "center",
          data: [],
        },
        tooltip: {
          trigger: "item",
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
            center: ['30%', '50%'],
            selectedMode: "single",
            data: [],
            label: {
              show: false,
            },
            labelLine: {
              show: false,
            },
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
      report_bydept: [],
      total_bydept: 0,

      optionByAct: {
        title: {
          text: "Aktivitas Pengeluaran",
          left: "left",
          textStyle: {
            fontSize: 24,
          },
        },
        tooltip: {
          trigger: "item",
          formatter: (param, ticket) => {
            return (
              param.name +
              "<br>" +
              this.setCurrency(param.value, "IDR")
            );
          },
        },
        grid: {
          left: "5%",
          right: "5%",
          bottom: "3%",
          containLabel: true,
        },
        xAxis: {
          type: 'category',
          boundaryGap: false,
          data: []
        },
        yAxis: {
          type: 'value',
          axisLabel: {
            formatter: val => {
              if(String(val).length < 7) {
                return (val / 1000) + " Ribu"
              }
              else if (String(val).length >= 7 && String(val).length <= 9){
                return (val / 1000000) + " Juta"
              }
              else if (String(val).length >= 10 && String(val).length <= 12){
                return (val / 1000000000) + " Miliar"
              } else {
                return (val / 1000000000000) + " Triliun"
              }
            }
          }
        },
        series: [
          {
            data: [],
            type: 'line',
            smooth: true,
            // symbol: 'none',
            lineStyle: {
              color: '#0288D1',
              width: 2
            },
          }
        ]
      },
      report_byAct: [],

      report_byKat: [],
      total_byKat: 0,
      sppList: [],
    };
  },
  computed: {
    curUser() {
      if (this.$store.state.currentUser) {
        return this.$store.state.currentUser;
      }
      return false;
    },
  },
  mounted() {
    this.fetchData();
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
      this.$router.push(`/po/list/null/${name}/null/null`);
    },
    handleClick80(...args) {
      let temp = args[0];
      let name = temp.name.split("/");
      if (name.length > 1) {
        name = name.join("%2F");
      } else {
        name = name.join("");
      }
      this.$router.push(`/po/list/null/${name}/null/null`);
    },
    handleClickByDept(...args) {
      let temp = args[0];
      let name = temp.name.split("/");
      if (name.length > 1) {
        name = name.join("%2F");
      } else {
        name = name.join("");
      }
      this.$router.push(`/po/list/null/null/${name}/null`);
    },
    fetchData() {
      this.report_50 = [];
      this.option50.series[0].data = [];
      this.report_80 = [];
      this.option80.series[0].data = [];
      this.option80.yAxis.data = [];
      this.report_bydept = [];
      this.optionBydept.series[0].data = [];
      this.optionBydept.legend.data = [];
      this.report_byKat = [];
      

      var dt = new Date().getFullYear();
      if (dt == this.selectedShow) {
        this.optionByAct.series[0].data = [];
        this.optionByAct.xAxis.data = [];
        this.report_byAct = [];

        this.showByYear(this.selectedShow);
      } else {
        this.showByMonth(this.selectedShow);
      }

      this.getManPruchasing();
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
              this.option80.yAxis.data.push(
                result.data[i].vendor.length > 20
                  ? result.data[i].vendor.substring(0, 20) + "..."
                  : result.data[i].vendor
              );
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
        });

        this.$http.get("/yearly_dept_report", {}).then((resp) => {
          for (var i = 0; i < resp.data.length; i++) {
            this.report_bydept.push(resp.data[i]);
            this.optionBydept.series[0].data.push({
              value: resp.data[i].price,
              name: resp.data[i].cost_category.toUpperCase(),
            });
            this.optionBydept.legend.data.push(
              resp.data[i].cost_category.toUpperCase()
            );
          }
        });

        this.$http.get("/yearly_kat_report", {}).then((resp) => {
          for (var i = 0; i < resp.data.length; i++) {
            this.report_byKat.push(resp.data[i]);
          }
        });

        const months = [
          'January', 'February', 'March', 'April',
          'May', 'June', 'July', 'August',
          'September', 'October', 'November', 'December'
        ];
        this.$http.get("/yearly_data_report_by_month", {}).then((resp) => {
          let max = Math.max(...resp.data.map(o => o.month))
          for (var i = 0; i < months.length; i++) {
            let temp = resp.data.find(el => parseInt(el.month) - 1 == i)
            if(temp){
              this.report_byAct.push(temp);
              this.optionByAct.series[0].data.push(parseInt(temp.price));
              this.optionByAct.xAxis.data.push(months[i]);
            } else {
              if(i < max){
                this.optionByAct.series[0].data.push(0);
              }
              this.optionByAct.xAxis.data.push(months[i]);
            }
          };
        });
      });
    },
    showByMonth(val) {
      this.$http.get("/monthly_summary", {}).then((result) => {
        this.summary = result.data;
      });

      this.$http.get("/monthly_total_price", {}).then((result) => {
        console.log(result.data);
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
              this.option80.yAxis.data.push(result.data[i].vendor);
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
        });

        this.$http.get("/monthly_dept_report", {}).then((resp) => {
          for (var i = 0; i < resp.data.length; i++) {
            this.report_bydept.push(resp.data[i]);
            this.optionBydept.series[0].data.push({
              value: resp.data[i].price,
              name: resp.data[i].cost_category.toUpperCase(),
            });
            this.optionBydept.legend.data.push(
              resp.data[i].cost_category.toUpperCase()
            );
          }
        });

        this.$http.get("/monthly_kat_report", {}).then((resp) => {
          for (var i = 0; i < resp.data.length; i++) {
            this.report_byKat.push(resp.data[i]);
          }
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
    getManPruchasing() {
      this.sppList = [];

      this.$http.get(`/spp-approval`, {}).then((result) => {
        for (var i = 0; i < result.data.length; i++) {
          if (
            result.data[i].manager_approve == 1 &&
            result.data[i].purch_manager_approve == 0
          ) {
            result.data[i].select = false;
            this.sppList.push(result.data[i]);
          }
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.summary-card {
  min-width: 150px;
  text-align: center;
  color: black;
}
</style>
