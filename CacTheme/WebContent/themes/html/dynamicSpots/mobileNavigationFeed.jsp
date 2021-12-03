<%@ page session="false" buffer="none" %> 
<%@ page trimDirectiveWhitespaces="true" %>
<%@ page contentType="text/html;charset=utf-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/resolver" prefix="r" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-fmt" prefix="portal-fmt" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-logic" prefix="portal-logic" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-navigation" prefix="portal-navigation" %>

<%if ("HEAD".equalsIgnoreCase(request.getMethod())) {
} else {%>

<%-- The children of the parent will be output in the HTML below --%>
<c:set var="parent" value="${wp.navigationModel[wp.identification[param.parentID]]}"/>

<%-- This JSP prints out the markup for the given parent node and level of navigation --%>

<%-- The navigation level for which children are currently being output, initial value is 0 --%>
<c:set var="level" value="0"/>
<c:if test="${!empty param.level}">
    <c:set var="level" value="${param.level}"/>
</c:if>

<%-- true if this is displaying the first level of navigation --%>
<c:set var="isFirstLevel" value="${level == 0}"/>

<%-- True if viewing on a tablet device --%>
<portal-logic:if deviceClass="tablet">
    <c:set var="isTablet" value="true"/>
</portal-logic:if>

<%-- Javascript code that will stop a browser event --%>
<c:set var="cancelEvent" value="if (!event) {if (window.event) event = window.event;} if (event) {if (event.preventDefault) event.preventDefault(); if (event.stopPropagation) event.stopPropagation(); if (event.cancel != null) event.cancel = true; if (event.cancelBubble != null) event.cancelBubble = true;}" />

<%-- open list of sibling pages --%>
<ul aria-label="${parent.title}" class="wpthemeExpandNav" role="list">

<%-- output a close link at the top of each navigation level for tablets (except the first level) --%>
<c:if test="${isTablet && !isFirstLevel}">
    <li class="wpthemeNavListItem wpthemeNavClose">
        <a role="button" aria-label="<portal-fmt:text key="theme.close" bundle="nls.commonUI"/>" title="<portal-fmt:text key="theme.close" bundle="nls.commonUI"/>" href="javascript:;" onclick="wptheme.toggleMobileNav('${wp.identification[parent]}','wpthemeNavCollapsed','<portal-fmt:text key="theme.expand" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.collapse" bundle="nls.commonUI"/>','wpthemeNavRoot',null,<c:if test="${isTablet}">true</c:if><c:if test="${!isTablet}">false</c:if>,'${wp.identification[parent]}',null,<c:out value="${level+1}"/>); <c:out value="${cancelEvent}"/>">
            &nbsp;<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
            <span class="wpthemeAltText"><portal-fmt:text key="theme.close" bundle="nls.commonUI"/></span>
        </a>
    </li>
</c:if>

<%-- output a search box at the top of the first level of navigation --%>
<c:if test="${isFirstLevel}">
    <portal-logic:if loggedIn="yes">
    <li class="wpthemeNavListItem wpthemeNavSearch" id="wpthemeMobileSearchBox"></li>
    </portal-logic:if>
</c:if>

<portal-navigation:uiNavigationModel var="uiNavigationModel" 
    mobileDeviceClassTest="smartphone/tablet" showHidden="${param.showHiddenPages}"
    selectedNodeID="${param.currentPageID}" selectionPath="${param.selectionPathIDs}" selectionPathSeparator=" ">

<%-- Loop through all the child nodes of the parent --%>
<c:forEach var="node" items="${uiNavigationModel.children[parent]}">

    <%-- The id of the node being output --%>
    <c:set var="nodeID" value="${wp.identification[node]}"/>

    <%-- true if the node being output is currently selected --%>
    <c:set var="isSelected" value="${node.isSelected}"/>

    <%-- True if the node has any visible children --%>
    <c:set var="hasVisibleChildren" value="${uiNavigationModel.hasChildren[node]}"/>

    <%-- open the list item for the node --%>
    <li role="listitem" class="wpthemeNavListItem<c:if test="${isSelected}"> wpthemeSelected</c:if><c:if test="${node.isInSelectionPath && isTablet}"> wpthemeAncestor</c:if> wpthemeNavCollapsed<c:if test="${hasVisibleChildren}"> wpthemeHasChildren</c:if>" aria-expanded="false" id="${nodeID}_navigation">

        <%-- output a link to the node, with its title and accessible text if it is currently selected --%>
        <a href="${node.urlGeneration.autoNavigationalState.clearScreenTemplate}">
            <span id="${nodeID}_navigationLinkText" lang="${node.title.xmlLocale}" dir="${node.title.direction}" class="${node.isHidden ? 'wpthemeHiddenPageText' : ''} ${node.isDraft? 'wpthemeDraftPageText' : ''}"><%--
                --%><c:out value="${node.title}"/><%--
                --%><c:if test="${isSelected}"><span class="wpthemeAccess"><portal-fmt:text key="currently_selected" bundle="nls8.Theme"/></span></c:if><%--
            --%></span>
        </a>
            
        <%-- Output an arrow link when node has visible children, then recurse to the next level of navigation --%>
        <c:if test="${hasVisibleChildren}">
    
            <%-- Set the text for the arrow to either "collapse" or "expand", depending on if the next level is open or not --%>
            <c:set var="btnValue"><portal-fmt:text key="theme.expand" bundle="nls.commonUI"/></c:set>

            <%-- The arrow button link --%>
            <a role="button" class="wpthemeExpandBtn" aria-label="${btnValue}" title="${btnValue}" href="javascript:;" onclick="wptheme.toggleMobileNav('${nodeID}','wpthemeNavCollapsed','<portal-fmt:text key="theme.expand" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.collapse" bundle="nls.commonUI"/>','wpthemeNavRoot',null,<c:if test="${isTablet}">true</c:if><c:if test="${!isTablet}">false</c:if>,'${nodeID}',null,<c:out value="${level+1}"/>); <c:out value="${cancelEvent}"/>" id="${nodeID}_navigationLink">
                &nbsp;<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
                <span class="wpthemeAltText" id="${nodeID}_navigationAccess">${btnValue}</span>
            </a>

            <%-- div into which markup for child nodes will be lazily loaded --%>
            <div<c:if test="${isTablet}"> class="wpthemeNavCollapsed wpthemeMobileNav wpthemeMobileSide"</c:if> id="${nodeID}_navigationSubnav"></div>

            <%-- Add an onload function that will expand the navigation to the currently selected level on tablets (this happens automatically on smartphone) --%>
            <c:if test="${!(!node.isInSelectionPath || isSelected) && isTablet}">
                <script type="text/javascript">i$.addOnLoad(function () {wptheme.mobileNavSideLastExpanded.push("<c:out value="${nodeID}"/>_navigationLink");});</script>
            </c:if>

        </c:if>

        <div class="wpthemeClear"></div>
    </li><%-- close the list item for the node --%>

</c:forEach>
</portal-navigation:uiNavigationModel>

</ul><%-- close the list of pages --%>
<%}%>