<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn label="Update" />
      </div>
      <q-markup-table separator="cell"  flat square dense>
        <thead class="bg-green text-white">
          <tr>
            <th style="width:10px;"></th>
            <th>PO Number</th>
            <th>PO Date</th>
            <th>Handle By</th>
            <th>Vendor</th>
            <th>value</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="d in poList" :key="d.id">
            <td>
              <q-checkbox v-model="d.select" />
            </td>
            <td>
              {{ d.po_id }} <q-chip color="teal" text-color="white" dense size="sm">{{ d.is_received }}</q-chip>
            </td>
            <td>{{ d.po_date }}</td>
            <td>{{ d.name }}</td>
            <td>{{ d.vendor }}</td>
            <td>{{ d.total_price }}</td>
          </tr>
        </tbody>
      </q-markup-table>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from "moment";
export default {
  data() {
    return {
      poList: [],
    };
  },
  mounted(){
    this.fetchData()

  },
  methods:{
    fetchData(){
      this.poList = []
      this.$http.get('/po', {})
      .then (result => {
        for(var i = 0; i < result.data.length;i++){

          result.data[i].select = false
          this.poList.push(result.data[i])
        }
      })
    },
    
  }
};
</script>

<style lang="scss" scoped></style>
