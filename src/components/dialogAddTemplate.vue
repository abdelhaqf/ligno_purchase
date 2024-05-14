<template>
  <q-dialog ref="dialog" @hide="onDialogHide" persistent>
    <q-card class="q-dialog-plugin" style="min-width: 900px;">
      <q-card-section>Buat Template Baru </q-card-section>
      <q-card-section>
        <q-input label="nama template" v-model="template.name"></q-input>
        <q-input label="Notes" v-model="template.notes"></q-input>
      </q-card-section>

      <q-card-section>
        <q-markup-table>
          <thead>
            <tr>
              <th>No</th>
              <th>Nama</th>
              <th>Qty</th>
              <th>Unit</th>
              <th>action</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(val, i) in spp_detail" :key="i">
              <q-tr style="display: contents;" v-if="!val.id">
                <td>
                  {{ i + 1 }}
                </td>
                <td>
                  <q-input
                    outlined
                    v-model="val.item"
                    v-if="showInput"
                    dense
                    class="l-grow"
                    placeholder="Masukan Nama Barang"
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
                    v-model="val.item"
                    map-options
                    emit-value
                    use-input
                    hide-selected
                    fill-input
                    @input-value="setModel"
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
                </td>
                <td><q-input v-model="val.qty"></q-input></td>
                <td><q-input v-model="val.unit"></q-input></td>
                <td><q-btn no-caps label="Hapus" @click="deleteSPPItem(i)"></q-btn></td>
              </q-tr>
            </tr>
            <tr>
              <td
                colspan="5"
                class="text-center"
                @click="
                  spp_detail.push({ id: null, item: '', qty: 0, unit: '' })
                "
              >
                + tambah barang
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-card-section>

      <q-card-actions align="right">
        <q-btn color="primary" label="Cancel" @click="onCancelClick" />
        <q-btn color="primary" label="OK" @click="onOKClick" />      
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  props: ["id_template"],
  data() {
    return {
      spp_detail: [],
      option: [],
      filtered: [],
      showInput: false,
      template: {
        "id_user": this.$store.state.currentUser.user_id,
      },
    };
  },
  mounted() {
    this.$http.get("/list_item", {}).then((result) => {
      this.option = result.data;
      this.option = this.option.filter((obj) => obj.value !== "");
      if (this.option.length == 0) this.showInput = true;
    });
    if (this.$props.id_template) {
    }
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
    deleteSPPItem(index) {
        this.spp_detail.splice(index, 1);
    },
    createTemplate(){
      this.$http.post("/new_template", this.template, {}).then((result) => {
          // console.log(result.data);
          for (var i = 0; i < this.spp_detail.length; i++) {
            this.spp_detail[i].id_template = result.data;
            this.$http.post("/new_template_detail", this.spp_detail[i], {}).then((result) => {});
          }

          // var notifikasi = {
          //     from_id: this.$store.state.currentUser.user_id,
          //     to_id: this.$store.state.currentUser.manager_id,
          //     notif: this.$store.state.currentUser.username + " membuat Template baru",
          //     note: "",
          //     spp_id: result.data,
          //     reference_page: "/spp/template",
          //     };
          // this.$http.post("/notifikasi", notifikasi, {}).then((result) => {});
      });
      
    },
    setModel(val, id) {
      console.log(val);
      // this.spp_detail[id].item = val;
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
      this.createTemplate();
      this.hide();
    },

    onCancelClick() {
      this.hide();
    },
  },
};
</script>
