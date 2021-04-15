import Vue from 'vue'
import VueRouter from 'vue-router'
import Home from '../views/Home.vue'
import Cadastro from '../views/Cadastro.vue'
import ListarClientes from '../views/ListarClientes.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'Home',
    component: Home
  },
  {
    path: '/cadastrar',
    name: "Cadastro Cliente",
    component: Cadastro
  },

  {
    path: "/listar",
    name: "Listar Clientes",
    component: ListarClientes,
  }

]

const router = new VueRouter({
  routes
})

export default router
