<template>
    <v-dialog
        v-model="mostrar"
        persistent
        max-height="800px"
        max-width="800px"
    >
        <v-card>
            <v-card-title>Formulario {{ this.editarEndereco ?  "Editar": "Cadastrar" }} Endereços</v-card-title>
            <v-form
                lazy-validation
                v-model="valido"
                ref="form"
            >
                <v-container>
                    <v-row>
                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="CEP"
                                v-model="cep"
                                v-mask="'########'"
                                required
                            >
                            </v-text-field>
                        </v-col>

                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Estado"
                                v-model="estado"
                                :rules="estadoRules"
                                oninput="if(this.value.length > 2) this.value = this.value.slice(0, 2).toUpperCase();"
                                blur="if(this.value.length > 2) this.value = this.value.slice(0, 2).toUpperCase();"
                                required
                            >
                            </v-text-field>
                        </v-col>
                        
                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Cidade"
                                v-model="cidade"
                                :rules="cidadeRules"
                                required
                            >
                            </v-text-field>
                        </v-col>

                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Rua"
                                v-model="endereco"
                                :rules="padraoRules"
                                required
                            >
                            </v-text-field>
                        </v-col>

                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Bairro"
                                v-model="bairro"
                                :rules="padraoRules"
                                required
                            >
                            </v-text-field>
                        </v-col>

                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Complemento"
                                v-model="complemento"
                                :rules="padraoRules"
                                required
                            >
                            </v-text-field>
                        </v-col>
            
                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Numero"
                                v-model="numero"
                                required
                            >
                            </v-text-field>
                        </v-col>
                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Nome"
                                v-model="nome_end"
                                :rules="padraoRules"
                                required
                            >
                            </v-text-field>
                        </v-col>
                        
                        <v-col
                            cols="12"
                        >
                            <v-text-field
                                label="Telefone do Endereço"
                                v-model="tel_end"
                                :rules="padraoRules"
                                v-mask="'(##) # ####-####'"
                                required
                            >
                            </v-text-field>
                        </v-col>

                        <v-card-actions>
                            <v-btn
                                text
                                @click="fecharFormulario"
                            >
                                Cancelar
                            </v-btn>
                            
                            <v-btn
                                
                                v-if="this.editarEndereco"
                                :disabled="!valido"
                                @click="validate()"
                            >
                                <!-- @click="editarFormulario" -->
                                Salvar
                            </v-btn>
                            
                            <v-btn
                                v-else
                               :disabled="!valido"
                               @click="validate()"
                            >
                                <!-- @click="enviarFormulario" -->
                                Cadastrar
                            </v-btn>
                        </v-card-actions>
                    </v-row>
                </v-container>
            </v-form>
        </v-card>
    </v-dialog>
</template>

<script>
import axios from 'axios'

export default {
    name: "FormularioEndereco",

    data: () => ({
            
            valido: true,
            cep: '',
            estado: '',
            cidade: '',
            bairro: '',
            endereco: '',
            numero: '',
            tel_end: '',
            nome_end: '',
            complemento: '',

            chave: null,
            estadoRules: [
                v => (v.length == 2) || "Estado Invalido"
            ],

            cidadeRules: [
                v => (v.length > 3) || "Cidade Desconhecida"
            ],
            
            padraoRules: [
                v => (v.length > 0) || "Campo Obrigatorio"
            ],
        
    }),

    methods: {
        fecharFormulario () {
            this.$emit("fechar-formulario", false)
        },

        async enviarFormulario () {
            await axios.post(`https://feijones.azurewebsites.net/api/clienteendereco/${this.chave}`, {
                nome_end: this.nome_end,
                tel_end: this.tel_end.replace(/[^A-Z0-9]/ig, ""),
                cep: this.cep,
                endereco: this.endereco,
                numero: this.numero,
                complemento: this.complemento,
                bairro: this.bairro,
                cidade: this.cidade,
                estado: this.estado,
            }).then(() => {
                this.atualizarLista()
                this.fecharFormulario()
            }
            )
            .catch(() => {
                this.atualizarLista()
                this.fecharFormulario()
            })
        },

        async editarFormulario () {
            await axios.put(`https://feijones.azurewebsites.net/api/endereco/${this.enderecoDados.iD_end}`, { 
                iD_cliente: +this.enderecoDados.iD_cliente,
                nome_end: this.nome_end,
                tel_end: this.tel_end.replace(/[^A-Z0-9]/ig, ""),
                cep: this.cep,
                endereco: this.endereco,
                numero: this.numero,
                complemento: this.complemento,
                bairro: this.bairro,
                cidade: this.cidade,
                estado: this.estado
            }).then(() => {
                this.atualizarListaEditada()
                this.fecharFormulario()
            }
            )
        },

        atualizarLista () {
            console.log("a" + this.enderecoDados)
            this.$emit("atualizar-lista", this.id_cliente, false)
        },

         atualizarListaEditada () {
            this.$emit("atualizar-lista-atualizada", this.enderecoDados.iD_cliente)
        },

        validate () {
            console.log(typeof(this.editarEndereco))
            this.$refs.form.validate()

            if (this.editarEndereco  && this.$refs.form.validate()){
                this.editarFormulario()
            } else if ((this.editarEndereco === false) && this.$refs.form.validate()){
                this.enviarFormulario()
            }
        },

    },



    props: {
        cpf_cnpj: {
            type: String,
            required: true
        },

        mostrar: {
            type: Boolean,
            required: true
        },

        id_cliente: {
            type: Number,
            required: true
        },

        editarEndereco : {
            type: Boolean,
        },

        enderecoDados: {
            type: Object
        }
    },

    mounted () {
        if(this.editarEndereco) {
            this.cep = this.enderecoDados.cep
            this.estado = this.enderecoDados.estado
            this.cidade = this.enderecoDados.cidade
            this.bairro = this.enderecoDados.bairro
            this.endereco = this.enderecoDados.endereco
            this.numero = this.enderecoDados.numero
            this.tel_end = this.enderecoDados.tel_end
            this.nome_end = this.enderecoDados.nome_end
            this.complemento = this.enderecoDados.complemento
        }

        this.chave = this.cpf_cnpj

        console.log(this.cpf_cnpj, this.id_cliente, this.editarEndereco, this.enderecoDados)
    }
}
</script>