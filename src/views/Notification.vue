<template>
  <div class="row justify-center q-px-lg q-pt-lg rounded-borders">
    <q-card flat bordered class="col-12">
      <q-card-section class="row justify-between text-h6">
        <div>Notifikasi</div>
        <div>
          <q-btn flat icon="more_vert" color="grey">
            <q-menu style="width: 100px;">
              <q-list>
                <q-item clickable v-close-popup @click="markAll">
                  <q-item-section>Tandai semua sudah dibaca</q-item-section>
                </q-item>
              </q-list>
            </q-menu>
          </q-btn>
        </div>
      </q-card-section>
      <q-markup-table bordered dense>
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th class="text-left">No SPP</th>
            <th class="text-left">Notif</th>
            <th class="text-left">Tanggal</th>
            <th class="text-center">Status</th>
          </tr>
        </thead>
        <tbody v-if="notifikasi.length">
          <tr v-for="d in notifikasi" :key="d.notif_id" :class="isRead(d)" @click="showData(d)">
            <td class="text-left">{{ d.spp_id }}</td>
            <td class="text-left">{{ d.notif }}</td>
            <td class="text-left">{{d.create_at | moment('DD MMM YYYY')}}</td>
            <td
              class="text-center"
              :class="d.is_read=='Y'?'text-grey':'text-light-blue-5'"
            >{{ d.is_read=='Y'? 'read':'new' }}</td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">tidak ada data</td>
          </tr>
        </tbody>
      </q-markup-table>
    </q-card>

    <q-dialog v-model="show" persistent transition-show="scale" transition-hide="scale">
      <q-card style="min-width:300px;">
        <q-card-section class="bg-primary text-bold text-white row">
          <div>NOTIFIKASI</div>

          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-card-section>
        <q-list class="q-py-lg">
          <q-item>
            <q-item-section>
              <q-item-label caption>Notif from: {{ selected.name }}</q-item-label>
              <q-item-label>{{ selected.notif }}</q-item-label>
            </q-item-section>
          </q-item>
          <q-item>
            <q-item-section>
              <q-item-label caption>note</q-item-label>
              <q-item-label>{{ selected.note }}</q-item-label>
            </q-item-section>
          </q-item>
        </q-list>
        <q-card-actions>
          <q-btn
            flat
            no-caps
            class="full-width"
            color="positive"
            label="Buka Halaman"
            @click="$router.push(selected.reference_page)"
          />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
import moment from "moment";

export default {
  data() {
    return {
      notifikasi: [],
      show: false,
      selected: {}
    };
  },
  mounted() {
    this.$http
      .get("/notifikasi/" + this.$store.state.currentUser.user_id, {})
      .then(result => {
        this.notifikasi = result.data;
      });
  },
  methods: {
    isRead(val) {
      if (val.is_read == "N") {
        return "bg-grey-1 text-bold";
      } else return "bg-grey-4";
    },

    showData(val) {
      this.selected = val;
      this.show = true;

      var data = {
        is_read: "Y"
      };
      this.selected.is_read = "Y";

      this.$http.put("/notifikasi/" + val.notif_id, data, {}).then(result => {
        this.$root.$emit("notifikasi");
      });
    },
    async markAll() {
      for (var i = 0; i < this.notifikasi.length; i++) {
        let data = {
          is_read: "Y"
        };
        await this.$http
          .put("/notifikasi/" + this.notifikasi[i].notif_id, data, {})
          .then(async result => {
            this.notifikasi[i].is_read = "Y";
            if (i + 1 == this.notifikasi.length)
              await this.$root.$emit("notifikasi");
          });
      }
    }
  }
};
</script>

<style lang="scss" scoped>
.align-right {
  justify-content: flex-end;
}
.q-markup-table {
  th,
  td {
    padding: 10px;
  }
  &:hover {
    cursor: pointer;
  }
  tr:hover {
    border: 2px solid grey;
  }
}
</style>
