<template>
  <div class="login">
    <el-form ref="loginRef" :model="loginForm" :rules="loginRules" class="login-form">
      <h3 class="title">{{ title }}</h3>
      <div class="login-mode-switch">
        <el-radio-group v-model="loginMode" size="small">
          <el-radio-button label="password">账号密码登录</el-radio-button>
          <el-radio-button label="sms">手机验证码登录</el-radio-button>
        </el-radio-group>
      </div>
      <el-form-item prop="username" v-if="loginMode === 'password'">
        <el-input
          v-model="loginForm.username"
          type="text"
          size="large"
          auto-complete="off"
          placeholder="账号"
        >
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="password" v-if="loginMode === 'password'">
        <el-input
          v-model="loginForm.password"
          type="password"
          size="large"
          auto-complete="off"
          placeholder="密码"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="password" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="phoneNumber" v-if="loginMode === 'sms'">
        <el-input
          v-model="loginForm.phoneNumber"
          type="text"
          size="large"
          auto-complete="off"
          placeholder="手机号"
        >
          <template #prefix><svg-icon icon-class="user" class="el-input__icon input-icon" /></template>
        </el-input>
      </el-form-item>
      <el-form-item prop="smsCode" v-if="loginMode === 'sms'">
        <el-input
          v-model="loginForm.smsCode"
          size="large"
          auto-complete="off"
          placeholder="短信验证码"
          style="width: 63%"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="login-code">
          <el-button
            size="large"
            type="primary"
            style="width: 100%;"
            :loading="smsSending"
            :disabled="smsCountdown > 0"
            @click="handleSendSms"
          >
            <span v-if="smsCountdown === 0">获取验证码</span>
            <span v-else>{{ smsCountdown }}秒后重试</span>
          </el-button>
        </div>
      </el-form-item>
      <el-form-item prop="code" v-if="captchaEnabled && loginMode === 'password'">
        <el-input
          v-model="loginForm.code"
          size="large"
          auto-complete="off"
          placeholder="验证码"
          style="width: 63%"
          @keyup.enter="handleLogin"
        >
          <template #prefix><svg-icon icon-class="validCode" class="el-input__icon input-icon" /></template>
        </el-input>
        <div class="login-code">
          <img :src="codeUrl" @click="getCode" class="login-code-img"/>
        </div>
      </el-form-item>
      <el-checkbox v-model="loginForm.rememberMe" style="margin:0px 0px 25px 0px;">记住密码</el-checkbox>
      <el-form-item style="width:100%;">
        <el-button
          :loading="loading"
          size="large"
          type="primary"
          style="width:100%;"
          @click.prevent="handleLogin"
        >
          <span v-if="!loading">登 录</span>
          <span v-else>登 录 中...</span>
        </el-button>
        <div style="float: right;" v-if="register">
          <router-link class="link-type" :to="'/register'">立即注册</router-link>
        </div>
      </el-form-item>
    </el-form>
    <!--  底部  -->
    <div class="el-login-footer">
      <span>Copyright © 2018-2025 ruoyi.vip All Rights Reserved.</span>
    </div>
  </div>
</template>

<script setup>
import { getCodeImg, sendSmsCode, checkSmsCode } from "@/api/login"
import Cookies from "js-cookie"
import { encrypt, decrypt } from "@/utils/jsencrypt"
import { setToken } from "@/utils/auth"
import useUserStore from '@/store/modules/user'

const title = import.meta.env.VITE_APP_TITLE
const userStore = useUserStore()
const route = useRoute()
const router = useRouter()
const { proxy } = getCurrentInstance()

const loginForm = ref({
  username: "admin",
  password: "admin123",
  rememberMe: false,
  code: "",
  uuid: "",
  phoneNumber: "",
  smsCode: ""
})

const loginMode = ref("password")

const loginRules = {
  username: [{
    validator: (rule, value, callback) => {
      if (loginMode.value === "password" && !value) {
        callback(new Error("请输入您的账号"))
      } else {
        callback()
      }
    },
    trigger: "blur"
  }],
  password: [{
    validator: (rule, value, callback) => {
      if (loginMode.value === "password" && !value) {
        callback(new Error("请输入您的密码"))
      } else {
        callback()
      }
    },
    trigger: "blur"
  }],
  code: [{
    validator: (rule, value, callback) => {
      if (loginMode.value === "password" && !value) {
        callback(new Error("请输入验证码"))
      } else {
        callback()
      }
    },
    trigger: "change"
  }],
  phoneNumber: [{
    validator: (rule, value, callback) => {
      if (loginMode.value === "sms" && !value) {
        callback(new Error("请输入手机号"))
      } else {
        callback()
      }
    },
    trigger: "blur"
  }],
  smsCode: [{
    validator: (rule, value, callback) => {
      if (loginMode.value === "sms" && !value) {
        callback(new Error("请输入短信验证码"))
      } else {
        callback()
      }
    },
    trigger: "blur"
  }]
}

const codeUrl = ref("")
const loading = ref(false)
const captchaEnabled = ref(true)
const register = ref(false)
const redirect = ref(undefined)
const smsSending = ref(false)
const smsCountdown = ref(0)
let smsTimer = null

watch(route, (newRoute) => {
    redirect.value = newRoute.query && newRoute.query.redirect
}, { immediate: true })

function handleLogin() {
  proxy.$refs.loginRef.validate(valid => {
    if (valid) {
      loading.value = true
      const doLogin = () => {
        if (loginForm.value.rememberMe) {
          Cookies.set("username", loginForm.value.username, { expires: 30 })
          Cookies.set("password", encrypt(loginForm.value.password), { expires: 30 })
          Cookies.set("rememberMe", loginForm.value.rememberMe, { expires: 30 })
        } else {
          Cookies.remove("username")
          Cookies.remove("password")
          Cookies.remove("rememberMe")
        }
        userStore.login(loginForm.value).then(() => {
          const query = route.query
          const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
            if (cur !== "redirect") {
              acc[cur] = query[cur]
            }
            return acc
          }, {})
          if (redirect.value) {
            router.push(redirect.value)
          } else {
            router.push({ path: "/", query: otherQueryParams })
          }
        }).catch(() => {
          loading.value = false
          if (captchaEnabled.value) {
            getCode()
          }
        })
      }

      if (loginMode.value === "sms") {
        checkSmsCode(loginForm.value.phoneNumber, loginForm.value.smsCode).then(res => {
          let data = null
          if (typeof res === "string") {
            try {
              data = JSON.parse(res)
            } catch (e) {
              data = null
            }
          } else {
            data = res
          }
          if (!data) {
            loading.value = false
            proxy.$modal.msgError("短信验证码验证失败")
            return
          }
          if (data.token) {
            setToken(data.token)
            userStore.token = data.token
            const query = route.query
            const otherQueryParams = Object.keys(query).reduce((acc, cur) => {
              if (cur !== "redirect") {
                acc[cur] = query[cur]
              }
              return acc
            }, {})
            if (redirect.value) {
              router.push(redirect.value)
            } else {
              router.push({ path: "/", query: otherQueryParams })
            }
            loading.value = false
            return
          }
          if (data.code === "OK" || data.code === 200) {
            doLogin()
            return
          }
          loading.value = false
          const message = data.message || "短信验证码验证失败"
          proxy.$modal.msgError(message)
        }).catch(() => {
          loading.value = false
        })
      } else {
        doLogin()
      }
    }
  })
}

function handleSendSms() {
  if (!loginForm.value.phoneNumber) {
    proxy.$modal.msgError("请输入手机号")
    return
  }
  if (smsCountdown.value > 0 || smsSending.value) {
    return
  }
  smsSending.value = true
  sendSmsCode(loginForm.value.phoneNumber).then(res => {
    smsSending.value = false
    let data = null
    if (typeof res === "string") {
      try {
        data = JSON.parse(res)
      } catch (e) {
        data = null
      }
    } else {
      data = res
    }
    if (data && data.code && data.code !== "OK") {
      const message = data.message || "验证码发送失败"
      proxy.$modal.msgError(message)
      return
    }
    proxy.$modal.msgSuccess("验证码发送成功")
    smsCountdown.value = 60
    smsTimer = setInterval(() => {
      if (smsCountdown.value > 0) {
        smsCountdown.value--
      }
      if (smsCountdown.value === 0 && smsTimer) {
        clearInterval(smsTimer)
        smsTimer = null
      }
    }, 1000)
  }).catch(() => {
    smsSending.value = false
  })
}

function getCode() {
  getCodeImg().then(res => {
    captchaEnabled.value = res.captchaEnabled === undefined ? true : res.captchaEnabled
    if (captchaEnabled.value) {
      codeUrl.value = "data:image/gif;base64," + res.img
      loginForm.value.uuid = res.uuid
    }
  })
}

function getCookie() {
  const username = Cookies.get("username")
  const password = Cookies.get("password")
  const rememberMe = Cookies.get("rememberMe")
  loginForm.value = {
    username: username === undefined ? loginForm.value.username : username,
    password: password === undefined ? loginForm.value.password : decrypt(password),
    rememberMe: rememberMe === undefined ? false : Boolean(rememberMe)
  }
}

getCode()
getCookie()
onUnmounted(() => {
  if (smsTimer) {
    clearInterval(smsTimer)
    smsTimer = null
  }
})
</script>

<style lang='scss' scoped>
.login {
  display: flex;
  justify-content: center;
  align-items: center;
  height: 100%;
  background-image: url("../assets/images/login-background.jpg");
  background-size: cover;
}
.title {
  margin: 0px auto 30px auto;
  text-align: center;
  color: #707070;
}

.login-form {
  border-radius: 6px;
  background: #ffffff;
  width: 400px;
  padding: 25px 25px 5px 25px;
  z-index: 1;
  .login-mode-switch {
    text-align: center;
    margin-bottom: 15px;
  }
  .el-input {
    height: 40px;
    input {
      height: 40px;
    }
  }
  .input-icon {
    height: 39px;
    width: 14px;
    margin-left: 0px;
  }
}
.login-tip {
  font-size: 13px;
  text-align: center;
  color: #bfbfbf;
}
.login-code {
  width: 33%;
  height: 40px;
  float: right;
  img {
    cursor: pointer;
    vertical-align: middle;
  }
}
.el-login-footer {
  height: 40px;
  line-height: 40px;
  position: fixed;
  bottom: 0;
  width: 100%;
  text-align: center;
  color: #fff;
  font-family: Arial;
  font-size: 12px;
  letter-spacing: 1px;
}
.login-code-img {
  height: 40px;
  padding-left: 12px;
}
</style>
