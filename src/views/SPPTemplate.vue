<template>
  <div class="row relative q-px-lg ">
    <q-card flat square class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-between items-center">
        <div class="row q-gutter-x-md">
          <q-input
            outlined
            dense
            placeholder="Cari Nama Template"
            style="width: 300px;"
            v-model="searchTerm"
            @input="fetchData"
            clearable
            @clear="searchTerm = ''"
          >
          <template v-slot:prepend>
            <q-icon name="search" />
          </template>
          </q-input>
        </div>
        <q-btn 
          no-caps  
          unelevated
          color="primary" 
          label="Add Template" 
          @click="showDialogTemplate(null)">
        </q-btn>
      </q-card-section>

      <!-- table  -->
      <q-markup-table flat class="stickyTable" style="height: calc(100vh - 320px);">
        <thead class="bg-blue-grey-14 text-white">
          <tr>
            <th>No</th>
            <th>Nama</th>
            <th>Jumlah Item</th>
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
              <!-- <div v-for="(item, i) in d.details" :key="i" class="">
                <div>{{ item.item }} ({{ item.qty }} {{ item.unit }})</div>
              </div> -->
              <span>
                {{ d.details.length }} Item
                <q-tooltip
                    content-style="width:300px"
                    content-class="l-text-detail bg-white text-black shadow-2"
                    >
                     <div v-for="(item, i) in d.details" :key="i" class="">
                        <div>{{ item.item }} ({{ item.qty }} {{ item.unit }})</div>
                     </div>
                </q-tooltip>
              </span>
              
            </td>
            <td>
              <div class="l-wrap-cell" v-if="d.notes">
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
              <div v-else class="text-center">-</div>
            </td>
            <td class="text-center">
              <q-btn-dropdown flat dense dropdown-icon="more_horiz">
                <q-list>
                  <q-item
                    clickable
                    v-close-popup
                    @click="showDialogTemplate(d.id)">
                    Detail
                  </q-item>
                  <q-item
                   clickable
                    v-close-popup
                    @click="showDialogOrder(d.id)">
                    Order
                  </q-item>
                  <q-item
                    clickable
                    v-close-popup
                    @click="deleteTemplate(d)">
                    Delete
                  </q-item>
                </q-list>
              </q-btn-dropdown>
              
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
import dialogOrderTemplate from "../components/dialogOrderTemplate.vue";
export default {
  data() {
    return {
      template: [],
      searchTerm: null,
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
      this.$q.dialog({
        component: dialogAddTemplate,
        parent: this,
        id_template: id,
      })
      .onOk(() => {
          this.fetchData();
        });
    },
    showDialogOrder(id) {
      this.$q
        .dialog({
          component: dialogOrderTemplate,
          parent: this,
          id_template: id,
        })
        .onOk((val) => {
          console.log("OK was clicked on dialog: ", val);
        })
    },
    deleteTemplate(item) {
      this.$http.put("/inactivate_template", item, {}).then((result) => {
        this.fetchData();
      });
    },
  },
};
</script>
