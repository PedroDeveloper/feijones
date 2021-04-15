<template>

    <v-form
        v-model="valido"
        ref="form"
        lazy-validation
    >
        <v-container>

            
   <div class="text-center">
   
    <v-dialog
      v-model="dialog"
      hide-overlay
      persistent
      width="300"
      
    > 
    
     
    </v-dialog>
  </div>
            <v-row>

                <v-col
                    cols="12"
                >
                    <v-radio-group
                        v-model="cliente.tipo"
                        row
                    >
                        <v-radio
                            value="fisica"
                            label="Fisica"
                        ></v-radio>

                        <v-radio
                            value="jurudica"
                            label="Juridica"
                        ></v-radio>
                    </v-radio-group>
                </v-col>



                <v-col
                    cols="12"
                    md="6"
                >
                    <v-text-field
                        v-if="cliente.tipo === 'fisica'"
                        v-model="cliente.cpf"
                        v-mask="['###.###.###-##']"
                        label="CPF"
                        :rules="cpfRules"
                        required
                    ></v-text-field>

                    <v-text-field
                        v-else
                        v-model="cliente.cnpj"
                        v-mask="['##.###.###/####-##']"
                        label="CNPJ"
                        :rules="cnpjRules"
                        required
                    >
                    </v-text-field>
                </v-col>

                <v-col
                    cols="12"
                    md="6"
                >
                    <v-text-field

                        v-model="cliente.telefone"
                        label="Telefone"
                        v-mask="`(##) # ####-####`"
                        required
                        :rules="telefoneRules"
                        counter
                    ></v-text-field>            

                    
                </v-col>


                <v-col
                    cols="12"
                    md="6"
                >
                    <v-text-field
                         v-if="cliente.tipo === 'fisica'"
                        label="Nome"
                        required
                        :rules="nomeRules"
                        v-model="cadastroForm.nome"
                    >
                    ></v-text-field>
                    
                      <v-text-field
                        v-else
                        v-model="cliente.razaoSocial"
                        :rules="razaoSocialRules"
                        label="Razao Social"
                        required>
                    
                         </v-text-field>
                </v-col>

                <v-col
                    cols="12"
                    md="6"
                >
                    <v-text-field
                        label="Email"
                        :rules="emailRules"
                        required
                        v-model="cadastroForm.email"
                    ></v-text-field>
                </v-col>

                <v-col
                    cols="6"
                    sm="6"
                >
                    <v-btn
                        block
                        x-small
                        @click="limparCampos"
                    >
                        Apagar Campos
                    </v-btn>
                </v-col>
                
                <v-col
                    cols="6"
                    sm="6"
                >
                    <v-btn
                        submit  
                        block
                        x-small
                        @click="validate()"
                        :disabled="!valido"
                    >
                        Cadastrar Cliente
                    </v-btn>
                </v-col>

                <v-col
                    cols="6"
                    sm="6"
                >
                    <v-dialog
                        v-model="dialog"
                        persistent
                        max-width="330"
                    >

     <v-card
        color="primary"
        dark
      >
        <v-card-text>
          Atualizando dados..
        <v-progress-circular
            indeterminate
            color="white"
            class="mb-0"
          ></v-progress-circular>

         </v-card-text>
         </v-card>
                            <v-card>
                            <v-card-title center>{{ cadastroMensagem }}</v-card-title>
                            <v-card-actions>
                                <v-btn color="error" @click="fecharDialog()" text x-small>Cadastrar</v-btn>
                                <v-spacer></v-spacer>
                                <v-btn color="success" text x-small to="/listar">Visualizar Cadastros</v-btn>
                            </v-card-actions>
                        </v-card>

                    </v-dialog>
                </v-col>

            </v-row>
            
        </v-container>
    </v-form>

    
</template>

<script>
import axios from 'axios'




export default {
    name: "CadastrarCliente",

    data: () => ({
        valido: true,
        cadastroFeito: null,
        dialog: false,
         phone: "",
        

        cadastroForm: {
            nome: '',
            email: '',
        },
        cliente: {
            tipo: 'fisica',
            cpf: '',
            cnpj: '',
            telefone: '',
            razaoSocial: '',
        },

        emailRules: [
            v => /^\w+([.-]?\w+)*@\w+([.-]?\w+)*(\.\w{2,3})+$/.test(v) || "Insira um email válido"
        ],

        

        telefoneRules: [
            v => ((v.length === 0 || v.length === 16)) || "Digite um número válido"
        ],

        nomeRules: [
            v => v.length > 0 || "Insira um nome"
        ],

        cpfRules: [
            v => (v.length === 14) || "Insira um CPF valido"
        ],

        cnpjRules: [
             v => (v.length === 18) || "Insira um CNPJ valido"
        ],

        razaoSocialRules: [
            v => ( v.length === 0 || v.length >= 3 ) || "Insira uma Razão Social Valida"
        ]

    }),

    methods: {
        limparCampos () {
            this.cadastroForm = {
                nome: '',
                email: '',
            }
            this.cliente = {
                tipo: 'fisica',
                cpf: '',
                cnpj: '',
                telefone: '',
                razaoSocial: '',
            } 
         },
        
        validate() {
            this.$refs.form.validate()
            
            if(this.$refs.form.validate())
                this.cadastrarCliente()
        },

         async cadastrarCliente() {
             const dadosTratados = { ...this.cadastroForm, ...this.cliente,
                telefone: this.cliente.telefone.replace(/[^A-Z0-9]/ig, ""),
                cnpj: this.cliente.cnpj === "" ? null : this.cliente.cnpj.replace(/[^A-Z0-9]/ig, ""),
                cpf: this.cliente.cpf === "" ? null : this.cliente.cpf.replace(/\D/g, '')
            }

            console.log(dadosTratados)

            await axios.post('https://feijones.azurewebsites.net/api/cliente/', {
                Cpf: dadosTratados.cpf,
                Cnpj: dadosTratados.cnpj,
                Nome: dadosTratados.nome,
                RazaoSoci: dadosTratados.razaoSocial,
                Email: dadosTratados.email,
                Tel: dadosTratados.telefone
            }).catch(() => false)
                .then((res) => this.cadastroFeito = (res.status) ? true : false)

            this.limparCampos()

         },


         fecharDialog() {
             this.dialog = false
         }

    },

    computed: {

        cadastroMensagem() {
            
                return this.cadastroFeito ? "Cadastro Realizado" : "Houve um erro ao cadastrar."
            

            
        }
    },


    watch: {
        'cliente.tipo' () {
            if (this.cliente.tipo === 'fisica') {
                this.cliente.cnpj = ''
                this.cliente.razaoSocial = ''
            } else {
                this.cliente.cpf = ''
                this.cliente.telefone = ''
            }
        },
    
            dialog (val) {
        if (!val) return

        setTimeout(() => (this.dialog = false), 8000)
        },
        
       

       cadastroFeito () {
            this.dialog = !this.dialog
            console.log(this.dialog)
        }

    }
}
</script>