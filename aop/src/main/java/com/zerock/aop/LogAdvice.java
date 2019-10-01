package com.zerock.aop;

import java.lang.reflect.Array;
import java.util.Arrays;

import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import lombok.extern.log4j.Log4j;

@Aspect
@Log4j
@Component
public class LogAdvice {
	
	@Before("execution(* com.zerock.service.SampleService*.*(..))")
	public void logBefore() {
		log.info("====================");
	}
	
	@Before("execution(* com.zerock.service.SampleService*.doAdd(String, String)) && args(str1, str2)")
	public void logBefoeWithParam(String str1, String str2) {
		log.info("str1 : " + str1);
		log.info("str2 : " + str2);
	}
	
	@AfterThrowing(pointcut = "execution(* com.zerock.service.SampleService*.*(..))", throwing = "e")
	public void logException(Exception e) {
		log.info("Exception....!!!!");
		log.info("exception : " + e);
	}
	
	@Around("execution(* com.zerock.service.SampleService*.*(..))")
	public Object logTime(ProceedingJoinPoint pjp) {
		long start = System.currentTimeMillis();
		
		log.info("Target : " + pjp.getTarget());
		log.info("Param : " + Arrays.toString(pjp.getArgs()));
		
		Object result = null;
		
		try {
			result = pjp.proceed();
		} catch(Throwable e) {
			e.printStackTrace();
		}
		
		long end = System.currentTimeMillis();
		
		log.info("Time : " + (end - start));
		
		return result;
	}
}