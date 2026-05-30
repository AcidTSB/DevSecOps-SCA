package com.drownincloud.security.scademo.controller;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * REST controller cung cấp các endpoint demo cho project DevSecOps SCA.
 * Mỗi endpoint trả JSON mô tả thông tin lab, dependency, và mức độ rủi ro.
 */
@RestController
@RequestMapping("/api")
public class DemoController {

    private static final Logger log = LogManager.getLogger(DemoController.class);

    @Value("${app.demo.name:DevSecOps SCA Demo}")
    private String appName;

    // -- Health check ----------------------------------------------------------

    /**
     * GET /api/health
     * Kiểm tra trạng thái ứng dụng.
     */
    @GetMapping("/health")
    public Map<String, Object> health() {
        log.info("Health endpoint called");
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("status", "UP");
        response.put("application", appName);
        response.put("timestamp", Instant.now().toString());
        return response;
    }

    // -- Lab info --------------------------------------------------------------

    /**
     * GET /api/lab/info
     * Trả thông tin tổng quan về lab DevSecOps SCA.
     */
    @GetMapping("/lab/info")
    public Map<String, Object> labInfo() {
        log.info("Lab info endpoint called");
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("project", "DevSecOps SCA Demo");
        response.put("purpose", "Detect vulnerable open-source dependencies");
        response.put("scaTool", "OWASP Dependency-Check");
        response.put("environment", "Windows Local Lab");
        response.put("javaVersion", System.getProperty("java.version"));
        response.put("framework", "Spring Boot 3.3.x");
        response.put("buildTool", "Apache Maven");
        return response;
    }

    // -- Dependencies list -----------------------------------------------------

    /**
     * GET /api/lab/dependencies
     * Liệt kê các dependency chính trong lab, bao gồm dependency cố tình vulnerable.
     */
    @GetMapping("/lab/dependencies")
    public Map<String, Object> labDependencies() {
        log.info("Dependencies endpoint called — demonstrating Log4j usage via logger");

        // Lấy version Log4j đang dùng lúc runtime
        String log4jVersion = org.apache.logging.log4j.util.PropertiesUtil
                .getProperties().getStringProperty("log4j2.version", "unknown");

        Map<String, Object> response = new LinkedHashMap<>();
        response.put("note", "Danh sách dependency chính trong project");

        // Dependency vulnerable demo
        Map<String, String> log4jDep = new LinkedHashMap<>();
        log4jDep.put("groupId", "org.apache.logging.log4j");
        log4jDep.put("artifactId", "log4j-core");
        log4jDep.put("runtimeVersion", log4jVersion);
        log4jDep.put("vulnerableVersion", "2.14.1");
        log4jDep.put("fixedVersion", "2.24.3");
        log4jDep.put("knownCVE", "CVE-2021-44228 (Log4Shell)");
        log4jDep.put("severity", "CRITICAL — CVSS 10.0");

        // Spring Boot
        Map<String, String> springDep = new LinkedHashMap<>();
        springDep.put("groupId", "org.springframework.boot");
        springDep.put("artifactId", "spring-boot-starter-web");
        springDep.put("version", "3.3.5 (managed by parent)");
        springDep.put("status", "Up-to-date");

        response.put("dependencies", List.of(log4jDep, springDep));
        return response;
    }

    // -- Risk summary ----------------------------------------------------------

    /**
     * GET /api/lab/risk-summary
     * Tóm tắt rủi ro khi sử dụng dependency cũ và cách DevSecOps phát hiện.
     */
    @GetMapping("/lab/risk-summary")
    public Map<String, Object> riskSummary() {
        log.info("Risk summary endpoint called");
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("scanTool", "OWASP Dependency-Check");
        response.put("scanMode", "Maven plugin — mvn dependency-check:check");
        response.put("cvssThreshold", 7);
        response.put("buildBehavior", "Build FAILS khi phát hiện CVE có CVSS >= 7");
        response.put("vulnerableProfile", "mvn ... -Pvulnerable  → Log4j 2.14.1 (có CVE-2021-44228)");
        response.put("fixedProfile", "mvn ... -Pfixed  → Log4j 2.24.3 (đã vá)");
        response.put("expectedResult",
                "Scan vulnerable → nhiều CVE Critical/High; Scan fixed → giảm hoặc không còn CVE nghiêm trọng");
        response.put("devSecOpsLesson",
                "Tích hợp SCA vào CI/CD giúp phát hiện lỗ hổng dependency trước khi deploy");
        return response;
    }

    // -- SCA context (giữ lại endpoint cũ cho tương thích) ----------------------

    /**
     * GET /api/sca/context
     * Giải thích ngắn gọn về Software Composition Analysis.
     */
    @GetMapping("/sca/context")
    public Map<String, Object> scaContext() {
        Map<String, Object> response = new LinkedHashMap<>();
        response.put("topic", "Software Composition Analysis");
        response.put("purpose", "Detect vulnerable open-source dependencies before release");
        response.put("demoDependency", "org.apache.logging.log4j:log4j-core");
        response.put("defense", "Upgrade vulnerable dependency and enforce CVSS gate in CI/CD pipeline");
        return response;
    }
}
