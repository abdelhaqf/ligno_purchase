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
                    <div class="text-grey-8" style="min-width: 150px ;">Ditangani Oleh</div>
                    <div class="text-bold text-right">{{ po.handler_name }}</div>
                </div>
                <div class="row justify-between items-center">
                    <div class="text-grey-8" style="min-width: 150px ;">Vendor</div>
                    <div class="text-right">{{ po.vendor }}</div>
                </div>
                <div class="row justify-between items-center">
                    <div class="text-grey-8" style="min-width: 150px ;">Kategori Biaya</div>
                    <div class="text-right">          
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
                        >
                        </q-select>
                    </div>
                </div>
            </q-card-section>
            <q-scroll-area style="height:calc(100vh - 480px)" class="q-px-md">
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
                            <th>Received</th>             
                            <th class="q-mx-sm">Action</th>
                        </tr>
                        </thead>
                        <!-- table body  -->
                        <tbody>
                            <tr v-for="(d, i) in po.spp" :key="i">
                                <td class="text-center">{{ d.spp_id }}</td>
                                <td>{{ d.name }}</td>
                                <td>{{ d.item }}</td>
                                <td v-if="!isEdit" class="text-center">
                                    {{ d.qty }} {{ d.unit }}
                                </td>
                                <td v-else class="text-center">
                                    <q-input 
                                        style="min-width: 100px;"
                                        outlined 
                                        dense
                                        v-model="d.qty"/>
                                    <q-input 
                                        class="q-my-sm"
                                        outlined 
                                        dense
                                        v-model="d.unit"/>
                                </td>
                                <td v-if="!isEdit" class="text-center">
                                    {{ setCurrency(parseFloat(d.price) , d.currency) }}
                                </td>
                                <td v-else>
                                    <money v-model="d.price" v-bind="moneyType(d.currency)"></money>
                                </td>
                                <td v-if="!isEdit" class="text-center"> 
                                    {{ momentFormatDate(d.est_arrival)}}
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
                                <td v-if="!isEdit" class="text-left" style="max-width: 250px;">
                                    <!-- {{d.note}} -->
                                    <div class="l-wrap-cell">
                                        <span>
                                        {{
                                            d.note.length > 20
                                            ? d.note.slice(0, 13)
                                            : d.note
                                        }}
                                        </span>
                                        <span v-if="d.note.length > 20" class=" no-wrap ">
                                        ...
                                        <q-tooltip
                                            content-style="width:300px"
                                            content-class="l-text-detail bg-white text-black shadow-2"
                                            >{{ d.note }}</q-tooltip
                                        >
                                        </span>
                                    </div>
                                </td>
                                <td v-else class="text-center" style="max-width: 400px;">
                                    <q-input 
                                        outlined 
                                        dense
                                        autogrow
                                        v-model="d.note" 
                                        label="Note" />
                                </td>
                                <td class="text-center">
                                    <q-select
                                        outlined
                                        v-model="d.is_received"
                                        :options="isReceivedOption"
                                        class="bg-white"
                                        map-options
                                        emit-value
                                        dense
                                    >
                                    </q-select>
                                </td>
                                <td class="text-center">
                                    <q-btn
                                        unelevated
                                        label="Sync"
                                        color="blue"
                                        no-caps
                                    >
                                    </q-btn>
                                </td>
                            </tr>
                        </tbody>
                </q-markup-table>
            </q-scroll-area>
        </q-card>

        <q-footer
            style="max-width: 1440px;"
            class="q-mx-auto atas-radius bg-white"
            >
            <q-card-section class="row justify-end items-center">
                <div class="row justify-end q-gutter-x-md">
                    <q-btn
                        unelevated
                        label="Edit"
                        color="white" 
                        text-color="black" 
                        outline style="color: black;"
                        no-caps
                        @click="isEdit=!isEdit"
                    >
                    </q-btn>
                    <q-btn
                        unelevated
                        label="Simpan"
                        color="blue"
                        no-caps
                        @click="updatePO"
                    >
                    </q-btn>
                </div>
            </q-card-section>
        </q-footer>
    </div>
</template>

<script>
import moment from "moment";
moment.locale("id");
import { Money } from "v-money";
export default {
    components: { Money },
    data() {
        return {
            isEdit: false,
            po: {},
            isReceived: "0",
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

        };
    },
    async mounted() {
        await this.getPO();
        
    },
    // watch: {
    //     curr: {
    //     deep: true,
    //         handler(val) {
    //             for (var i = 0; i < this.sppSelect.length; i++) {
    //             this.sppSelect[i].currency = this.curr;
    //             }

    //             if (this.curr == "IDR") {
    //             this.money.precision = 0;
    //             this.money.prefix = "Rp ";
    //             } else {
    //             this.money.precision = 2;
    //             this.money.prefix = "$ ";
    //             }
    //         },
    //     },
    // },
    computed: {

    },
    methods: {
        async getPO() {
            let id = decodeURIComponent(this.$route.params.id);

            let result = await this.$http.get(
                `/po/detail?id=${encodeURIComponent(id)}`,
                {}
            );
            this.po = result.data;
            this.isReceived = result.data.is_received;
        },
        async updatePO() {

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

            return money
        }
    },

}
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
</style>