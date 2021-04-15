<template>
    <v-container>
        <h1>Clientes Cadastrados</h1>
        <v-expansion-panels
            multiple
            class="mt-3"
        >
            <v-expansion-panel
                v-for="(cliente, index) in clientesListados"
                :key="index"
            >
                <!-- TODO:
                    [] Ternary operator into computed
                        [] Nome Razao Social
                        [] CPF CNPJ
                 -->
                <v-expansion-panel-header>{{cliente.nome ? cliente.nome : cliente.razaoSoci}}</v-expansion-panel-header>
                <v-expansion-panel-content>{{ cliente.cpf ? "CPF: " : "CNPJ: "}}: {{ cliente.cpf ? cliente.cpf : cliente.cnpj }}</v-expansion-panel-content>
                <v-expansion-panel-content>Email:{{ cliente.email }}</v-expansion-panel-content>
                <v-expansion-panel-content>Telefone:{{ cliente.tel }}</v-expansion-panel-content>
                <v-expansion-panel-content>
                    <v-btn
                        @click="mostrarEnderecos(cliente.id, true)"
                    >
                        Mostrar Endereços
                    </v-btn>

                    <v-dialog
                        v-model="mostrarEndereco"
                        fullscreen
                        mix-width="300px"
                    >

                        <v-card>
                            <v-toolbar
                                dark
                                color="primary"
                            >
                                <v-toolbar-title>{{ cliente.nome ? cliente.nome : cliente.razaoSoci }} ({{ enderecoCliente.length}}) </v-toolbar-title>
                                <v-spacer></v-spacer>
                                <v-toolbar-items>
                                    <v-btn icon @click="mostrarEndereco = false">
                                        <v-icon>mdi-close</v-icon>
                                    </v-btn>
                                    <v-btn icon>
                                        <v-icon @click="mostrarForm">mdi-map-marker-plus</v-icon>
                                    </v-btn>
                                </v-toolbar-items>
                            </v-toolbar>


                            <!-- <v-dialog
                                v-model="mostrarFormulario"
                                persistent
                                @fechar-formulario="mostrarForm()"
                            > -->

                                <div v-if="mostrarFormulario">
                                    <FormularioEndereco 
                                        :cpf_cnpj="cliente.cpf ? cliente.cpf : cliente.cnpj"
                                        :mostrar="mostrarFormulario"
                                        :id_cliente="cliente.id"
                                        :editarEndereco="editarEndereco"
                                        :enderecoDados="editarEnderecoDados"
                                        @fechar-formulario="fecharFormulario"
                                        @atualizar-lista="mostrarEnderecos($event, false)"
                                        @atualizar-lista-atualizada="mostrarEnderecos($event, false)"
                                    />

                                </div>
                            <!-- </v-dialog> -->

                            <v-expansion-panels>

                                <v-expansion-panel 
                                    v-if="enderecoCliente.length === 0"
                                >Adicione um endereço clicando no icone. </v-expansion-panel>

                                <v-expansion-panel v-else
                                    v-for="endereco in enderecoCliente"
                                    :key="endereco.id"
                                >

                                    <v-expansion-panel-header>{{ endereco.endereco }}</v-expansion-panel-header>
                                    
                                    <v-expansion-panel-content>
                                        CEP: {{ endereco.cep }}
                                    </v-expansion-panel-content>
                                    
                                    <v-expansion-panel-content>
                                        Estado: {{ endereco.estado }}
                                    </v-expansion-panel-content>
                                    
                                    <v-expansion-panel-content>
                                        Cidade: {{ endereco.cidade }}
                                    </v-expansion-panel-content>
                                    
                                    <v-expansion-panel-content>
                                        Bairro: {{ endereco.bairro }}
                                    </v-expansion-panel-content>

                                    <v-expansion-panel-content>
                                        Complemento: {{ endereco.complemento }}
                                    </v-expansion-panel-content>

                                    <v-expansion-panel-content>
                                        Numero: {{ endereco.numero }}
                                    </v-expansion-panel-content>

                                     <v-expansion-panel-content>
                                        Nome: {{ endereco.nome_end }}
                                    </v-expansion-panel-content>

                                    <v-expansion-panel-content>
                                        Telefone: {{ endereco.tel_end }}
                                    </v-expansion-panel-content>

                                     <v-expansion-panel-content>
                                         <v-row>
                                             <v-col cols="6" md="12">
                                                <v-btn
                                                     @click="editarForm(endereco)"
                                                >
                                                    Editar
                                                </v-btn>
                                             </v-col>
                                            <v-col cols="6" md="12">
                                                <v-btn @click="deletarEndereco(endereco.iD_end, endereco.iD_cliente)">
                                                    Deletar
                                                </v-btn>
                                            </v-col>
                                         </v-row>
                                         
                                    </v-expansion-panel-content>
                                    
                                     <v-expansion-panel-content>
                                        
                                    </v-expansion-panel-content>


                                </v-expansion-panel>
                            </v-expansion-panels> 

                        </v-card>

                    </v-dialog>

                </v-expansion-panel-content>


            </v-expansion-panel>
        </v-expansion-panels>
    </v-container>
</template>

<script>
import axios from "axios"
import FormularioEndereco from './FormularioEndereco'

export default {
    name: "ListarClientes",
    

    data: () => ({
        clientesListados: null,
        mostrarEndereco: false,
        mostrarFormulario: false,
        editarEndereco: false,
        editarEnderecoDados: {},
        enderecoCliente: [],
    }),

    methods: {
        async buscarClientes () {
           let result = await axios.get('http://feijoneswebapi.azurewebsites.net/api/cliente/')
           this.clientesListados = result.data
        //    console.log(this.clientesListados)
        },

        async mostrarEnderecos (id, flag) {
            let result = await axios.get(`http://feijoneswebapi.azurewebsites.net/api/clienteendereco/${id}`)
            if (flag) {
                this.mostrarEndereco = !this.mostrarEndereco
                this.enderecoCliente = result.data
                console.log(this.enderecoCliente)
            } else {
                this.enderecoCliente = result.data
            }
            
        },

        async deletarEndereco (iD_end, iD_cliente) {
            await axios.delete(`http://feijoneswebapi.azurewebsites.net/api/endereco/${iD_end}`)
            this.mostrarEnderecos (iD_cliente)
        },

        mostrarForm() {
            this.mostrarFormulario = !this.mostrarFormulario
        },

        editarForm(endereco) {
            this.mostrarFormulario = !this.mostrarFormulario
            this.editarEndereco = !this.editarEndereco
            this.editarEnderecoDados = endereco
        },

        fecharFormulario (e) {
            this.mostrarFormulario = e
            this.editarEndereco = e
        }
    },

    mounted () {
        this.buscarClientes()
    },

    components: {
        FormularioEndereco
    }
}
</script>