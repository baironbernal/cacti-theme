package com.davivienda.oc.wcm;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.workplace.wcm.api.Repository;
import com.ibm.workplace.wcm.api.VirtualPortalContext;
import com.ibm.workplace.wcm.api.WebContentService;
import com.ibm.workplace.wcm.api.exceptions.VirtualPortalNotFoundException;
import com.ibm.workplace.wcm.api.exceptions.WCMException;

@SuppressWarnings("deprecation")
public class WcmBean {
	public static final String SESSION_COUNTER = "counterTheme";
//	private static final String JNDI_WCM = "portal:service/wcm/WebContentService";
	private static WebContentService webContentService;
//	private static Workspace workspace;
	private static Repository repository;
	private Context ctx;
	private String libraryName;
	private String contentName;
	private String virtualPortalName;
	private HttpServletRequest request;
	private HttpServletResponse response;
	private boolean withCache = true;

	public WcmBean() throws VirtualPortalNotFoundException {
		try {
			this.ctx = new InitialContext();
			if (webContentService == null) {
				webContentService = (WebContentService) this.ctx.lookup("portal:service/wcm/WebContentService");
				repository = webContentService.getRepository();
				
			}
		} catch (NamingException e) {
			System.err.println("Ha ocurrido un error "+e.getMessage());
		}
	}

	public String getContent() {
    	VirtualPortalContext vctx;
		try {
			
			VPScopedActionContentFindByName vpA = new VPScopedActionContentFindByName(libraryName, contentName);
			vpA.setRequest(request);
			
			//Dependiendo de la JSP donde se haga el llamado se busca en el sub-portal de personas o empresas
			vctx = repository.generateVPContextFromContextPath( virtualPortalName );
			repository.executeInVP(vctx, vpA);
			
			return vpA.getContent();
			
		} catch (VirtualPortalNotFoundException e) {
			System.err.println("Ha ocurrido un error "+e.getMessage());
		} catch (WCMException e) {
			System.err.println("Ha ocurrido un error "+e.getMessage());
		}
		return null;
	}

	public String getContent(String libraryName, String contentName, HttpServletRequest request,
			HttpServletResponse response) {
		this.libraryName = libraryName;
		this.contentName = contentName;
		this.request = request;
		this.response = response;

		return getContent();
	}

	public String getContent(String contentName) {
		this.contentName = contentName;

		return getContent();
	}

	public String getLibraryName() {
		return this.libraryName;
	}

	public void setLibraryName(String libraryName) {
		this.libraryName = libraryName;
	}

	public String getContentName() {
		return this.contentName;
	}

	public void setContentName(String contentName) {
		this.contentName = contentName;
	}

	public String getVirtualPortalName() {
		return virtualPortalName;
	}
	
	public void setVirtualPortalName(String virtualPortalName) {
		this.virtualPortalName = virtualPortalName;
	}
	
	public HttpServletRequest getRequest() {
		return this.request;
	}

	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}

	public HttpServletResponse getResponse() {
		return this.response;
	}

	public void setResponse(HttpServletResponse response) {
		this.response = response;
	}

	public boolean isWithCache() {
		return this.withCache;
	}

	public void setWithCache(boolean withCache) {
		this.withCache = withCache;
	}

}
