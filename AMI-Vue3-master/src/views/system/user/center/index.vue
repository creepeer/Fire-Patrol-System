<template>
  <div class="app-container">
    <el-row :gutter="20">
      <el-col :span="24">
        <el-card class="box-card">
          <template #header>
            <div class="clearfix">
              <span>个人中心信息</span>
            </div>
          </template>
          
          <el-tabs v-model="activeTab">
            <el-tab-pane label="基本资料" name="userinfo">
              <!-- 使用 disabled 属性设置为只读展示 -->
              <el-form :model="form" label-width="100px" disabled>
                <h4 class="form-header">基本信息</h4>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="姓名" prop="userName">
                      <el-input v-model="form.userName" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="用户邮箱" prop="userEmail">
                      <el-input v-model="form.userEmail" />
                    </el-form-item>
                  </el-col>
                </el-row>

                <h4 class="form-header">公司信息</h4>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="公司名称" prop="deptName">
                      <el-input v-model="form.deptName" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="公司类型" prop="deptType">
                      <el-input v-model="form.deptType" />
                    </el-form-item>
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="公司地址" prop="deptLocation">
                      <el-input v-model="form.deptLocation" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="公司编码" prop="deptCode">
                      <el-input v-model="form.deptCode" />
                    </el-form-item>
                  </el-col>
                </el-row>
                <el-row>
                  <el-col :span="12">
                    <el-form-item label="公司传真" prop="deptFax">
                      <el-input v-model="form.deptFax" />
                    </el-form-item>
                  </el-col>
                  <el-col :span="12">
                    <el-form-item label="公司邮箱" prop="deptEmail">
                      <el-input v-model="form.deptEmail" />
                    </el-form-item>
                  </el-col>
                </el-row>
              </el-form>
            </el-tab-pane>

            <el-tab-pane label="修改密码" name="resetPwd">
              <el-form ref="pwdRef" :model="pwdForm" :rules="pwdRules" label-width="80px">
                <el-form-item label="旧密码" prop="oldPassword">
                  <el-input v-model="pwdForm.oldPassword" placeholder="请输入旧密码" type="password" show-password />
                </el-form-item>
                <el-form-item label="新密码" prop="newPassword">
                  <el-input v-model="pwdForm.newPassword" placeholder="请输入新密码" type="password" show-password />
                </el-form-item>
                <el-form-item label="确认密码" prop="confirmPassword">
                  <el-input v-model="pwdForm.confirmPassword" placeholder="请确认新密码" type="password" show-password/>
                </el-form-item>
                <el-form-item>
                  <el-button type="primary" @click="submitPwd">保存</el-button>
                  <el-button type="danger" @click="close">关闭</el-button>
                </el-form-item>
              </el-form>
            </el-tab-pane>
          </el-tabs>
        </el-card>
      </el-col>
    </el-row>
  </div>
</template>

<script setup name="Center">
import { reactive, onMounted, ref, getCurrentInstance } from 'vue';
import { ElMessage } from 'element-plus';
import { getPersonCenter, updateUserPwd } from '@/api/system/user';
import useUserStore from '@/store/modules/user';

const { proxy } = getCurrentInstance();
const userStore = useUserStore();
const loading = ref(false);
const activeTab = ref("userinfo");

const form = reactive({
  userId: null,
  deptId: '',
  userName: '',
  userEmail: '',
  deptName: '',
  deptType: '',
  deptLocation: '',
  deptCode: '',
  deptFax: '',
  deptEmail: ''
});

const pwdForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
});

const equalToPassword = (rule, value, callback) => {
  if (pwdForm.newPassword !== value) {
    callback(new Error("两次输入的密码不一致"));
  } else {
    callback();
  }
};

const pwdRules = ref({
  oldPassword: [{ required: true, message: "旧密码不能为空", trigger: "blur" }],
  newPassword: [
    { required: true, message: "新密码不能为空", trigger: "blur" }, 
    { min: 6, max: 20, message: "长度在 6 到 20 个字符", trigger: "blur" }
  ],
  confirmPassword: [
    { required: true, message: "确认密码不能为空", trigger: "blur" }, 
    { required: true, validator: equalToPassword, trigger: "blur" }
  ]
});

/** 获取个人中心信息 */
function getInfo() {
  loading.value = true;
  const userId = userStore.id;
  getPersonCenter(userId).then(response => {
    Object.assign(form, response.data);
    loading.value = false;
  }).catch(() => {
    loading.value = false;
  });
}

/** 提交密码修改 */
function submitPwd() {
  proxy.$refs.pwdRef.validate(valid => {
    if (valid) {
      updateUserPwd(pwdForm.oldPassword, pwdForm.newPassword).then(response => {
        ElMessage.success("修改成功");
      });
    }
  });
}

/** 关闭按钮 */
function close() {
  proxy.$tab.closePage();
}

onMounted(() => {
  getInfo();
});
</script>

<style scoped lang="scss">
.form-header {
  color: #1890ff;
  border-bottom: 1px solid #e8e8e8;
  padding-bottom: 10px;
  margin-bottom: 20px;
  font-size: 15px;
  font-weight: 500;
}
</style>
