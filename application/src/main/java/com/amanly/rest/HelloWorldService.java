package com.amanly.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

@Path("/hello")
public class HelloWorldService {
	
	private static final Logger logger = LogManager.getLogger(HelloWorldService.class);
	
	@GET
	public Response getMsg() {
		final String output = "HashiAppDemo says hello!!!";
		logger.debug(output);
		return Response.status(Status.OK).entity(output).build();
	}

	@GET
	@Path("/{param}")
	public Response getMsg(@PathParam("param") String msg) {
		final String output = "HashiAppDemo says hello : " + msg + "\n";
		logger.debug(output);
		return Response.status(Status.OK).entity(output).build();
	}

}