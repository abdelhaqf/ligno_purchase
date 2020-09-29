<template>
  <div class="">
    <div class="row q-pa-md">
      <q-select class="col-4" outlined v-model="selectOption" :options="option" label="Product" dense />
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
      option: ['Sodium Bikarbonat', 'Pasir Jambi', 'TEGO-SMO', 'Crude Palm Oil'],
      selectOption: null,
      priceList: [
        {
          id: 1,
          product: 'Crude Palm Oil',
          price: 'Rp 23.000',
          unit: 'liter',
          po_id: 'PO/20/IX/003',
          po_date: '9 Sept 2020',
          vendor: 'PT Mitra Utama',
          qty: '2.300 liter'
        },
        {
          id: 2,
          product: 'Crude Palm Oil',
          price: 'Rp 22.000',
          unit: 'liter',
          po_id: 'PO/20/X/033',
          po_date: '21 Aug 2020',
          vendor: 'PT Kurnia Raya',
          qty: '2.300 liter'
        },
        {
          id: 3,
          product: 'Crude Palm Oil',
          price: 'Rp 26.000',
          unit: 'liter',
          po_id: 'PO/20/IX/053',
          po_date: '19 Aug 2020',
          vendor: 'PT Mitra Utama',
          qty: '1.000 liter'
        }
      ]
    };
  },
  mounted(){

  },
  methods:{
    
  }
};
</script>

<style lang="scss" scoped></style>
