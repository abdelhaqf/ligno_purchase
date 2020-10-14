<template>
  <div class="">
    <div class="row q-pa-md">
      <q-select class="col-4" 
       outlined dense
       v-model="selectOption" :options="option" 
       map-options emit-value label="Product"
       @input="change()"
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
           <td>{{setCurrency(p.price, p.currency)}} / {{p.unit}}</td>
           <td>{{p.qty}}</td>
         </tr>
       </tbody>
     </q-markup-table>
  </div>
</template>

<script>

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
    change(val){
      this.$http.get('/pricelist/' + this.selectOption, {})
      .then (result => {
        this.priceList = result.data
      })
    },
    setCurrency(price, cur) {
      if(cur == 'IDR'){
        const formatter = new Intl.NumberFormat('ID', {
          style: 'currency',
          currency: 'IDR',
          currencyDisplay: "symbol",
          minimumFractionDigits: 0
        })
        return formatter.format(price)
      }
      else if (cur == 'USD'){
        const formatter = new Intl.NumberFormat('US', {
          style: 'currency',
          currency: 'USD',
          currencyDisplay: "symbol",
          minimumFractionDigits: 2
        })
        return formatter.format(price)
      }
    },
    
  }
};
</script>

<style lang="scss" scoped></style>
