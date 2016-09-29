package com.amanly.rest;

import javax.servlet.ServletContext;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Path("/version")
public class VersionService {
	
	private String version = "UNKNOWN";
	private static final Logger logger = LogManager.getLogger(VersionService.class);
	
	@Context
    public void setServletContext(ServletContext context) {
		if (version == null) {
			version = (String)context.getAttribute("Version");
        }
    }

	@GET
	public Response getVersion() {
		final String output = "Version : " + version + "\n";
		logger.info(output);
		return Response.status(Status.OK).entity(output).build();
	}
}