package com.amanly.rest;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.bettercloud.vault.Vault;
import com.bettercloud.vault.VaultException;

@Path("/vault")
public class VaultService {
	
	private static final Logger logger = LogManager.getLogger(VaultService.class);
	private Vault vault;
	
	@Context
    public void setServletContext(ServletContext context) {
        if (vault == null) {
        	vault = (Vault)context.getAttribute("Vault");
        }
    }

	@GET
	@Path("/{param1}/{param2}")
	public Response getSecret(@Context HttpServletRequest req, @PathParam("param1") String path, @PathParam("param2") String key) {
		try {
			final String value = vault.logical().read(path + "/" + key).getData().get("value");
			String output = "Vault secret : " + value + "\n";
			logger.debug(output);
			return Response.status(Status.OK).entity(output).build();
		} catch (VaultException e) {
			return Response.status(Status.BAD_REQUEST).entity("Unable to find a vault secret for path: " + path + "/" + key).build();
		}
	}

}