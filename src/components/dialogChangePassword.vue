<template>
    <q-dialog ref="dialog" @hide="onDialogHide" persistent>
        <q-card
            class="q-dialog-plugin my-font"
            style="min-width: 200px; max-height: 90vh;"
        >
            <q-card-section class="q-py-sm row justify-between items-center">
                <div class="text-h6 text-weight-bold">Ubah Password</div>
                <q-btn
                    flat
                    dense
                    icon="close"
                    @click="onCancelClick"
                />
            </q-card-section>
            <q-separator/>
            <q-card-section class="column q-gutter-y-md">
                <div>
                    <div>Password Saat Ini :</div>
                    <q-input
                    ref="pass"
                    outlined
                    v-model="password"
                    placeholder="Masukkan Password Saat Ini"
                    dense
                    @keyup.enter="$refs.pass2.focus()"
                    autofocus
                    class="q-mt-xs bg-white"
                    :type="isPwdPass ? 'password' : 'text'"
                    >
                        <template v-slot:append>
                            <q-icon
                            :name="isPwdPass ? 'visibility_off' : 'visibility'"
                            class="cursor-pointer"
                            @click="isPwdPass = !isPwdPass"
                            />
                        </template>
                    </q-input>
                </div>

                <div>
                    <div>Password Baru :</div>
                    <q-input
                    ref="pass2"
                    outlined
                    v-model="newPassword"
                    placeholder="Masukkan Password Baru"
                    dense
                    @keyup.enter="$refs.pass3.focus()"
                    class="q-mt-xs bg-white"
                    :type="isPwdNew ? 'password' : 'text'"
                    >
                        <template v-slot:append>
                            <q-icon
                            :name="isPwdNew ? 'visibility_off' : 'visibility'"
                            class="cursor-pointer"
                            @click="isPwdNew = !isPwdNew"
                            />
                        </template>
                    </q-input>
                </div>
                
                <div>
                    <div>Konfirmasi Password Baru :</div>
                    <q-input
                    ref="pass3"
                    outlined
                    v-model="confirmPassword"
                    placeholder="Masukkan Ulang Password Baru"
                    dense
                    @keyup.enter="changePass"
                    class="q-mt-xs bg-white"
                    :type="isPwdConfirm ? 'password' : 'text'"
                    >
                        <template v-slot:append>
                            <q-icon
                            :name="isPwdConfirm ? 'visibility_off' : 'visibility'"
                            class="cursor-pointer"
                            @click="isPwdConfirm = !isPwdConfirm"
                            />
                        </template>
                    </q-input>
                </div>
                <div v-if="showError" class="text-red">
                    {{ errorText }}
                </div>
            </q-card-section>
            <q-card-actions>
                <q-btn
                    no-caps
                    unelevated
                    label="Simpan"
                    color="primary"
                    class="l-grow q-mx-sm"
                    @click="changePass"
                />
            </q-card-actions>
        </q-card>
    </q-dialog>
</template>

<script>
import md5 from "md5";
export default {
    data() {
        return {
            password: "",
            isPwdPass: true,
            newPassword: "",
            isPwdNew: true,
            confirmPassword: "",
            isPwdConfirm: true,
            showError: false,
            errorText: "",
        };
    },
    async mounted() {},
    computed: {
        curUser() {
            if (this.$route.meta.currentUser) {
                return this.$route.meta.currentUser;
            }
            return false;
        },
    },
    methods: {
        show() {
            this.$refs.dialog.show();
        },
        hide() {
            this.$refs.dialog.hide();
        },

        onDialogHide() {
            this.$emit("hide");
        },

        onOKClick() {
            this.$emit("ok");
            this.hide();
        },

        onCancelClick() {
            this.hide();
        },
        async changePass(){
            if(this.newPassword == this.confirmPassword && this.newPassword != ""){
                var usr = {};
                usr.username = this.curUser.username;
                usr.password = md5(this.password);

                confirm = true;
                await this.$http
                    .post("/login", usr, {})
                    .then(async (result) => {
                    console.log(result.status);
                })
                .catch((err) => {
                    this.showError = true;
                    this.errorText = "Password Saat Ini Salah!"
                    confirm = false
                });

                if (confirm) {
                    let data = {
                        id: this.curUser ? this.curUser.user_id : "",
                        newPass: md5(this.newPassword)
                    }
                    await this.$http.put("/change_password", data, {}).then((result) => {
                        this.onOKClick();
                        this.$q.notify({ message: "Ubah Password Berhasil!", color: "positive" });
                    }).catch((err) => {
                        this.$q.notify({ message: "Ubah Password Gagal!", color: "negative" });
                    });
                }
                
            } else {
                this.showError = true;
                this.errorText = "Password Konfirmasi Salah atau Kolom Masukkan Password Baru Masih Kosong"
            }
        },
    }
}

</script>