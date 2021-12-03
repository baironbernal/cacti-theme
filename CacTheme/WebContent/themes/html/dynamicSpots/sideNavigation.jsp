<%@ page session="false" buffer="none" %> 
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../includePortalTaglibs.jspf" %>

<%-- This JSP prints out a nested side navigation by recursing the navigation tree --%>

<%-- The children of the parent will be output in the HTML below.
        If this is the first time the JSP is being called in the recursion, 
        parentNode will be empty and should be set to the given start level of the navigation --%>
<c:if test="${empty parentNode}">
    <c:set var="parentNode" value="${wp.selectionModel.selectionPath[param.startLevel]}" />
</c:if>

<%-- open up the list into which sibling pages will be added --%>
<ul class="wpthemeNavList wpthemeNavContainer">

<%-- loop through all the children of the parent node --%>
<portal-navigation:uiNavigationModel var="uiNavigationModel" mobileDeviceClassTest="smartphone/tablet" >

<c:forEach var="node" items="${uiNavigationModel.children[parentNode]}">

    <%-- begin page markup --%>
    <li class="wpthemeNavListItem">
        <span>

            <%-- output a link to the page, and add a CSS class if it is the currently selected page --%>
            <a href="${fn:escapeXml(node.urlGeneration.autoNavigationalState.clearScreenTemplate)}" class="${node.isSelected ? 'wpthemeSelected' : ''} ${node.isHidden ? 'wpthemeHiddenPageText' : ''} ${node.isDraft? 'wpthemeDraftPageText' : ''}"><%--

                --%><%-- start page title markup --%><%--
                --%><span lang="${node.title.xmlLocale}" dir="${node.title.direction}"><%--

                    <!-- print out the page title -->
                    --%><c:out value="${node.title}"/><%--

                    <!-- mark the page if it is currently selected for accessibility -->
                    --%><c:if test="${node.isSelected}"><span class="wpthemeAccess"> <portal-fmt:text key="currently_selected" bundle="nls.commonTheme"/></span></c:if><%--

                --%></span><%-- end page title markup --%><%--
            --%></a>

            <%-- output the close icon for dynamic pages --%>
            <portal-dynamicui:closePage node="${node}">
                <a class="wpthemeClose" href="<%closePageURL.write(out);%>" aria-label="<portal-fmt:text key="theme.close" bundle="nls.commonUI"/>">&#10799;</a>
            </portal-dynamicui:closePage>

        </span>

        <%-- if the given node has children, call this JSP again to print them out recursively --%>
        <c:if test="${uiNavigationModel.hasChildren[node]}">
            <c:set var="parentNode" value="${node}" scope="request"/>
            <jsp:include page="sideNavigation.jsp"/>
        </c:if>
            
    </li><%-- end page markup --%>
</c:forEach>
</portal-navigation:uiNavigationModel>

</ul><%-- close the list of pages --%>