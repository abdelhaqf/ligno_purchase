<template>
  <div class="q-px-lg rounded-borders full-width">
    <q-card flat bordered class="bg-white">
      <q-item class="q-py-md">
        <q-item-section side>
          <q-btn flat icon="arrow_back" @click="$router.go(-1)" dense></q-btn>
        </q-item-section>
        <q-item-section>
          <div class="text-bold l-text-detail">Detail PO #{{ po.po_id }}</div>
          <div class="text-grey-6">
            <span>
              <q-icon name="today" />
            </span>
            Tanggal PO:
            <span class="text-bold">
              {{ momentFormatDate(po.po_date) }}
            </span>
          </div>
        </q-item-section>
      </q-item>
      <q-separator size="2px" inset></q-separator>
      <q-card-section class="q-ma-md bg-grey-2 column q-gutter-y-sm">
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">
            Ditangani Oleh
          </div>
          <div class="text-bold text-right">{{ po.handler_name }}</div>
        </div>
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">Vendor</div>
          <div v-if="!isEdit" class="text-right">{{ po.vendor }}</div>
          <div class="text-right" v-else>
            <q-input
              outlined
              v-model="po.vendor"
              dense
              style="min-width: 350px ;"
              class="bg-white"
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
            </q-input>
            <q-select
              v-else
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
              @input-value="setModel"
              style="min-width: 350px ;"
              class="bg-white"
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
        <div class="row justify-between items-center">
          <div class="text-grey-8" style="min-width: 150px ;">
            Kategori Biaya
          </div>
          <div v-if="!isEdit" class="text-right">{{ po.cost_category }}</div>
          <div class="text-right" v-else>
            <q-select
              outlined
              v-model="po.cost_category"
              :options="cost_ctg"
              class="bg-white"
              map-options
              emit-value
              use-input
              hide-selected
              fill-input
              dense
              style="min-width: 350px ;"
            >
            </q-select>
          </div>
        </div>
      </q-card-section>
      <q-scroll-area style="height:calc(100vh - 515px)" class="q-px-md">
        <q-markup-table
          wrap-cells
          flat
          bordered
          class="stickyTable"
          style="max-height: calc(100vh - 375px);"
        >
          <!-- table head -->
          <thead class="text-white">
            <tr>
              <th class="q-px-xs">SPP</th>
              <th>Request By</th>
              <th>Barang</th>
              <th>QTY</th>
              <th>Value</th>
              <th>Est. Arrival</th>
              <th>Note</th>
              <th v-if="!isEdit">Received</th>
              <th v-if="!isEdit" class="q-mx-sm">Action</th>
            </tr>
          </thead>
          <!-- table body  -->
          <tbody>
            <tr v-for="(d, i) in po.spp" :key="i">
              <td class="text-center">{{ d.spp_id }}</td>
              <td>{{ d.name }}</td>
              <td v-if="!isEdit">{{ d.item }}</td>
              <td v-else class="text-center">
                <q-input
                  style="min-width: 150px;"
                  outlined
                  dense
                  v-model="d.item"
                />
              </td>
              <td v-if="!isEdit" class="text-center">
                {{ d.qty }} {{ d.unit }}
              </td>
              <td v-else class="text-center">
                <q-input
                  style="min-width: 100px;"
                  outlined
                  dense
                  v-model="d.qty"
                />
                <q-input class="q-my-sm" outlined dense v-model="d.unit" />
              </td>
              <td v-if="!isEdit" class="text-center">
                {{ setCurrency(parseFloat(d.price), d.currency) }}
              </td>
              <td v-else>
                <money v-model="d.price" v-bind="moneyType(d.currency)"></money>
              </td>
              <td v-if="!isEdit" class="text-center">
                {{ momentFormatDate(d.est_arrival) }}
              </td>
              <td v-else>
                <q-input
                  outlined
                  dense
                  bg-color="white"
                  v-model="d.est_arrival"
                  class="l-grow"
                  style="min-width: 150px;"
                >
                  <template v-slot:append>
                    <q-icon name="event" class="cursor-pointer">
                      <q-popup-proxy
                        ref="qDateProxy"
                        transition-show="scale"
                        transition-hide="scale"
                      >
                        <q-date minimal v-model="d.est_arrival">
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
              <td v-if="!isEdit" class="text-left" style="max-width: 150px;">
                <!-- {{d.note}} -->
                <div class="l-wrap-cell" v-if="d.note">
                  <span>
                    {{ d.note.length > 40 ? d.note.slice(0, 33) : d.note }}
                  </span>
                  <span v-if="d.note.length > 40" class=" no-wrap ">
                    ...
                    <q-tooltip
                      content-style="width:300px"
                      content-class="l-text-detail bg-white text-black shadow-2"
                      >{{ d.note }}</q-tooltip
                    >
                  </span>
                </div>
                <div v-else class="text-center l-grow">-</div>
              </td>
              <td v-else class="text-center" style="min-width: 200px;">
                <q-input
                  outlined
                  dense
                  autogrow
                  v-model="d.note"
                  placeholder="Masukkan Note"
                />
              </td>
              <td class="text-center" v-if="!isEdit">
                <q-select
                  outlined
                  v-model="d.is_received"
                  :options="isReceivedOption"
                  class="bg-white"
                  map-options
                  emit-value
                  dense
                  @input="updateIsReceived(d);"
                >
                </q-select>
              </td>
              <td class="text-center" v-if="!isEdit">
                <q-btn
                  unelevated
                  label="Sync"
                  color="primary"
                  no-caps
                  @click="showDialogSync(d)"
                  :disable="d.sync != null"
                >
                </q-btn>
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-scroll-area>
      <q-separator size="1px"></q-separator>
      <q-card-section class="row justify-end items-center">
        <div class="row justify-end q-gutter-x-md" v-if="!isEdit">
          <q-btn
            unelevated
            label="Re-Order"
            color="primary"
            no-caps
            @click="
              reorderList();
              showDialogReorder();
            "
          >
          </q-btn>
          <q-btn
            unelevated
            label="Edit"
            color="white"
            text-color="black"
            outline
            style="color: black;"
            no-caps
            @click="isEdit = true"
          >
          </q-btn>
        </div>
        <div class="row justify-end q-gutter-x-md" v-else>
          <q-btn
            unelevated
            label="Batal"
            color="negative"
            no-caps
            @click="
              isEdit = false;
              fetchData();
            "
          >
          </q-btn>
          <q-btn
            unelevated
            label="Simpan"
            color="primary"
            no-caps
            @click="updateSPP_PO"
          >
          </q-btn>
        </div>
      </q-card-section>
    </q-card>

    <!-- <q-footer style="max-width: 1440px;" class="q-mx-auto atas-radius bg-white">
      <q-card-section class="row justify-end items-center">
        <div class="row justify-end q-gutter-x-md" v-if="!isEdit">
          <q-btn
            unelevated
            label="Re-Order"
            color="primary"
            no-caps
            @click="
              reorderList();
              showDialogReorder();
            "
          >
          </q-btn>
          <q-btn
            unelevated
            label="Edit"
            color="white"
            text-color="black"
            outline
            style="color: black;"
            no-caps
            @click="isEdit = true"
          >
          </q-btn>
        </div>
        <div class="row justify-end q-gutter-x-md" v-else>
          <q-btn
            unelevated
            label="Batal"
            color="negative"
            no-caps
            @click="isEdit = false; fetchData();">
          </q-btn>
          <q-btn
            unelevated
            label="Simpan"
            color="primary"
            no-caps
            @click="updateSPP_PO"
          >
          </q-btn>
        </div>
      </q-card-section>
    </q-footer> -->
  </div>
</template>

<script>
import moment from "moment";
moment.locale("id");
import { Money } from "v-money";
import dialogReorderPO from "../components/dialogReorderPO.vue";
import dialogSyncRM from "../components/dialogSyncRM.vue";
export default {
  components: { Money },
  data() {
    return {
      isEdit: false,
      po: {},
      old: {},
      cost_ctg: [
        "BELUM DIKATEGORIKAN",
        "Marketing/Sales",
        "RnD",
        "Produksi/Gudang",
        "Purchasing/Accounting",
        "Lab Pusat",
        "Lab Beton",
        "IT",
        "Umum/HRD",
        "Maintenance",
      ],
      isReceivedOption: [
        { label: "No", value: "0" },
        { label: "Partial", value: "1" },
        { label: "Full", value: "2" },
        { label: "Suspended", value: "300" },
        { label: "Closed", value: "40000" },
      ],
      newSpp: [],
      optVendor: [],
      filteredVD: [],
      showInput: false,
    };
  },
  async mounted() {
    await this.fetchData();
    await this.getVendor();
  },
  watch: {},
  computed: {},
  methods: {
    setModel(val) {
      this.po.vendor = val;
    },
    showDialogReorder() {
      this.$q
        .dialog({
          component: dialogReorderPO,
          parent: this,
          newSpp: this.newSpp,
          from: "po_detail",
          style: "border: 2px solid black",
        })
        .onOk((val) => {
          console.log("OK was clicked on dialog: ", val);
        })
        .onCancel(() => {
          console.log("Cancel was clicked on dialog");
        })
        .onDismiss(() => {
          console.log("OK or cancel was clicked on dialog");
        });
    },
    showDialogSync(spp) {
      let payload = JSON.parse(JSON.stringify(spp));
      payload.confirmed = false;
      payload.id_rm = null;
      payload.syncPrice = 0;

      this.$q
        .dialog({
          component: dialogSyncRM,
          parent: this,
          spp: payload,
        })
        .onOk(async () => {
          await this.fetchData();
        });
    },
    async fetchData() {
      let id = decodeURIComponent(this.$route.params.id);

      let result = await this.$http.get(
        `/po/detail?id=${encodeURIComponent(id)}`,
        {}
      );
      this.po = result.data;
      this.old = JSON.parse(JSON.stringify(result.data));
    },
    momentFormatDate(date) {
      if (date) {
        return moment(date).format("DD MMM YYYY");
      }
      return "-";
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
    moneyType(curr) {
      let money = {
        decimal: ",",
        thousands: ".",
        prefix: "Rp ",
        suffix: "",
        precision: 0,
        masked: false,
      };
      if (curr == "IDR") {
        money.precision = 0;
        money.prefix = "Rp ";
        money.decimal = ",";
        money.thousands = ".";
      } else {
        money.precision = 0;
        money.prefix = "$ ";
        money.decimal = ".";
        money.thousands = ",";
      }

      return money;
    },
    reorderList() {
      this.newSpp = [];
      for (var i = 0; i < this.po.spp.length; i++) {
        let temp = {};
        temp.item = this.po.spp[i].item;
        temp.qty = this.po.spp[i].qty;
        temp.unit = this.po.spp[i].unit;
        temp.cc = this.po.spp[i].cc;
        // temp.deadline =
        //   this.po.spp[i].deadline >= moment().format("YYYY-MM-DD")
        //     ? moment(this.po.spp[i].deadline).format("YYYY/MM/DD")
        //     : moment().format("YYYY/MM/DD");
        temp.description = this.po.spp[i].description;
        temp.user_id = this.$store.state.currentUser.user_id;

        this.newSpp.push(temp);
      }
    },
    async updateIsReceived(spp){
      let data = {
          is_received: spp.is_received
      }
      
      await this.$http
          .put("/update_spp/" + spp.spp_id, data, {})
          .then((result) => {

            var info = `${this.$store.state.currentUser.username} mengubah status penerimaan SPP ${spp.spp_id}`;

            let history = {
              spp_id: spp.spp_id,
              status: "process",
              content: info,
            };
            if (spp.is_received == 2) {
              history.status = "done";
            }
            if (spp.is_received == 300) {
              history.status = "suspended";
            }
            if (spp.is_received == 40000) {
              history.status = "closed";
            }
            this.$http.post("/new_history", history, {}).then((result) => {});

            if (spp.is_received == 2)
              info = "barang sudah diterima penuh";
            if (spp.is_received == 1)
              info = "barang sudah diterima sebagian";
            if (spp.is_received == 300) info = "PO sementara di suspend";
            if (spp.is_received == 40000) info = "PO dinyatakan closed";

            var notifikasi = {
              from_id: this.$store.state.currentUser.user_id,
              to_id: spp.user_id,
              notif: "Perubahan Status SPP",
              note: info,
              spp_id: spp.spp_id,
              reference_page: "/spp/list",
            };
            if (info != "") {
              this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

              notifikasi.to_id = 4; // Notif ke Manager purchasing
              this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
            }

            this.$q.notify("Status SPP berhasil diubah!");
          });
    },
    async updateSPP_PO() {
      for (var i = 0; i < this.po.spp.length; i++) {
        let data = {
          // is_received: this.po.spp[i].is_received,
          coa: this.po.spp[i].coa,
          note: this.po.spp[i].note,
          cost_category: this.po.cost_category,

          item: this.po.spp[i].item,
          qty: this.po.spp[i].qty,
          unit: this.po.spp[i].unit,
          price: this.po.spp[i].price,
          est_arrival: this.po.spp[i].est_arrival,
        };
        var note_add = "";
        if (this.po.spp[i].item != this.old.spp[i].item) {
          note_add =
            note_add +
            ", nama item: " +
            this.old.spp[i].item +
            " => " +
            this.po.spp[i].item;
        }
        if (this.po.spp[i].qty != this.old.spp[i].qty) {
          note_add =
            note_add +
            ", qty: " +
            this.old.spp[i].qty +
            " => " +
            this.po.spp[i].qty;
        }
        if (this.po.spp[i].unit != this.old.spp[i].unit) {
          note_add =
            note_add +
            ", unit: " +
            this.po.spp[i].unit +
            " => " +
            this.old.spp[i].unit;
        }
        if (this.po.spp[i].price != this.old.spp[i].price) {
          note_add =
            note_add +
            ", harga: " +
            this.old.spp[i].price +
            " => " +
            this.po.spp[i].price;
        }
        if (this.po.spp[i].note != this.old.spp[i].note) {
          note_add =
            note_add +
            ", harga: " +
            this.old.spp[i].note +
            " => " +
            this.po.spp[i].note;
        }
        if (note_add != "")
          data.revision = this.$store.state.currentUser.username;

        await this.$http
          .put("/update_spp/" + this.po.spp[i].spp_id, data, {})
          .then((result) => {});

        let history = {
          spp_id: this.po.spp[i].spp_id,
          status: "process",
          content: this.po.spp[i].note + note_add,
        };
        if (this.po.spp[i].is_received == 2) {
          history.status = "done";
        }
        if (this.po.spp[i].is_received == 300) {
          history.status = "suspended";
        }
        if (this.po.spp[i].is_received == 40000) {
          history.status = "closed";
        }
        this.$http.post("/new_history", history, {}).then((result) => {});

        var info = `${this.$store.state.currentUser.username} telah melakukan perubahan pada SPP ${this.po.spp[i].spp_id}`;
        var notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: this.po.spp[i].user_id,
          notif: "Perubahan Detail SPP",
          note: info,
          spp_id: this.po.spp[i].spp_id,
          reference_page: "/spp/list",
        };
        if (info != "") {
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});

          notifikasi.to_id = 4; // Notif ke Manager purchasing
          this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
        }
      }

      let data = {
        vendor: this.po.vendor,
        po_id: this.po.po_id,
      };

      await this.$http.put("/update_po", data, {}).then((result) => {});

      this.show_detail = false;
      await this.fetchData();
      this.$q.notify("Data PO dan SPP berhasil diubah!");
      this.isEdit = false;
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
  },
};
</script>

<style lang="scss" scoped>
.v-money {
  line-height: 1;
  font-size: 14px;
  border: 1px solid silver;
  border-radius: 5px;
  padding: 10px;
  box-sizing: border-box;
}
.v-money:focus {
  outline: none;
  box-shadow: inset 0 0 0 1.5pt #0e84eb;
}
.l-wrap-cell {
  width: 150px !important;
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
