package com.amanly.controller;

import javax.annotation.PostConstruct;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.bettercloud.vault.Vault;
import com.bettercloud.vault.VaultConfig;
import com.bettercloud.vault.VaultException;

@RestController
class VaultController {
	
	private static Log logger = LogFactory.getLog(VaultController.class);
	private Vault vault = null;
    
    @RequestMapping("/vault/{param1}/{param2}")
	public String getSecret(@PathVariable String param1, @PathVariable String param2) {
		try {
			logger.debug(vault.logical().read(param1 + "/" + param2));
			final String value = getVault().logical().read(param1 + "/" + param2).getData().get("value");
			return "Vault secret : " + value + "\n";
		} catch (VaultException e) {
			logger.error("Error with the path [" + param1 + "/" + param2 + "]: " + e.getMessage());
			return "Unable to find a vault secret for path: " + param1 + "/" + param2;
		}
	}
    
    @PostConstruct
    private Vault getVault() {
    	if (vault == null) {
			final String vaultToken = System.getenv("VAULT_TOKEN");
			if (vaultToken == null || vaultToken.isEmpty()) {
				logger.error("VAULT_TOKEN must be set and non-empty");
			} else {
				logger.info("Found VAULT_TOKEN environment variable set as: [redacted]");
			}
			
			final String vaultAddress = System.getenv("VAULT_ADDR");
			if (vaultAddress == null || vaultAddress.isEmpty()) {
				logger.error("VAULT_ADDR must be set and non-empty");
			} else {
				logger.info("Found VAULT_ADDR environment variable set as: [" + vaultAddress + "]");
			}
			
			Vault vault = null;
			try {
				vault = new Vault(new VaultConfig(vaultAddress, vaultToken));
				logger.info("Connected to Vault Server");
				return vault;
			} catch (VaultException e) {
				logger.error("Unable to connect to the Vault server.  Exiting application...");
				System.exit(-1);
			}
    	}
		return vault;
	}
}