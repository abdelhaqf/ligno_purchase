<template>
  <div class="row">
    <div class="col-12">
      <div class="q-pa-md q-gutter-md">
        <q-btn color="primary" label="Buat PO" />
        <q-btn label="Detail" />
      </div>
      <q-markup-table separator="cell"  flat square>
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
              <q-checkbox v-model="d.select" />
            </td>
            <td>
              {{ d.name }} <q-chip color="teal" text-color="white" dense size="sm">{{ d.department }}</q-chip>
            </td>
            <td>{{ d.create_at }}</td>
            <td>{{ d.item }}</td>
            <td>{{ d.qty }}</td>
            <td>{{ d.deadline }}</td>
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
};
</script>

<style lang="scss" scoped></style>
