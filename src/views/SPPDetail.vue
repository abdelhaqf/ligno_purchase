<template>
  <div class="row relative">

  </div>
</template>

<script>
// @ is an alias to /src
import moment from "moment";
export default {
  data() {
    return {
      spp:{},
      id: '',
      alert: false,
      
    };
  },
  mounted(){
    this.fetchData()
  },
  methods:{
    fetchData(){
      this.id = this.$route.params.id

      this.$http.get('/spp_byid/' + this.id, {})
      .then (result => {
        this.spp = result.data
      })
    },

  }
};
</script>

<style lang="scss" scoped>
.container{
  width: 100%; height: 100%;
  background-color: white;
  position: absolute;
  z-index: 1000;
  left: 0px; top: 0px;
}

table{

}
</style>
