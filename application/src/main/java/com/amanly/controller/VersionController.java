package com.amanly.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class VersionController {
	
	@Value("${application.version}")
	private String version;
    
    @RequestMapping("/version")
    String version() {
        return "Version: " + version;
    }
    
}
