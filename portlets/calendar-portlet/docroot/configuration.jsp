<%--
/**
 * Copyright (c) 2000-present Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
--%>

<%@ include file="/init.jsp" %>

<%
String tabs2 = ParamUtil.getString(request, "tabs2", "user-settings");
%>

<liferay-portlet:actionURL portletConfiguration="true" var="configurationActionURL" />

<liferay-portlet:renderURL portletConfiguration="true" var="configurationRenderURL">
	<portlet:param name="tabs2" value="<%= tabs2 %>" />
</liferay-portlet:renderURL>

<aui:form action="<%= configurationActionURL %>" method="post" name="fm" onSubmit='<%= "event.preventDefault(); " + renderResponse.getNamespace() + "saveConfiguration();" %>'>
	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />
	<aui:input name="tabs2" type="hidden" value="<%= tabs2 %>" />
	<aui:input name="redirect" type="hidden" value="<%= configurationRenderURL %>" />

	<%
	String tabs2Names = "user-settings";

	if (PortalUtil.isRSSFeedsEnabled()) {
		tabs2Names += ",rss";
	}
	%>

	<liferay-ui:tabs
		names="<%= tabs2Names %>"
		param="tabs2"
		url="<%= configurationRenderURL %>"
	/>

	<c:choose>
		<c:when test='<%= tabs2.equals("user-settings") %>'>
			<aui:fieldset>
				<aui:select label="time-format" name="isoTimeFormat">
					<aui:option label="am-pm" selected="<%= !isoTimeFormat %>" value="<%= false %>" />
					<aui:option label="24-hour" selected="<%= isoTimeFormat %>" value="<%= true %>" />
				</aui:select>

				<aui:select label="default-duration" name="defaultDuration" value="<%= defaultDuration %>">
					<aui:option label='<%= LanguageUtil.format(pageContext, "x-minutes", "15", false) %>' value="15" />
					<aui:option label='<%= LanguageUtil.format(pageContext, "x-minutes", "30", false) %>' value="30" />
					<aui:option label='<%= LanguageUtil.format(pageContext, "x-minutes", "60", false) %>' value="60" />
					<aui:option label='<%= LanguageUtil.format(pageContext, "x-minutes", "120", false) %>' value="120" />
				</aui:select>

				<aui:select label="default-view" name="defaultView" value="<%= defaultView %>">
					<aui:option label="day" value="day" />
					<aui:option label="month" value="month" />
					<aui:option label="week" value="week" />
				</aui:select>

				<aui:select label="week-starts-on" name="weekStartsOn" value="<%= weekStartsOn %>">
					<aui:option label="weekday.SU" value="0" />
					<aui:option label="weekday.MO" value="1" />
					<aui:option label="weekday.SA" value="6" />
				</aui:select>

				<aui:input cssClass="calendar-portlet-time-zone-field" disabled="<%= usePortalTimeZone %>" label="time-zone" name="timeZoneId" type="timeZone" value="<%= timeZoneId %>" />

				<aui:input label="use-global-timezone" name="usePortalTimeZone" type="checkbox" value="<%= usePortalTimeZone %>" />
			</aui:fieldset>
		</c:when>
		<c:when test='<%= tabs2.equals("rss") %>'>
			<liferay-ui:rss-settings
				delta="<%= rssDelta %>"
				displayStyle="<%= rssDisplayStyle %>"
				enabled="<%= enableRSS %>"
				feedType="<%= rssFeedType %>"
			/>

			<aui:fieldset cssClass="rss-time-interval" id="rssTimeIntervalContainer">
				<aui:select label="time-interval" name="preferences--rssTimeInterval--" value="<%= rssTimeInterval %>">
					<aui:option label="week" value="<%= Time.WEEK %>" />
					<aui:option label="month" value="<%= Time.MONTH %>" />
					<aui:option label="year" value="<%= Time.YEAR %>" />
				</aui:select>
			</aui:fieldset>
		</c:when>
	</c:choose>

	<aui:button-row>
		<aui:button type="submit" />
	</aui:button-row>
</aui:form>

<aui:script use="aui-base">
	var usePortalTimeZoneCheckbox = A.one('#<portlet:namespace />usePortalTimeZoneCheckbox');

	if (usePortalTimeZoneCheckbox) {
		usePortalTimeZoneCheckbox.on(
			'change',
			function(event) {
				document.<portlet:namespace />fm.<portlet:namespace />timeZoneId.disabled = usePortalTimeZoneCheckbox.attr('checked');
			}
		);
	}
</aui:script>

<aui:script>
	function <portlet:namespace />saveConfiguration() {
		submitForm(document.<portlet:namespace />fm);
	}

	Liferay.Util.toggleBoxes('<portlet:namespace />enableRssCheckbox', '<portlet:namespace />rssTimeIntervalContainer');
</aui:script>