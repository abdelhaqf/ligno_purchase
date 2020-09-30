<template>
  <div class="">
    <div class="row q-pa-md">
      <q-select class="col-4" 
       outlined dense
       v-model="selectOption" :options="option" 
       map-options emit-value label="Product"
       @input="test()"
        />
    </div>
     <q-markup-table flat dense  square>
       <thead class="bg-green text-white">
         <th>PO</th>
         <th>PO Date</th>
         <th>Vendor</th>
         <th>Price</th>
         <th>Qty</th>
       </thead>
       <tbody>
         <tr v-for="p in priceList" :key="p.id">
           <td>{{p.po_id}}</td>
           <td>{{p.po_date}}</td>
           <td>{{p.vendor}}</td>
           <td>{{p.price}} / {{p.unit}}</td>
           <td>{{p.qty}}</td>
         </tr>
       </tbody>
     </q-markup-table>
  </div>
</template>

<script>
// @ is an alias to /src

export default {
  data() {
    return {
      option: [],
      selectOption: null,
      priceList: [],
    };
  },
  mounted(){
    this.fetchData()
  },
  methods:{
    fetchData(){
      this.$http.get('/list_item', {})
      .then (result => {
        this.option = result.data
      })
    },
    test(val){
      this.$http.get('/pricelist/' + this.selectOption, {})
      .then (result => {
        this.priceList = result.data
      })
    }
    
  }
};
</script>

<style lang="scss" scoped></style>
