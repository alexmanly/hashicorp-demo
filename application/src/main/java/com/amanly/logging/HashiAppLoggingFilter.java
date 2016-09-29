package com.amanly.logging;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.sun.jersey.api.container.filter.LoggingFilter;
import com.sun.jersey.spi.container.ContainerRequest;
import com.sun.jersey.spi.container.ContainerRequestFilter;
import com.sun.jersey.spi.container.ContainerResponse;
import com.sun.jersey.spi.container.ContainerResponseFilter;

public class HashiAppLoggingFilter extends LoggingFilter implements ContainerRequestFilter, ContainerResponseFilter {
	
	private static final Logger logger = LogManager.getLogger(HashiAppLoggingFilter.class);

	@Override
	public ContainerResponse filter(ContainerRequest req, ContainerResponse res) {
		return res;
	}

	@Override
	public ContainerRequest filter(ContainerRequest req) {
		logger.debug(String.format("%s - - [%s] \"%s %s\" %s\n", 
			req.getRequestUri().getHost(),
			new SimpleDateFormat("HH:mm:ss").format(Calendar.getInstance().getTime()),
			req.getMethod(),
			req.getRequestUri().getPath(),
			req.getHeaderValue("User-Agent")));
		return req;
	}

}
