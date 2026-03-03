package com.ruoyi.web.controller.common;

import com.aliyun.dypnsapi20170525.Client;
import com.aliyun.dypnsapi20170525.models.SendSmsVerifyCodeRequest;
import com.aliyun.dypnsapi20170525.models.SendSmsVerifyCodeResponse;
import com.aliyun.teaopenapi.models.Config;
import com.aliyun.teautil.models.RuntimeOptions;
import com.google.gson.Gson;
import com.ruoyi.common.constant.Constants;
import com.ruoyi.common.core.domain.AjaxResult;
import com.ruoyi.common.core.domain.entity.SysUser;
import com.ruoyi.framework.web.service.SysLoginService;
import com.ruoyi.system.service.ISysUserService;
import com.ruoyi.system.service.impl.SysUserServiceImpl;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;
import java.util.concurrent.TimeUnit;

import static com.ruoyi.common.utils.uuid.IdUtils.randomUUID;

@RestController
@Slf4j
@RequestMapping("/sms")
public class SmsController {

    @Autowired
    private StringRedisTemplate redisTemplate;
    @Value("${aliyun.sms.sms-key-id}")
    String accessKeyId;
    @Value("${aliyun.sms.sms-key-secret}")
    String accessKeySecret;
    @Autowired
    private SysLoginService loginService;
    @Autowired
    private SysUserServiceImpl userService;
    /**
     * 初始化阿里云客户端
     */
    private Client createClient() throws Exception {
        Config config = new Config()
                .setAccessKeyId(accessKeyId)
                .setAccessKeySecret(accessKeySecret);
        config.endpoint = "dypnsapi.aliyuncs.com";
        return new Client(config);
    }

    /**
     * 发送短信验证码
     * @param phoneNumber 手机号码
     * @return 发送结果
     */
    @PostMapping("/sendCode")
    public String sendVerifyCode(@RequestParam String phoneNumber) {
        try {
            // 生成6位随机验证码
            String verifyCode = String.valueOf((int)((Math.random() * 9 + 1) * 100000));

            // 保存到Redis，有效期5分钟
            String redisKey = "sms:code:" + phoneNumber;
            redisTemplate.opsForValue().set(redisKey, verifyCode, 30, TimeUnit.MINUTES);

            Client client = createClient();

            SendSmsVerifyCodeRequest request = new SendSmsVerifyCodeRequest()
                    .setPhoneNumber(phoneNumber)
                    .setSignName("速通互联验证码")
                    .setTemplateCode("100001")
                    .setTemplateParam("{\"code\":\"" + verifyCode + "\",\"min\":\"5\"}")
                    .setCountryCode("86")
                    .setInterval(60L)
                    .setValidTime(5L)
                    .setCodeType(1L)
                    .setReturnVerifyCode(false);

            RuntimeOptions runtime = new RuntimeOptions();
            SendSmsVerifyCodeResponse resp = client.sendSmsVerifyCodeWithOptions(request, runtime);

            return new Gson().toJson(resp);

        } catch (Exception e) {
            e.printStackTrace();
            return "{\"code\":\"ERROR\",\"message\":\"" + e.getMessage() + "\"}";
        }
    }

    /**
     * 验证短信验证码
     * @param phoneNumber 手机号码
     * @param verifyCode 用户输入的验证码
     * @return 验证结果
     */
    @PostMapping("/checkCode")
    public AjaxResult checkVerifyCode(
            @RequestParam String phoneNumber,
            @RequestParam String verifyCode) {
        SysUser user=userService.selectUserByPhone(phoneNumber);
        log.info("user{}",user);
        AjaxResult ajax = AjaxResult.success();
        if(user!=null){
            try {
                // 从Redis获取验证码
                String redisKey = "sms:code:" + phoneNumber;
                String cachedCode = redisTemplate.opsForValue().get(redisKey);

                // 检查验证码是否存在
                if (cachedCode == null) {
                    ajax.put(Constants.LOGIN_FAIL,"短信验证码已过期");
                    return ajax;
                }
                // 验证验证码
                String token = loginService.loginByPhone(user);
                // 验证成功后删除验证码（防止重复使用）
                redisTemplate.delete(redisKey);
                ajax.put(Constants.TOKEN, token);
                return ajax;
            } catch (Exception e) {
                e.printStackTrace();
                ajax=AjaxResult.error();
                return  ajax;
            }
        }
        else{
            ajax.put(Constants.LOGIN_FAIL,"用户未注册");
            return ajax;
        }
    }
}