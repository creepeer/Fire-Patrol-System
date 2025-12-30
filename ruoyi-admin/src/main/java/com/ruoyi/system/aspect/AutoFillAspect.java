package com.ruoyi.system.aspect;

import com.ruoyi.common.annotation.AutoFill;
import com.ruoyi.common.core.controller.BaseController;
import com.ruoyi.common.enums.OperationType;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.Signature;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.Date;

/**
 * 自定义切面，实现公共字段自动填充处理
 */
@Aspect
@Component
@Slf4j
public class AutoFillAspect extends BaseController {
    @Pointcut("execution(* com.ruoyi.system.mapper.*.*(..))&&@annotation(com.ruoyi.common.annotation.AutoFill)")
    public void  autoFillPointCut(){

    }

    /**
     * 前置通知，在通知中进行公共字段填充
     */
    @Before("autoFillPointCut()")
    public void autoFill(JoinPoint joinPoint){
        log.info("开始公共字段填充");
        MethodSignature signature = (MethodSignature) joinPoint.getSignature();
        AutoFill autoFill=signature.getMethod().getAnnotation(AutoFill.class);
        OperationType operationType=autoFill.value();
        Object[] args = joinPoint.getArgs();
        if(args == null||args.length==0){
            return;
        }
        Object entity = args[0];
        Date date=new Date();
        String userId= getUserId().toString();
        if(operationType==OperationType.INSERT){
            try {
                Method setCreatorTime = entity.getClass().getDeclaredMethod("setCreatorTime", Date.class);
                Method setCreator = entity.getClass().getDeclaredMethod("setCreator", String.class);

                Method setModifierTime = entity.getClass().getDeclaredMethod("setModifierTime", Date.class);
                Method setModifier = entity.getClass().getDeclaredMethod("setModifier", String.class);
                //反射赋值
                setCreatorTime.invoke(entity,date);
                setCreator.invoke(entity,userId);
                setModifier.invoke(entity,userId);
                setModifierTime.invoke(entity,date);

            } catch (Exception e) {
                throw new RuntimeException(e);
            }

        } else if (operationType==OperationType.UPDATE) {
            Method setModifierTime = null;
            try {
                setModifierTime = entity.getClass().getDeclaredMethod("setModifierTime", Date.class);
                Method setModifier = entity.getClass().getDeclaredMethod("setModifier", String.class);
                setModifier.invoke(entity,userId);
                setModifierTime.invoke(entity,date);
            } catch (Exception e) {
                throw new RuntimeException(e);
            }


        }

    }
}
