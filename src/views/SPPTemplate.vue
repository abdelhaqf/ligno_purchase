<template>
  <div class="row relative q-px-lg ">
    <q-card flat square class="col-12 bg-white rounded-borders">
      <q-card-section class="row justify-center"
        ><q-btn label="add template" @click="showDialogTemplate(null)"></q-btn
      ></q-card-section>
    </q-card>
  </div>
</template>
<script>
import dialogAddTemplate from "../components/dialogAddTemplate.vue";
export default {
  data() {
    return {};
  },
  mounted() {},
  methods: {
    showDialogTemplate(id) {
      console.log("called");
      this.$q.dialog({
        component: dialogAddTemplate,
        parent: this,
        id_template: id,
      });
    },
  },
};
</script>
