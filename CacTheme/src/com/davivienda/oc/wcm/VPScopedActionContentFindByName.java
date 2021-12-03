package com.davivienda.oc.wcm;

import java.util.HashMap;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.ibm.workplace.wcm.api.Content;
import com.ibm.workplace.wcm.api.DocumentIdIterator;
import com.ibm.workplace.wcm.api.DocumentTypes;
import com.ibm.workplace.wcm.api.RenderingContext;
import com.ibm.workplace.wcm.api.Repository;
import com.ibm.workplace.wcm.api.SiteArea;
import com.ibm.workplace.wcm.api.VirtualPortalScopedAction;
import com.ibm.workplace.wcm.api.WebContentService;
import com.ibm.workplace.wcm.api.Workspace;
import com.ibm.workplace.wcm.api.exceptions.WCMException;

@SuppressWarnings("deprecation")
public class VPScopedActionContentFindByName implements VirtualPortalScopedAction {

	public static final String SESSION_COUNTER = "counterTheme";
	private static WebContentService webContentService;
	private static Workspace workspace;
	private static Repository repository;
	private Context ctx;
	private String libraryName;
	private String contentName;
	private HttpServletRequest request;
	private HttpServletResponse response;
	private String content = "";
	
	public VPScopedActionContentFindByName(String libraryName, String contentName) {
		this.libraryName = libraryName;
		this.contentName = contentName;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void run() throws WCMException {
		
		try {
			this.ctx = new InitialContext();
			if (webContentService == null) {
				webContentService = (WebContentService) this.ctx.lookup("portal:service/wcm/WebContentService");
				repository = webContentService.getRepository();
			}
		} catch (NamingException e) {
			System.err.println("Ha ocurrido un error "+e.getMessage());
		}
		
		String content = "";
		DocumentIdIterator dii = null;
		Content c = null;
		SiteArea sa = null;
		RenderingContext rc = null;

		label502: try {
			try {
				workspace = repository.getWorkspace(this.request.getUserPrincipal());
			} catch (Exception e) {
				workspace = repository.getWorkspace();
			}

			if (workspace == null) {
				throw new NullPointerException("No se encontro contenido");
			}

			workspace.login();

			/* Trace */
			/*System.out.println("Ejecutando metodo run()");
			System.out.println("	Nombre:" + contentName);
			System.out.println("	Biblioteca:" + libraryName);
			System.out.println("	VirtualPortalContextPath:" + repository.getCurrentVirtualPortalContext().getVirtualPortalContextPath());*/

			workspace.setCurrentDocumentLibrary(workspace.getDocumentLibrary(this.libraryName));

			dii = workspace.findByName(DocumentTypes.Content, this.contentName);

			if (dii.hasNext()) {
				c = (Content) workspace.getById(dii.nextId());
			} else {
				throw new Exception("No se encontro contenido");
			}

			//HttpSession session = this.request.getSession();
			
			if (this.request.getAttribute(this.contentName) == null) {
			//if (session.getAttribute(this.contentName) == null) {
				if (c != null) {
					sa = (SiteArea) workspace.getById(c.getDirectParent());
					rc = workspace.createRenderingContext(this.request, this.response, new HashMap());
					rc.setRenderedContent(c, sa);
					content = workspace.render(rc);
					//session.setAttribute(this.contentName, content);
					this.request.setAttribute(this.contentName, content);
					break label502;
				}
			} else {
				//content = (String) session.getAttribute(this.contentName);
				content = (String) this.request.getAttribute(this.contentName);
			}
		} catch (Exception e) {
			content = "No se encontro contenido";

			if (this.libraryName == null || this.libraryName.equalsIgnoreCase("")) {
				System.err.println("No se ha enviado la libreria a buscar");
			} else if (this.contentName == null || this.contentName.equalsIgnoreCase("")) {
				System.err.println("No se ha enviado el nombre del contenido a buscar");
			} else {
				System.err.println("No se ha encontrado el contenido con nombre: " + this.contentName + " en la libreria: " + this.libraryName);
			}

			/* OC 12/05/2016 - Imprimir traza completa */
			System.err.println("Ha ocurrido un error "+e.getMessage());

			if (workspace != null) {
				workspace.logout();
			}
			
			if (repository != null) {
				repository.endWorkspace();
			}

			if (this.ctx != null){
				try {
					this.ctx.close();
				} catch (NamingException ex) {
					content = "No se encontro contenido";
				}
			}
			
		} finally {
			
			if (workspace != null) {
				workspace.logout();
			}
			
			if (repository != null) {
				repository.endWorkspace();
			}

			if (this.ctx != null) {
				try {
					this.ctx.close();
				} catch (NamingException e) {
					content = "No se encontro contenido";
				}
			}

		}

		this.content = content;
	}

	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public void setRequest(HttpServletRequest request) {
		this.request = request;
	}
	
}
