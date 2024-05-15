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
        <q-card-section class="row justify-between items-center q-py-none">
          <div class="row justify-center" style="width: 20%">
            <img style="width: 2.5cm" :src="`${public_url}/Logo/ligno.png`" />
          </div>
          <div class="text-center" style="width: 60%">
            <span class="text-blue-10 text-bold" style="font-size: 1.25rem">
              PT. LIGNO SPECIALITY CHEMICALS
            </span>
          </div>
          <div class="row justify-end" style="width: 20%"></div>
        </q-card-section>
        <hr style="border-top: 1px solid black; width: 100%" />
        <q-card-section class="text-h6 text-center text-bold q-py-sm">
          LAPORAN SPP DISETUJUI
        </q-card-section>
        <div class="row justify-between">
          <q-markup-table flat dense separator="none">
            <tr>
              <td style="width:100px">No. SPP</td>
              <td style="width:5px">:</td>
              <td class="text-left">{{ val.spp_id }}</td>
            </tr>
            <tr>
              <td style="width:100px">Requester</td>
              <td style="width:5px">:</td>
              <td class="text-left text-capitalize">
                {{ val.name }} - {{ val.dept }}
              </td>
            </tr>
          </q-markup-table>

          <q-markup-table flat dense separator="nonte">
            <tr>
              <td style="width:100px">Request Date</td>
              <td style="width:5px">:</td>
              <td class="text-left">
                {{ momentMask(val.create_at) }}
              </td>
            </tr>
          </q-markup-table>
        </div>

        <q-markup-table flal separator="none" class="q-mt-md" dense>
          <thead>
            <tr>
              <th class="text-center trow" style="font-weight: 600;">
                Nama Barang
              </th>
              <th
                class="text-center trow"
                style="font-weight: 600;width:100px;"
              >
                Deadline
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
              <td>{{ momentMask(val.deadline) }}</td>
              <td>{{ `${val.qty} ${val.unit}` }}</td>
              <td class="text-capitalize">{{ val.handler_name }}</td>
              <td class="text-center">{{ val.kategori }}</td>
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
