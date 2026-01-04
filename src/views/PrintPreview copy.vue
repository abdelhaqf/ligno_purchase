<template>
  <div class="column items-center">
    <div class="q-py-md printPaper row justify-between noprint">
      <q-btn flat label="Close" @click="closeTab"></q-btn>
      <q-btn
        unelevated
        color="primary"
        label="print"
        @click="printPage()"
      ></q-btn>
    </div>
    <div class="printPaper" v-for="(val, i) in data" :key="i" ref="myRef">
      <q-card
        flat
        class="my-font column"
        style="height: calc(264mm / 3); width: 100%"
      >
        <q-card-section class="row justify-between items-center q-py-sm">
          <div class="row justify-center">
            <img style="width: 2.5cm" :src="`${public_url}/Logo/ligno.png`" />
          </div>
          <div class="column text-right">
            <div class="text-subtitle1 text-bold">
              LAPORAN SPP DISETUJUI #{{ val.spp_id }}
            </div>
            <div class="row q-gutter-x-xs justify-end">
              <div>{{ val.name }} - {{ val.dept }}</div>
              <div>•</div>
              <div>{{ momentMask(val.create_at) }}</div>
            </div>
          </div>
        </q-card-section>
        <div style="border-top: 1px solid black; width: 100%" />

        <q-markup-table flat separator="none" class="q-mt-md" dense wrap-cells>
          <thead>
            <tr>
              <th class="text-center trow" style="font-weight: 600;">
                Nama Barang
              </th>
              <th
                class="text-center trow"
                style="font-weight: 600;width:100px;"
              >
                Urgency
              </th>
              <th
                class="text-center trow"
                style="font-weight: 600;width:100px;"
              >
                Qty
              </th>
              <th class="text-center trow" style="font-weight: 600;">
                Diproses Oleh
              </th>
              <th class="text-center trow" style="font-weight: 600;">
                Kategori Barang/Jasa
              </th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>{{ val.item }}</td>
              <!-- <td>{{ momentMask(val.deadline) }}</td> -->
              <td class="text-center" style="width: 100px;">
                {{ val.urgency }}
              </td>
              <td style="width: 100px;">{{ `${val.qty} ${val.unit}` }}</td>
              <td class="text-capitalize" style="width: 125px;">
                {{ val.handler_name }}
              </td>
              <td class="text-center" style="width: 165px;">
                {{ val.kategori }}
              </td>
            </tr>
          </tbody>
        </q-markup-table>

        <q-card-section class="text-bold q-py-sm">History</q-card-section>

        <q-markup-table flat separator="none" dense wrap-cells>
          <thead>
            <tr>
              <th class="text-center trow" style="font-weight: 600;">
                No. PO
              </th>
              <th
                class="text-center trow"
                style="font-weight: 600;width:100px;"
              >
                Tanngal PO
              </th>
              <th class="text-center trow" style="font-weight: 600;">
                Nama Vendor
              </th>
              <th
                class="text-center trow"
                style="font-weight: 600;width:100px;"
              >
                Qty
              </th>
              <th class="text-center trow" style="font-weight: 600;">
                Harga
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(el, j) in val.history" :key="j">
              <td style="width:150px;">{{ el.po_id }}</td>
              <td class="text-center" style="width:100px;">{{ el.po_date }}</td>
              <td>
                <div v-if="el.vendor.length <= 25">
                  {{ el.vendor }}
                </div>
                <div class="cursor-pointer" v-else>
                  {{ el.vendor.slice(0, 23) }}
                  <span>....</span>
                </div>
              </td>
              <td class="text-center" style="width:115px;">
                {{ `${el.qty} ${el.unit}` }}
              </td>
              <td class="text-right" style="width:130px;">
                {{
                  setCurrency(
                    parseFloat(el.price) / parseFloat(el.qty),
                    el.currency
                  )
                }}
                / {{ el.unit }}
              </td>
            </tr>
            <tr v-if="val.history.length == 0">
              <td colspan="5" class="text-center text-bold text-grey-7">
                Tidak ada Riwayat Pembelian
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-card>
      <hr style="border-top: 1px dashed black; width: 100%" />
    </div>
  </div>
</template>

<script>
import { mapGetters, mapState } from "vuex";
import moment from "moment";
moment.locale("ID");
import html2canvas from "html2canvas";
import { jsPDF } from "jspdf";
export default {
  data() {
    return {
      mode: "preview",
      data: [],
      public_url: process.env.VUE_APP_PUBLIC_URL,
    };
  },
  async mounted() {
    document.title = "Print Preview";

    window.addEventListener("beforeprint", (event) => {
      this.mode = "print";
    });

    window.onbeforeprint = () => {
      this.mode = "print";
    };

    window.addEventListener("afterprint", (event) => {
      this.mode = "preview";
    });

    window.onafterprint = () => {
      this.mode = "preview";
    };

    await this.getData();
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
    closeTab() {
      window.close();
    },
    momentMask(date) {
      if (date) {
        return moment(date).format("DD MMM YYYY");
      } else {
        return "-";
      }
    },
    async getData() {
      let temp = this.$route.params.data;
      this.$q.loading.show();
      try {
        let payload = JSON.parse(temp);

        let resp = await this.$http.post("/print/getdata", payload);
        this.data = resp.data;
        this.$q.loading.hide();
      } catch (err) {
        this.$router.push("/spp/approved");
        this.$q.loading.hide();
      }
    },
    async printPage() {
      this.mode = "print";
      window.print();
      this.mode = "preview";
      // try {
      //   const doc = new jsPDF("p", "mm", "a4");
      //   const gambar = [];

      //   for (let item of this.$refs.myRef) {
      //     let page = await html2canvas(item, { scale: 2 });
      //     gambar.push(page.toDataURL("image/png"));
      //   }

      //   for (let i in gambar) {
      //     let item = gambar[i];
      //     if (i % 2 == 0) {
      //       if (i > 0) {
      //         doc.addPage();
      //       }
      //       doc.addImage(item, "JPEG", 10, 0, 190, 138, `alias${i}`, "MEDIUM");
      //     } else {
      //       doc.addImage(
      //         item,
      //         "JPEG",
      //         10,
      //         139,
      //         190,
      //         138,
      //         `alias${i}`,
      //         "MEDIUM"
      //       );
      //     }
      //   }
      //   doc.output("dataurlnewwindow");
      // } catch (err) {
      //   console.log(err);
      // }
    },
  },

  computed: {
    theData() {
      return mapState(["printData"]);
    },
  },
};
</script>

<style>
.trow {
  background-color: #e0e0e0 !important;
  -webkit-print-color-adjust: exact !important;
}
@media print {
  .noprint {
    visibility: hidden;
    display: none;
  }
  .toprint {
    visibility: visible;
    display: block;
  }
  header {
    visibility: hidden;
    display: none;
  }
}
</style>
