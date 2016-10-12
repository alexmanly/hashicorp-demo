package com.amanly.controller;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
class VaultController {
	
	private static Log logger = LogFactory.getLog(VaultController.class);
	
	@Value("${password}")
    String password;
	
	@PostConstruct
    private void postConstruct() {
		logger.info("My password is: " + password);
    }

    
    @RequestMapping("/vault")
	public String getSecret() {
    	return "Vault secret : " + password + "\n";
	}
}