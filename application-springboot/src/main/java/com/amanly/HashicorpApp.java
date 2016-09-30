package com.amanly;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.EnableAutoConfiguration;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

@SpringBootApplication
@Configuration
@ComponentScan
@EnableAutoConfiguration
public class HashicorpApp {

	private static Log logger = LogFactory.getLog(HashicorpApp.class);

	@Bean
	protected ServletContextListener listener() {
		return new ServletContextListener() {

			public void contextInitialized(ServletContextEvent sce) {
				logger.info("Starting Hashiapp application...");
			}

			public void contextDestroyed(ServletContextEvent sce) {
				logger.info("Hashiapp application destroyed");
			}

		};
	}

	public static void main(String[] args) throws Exception {
		SpringApplication.run(HashicorpApp.class, args);
	}
}
