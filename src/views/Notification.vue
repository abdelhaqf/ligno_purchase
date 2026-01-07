<template>
  <div class="row relative q-px-lg ">
    <q-card flat square class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-between items-center">
        <div class="row items-center q-gutter-x-sm">
          <q-chip
            clickable
            :color="status == 'ALL' ? 'primary' : 'grey-3'"
            :text-color="status == 'ALL' ? 'white' : ''"
            @click="
              status = 'ALL';
              stopfetch = false;
              notifikasi = [];
              getNotif();
            "
            label="All"
          ></q-chip>
          <q-chip
            clickable
            :color="status == 'UNREAD' ? 'primary' : 'grey-3'"
            :text-color="status == 'UNREAD' ? 'white' : ''"
            @click="
              status = 'UNREAD';
              stopfetch = false;
              notifikasi = [];
              getNotif();
            "
            label="Unread"
          ></q-chip>
        </div>
        <q-btn
          flat
          :text-color="isUnreadable ? '' : 'primary'"
          label="Mark All As Read"
          no-caps
          :disable="isUnreadable"
        ></q-btn>
      </q-card-section>
      <q-scroll-area style="height: calc(100vh - 240px);">
        <q-infinite-scroll @load="onLoad" :offset="100">
          <q-list>
            <q-item
              clickable
              v-ripple
              v-for="(d, i) in notifikasi"
              :key="i"
              :class="{ 'bg-blue-1': d.is_read == 'N' }"
              @click="showData(d)"
              class="cursor-pointer"
            >
              <q-item-section top avatar>
                <q-avatar color="primary" text-color="white">{{
                  d.username[0].toUpperCase()
                }}</q-avatar>
              </q-item-section>

              <q-item-section>
                <q-item-label>{{ d.name }}</q-item-label>
                <q-item-label caption lines="2">{{ d.notif }}</q-item-label>
              </q-item-section>

              <q-item-section side top>
                <q-item-label caption>{{
                  d.create_at | moment("DD MMM YYYY")
                }}</q-item-label>
              </q-item-section>
            </q-item>
          </q-list>
          <template v-slot:loading>
            <div class="row justify-center q-my-md">
              <q-spinner-dots color="primary" size="40px" />
            </div>
          </template>
        </q-infinite-scroll>
      </q-scroll-area>
    </q-card>

    <q-dialog
      v-model="show"
      persistent
      transition-show="scale"
      transition-hide="scale"
    >
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
              <q-item-label caption
                >Notif from: {{ selected.name }}</q-item-label
              >
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
      selected: {},
      status: "ALL",
      stopfetch: false,
    };
  },
  mounted() {},
  computed: {
    isUnreadable() {
      let count = this.notifikasi.filter((el) => el.is_read == "N");
      if (count.length > 0) return false;
      else return true;
    },
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
        is_read: "Y",
      };
      this.selected.is_read = "Y";

      this.$http.put("/notifikasi/" + val.notif_id, data, {}).then((result) => {
        this.$root.$emit("notifikasi");
      });
    },
    async markAll() {
      for (var i = 0; i < this.notifikasi.length; i++) {
        let data = {
          is_read: "Y",
        };
        await this.$http
          .put("/notifikasi/" + this.notifikasi[i].notif_id, data, {})
          .then(async (result) => {
            this.notifikasi[i].is_read = "Y";
            if (i + 1 == this.notifikasi.length)
              await this.$root.$emit("notifikasi");
          });
      }
    },
    async onLoad(index, done) {
      await this.getNotif();
      done();
    },
    async getNotif() {
      if (this.stopfetch) {
        return;
      }
      let last_id = "";
      if (this.notifikasi.length > 0) {
        last_id = this.notifikasi[this.notifikasi.length - 1].notif_id;
      }
      await this.$http
        .get(
          `/notifikasi/${this.$store.state.currentUser.user_id}/${this.status}/${last_id}`,
          {}
        )
        .then((result) => {
          if (result.data.length == 0) {
            this.stopfetch = true;
          }
          this.notifikasi = this.notifikasi.concat(result.data);
        });
    },
  },
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
