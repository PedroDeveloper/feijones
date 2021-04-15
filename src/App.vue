<template>
  <v-app>
    <v-sheet>
      <v-card class="overflow-hidden">
        <v-toolbar
          dark
          color="indigo"
        >
          <v-app-bar-nav-icon @click="drawer = true" class="hidden-md-and-up" ></v-app-bar-nav-icon>
          <v-toolbar-title><p class="logo"><a href="/">Feijones</a></p></v-toolbar-title>
        
          

          <!-- TODO: REMOVER ISSO SM-AND-DOWN -->
          <template v-slot:extension> 
          
            <v-tabs
              class="hidden-sm-and-down"
              v-model="tab"
              align-with-title
              
            >
            <v-tab
                v-for="(item, index) in items"
                :key="index"
                :to="{ path: item.path}"
              >
                <!-- TODO: Deixar essa linha dinamica e automatica -->
                {{ item.name }}
              </v-tab>
            </v-tabs>
          </template>
        </v-toolbar>
      </v-card>
      <v-navigation-drawer v-model="drawer"
            temporary
            absolute
            :width=200
            left
            
        >
            <v-list
              nav
              dense
            >
              <v-list-item-group>

                 <v-list-item to="/">
                  <v-list-item-icon>
                    <v-icon>mdi-home</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Inicio</v-list-item-title>
                </v-list-item>
            


                <v-list-item to="/cadastrar">
                  <v-list-item-icon>
                    <v-icon>mdi-account-multiple-plus</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Cadastrar Clientes</v-list-item-title>
                </v-list-item>
            

                <v-list-item to="/listar">
                  <v-list-item-icon>
                    <v-icon>mdi-magnify</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Visualizar Clientes</v-list-item-title>
                </v-list-item>
          </v-list-item-group>
        </v-list>
        </v-navigation-drawer> 
    
      <v-main>
        
        <router-view></router-view>
      </v-main>
    </v-sheet>
  </v-app>
  
</template>

<script>

export default {
  name: 'App',

  components: {
  },

  data: () => ({
    drawer: false,
    tab: null,
    items: [
      {
        name: "Inicio",
        path: "/"
      },

      {
        name: 'Cadastrar Clientes',
        path: '/cadastrar'
      },

      {
        name: "Visualizar Clientes",
        path: '/listar'
      },

    ],
    //
  }),

  methods: {



    home() {
      this.$router.push({ name: 'Home' })
    }
  }
};
</script>

<style>
  .logo a {
    cursor: pointer;
    position: relative;
    text-decoration: none;
    color: white !important;
    top: 7px;
  }
  .router-link-v-tab {
    text-decoration: none;
    color: white !important;
  }
</style>
