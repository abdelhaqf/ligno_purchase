<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Setuju" />
        <q-btn label="Tolak" />
        <q-btn label="Detail" :disabled="selectCount != 1" @click="showDetail = true" />
      </div>
      <q-markup-table flat square dense>
        <thead class="bg-green text-white">
          <tr>
            <th style="width:10px;"></th>
            <th>user</th>
            <th>date</th>
            <th>item</th>
            <th>qty</th>
            <th>deadline</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="d in dummy" :key="d.id">
            <td>
              <q-checkbox v-model="d.select" dense />
            </td>
            <td>
              {{ d.name }} <q-chip color="grey-7" text-color="white" dense size="sm">{{ d.department }}</q-chip>
            </td>
            <td>{{ d.create_at }}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }}</td>
            <td>{{ d.deadline }}</td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>

    <q-dialog v-model="showDetail" persistent transition-show="flip-down" transition-hide="flip-up">
      <q-card >
        <q-bar class="bg-primary text-white">
          <div>SPP 09/20/003</div>

          <q-space />

          <q-btn dense flat icon="close" v-close-popup>
            <q-tooltip>Close</q-tooltip>
          </q-btn>
        </q-bar>
        <q-card-section class="">
          <q-list>
            <q-item>
              <q-item-section>
                <q-item-label caption>Requester</q-item-label>
                <q-item-label>Wildan</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Request Date</q-item-label>
                <q-item-label>21 Sept 2020</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Deadline</q-item-label>
                <q-item-label>24 Sept 2020</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Item</q-item-label>
                <q-item-label>2 buah Rompi Untuk Trial</q-item-label>
              </q-item-section>
            </q-item>
            <q-item>
              <q-item-section>
                <q-item-label caption>Description</q-item-label>
                <q-item-label
                  >Untuk Keperluan trial di Surabaya, Wildan dan Roni, permintaan dokumentasi yang lebih baik, hasil
                  rapat Maret 2020</q-item-label
                >
              </q-item-section>
            </q-item>
          </q-list>
        </q-card-section>
        <q-card-actions align="right">
          <q-btn flat label="Tolak" color="primary" v-close-popup />
          <q-btn flat label="Setuju" color="primary" v-close-popup />
        </q-card-actions>
      </q-card>
    </q-dialog>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from "moment";
export default {
  data() {
    return {
      showDetail: false,
      spp: [],
      selected: {},
      dummy: [
        {
          id: 1,
          select: false,
          name: "Abdel Haq Firdausy",
          department: "Marketing",
          create_at: moment().format("YYYY/MM/DD"),
          item: "rompi untuk trial",
          qty: "2",
          deadline: moment()
            .add(3, "days")
            .format("YYYY/MM/DD"),
        },
        {
          id: 2,
          select: false,
          name: "Ahmad Darmawansyah",
          department: "Accounting",
          create_at: moment()
            .add(1, "days")
            .format("YYYY/MM/DD"),
          item: "Materai Rp 10.000",
          qty: "30",
          deadline: moment()
            .add(5, "days")
            .format("YYYY/MM/DD"),
        },
      ],
    };
  },
  mounted() {},
  methods: {
    getSPP() {
      this.$http.get("/spp", {}).then((result) => {
        this.spp = result.data;
      });
    },
  },
  computed:{
    selectCount(){
      var data = this.spp.filter(e => e.select === true)
      var count = data.length

      if(data[0])
        this.selected = data[0]

      return count
    }

  }
};
</script>

<style lang="scss" scoped></style>
