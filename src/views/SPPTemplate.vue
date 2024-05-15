<template>
  <div class="row relative q-px-lg ">
    <q-card flat square class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-center"
        ><q-btn label="add template" @click="showDialogTemplate(null)"></q-btn>
      </q-card-section>

      <!-- table  -->
      <q-markup-table class="stickyTable" style="height: calc(100vh - 320px);">
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th style="width:25px;">No</th>
            <th>Nama</th>
            <th>Item</th>
            <th>Note</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody v-if="template.length" separator="horizontal">
          <tr v-for="(d, index) in template" :key="index">
            <td class="text-center">
              {{ index + 1 }}
            </td>
            <td class="text-left l-grow">{{ d.name }}</td>
            <td class="text-center">
              <div v-for="(item, i) in d.details" :key="i" class="">
                <div>{{ item.item }} ({{ item.qty }} {{ item.unit }})</div>
              </div>
            </td>
            <td>
              <div class="l-wrap-cell">
                <span>
                  {{ d.notes.length > 70 ? d.notes.slice(0, 63) : d.notes }}
                </span>
                <span v-if="d.notes.length > 70" class=" no-wrap ">
                  ...
                  <q-tooltip
                    content-style="width:300px"
                    content-class="l-text-detail bg-white text-black shadow-2"
                    >{{ d.notes }}</q-tooltip
                  >
                </span>
              </div>
            </td>
            <td class="text-center">
              <q-btn
                flat
                no-caps
                label="Detail"
                color="primary"
                @click="showDialogTemplate(d.id)"
              ></q-btn>
              <q-btn
                flat
                no-caps
                label="Delete"
                color="negative"
                @click="deleteTemplate(d)"
              ></q-btn>
            </td>
          </tr>
        </tbody>
        <tbody v-else class="bg-green-1">
          <tr>
            <td class="text-center text-grey" colspan="99">tidak ada data</td>
          </tr>
        </tbody>
      </q-markup-table>
    </q-card>
  </div>
</template>
<script>
import dialogAddTemplate from "../components/dialogAddTemplate.vue";
export default {
  data() {
    return {
      template: [],
    };
  },
  mounted() {
    this.fetchData();
  },
  methods: {
    async fetchData() {
      this.template = [];
      this.$http.get(`/template_list`, {}).then((result) => {
        for (var i = 0; i < result.data.length; i++) {
          this.template.push(result.data[i]);
        }
      });
    },
    showDialogTemplate(id) {
      console.log("called");
      this.$q.dialog({
        component: dialogAddTemplate,
        parent: this,
        id_template: id,
      })
      .onOk(() => {
          this.fetchData();
        })
      ;

      
    },
    deleteTemplate(item) {
      this.$http.put("/inactivate_template", item, {}).then((result) => {
        this.fetchData();
      });
    },
  },
};
</script>
