<%@ page session="false" buffer="none" %> 
<%@ page trimDirectiveWhitespaces="true" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ include file="../includePortalTaglibs.jspf" %>
<portal-core:constants/><portal-core:defineObjects/>

<%-- Renders the links that are shown in the banner --%>

<%-- lazy load the selection path array and theme configuration object --%>
<portal-core:lazy-set var="selectionPath" elExpression="wp.selectionModel.selectionPath"/>
<portal-core:lazy-set var="themeConfig" elExpression="wp.themeConfig"/>

<%-- add a CSS class on mobile devices --%>
<portal-logic:if deviceClass="smartphone/tablet"><div class="wpthemeMobile"></portal-logic:if>

<%-- open the left common actions list --%>
<ul class="wpthemeCommonActions wpthemeLeft">

    <%-- set the target node to the root of the current set of pages (level 1 in the selection path) --%>
    <c:set var="node" value="${selectionPath[1]}"/>

    <%-- output the logo, with a link to the target node --%>
    <li>
        <span class="wpthemeBranding">
            <a class="wpthemeBrandingLink" href="${fn:escapeXml(node.urlGeneration.autoNavigationalState.clearScreenTemplate)}" alt="<portal-fmt:out>${node.title}</portal-fmt:out>">
                <img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" alt="<portal-fmt:text key="theme.ibmLogo" bundle="nls.commonUI"/>">
            </a>
            <span class="wpthemeAltText"><portal-fmt:text key="theme.ibmLogo" bundle="nls.commonUI"/></span>
        </span>
    </li>

</ul><%-- close the left common actions list --%>

<%-- open the right common actions list --%>
<ul class="wpthemeCommonActions wpthemeRight">

<portal-logic:if loggedIn="yes">

    <%-- Username is used as a link to 'Edit My Profile', do not show this link on smartphones --%>
    <portal-logic:if deviceClass="!smartphone">
        <li class="wpthemeFirst" id="wpthemeUserName">
            <a href="${fn:escapeXml(wp.navigationModel['wps.Selfcare'].urlGeneration.autoSelectPortlet.normal.setRenderParam('ao','thm').setRenderParam('OCN',wp.identification[wp.selectionModel.selected]).setThemeTemplate(''))}">
                <c:out value="${wp.user[themeConfig['user.displaynameattribute']]}" />
            </a>
        </li>
    </portal-logic:if>

    <%--
    This creates the Actions context menu for page actions.  We use the
    &#36; HTML entity to encode the $ character so that it won't be interpreted
    as a JSP expression here and will show up as literals. Do not show this menu on mobile devices.
    --%>
    <portal-logic:if deviceClass="!(smartphone/tablet)">
        <li id="wpthemeActionsMenu">
            <c:if test="${!wpthemeWAI}" >
                <span tabindex="0" aria-labelledby="wpContextMenu" role="button" aria-haspopup="true" class="wpthemeActionsMenu wpthemeMenuAnchor wpthemeMenuFocus wpthemeActionDisabled"
                    onclick="if (typeof wptheme != 'undefined') wptheme.contextMenu.init({ 'node': this, menuId: 'pageAction', jsonQuery: {'navID':ibmCfg.portalConfig.currentPageOID}, params: {'alignment':'right'}});"
                    onmousemove="if (typeof i$ != 'undefined' &amp;&amp; typeof wptheme != 'undefined') { i$.removeClass(this,'wpthemeActionDisabled'); this.onmousemove = null; }"
                    onkeydown="if (typeof i$ != 'undefined' &amp;&amp; typeof wptheme != 'undefined') {if (event.keyCode ==13 || event.keyCode ==32 || event.keyCode==38 || event.keyCode ==40) {wptheme.contextMenu.init(this, 'pageAction', {'navID':ibmCfg.portalConfig.currentPageOID}); return false;}}">
                    <span class="wpthemeUnderlineText" id="wpContextMenu"><portal-fmt:text key='theme_actions' bundle='nls.commonTheme'/></span>
                </span>
            </c:if>
        </li>
    </portal-logic:if>

    <%-- Logout Link --%>
    <c:set var="endPreviewOperation" value="${wp.operation['ibm.portal.operations.endPreviewMode']}"></c:set>
	<c:if test="${!endPreviewOperation.isActive}">
	    <%-- only show if preview mode is not active --%>
	    <li id="wpthemeLogout">
	        <a id="logoutlink" href="${fn:escapeXml(wp.selectionModel.selected.urlGeneration.logout.keepNavigationalState)}"><portal-fmt:text key="link.logout" bundle="nls.engine"/></a>
	    </li>
	</c:if>

</portal-logic:if><%-- end loggedIn="yes" items --%>

<portal-logic:if loggedIn="no">

    <%-- Sign up Link --%>
    <portal-logic:if deviceClass="!smartphone">
        <c:if test="${wp.ac['wps.USER_SELF_ENROLLMENT'].hasPermission['editor']}">
            <li class="wpthemeFirst" id="wpthemeSignUp">
                <a href="${fn:escapeXml(wp.navigationModel['wps.Selfcare'].urlGeneration.autoSelectPortlet.normal.setRenderParam('ao','thm').setRenderParam('OCN',wp.identification[wp.selectionModel.selected]).allowRelativeURL.setThemeTemplate(''))}"><portal-fmt:text key="link.enrollment" bundle="nls.engine"/></a>
            </li>
        </c:if>
    </portal-logic:if>

    <%-- Login Link, only show if not in preview mode --%>
    <c:if test="${!(wp.operation['ibm.portal.operations.endPreviewMode'].isActive)}">
        <li class="wpthemeLast" id="wpthemeLogin">
            <a href="${fn:escapeXml(wp.selectionModel.selected.urlGeneration.keepNavigationalState.allowRelativeURL.forceProtected)}" ><portal-fmt:text key="link.login" bundle="nls.engine"/></a>
        </li>
    </c:if>

</portal-logic:if><%-- end loggedIn="no" items --%>

<%--  Toggle icon for showing and hiding the top navigation on tablets --%>
<portal-logic:if deviceClass="tablet">
    <li id="wpthemeTopNavToggle">
        <a role="button" class="wpthemeTopNavToggleBtn" aria-label="<portal-fmt:text key="theme.display.top.nav" bundle="nls.commonUI"/>" title="<portal-fmt:text key="theme.display.top.nav" bundle="nls.commonUI"/>" href="javascript:;" onclick="wptheme.toggleMobileTopNav('<portal-fmt:text key="theme.display.top.nav" bundle="nls.commonUI"/>','<portal-fmt:text key="theme.hide.top.nav" bundle="nls.commonUI"/>');" id="wpthemeTopNavToggleBtn">
            &nbsp;<img alt="" src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==">
            <span class="wpthemeAltText" id="wpthemeTopNavToggleBtnAccess"><portal-fmt:text key="theme.display.top.nav" bundle="nls.commonUI"/></span>
        </a>
    </li>
</portal-logic:if>

<%-- Help icon - only displayed for all authenticated users on desktop --%>
<portal-logic:if loggedIn="yes">
    <portal-logic:if deviceClass="!(smartphone/tablet)">
        <li id="wpthemeHelp">
            <a id="wpthemeHelpAnchor" class="wpthemeHelp" href="<r:url uri='helpAdvisor:com.ibm.wp.authors.help.welcome'/>" onclick="return !window.open(this.href,'wpthemeHelp','width=800,height=600');" aria-label="<portal-fmt:text key="help.title" bundle="nls.commonUI"/>" aria-haspopup="true" role="button">
                <img src="data:image/gif;base64,R0lGODlhAQABAIAAAP///wAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw==" alt="">
                <span class="wpthemeAltText"><portal-fmt:text key="help.title" bundle="nls.commonUI"/></span>
            </a>
        </li>
    </portal-logic:if>
</portal-logic:if>

</ul><%-- close the right common actions list --%>
<portal-logic:if deviceClass="smartphone/tablet"></div></portal-logic:if>