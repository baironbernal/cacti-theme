<%@ page session="false" buffer="none" %> 
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-fmt" prefix="portal-fmt" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-navigation" prefix="portal-navigation" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/resolver" prefix="r" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-core" prefix="portal-core" %>
<%@ taglib uri="http://www.ibm.com/xmlns/prod/websphere/portal/v8.5/portal-logic" prefix="portal-logic" %>

<%-- This JSP prints out a nested navigation by recursing the navigation tree --%>

<%-- true if hidden pages should be shown in the navigation --%>
<portal-core:lazy-set var="showHiddenPages" elExpression=="wp.publicRenderParam['{http://www.ibm.com/xmlns/prod/websphere/portal/publicparams}hiddenPages']" />

<%-- The children of the parent will be output in the HTML below.
		If this is the first time the JSP is being called in the recursion, 
		parent will be empty and should be set to the given start level of the navigation --%>
<c:if test="${empty parent}">
	<c:set var="parent" value="${wp.selectionModel.selectionPath[1]}" />
</c:if>

<%-- The navigation level for which children are currently being output, initial value is 1 --%>
<c:set var="curLevel" value="1" />
<c:if test="${!empty nextLevel}">
	<c:set var="curLevel" value="${nextLevel}" />
</c:if>

<%-- true if this is displaying the first level of navigation --%>
<c:set var="isFirstLevel" value="${curLevel == 1}" />

<%-- True if viewing on a tablet device --%>
<portal-logic:if deviceClass="tablet">
	<c:set var="isTablet" value="true"/>
</portal-logic:if>

<%-- True if the current parent node has children --%>
<c:set var="hasChildren" value="false"/> 

<%-- Javascript code that will stop a browser event --%>
<c:set var="cancelEvent" value="if (!event) {if (window.event) event = window.event;} if (event) {if (event.preventDefault) event.preventDefault(); if (event.stopPropagation) event.stopPropagation(); if (event.cancel != null) event.cancel = true; if (event.cancelBubble != null) event.cancelBubble = true;}"/>

<%-- Output the navigation icon and container div on the first recursive pass --%>
<c:if test="${isFirstLevel}">

	<%-- navigation icon --%>
	<a role="button" class="wpthemeNavToggleBtn" aria-label="<portal-fmt:text key="theme.display.nav" bundle="nls.commonUI"/>" title="<portal-fmt:text key="theme.display.nav" bundle="nls.commonUI"/>" href="javascript:;" onclick="wptheme.toggleMobileNav('wpthemeNavRoot','wpthemeNavCollapsed','<portal-fmt:text key="theme.display.nav" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.hide.nav" bundle="nls.commonUI"/>','wpthemeNavRoot',null,<c:if test="${isTablet}">true</c:if><c:if test="${!isTablet}">false</c:if>,null,null,0); <c:out value="${cancelEvent}"/>" id="wpthemeNavRootLink">
		<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
		<span class="wpthemeAltText" id="wpthemeNavRootAccess"><portal-fmt:text key="theme.display.nav" bundle="nls.commonUI"/></span>
	</a>

	<%-- navigation border --%>
	<div class="wpthemeMobileBorder"></div>

	<%-- navigation container div, initially closed --%>
	<div role="navigation" tabindex="-1" aria-expanded="false" class="wpthemeNavCollapsed wpthemeMobileNav<c:if test="${isTablet}"> wpthemeMobileSide</c:if>" id="wpthemeNavRoot">
</c:if>

<portal-navigation:uiNavigationModel var="uiNavigationModel" mobileDeviceClassTest="smartphone/tablet" >

<%-- Loop through all the child nodes of the parent --%>
<c:forEach var="node" items="${uiNavigationModel.children[parent]}">

    <%-- The id of the node being output --%>
    <c:set var="nodeID" value="${wp.identification[node]}"/>

    <%-- true if the node being output is currently selected --%>
    <c:set var="isSelected" value="${node.isSelected}"/>

	<%-- true if the current section/list of sibling pages is collapsed --%>
	<c:set var="isCollapsed" value="${wp.selectionModel[node] == null || isSelected || isTablet}" />

	<%-- Start a new UL before the first child node --%>
	<c:if test="${hasChildren == false}">

		<%-- Output a div around each list of siblings that isn't the first level of navigation (the first level is inside the wpthemeNavRoot div above) --%>
		<c:if test="${!isFirstLevel}">
			<div<c:if test="${isTablet}"> class="wpthemeNavCollapsed wpthemeMobileNav wpthemeMobileSide"</c:if> id="${wp.identification[parent]}_navigationSubnav">
		</c:if>

		<%-- open list of sibling pages --%>
		<ul aria-label="${parent.title}" class="wpthemeExpandNav" <c:if test="${isFirstLevel}">role="tree"</c:if><c:if test="${!isFirstLevel}">role="group"</c:if>>
	
		<%-- output a close link at the top of each navigation level for tablets (except the first level) --%>
		<c:if test="${isTablet && !isFirstLevel}">
			<li class="wpthemeNavListItem wpthemeNavClose">
				<a role="button" aria-label="<portal-fmt:text key="theme.close" bundle="nls.commonUI"/>" title="<portal-fmt:text key="theme.close" bundle="nls.commonUI"/>" href="javascript:;" onclick="wptheme.toggleMobileNav('${wp.identification[parent]}','wpthemeNavCollapsed','<portal-fmt:text key="theme.expand" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.collapse" bundle="nls.commonUI"/>','wpthemeNavRoot',null,<c:if test="${isTablet}">true</c:if><c:if test="${!isTablet}">false</c:if>,null,null<c:out value="${curLevel}"/>); <c:out value="${cancelEvent}"/>">
					&nbsp;<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
					<span class="wpthemeAltText" id="${nodeID}_navigationAccess"><portal-fmt:text key="theme.close" bundle="nls.commonUI"/></span>
				</a>
			</li>
		</c:if>
	
		<%-- output a search box at the top of the first level of navigation --%>
		<c:if test="${isFirstLevel}">
            <portal-logic:if loggedIn="yes">
                <li class="wpthemeNavListItem wpthemeNavSearch">
                    <r:dataSource uri="dyn-cs:id:wp_search_mobile_dynspot" escape="none"/><%-- link to the search dynamic content spot --%>
                </li>
            </portal-logic:if>
		</c:if>

	</c:if><%-- end new UL code --%>

	<c:set var="hasChildren" value="true"/> 

    <%-- True if the node has any visible children --%>
    <c:set var="hasVisibleChildren" value="${uiNavigationModel.hasChildren[node]}"/>

	<%-- open the list item for the node --%>
	<li role="treeitem" class="wpthemeNavListItem<c:if test="${isSelected}"> wpthemeSelected</c:if><c:if test="${wp.selectionModel[node] != null && isTablet}"> wpthemeAncestor</c:if><c:if test="${isCollapsed}"> wpthemeNavCollapsed</c:if><c:if test="${hasVisibleChildren}"> wpthemeHasChildren</c:if>" <c:if test="${!isCollapsed}">aria-expanded="true"</c:if><c:if test="${isCollapsed}">aria-expanded="false"</c:if> id="${nodeID}_navigation">

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
			<c:set var="btnValue"><portal-fmt:text key="theme.collapse" bundle="nls.commonUI"/></c:set>
			<c:if test="${isCollapsed}"><c:set var="btnValue"><portal-fmt:text key="theme.expand" bundle="nls.commonUI"/></c:set></c:if>

			<%-- The arrow button link --%>
			<a role="button" class="wpthemeExpandBtn" aria-label="${btnValue}" title="${btnValue}" href="javascript:;" onclick="wptheme.toggleMobileNav('${nodeID}','wpthemeNavCollapsed','<portal-fmt:text key="theme.expand" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.collapse" bundle="nls.commonUI"/>','wpthemeNavRoot',null,<c:if test="${isTablet}">true</c:if><c:if test="${!isTablet}">false</c:if>,null,null,<c:out value="${curLevel}"/>); <c:out value="${cancelEvent}"/>" id="${nodeID}_navigationLink">
				&nbsp;<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="/>
				<span class="wpthemeAltText" id="${nodeID}_navigationAccess">${btnValue}</span>
			</a>

			<%-- Add an onload function that will expand the navigation to the currently selected level on tablets (this happens automatically on smartphone) --%>
			<c:if test="${!(wp.selectionModel[node] == null || isSelected) && isTablet}">
				<script type="text/javascript">i$.addOnLoad(function () {wptheme.mobileNavSideLastExpanded.push("<c:out value="${nodeID}"/>_navigationLink");});</script>
			</c:if>

			<%-- recurse to the next level of navigation --%>
			<c:set var="parent" value="${node}" scope="request"/>
			<c:set var="nextLevel" value="${curLevel + 1}" scope="request"/>
			<jsp:include page="mobileNavigation.jsp"/>
	
		</c:if>

		<div class="wpthemeClear"></div>
	</li><%-- close the list item for the node --%>
</c:forEach>

</portal-navigation:uiNavigationModel>

<%-- close the list of sibling pages --%>
<c:if test="${hasChildren != false}">
	</ul>
	<c:if test="${!isFirstLevel}"></div></c:if>
</c:if>

<c:if test="${isFirstLevel}">
	<%-- Hide the navigation if it is empty --%>
	<c:if test="${hasChildren == false}">
		<script type="text/javascript">
			wptheme.hideMobileNav();
		</script>
	</c:if>
	<%-- close wpthemeNavRoot --%>
	</div>
</c:if>