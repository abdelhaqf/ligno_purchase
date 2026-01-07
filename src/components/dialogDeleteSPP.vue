<template>
  <q-dialog ref="dialog" @hide="onDialogHide">
    <q-card class="my-font" style="width: 500px;">
      <q-card-section class="items-center">
        <div class="text-h6 text-weight-bold">Hapus SPP dari PO</div>
        <div class="text-grey">
          Pastikan spp yang akan dihapus dari PO SPP sudah sesuai
        </div>
      </q-card-section>
      <q-separator />
      <q-card-section>
        Apa anda yakin akan menghapus SPP berikut dari PO
        <span class="text-bold">{{ selspp.po_id }}</span> ?
      </q-card-section>

      <q-markup-table flat>
        <tr>
          <td>Nomor</td>
          <td>:</td>
          <td>{{ selspp.spp_id }}</td>
        </tr>
        <tr>
          <td>Nama Barang</td>
          <td>:</td>
          <td>{{ selspp.item }}</td>
        </tr>
        <tr>
          <td>QTY</td>
          <td>:</td>
          <td>{{ selspp.qty }} {{ selspp.unit }}</td>
        </tr>
      </q-markup-table>

      <q-card-section>
        SPP yang dihapus dari PO akan kembali ke menu
        <span class="text-bold">SPP Disetujui</span>
      </q-card-section>

      <q-card-actions align="right">
        <q-btn outline label="Batal" no-caps @click="onCancelClick"></q-btn>
        <q-btn
          unelevated
          class="text-bold"
          color="negative"
          label="Hapus SPP"
          no-caps
          @click="deleteSPP"
        ></q-btn>
      </q-card-actions>
    </q-card>
  </q-dialog>
</template>

<script>
export default {
  props: ["spp"],
  data() {
    return {
      selspp: {},
    };
  },
  mounted() {
    this.selspp = this.$props.spp;
  },
  computed: {},
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
      this.$emit("ok");
      this.hide();
    },

    onCancelClick() {
      this.hide();
    },

    async deleteSPP() {
      try {
        this.$q.loading.show();

        // remove spp from PO
        let payload = this.selspp;
        payload.revision = this.$store.state.currentUser.username;
        await this.$http.post("/po/delspp", payload);

        // Create History
        let history = {
          spp_id: payload.spp_id,
          status: "process",
          content: "PO dibatalkan!",
        };
        await this.$http.post("/new_history", history, {}).then((result) => {});

        // Create Notif
        var info = `${this.$store.state.currentUser.username} telah membatalkan PO pada SPP ${payload.spp_id}`;
        var notifikasi = {
          from_id: this.$store.state.currentUser.user_id,
          to_id: payload.user_id,
          notif: `Pembatalan PO untuk SPP ${payload.spp_id}`,
          note: info,
          spp_id: payload.spp_id,
          reference_page: "/spp/list",
        };

        await this.$http
          .post("/notifikasi", notifikasi, {})
          .then((result) => {});

        notifikasi.to_id = 4; // Notif ke Manager purchasing
        await this.$http
          .post("/notifikasi", notifikasi, {})
          .then((result) => {});

        this.$q.notify({
          message: "SPP berhasil dikeluarkan dari PO!",
          color: "positive",
        });
        this.onOKClick();
      } catch (err) {
        console.log(err);
        this.$q.notify({
          message: "SPP gagal dikeluarkan dari PO!",
          color: "negative",
        });
      } finally {
        this.$q.loading.hide();
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
