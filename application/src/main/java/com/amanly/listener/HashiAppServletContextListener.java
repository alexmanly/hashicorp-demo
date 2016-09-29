package com.amanly.listener;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.util.jar.Attributes;
import java.util.jar.Manifest;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

import com.bettercloud.vault.Vault;
import com.bettercloud.vault.VaultConfig;
import com.bettercloud.vault.VaultException;

@WebListener
public class HashiAppServletContextListener implements ServletContextListener {
	
	private static final Logger logger = LogManager.getLogger(HashiAppServletContextListener.class);
	
	public void contextInitialized(ServletContextEvent event) {
		logger.info("Starting Hashiapp application...");

		event.getServletContext().setAttribute("Version", getVersion(event));
		event.getServletContext().setAttribute("Vault", getVault(event));
	}
	
	private String getVersion(ServletContextEvent event) {
		String version = "UNKNOWN";
		InputStream stream = null;
    	try {
			final URL main = event.getServletContext().getResource("/META-INF/MANIFEST.MF");
			stream = main.openStream();
			final Manifest manifest = new Manifest(stream);
            final Attributes attrs = manifest.getMainAttributes();
            version = attrs.getValue("Application-Version");
            logger.info("Version: [" + version + "]");
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				stream.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
    	return version;
	}

	private Vault getVault(ServletContextEvent event) {
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
		return vault;
	}

	public void contextDestroyed(ServletContextEvent event) {
		logger.info("Hashiapp application destroyed");
	}
}
