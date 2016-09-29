package com.amanly.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Path("/health")
public class HealthService {
	
	private static Status STATUS = Status.OK;
	private static final Logger logger = LogManager.getLogger(HealthService.class);
	
	@GET
	public Response getHealthStatus() {
		logger.debug("Status is: " + HealthService.STATUS);
		return Response.status(HealthService.STATUS).entity("Everything OK here.\n").build();
	}
	
	@GET
	@Path("/toggle")
	public Response toggleHealthStatus() {
		switch (STATUS) {
		case OK:
			return setUnhealthy();
		case SERVICE_UNAVAILABLE:
			return setHealthy();
		default:
			return Response.status(Status.OK).build();
		}
	}
	
	@GET
	@Path("/off")
	public Response setUnhealthy() {
		HealthService.STATUS = Status.SERVICE_UNAVAILABLE;
		logger.debug("Application health has been turned off");
		return Response.status(Status.OK).build();
	}
	
	@GET
	@Path("/on")
	public Response setHealthy() {
		HealthService.STATUS = Status.OK;
		logger.debug("Application health has been turned on");
		return Response.status(Status.OK).build();
	}
}