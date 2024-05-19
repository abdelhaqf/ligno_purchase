<template>
    <q-dialog ref="dialog" @hide="onDialogHide" persistent>
            <q-card class="my-font" style="min-width: 1200px !important;">
                <q-card-section class="items-center">
                    <div class="text-h6 text-weight-bold q-mb-sm">Order dari Template</div>
                </q-card-section>
                <q-separator/>
                <q-card-section class="bg-grey-2 column q-gutter-y-md q-pt-none">
                    <div class="row items-center l-grow">
                        <div style="width: 125px;">Deadline</div>
                        <q-field dense outlined class="l-grow bg-white">
                            <template v-slot:prepend>
                            <q-icon name="date_range" />
                            </template>

                            <template v-slot:control>
                            <div class="self-center full-width no-outline" tabindex="0">
                                {{ date_model(deadline) }}
                            </div>
                            </template>
                            <q-popup-proxy
                            style="width:fit-content"
                            transition-show="scale"
                            transition-hide="scale"
                            >
                            <q-date v-model="deadline" :options="limitDate">
                                <div class="row items-center justify-end">
                                <q-btn v-close-popup label="Close" color="primary" flat />
                                </div>
                            </q-date>
                            </q-popup-proxy>
                        </q-field>
                    </div>
                    <div class="row items-center l-grow">
                        <div style="width: 125px;">CC</div>
                        <q-select
                            outlined
                            dense
                            emit-value
                            map-options
                            :options="listUser"
                            v-model="cc"
                            class="l-grow bg-white"
                            placeholder="Pilih Nama"
                        ></q-select>
                    </div>
                    <q-markup-table
                        wrap-cells
                        flat
                        bordered
                        class="stickyTable"
                        >
                            <!-- table head -->
                            <thead class="text-white">
                            <tr>
                                <th>No</th>
                                <th>Nama Barang</th>
                                <th>QTY</th>
                                <th>Satuan</th>
                                <th>Keterangan</th>             
                                <th class="q-mx-sm">Action</th>
                            </tr>
                            </thead>
                            <!-- table body  -->
                            <tbody>
                                <tr v-for="(d, i) in template.template_detail" :key="i">
                                    <td>{{ i + 1 }}</td>
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
                                        <!-- {{ d.unit }} -->
                                        <q-input
                                            outlined
                                            v-model="d.unit"
                                            dense
                                            class="l-grow"
                                            placeholder="e.g. kg / m / dus"
                                        >
                                        </q-input>
                                    </td>
                                    <td style="min-width: 180px;">
                                        
                                        <!-- {{ d.description }}    -->
                                        <q-input
                                                outlined
                                                v-model="d.description"
                                                dense
                                                autogrow
                                                class="l-grow"
                                                />
                                        <!-- <div class="l-wrap-cell" v-if="d.description">
                                            <span>
                                                {{ d.description.length > 40 ? d.description.slice(0, 33) : d.description }}
                                            </span>
                                            <span v-if="d.description.length > 40" class=" no-wrap ">
                                                ...
                                                <q-tooltip
                                                content-style="width:300px"
                                                content-class="l-text-detail bg-white text-black shadow-2"
                                                >{{ d.description }}</q-tooltip
                                                >
                                            </span>
                                        </div>
                                        <div v-else class="text-center l-grow">-</div> -->
                                    </td>
                                    <td class="text-center">
                                        <q-btn
                                            label="Hapus"
                                            flat
                                            no-caps
                                            color="negative"
                                            dense
                                            @click="deleteSPPItem(i)"
                                        />
                                    </td>
                                </tr>
                            </tbody>
                    </q-markup-table>
                </q-card-section>
                <q-card-actions align="between" class="row q-gutter-x-sm q-pa-md">
                    <q-btn
                        outline
                        label="Tidak, Kembali"
                        dense
                        class="l-grow q-py-sm text-weight-bold"
                        color="black"
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
                        class=" l-grow q-py-sm text-weight-bold"
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
props: ["id_template"],
    data() {
        return {
        id: null,
        template: {},
        listUser: [],
        spp:[],
        deadline: null,
        cc: "",
        };
    },
    mounted() {
        this.id = this.$props.id_template;
        this.getUsers();
        this.getTemplateDetail();
    },
    computed: {
    },
    methods: {
        date_model(date) {
            if (!date) return "Pilih Tanggal Dibutuhkan";

            return moment(date).format("DD MMMM YYYY");
        },
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
            this.template.template_detail.splice(index, 1);
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
        async getTemplateDetail(){
            await this.$http.get(`/template_detail/${this.id}`, {}).then((result) => {
                this.template = result.data;
            });
        },
        createSPP() {
            for (var i = 0; i < this.template.template_detail.length; i++) {
                this.template.template_detail[i].user_id = this.$store.state.currentUser.user_id;
                this.template.template_detail[i].deadline = this.deadline;
                this.template.template_detail[i].cc = this.cc;
                this.$http.post("/new_spp", this.template.template_detail[i], {}).then((result) => {
                    
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
                    reference_page: "/spp/list",
                    };
                    this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
                });
            }
            
        },
    },
};
</script>

<style lang="scss" scoped>
.l-wrap-cell {
  width: 150px !important;
  word-wrap: break-word !important; /* Ensures that words break and wrap to the next line */
  white-space: normal !important; /* Overrides any contrary settings that prevent wrapping */
  word-break: break-all;
}
</style>
  