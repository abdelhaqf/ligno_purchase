<template>
    <q-dialog ref="dialog" @hide="onDialogHide" persistent>
            <q-card style="min-width: 1200px !important;">
                <q-card-section>
                    Create SPP
                    <q-markup-table
                        wrap-cells
                        flat
                        bordered
                        class="stickyTable"
                        >
                            <!-- table head -->
                            <thead class="text-white">
                            <tr>
                                <th>Nama Barang</th>
                                <th>QTY</th>
                                <th>Satuan</th>
                                <th>Deadline</th>
                                <th>CC</th>
                                <th>Keterangan</th>             
                                <th class="q-mx-sm">Action</th>
                            </tr>
                            </thead>
                            <!-- table body  -->
                            <tbody>
                                <tr v-for="(d, i) in spp" :key="i">
                                    <td>
                                        {{ d.item }}
                                    </td>
                                    <td style="min-width: 150px;">
                                        <q-input
                                            type="number"
                                            outlined
                                            v-model="d.qty"
                                            dense
                                            class="l-grow"
                                            placeholder="0"
                                        />
                                    </td>
                                    <td>
                                        {{ d.unit }}
                                        <!-- <q-input
                                            outlined
                                            v-model="d.unit"
                                            dense
                                            class="l-grow"
                                            placeholder="e.g. kg / m / dus"
                                        >
                                        </q-input> -->
                                    </td>
                                    <td style="min-width: 170px;">
                                        <q-input
                                            outlined
                                            dense
                                            bg-color="white"
                                            v-model="d.deadline"
                                            class="l-grow"
                                        >
                                            <template v-slot:append>
                                            <q-icon name="event" class="cursor-pointer">
                                                <q-popup-proxy
                                                    ref="qDateProxy"
                                                    transition-show="scale"
                                                    transition-hide="scale"
                                                >
                                                    <q-date minimal v-model="d.deadline" :options="limitDate">
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
                                    <td style="min-width: 170px;">
                                        <q-select
                                            outlined
                                            dense
                                            emit-value
                                            map-options
                                            :options="listUser"
                                            v-model="d.cc"
                                            class="l-grow"
                                            placeholder="Pilih Nama"
                                            ></q-select>
                                    </td>
                                    <td style="min-width: 180px;">
                                        
                                        {{ d.description }}   
                                        <!-- <q-input
                                                outlined
                                                v-model="d.description"
                                                dense
                                                autogrow
                                                class="l-grow"
                                                /> -->
                                    </td>
                                    <td>
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
                </q-card-section>
                <q-card-actions align="between" class="row q-gutter-x-sm bg-grey-3 q-pa-md">
                    <q-btn
                        outline
                        label="Batal"
                        dense
                        class="l-grow"
                        color="grey-8"
                        no-caps
                        @click="onCancelClick"
                        style="width: 30%"
                    />
                    <q-btn
                        dense
                        unelevated
                        no-caps
                        color="primary"
                        label="Ya, Buat SPP"
                        class=" l-grow"
                        style="width: 40%"
                        @click="onOKClick"
                    />
                    </q-card-actions>
            </q-card>
        </q-dialog>
</template>
  
<script>
import moment from "moment";
export default {
props: ["newSpp"],
    data() {
        return {
        spp: [],
        listUser: [],
        };
    },
    mounted() {
        this.spp = this.$props.newSpp;
        this.getUsers();
    },
    methods: {
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
            this.$emit("ok", "spp berhasil dibuat");
            this.createSPP();
            this.hide();
        },

        onCancelClick() {
            this.hide();
        },
        deleteSPPItem(index) {
            this.spp.splice(index, 1);
        },
        limitDate(date) {
            return date >= moment().format("YYYY/MM/DD");
        },
        async getUsers() {
            let result = await this.$http.get("/list/user", {});
            this.listUser = result.data;
            this.listUser.unshift({
                value: 0,
                label: "-",
                id_user: 0,
            });
        },
        createSPP() {
            for (var i = 0; i < this.newSpp.length; i++) {
                this.$http.post("/new_spp", this.newSpp[i], {}).then((result) => {
                    
                    var history = {
                        spp_id: result.data,
                        status: "created",
                        content: "Dibuat oleh " + this.$store.state.currentUser.username,
                    };
                    this.$http.post("/new_history", history, {}).then((result) => {});

                    this.$q.notify("SPP Berhasil Dibuat!");

                    var notifikasi = {
                    from_id: this.$store.state.currentUser.user_id,
                    to_id: this.$store.state.currentUser.manager_id,
                    notif: this.$store.state.currentUser.username + " membuat SPP baru",
                    note: "",
                    spp_id: result.data,
                    reference_page: "/spp/approval",
                    };
                    this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
                });
            }
            
        },
    },
};
</script>
  