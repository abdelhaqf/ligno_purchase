<template>
  <q-dialog ref="dialog" @hide="onDialogHide" persistent>
    <q-card
      class="q-dialog-plugin my-font"
      style="min-width: 900px; max-height: 90vh;"
    >
      <q-card-section class="q-py-sm">
        <div class="text-h6 text-weight-bold">Form Template Baru</div>
      </q-card-section>
      <q-separator />
      <q-card-section class="column q-gutter-y-md">
        <div class="row items-center l-grow">
          <div style="width: 125px;">Nama Template</div>
          <q-input
            outlined
            v-model="template.name"
            dense
            class="l-grow bg-white"
            placeholder="Masukkan Nama Template"
          />
        </div>
        <div class="row items-center l-grow">
          <div style="width: 125px;">Note</div>
          <q-input
            outlined
            v-model="template.notes"
            dense
            autogrow
            class="l-grow bg-white"
            placeholder="e.g keperluan maintanance..."
          />
        </div>
        <div class="row l-grow no-wrap">
          <div style="width: 125px;">Barang</div>
          <q-markup-table wrap-cells flat bordered class="stickyTable l-grow">
            <thead>
              <tr>
                <th>No</th>
                <th>Nama Barang</th>
                <th>Qty</th>
                <th>Unit</th>
                <th>Action</th>
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
                      v-if="toggleStats[i]"
                      dense
                      class="l-grow"
                      placeholder="Masukan Nama Barang"
                    >
                      <template v-slot:append>
                        <q-toggle
                          v-model="toggleStats[i]"
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
                          v-model="toggleStats[i]"
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
                      style="width:100px"
                    ></q-input>
                  </td>
                  <td>
                    <q-input
                      outlined
                      dense
                      v-model="val.unit"
                      style="width:150px"
                    ></q-input>
                  </td>
                  <td>
                    <q-btn
                      label="Hapus"
                      flat
                      no-caps
                      color="negative"
                      dense
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
                      label="Hapus"
                      flat
                      no-caps
                      color="negative"
                      dense
                      @click="deleteSPPItem(i)"
                    ></q-btn>
                  </td>
                </q-tr>
              </tr>
              <tr class="cursor-pointer">
                <td
                  colspan="5"
                  class="text-center text-blue"
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
                  + Tambah Barang
                </td>
              </tr>
            </tbody>
          </q-markup-table>
        </div>

        
      </q-card-section>

      <q-card-actions
        align="right"
        class="row q-gutter-x-sm q-pa-md"
        v-if="!$props.id_template"
      >
        <q-btn
          class="text-weight-bold q-pa-xs"
          outline
          no-caps
          color="black"
          label="Kembali"
          @click="onCancelClick"
        />
        <q-btn
          class="text-weight-bold q-pa-xs"
          unelevated
          no-caps
          color="primary"
          label="Simpan"
          @click="createTemplate"
        />
      </q-card-actions>
      <q-card-actions align="right" class="row q-gutter-x-sm q-pa-md" v-else>
        <q-btn
          class="q-pa-xs text-weight-bold"
          outline
          no-caps
          color="black"
          label="Kembali"
          @click="onCancelClick"
        />
        <q-btn
          class="q-pa-xs text-weight-bold"
          unelevated
          no-caps
          color="primary"
          label="Edit Template"
          @click="updateTemplate"
        />
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

    this.toggleStats = Array(this.template.template_detail.length).fill(false);
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
      // console.log(val);
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
      this.$emit("ok");
      this.hide();
    },

    onCancelClick() {
      this.hide();
      this.toggleStats = [];
    },
  },
};
</script>
