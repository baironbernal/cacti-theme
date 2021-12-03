<%@ page session="false" buffer="none" %>
<%@ page trimDirectiveWhitespaces="true" %>
<%@ include file="../includePortalTaglibs.jspf" %>

<%-- The div in which the statusbar prints out any message it receives --%>
<div class="wpthemeInner">
	<div id="wpthemeStatusBarContainer" class="wpthemeStatusBarContainer">

		<%-- Renders a message in the status bar alerting the user that javascript is disabled. Javascript is required for the statusbar to work --%>
		<noscript>
			<div class="wpthemeMessage" role="alert" wairole="alert">
				<img class="wpthemeMsgIcon wpthemeMsgIconError" src="data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7" alt="Error" />
				<span class="wpthemeAltText">Error:</span>
				<div class="wpthemeMessageBody"><portal-fmt:text key="theme.javascript.disabled" bundle="nls.engine"/></div>
			</div>
		</noscript>

	</div>
</div>
