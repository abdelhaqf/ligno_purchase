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
            <tr v-for="(val, i) in template.template_detail" :key="i">
              <q-tr style="display: contents;" v-if="!val.id">
                <td class="text-center">
                  {{ i + 1 }}
                </td>
                <td>
                  <q-input
                    outlined
                    v-model="val.item"
                    v-if="toggleStats[i - lengthExist]"
                    dense
                    class="l-grow"
                    placeholder="Masukan Nama Barang"
                  >
                    <template v-slot:append>
                      <q-toggle
                        v-model="toggleStats[i - lengthExist]"
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
                        v-model="toggleStats[i - lengthExist]"
                        color="green"
                        icon="add"
                        keep-color
                      />
                    </template>
                  </q-select>
                </td>
                <td>
                  <q-input
                    outlined
                    dense
                    type="number"
                    v-model="val.qty"
                    
                  ></q-input>
                </td>
                <td><q-input outlined
                    dense v-model="val.unit" style="width:200px"></q-input></td>
                <td>
                  <q-btn
                    no-caps
                    label="Hapus"
                    @click="deleteSPPItem(i)"
                  ></q-btn>
                </td>
              </q-tr>
              <q-tr style="display: contents;" v-else>
                <td>
                  {{ i + 1 }}
                </td>
                <td>
                  {{ val.item }}
                </td>
                <td>{{ val.qty }}</td>
                <td>{{ val.unit }}</td>
                <td>
                  <q-btn
                    no-caps
                    label="Hapus"
                    @click="deleteSPPItem(i)"
                  ></q-btn>
                </td>
              </q-tr>
            </tr>
            <tr>
              <td
                colspan="5"
                class="text-center"
                @click="
                  template.template_detail.push({
                    id: null,
                    item: '',
                    qty: 0,
                    unit: '',
                  });
                  toggleStats.push(false);
                "
              >
                + tambah barang
              </td>
            </tr>
          </tbody>
        </q-markup-table>
      </q-card-section>

      <q-card-actions align="right" v-if="!$props.id_template">
        <q-btn color="primary" label="Cancel" @click="onCancelClick" />
        <q-btn color="primary" label="Add Template" @click="createTemplate" />
      </q-card-actions>
      <q-card-actions align="right" v-else>
        <q-btn color="primary" label="Cancel" @click="onCancelClick" />
        <q-btn color="primary" label="Edit Template" @click="updateTemplate" />
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  props: ["id_template"],
  data() {
    return {
      option: [],
      filtered: [],
      showInput: false,
      template: {
        id_user: this.$store.state.currentUser.user_id,
        template_detail: [],
        notes: "",
      },
      toggleStats: [],
      lengthExist: 0,
    };
  },
  async mounted() {
    if (this.$props.id_template) {
      await this.getTemplate();
    }
    await this.$http.get("/list_item", {}).then((result) => {
      this.option = result.data;
      this.option = this.option.filter((obj) => obj.value !== "");
      if (this.option.length == 0) this.showInput = true;
    });
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
      this.template.template_detail.splice(index, 1);
      this.toggleStats.splice(index, 1);
    },
    async getTemplate() {
      await this.$http
        .get(`/template_detail/${this.$props.id_template}`)
        .then((resp) => {
          this.template = JSON.parse(JSON.stringify(resp.data));
        });

      this.lengthExist = this.template.template_detail.length;
    },
    createTemplate() {
      this.$http.post("/new_template", this.template, {}).then((result) => {
        // for (var i = 0; i < this.template_detail.length; i++) {
        //   this.spp_detail[i].id_template = result.data;
        //   this.$http
        //     .post("/new_template_detail", this.spp_detail[i], {})
        //     .then((result) => {});
        // }
        this.onOKClick();
      });
    },
    updateTemplate() {
      this.$http.put("/update_template", this.template, {}).then((result) => {
        this.onOKClick();
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
      this.$emit("ok")
      this.hide();
    },

    onCancelClick() {
      this.hide();
      this.toggleStats = [];
    },
  },
};
</script>
