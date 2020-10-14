<template>
  <div class="row">
    <div class="col-6">
      <div class="bg-green text-white text-h6 q-pa-md">SPP Baru</div>
      <div class="q-pa-md q-gutter-md ">
        <q-input outlined v-model="spp.item" label="Item" stack-label v-if="showInput" dense >
          <template v-slot:append>
            <q-btn round dense flat icon="arrow_drop_down" no-caps @click="showInput = !showInput" />
          </template>
        </q-input>
        <q-select class="col-4" v-else
          outlined dense stack-label
          v-model="spp.item" :options="option" 
          map-options emit-value label="Item"
          >
          <template v-slot:option="scope">
            <q-item
              v-bind="scope.itemProps"
              v-on="scope.itemEvents"
            >
              <q-item-section class="text-grey text-italic" v-if="scope.opt.value == ''" @click="test()"  >
                {{scope.opt.label}}
              </q-item-section>
              <q-item-section v-else >
                {{scope.opt.label}}
              </q-item-section>
            </q-item>
          </template>
        </q-select>

        <div>
          <div class="row q-col-gutter-sm">
            <q-input type="number" class="col-7" outlined v-model="spp.qty" label="Qty" stack-label dense />
            <q-input class="col-5" outlined v-model="spp.unit" label="Unit" stack-label dense />
          </div>
        </div>
        <q-input outlined v-model="spp.deadline" label="Deadline" stack-label dense readonly />
        <q-date v-model="spp.deadline" minimal :options="limitDate" />
        <q-input outlined v-model="spp.description" label="Description" stack-label dense type="textarea" />
        <div class="q-gutter-md row justify-end">
          <q-btn color="primary" label="Submit" @click="createSPP()" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// @ is an alias to /src
import moment from "moment";

export default {
  data() {
    return {
      spp: {
        deadline: moment()
          .add(1, "days")
          .format("YYYY/MM/DD"),
      },
      showInput: false,
      option: [],
    };
  },
  mounted(){
      this.$http.get('/list_item', {})
      .then (result => {
        this.option = result.data
        this.option.unshift({
          value: '',
          label: ' input baru'
        })
      })
  },
  methods: {
    test(){
      console.log('tes masuk');
      this.showInput = true
    },
    limitDate(date) {
      return date >= moment().format("YYYY/MM/DD");
    },
    createSPP(){
      this.spp.user_id = this.$store.state.currentUser.user_id
      this.$http.post('/new_spp', this.spp, {})
      .then (result => {
        this.spp = {
          deadline: moment()
            .add(1, "days")
            .format("YYYY/MM/DD"),
        }
        this.spp = result.data
        this.$q.notify('SPP Berhasil Dibuat!')
      })
    }
  },
};
</script>

<style lang="scss" scoped>
.align-right {
  justify-content: flex-end;
}
</style>
