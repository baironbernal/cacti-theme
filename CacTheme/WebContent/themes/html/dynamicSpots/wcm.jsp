<%@ page session="false" %> 
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><%@ 
taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-core" prefix="portal-core" %><%@
taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-fmt" prefix="portal-fmt" %><%@
taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-navigation" prefix="portal-navigation" %>
<portal-core:constants/>
<portal-core:defineObjects/>
<c:if test="${not empty param.name}" >
	<jsp:useBean id="wcm" class="com.davivienda.oc.wcm.WcmBean" scope="request"></jsp:useBean>
	<%
		wcm.setRequest(request);
		wcm.setResponse(response);
		wcm.setLibraryName("cacti-web-content");
		wcm.setVirtualPortalName("cacti");
	%>
	<%=wcm.getContent(request.getParameter("name"))%>
</c:if>