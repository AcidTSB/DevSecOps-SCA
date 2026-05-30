package com.drownincloud.security.scademo;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class ScaDemoApplication {

    private static final Logger log = LogManager.getLogger(ScaDemoApplication.class);

    public static void main(String[] args) {
        log.info("Starting DevSecOps SCA Demo Application");
        SpringApplication.run(ScaDemoApplication.class, args);
    }
}
