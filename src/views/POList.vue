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
          <tr v-for="d in dummy" :key="d.id">
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
      dummy: [
        {
          id: 1,
          select: false,
          po_id: 'PO/LSC/IX/0166',
          po_date: moment().format("YYYY/MM/DD"),
          name: "Wildan Abror Firdausy",
          vendor: "PT Swadaya Bersama",
          total_price: "Rp 2.400.000",
          is_received: "Half Received",
        },
        {
          id: 2,
          select: false,
          po_id: 'PO/LSC/IX/0167',
          po_date: moment().format("YYYY/MM/DD"),
          name: "Mansyur Ola Kopon",
          vendor: "PT Inti Eka Prama",
          total_price: "Rp 35.900.000",
          is_received: "Fully Received",
        },
      ],
    };
  },
};
</script>

<style lang="scss" scoped></style>
