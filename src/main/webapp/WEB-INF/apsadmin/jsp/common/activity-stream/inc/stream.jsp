<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="wp" uri="/aps-core" %>
<%@ taglib prefix="wpsa" uri="/apsadmin-core" %>
<%@ taglib prefix="wpsf" uri="/apsadmin-form" %>
<% pageContext.setAttribute("carriageReturn", "\r"); %> 
<% pageContext.setAttribute("newLine", "\n"); %> 
<%-- reading the list from mainBody.jsp with: <wpsa:activityStream var="activityStreamListVar" /> --%>
<c:set var="ajax" value="${param.ajax eq 'true'}" />
<s:set var="ajax" value="#attr.ajax" />
<s:if test="#ajax"><%-- ajax eh? so set the #activityStreamListVar variable accordingly --%>
	<s:set var="activityStreamListVar" value="%{getActionRecordIds()}" />
</s:if>
<s:else><%-- use the #activityStreamListVar from mainBody.jsp --%></s:else>
<c:set var="browserUsername" value="${session.currentUser.username}" />
<s:set var="currentUsernameVar" value="#attr.browserUsername" />
<wp:userProfileAttribute username="${browserUsername}" attributeRoleName="userprofile:fullname" var="browserUserFullnameVar" />
<wp:userProfileAttribute username="${browserUsername}" attributeRoleName="userprofile:email" var="browserUserEmailAttributeVar" />
<wp:ifauthorized permission="superuser" var="browserIsSuperUser" />
<s:iterator value="#activityStreamListVar" var="actionLogRecordIdVar" status="currentEvent">
	<wpsa:actionLogRecord key="%{#actionLogRecordIdVar}" var="actionLogRecordVar" />
	<s:set var="usernameVar" value="#actionLogRecordVar.username" scope="page" />
	<wp:userProfileAttribute username="${usernameVar}" attributeRoleName="userprofile:fullname" var="fullnameVar" />
	<wp:userProfileAttribute username="${usernameVar}" attributeRoleName="userprofile:email" var="emailAttributeVar" />
	<s:set var="fullnameVar" value="#attr.fullnameVar" />
	<s:set var="emailAttributeVar" value="#attr.emailAttributeVar" />
	<li
		class="media row padding-large-bottom"
		data-entando-timestamp="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm:ss|SSS" />"
		data-entando-timestamp-comment="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm:ss|SSS" />"
	>
		<div class="col-xs-12 col-sm-2 col-lg-1 margin-small-bottom activity-stream-picture">
			<img alt=" " src="<s:url action="avatarStream" namespace="/do/user/avatar">
							<s:param name="gravatarSize">56</s:param>
							<s:param name="username" value="#actionLogRecordVar.username" />
						</s:url>" width="56" height="56" class="img-circle media-object" />
		</div>
		<div class="media-body col-xs-12 col-sm-10 col-lg-11 activity-stream-event <s:if test="#currentEvent.first && !#ajax">event-first</s:if>">
			<s:set var="activityStreamInfoVar" value="#actionLogRecordVar.activityStreamInfo" />
			<s:set var="authGroupNameVar" value="#activityStreamInfoVar.linkAuthGroup" scope="page" />
			<s:set var="authPermissionNameVar" value="#activityStreamInfoVar.linkAuthPermission" scope="page" />
			<wp:ifauthorized groupName="${authGroupNameVar}" permission="${authPermissionNameVar}" var="isAuthorizedVar" />
			<div class="popover right display-block" data-entando="ajax-update">
				<div class="arrow"></div>
				<div class="popover-content">
					<c:choose>
						<c:when test="${isAuthorizedVar}">
							<a
								href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#actionLogRecordVar.username"/></s:url>"
								title="<s:text name="label.viewProfile" />: <s:property value="#actionLogRecordVar.username" />">
									<s:if test="null != #fullnameVar && #fullnameVar.length() > 0">
										<s:property value="#fullnameVar" />
									</s:if>
									<s:else>
										<s:property value="#actionLogRecordVar.username" />
									</s:else>
							</a>
						</c:when>
						<c:otherwise>
							<s:if test="null != #fullnameVar && #fullnameVar.length() > 0">
								<s:property value="#fullnameVar" />
							</s:if>
							<s:else>
								<s:property value="#actionLogRecordVar.username" />
							</s:else>
						</c:otherwise>
					</c:choose>
					&#32;&middot;&#32;
					<wpsa:activityTitle actionName="%{#actionLogRecordVar.actionName}" namespace="%{#actionLogRecordVar.namespace}" actionType="%{#activityStreamInfoVar.actionType}" />:&#32;
					<s:set var="linkTitleVar" value="%{getTitle('view/edit', #activityStreamInfoVar.objectTitles)}" />
					<c:choose>
						<c:when test="${isAuthorizedVar}">
							<s:url
								action="%{#activityStreamInfoVar.linkActionName}"
								namespace="%{#activityStreamInfoVar.linkNamespace}"
								var="actionUrlVar">
									<wpsa:paramMap map="#activityStreamInfoVar.linkParameters" />
							</s:url>
							<a href="<s:property value="#actionUrlVar" escape="false" />"><s:property value="#linkTitleVar" /></a>
						</c:when>
						<c:otherwise>
							<s:property value="#linkTitleVar" />
						</c:otherwise>
					</c:choose>
					<%-- like / dislike --%>
					<wpsa:activityStreamLikeRecords recordId="%{#actionLogRecordIdVar}" var="activityStreamLikeRecordsVar" />
						<s:set value="%{#activityStreamLikeRecordsVar.containsUser(#currentUsernameVar)}" var="likeRecordsContainsUserVar" />
						<p class="margin-small-vertical">
							<time datetime="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm" />" title="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm" />" class="text-info">
								<s:date name="#actionLogRecordVar.actionDate" nice="true" />
							</time>
							<s:if test="#activityStreamLikeRecordsVar.size() > 0">
								&#32;&middot;&#32;
								<span
									data-toggle="tooltip"
									data-placement="bottom"
									data-original-title="<s:iterator value="#activityStreamLikeRecordsVar" var="activityStreamLikeRecordVar"><s:property value="#activityStreamLikeRecordVar.displayName" />&#32;
										</s:iterator><s:text name="label.like.likesthis" />">
									<s:property value="#activityStreamLikeRecordsVar.size()" />
									&#32;
									<s:text name="label.like.number" />
								</span>
							</s:if>
							&#32;&middot;&#32;
							<s:if test="%{#likeRecordsContainsUserVar}" >
								<a
									href="<s:url namespace="/do/ActivityStream" action="unlikeActivity">
										<s:param name="recordId" value="%{#actionLogRecordIdVar}" />
										</s:url>">
										<s:text name="label.like.unlike" />
								</a>
							</s:if>
							<s:else>
								<a
									href="<s:url namespace="/do/ActivityStream" action="likeActivity">
										<s:param name="recordId" value="%{#actionLogRecordIdVar}" /></s:url>">
										<s:text name="label.like.like" />
								</a>
							</s:else>
						</p>
				</div>
			</div>

			<%-- comments --%>
			<wpsa:activityStreamCommentRecords recordId="%{#actionLogRecordIdVar}" var="activityStreamCommentListVar" />
				<s:iterator value="#activityStreamCommentListVar" var="activityStreamCommentVar">
				<div class="padding-base-left" style="margin-left: 20px" data-entando="ajax-update">
					<h4 class="sr-only"><s:text name="activity.stream.title.comments" /></h4>
						<div class="media" data-entando-comment="%{#activityStreamCommentVar.commentDate}">
							<a
								class="pull-left"
								href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#activityStreamCommentVar.username"/></s:url>"
								title="<s:text name="label.viewProfile" />:&#32;<s:property value="#activityStreamCommentVar.displayName" />"
								>
								<img
									class="img-circle media-object stream-img-small"
									src="/portalexample/do/user/avatar/avatarStream.action?gravatarSize=56&username=<s:property value="#activityStreamCommentVar.username" />" />
							</a>
							<div class="media-body">
								<h5 class="media-heading">
									<a
										href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#activityStreamCommentVar.username"/></s:url>"
										title="<s:text name="label.viewProfile" />:&#32;<s:property value="#activityStreamCommentVar.displayName" />">
										<s:property value="#activityStreamCommentVar.displayName" /></a>
									&#32;&middot;&#32;<time datetime="<s:date name="#activityStreamCommentVar.commentDate" format="yyyy-MM-dd HH:mm" />" title="<s:date name="#activityStreamCommentVar.commentDate" format="yyyy-MM-dd HH:mm" />" class="text-info">
										<s:date name="%{#activityStreamCommentVar.commentDate}" nice="true" />
									</time>
									<s:if test="#activityStreamCommentVar.username == #attr.browserUsername || #attr.browserIsSuperUser">
										<a href="#remove" data-entando="remove-comment-ajax" class="pull-right">
											<span class="icon fa fa-icon fa-times-circle-o"></span>
											&nbsp;<s:text name="activity.stream.button.delete" />
										</a>
									</s:if>
								</h5>
								<c:set var="STRING_TO_ESCAPE"><s:property value="#activityStreamCommentVar.commentText" /></c:set>
								<c:set var="ESCAPED_STRING" value="${fn:replace(fn:replace(STRING_TO_ESCAPE,carriageReturn,' '),newLine,'<br />')}" />
								<c:set var="ESCAPED_STRING" value="${fn:replace(ESCAPED_STRING,'<br /><br />','<br />')}" />
								<c:out value="${ESCAPED_STRING}" escapeXml="false" />
							</div>
						</div>
				</div>
				</s:iterator>
				<div class="padding-base-left margin-small-top" style="margin-left: 20px">
					<div class="insert-comment media <s:if test="#ajax"> hide </s:if>">
						<span
							class="pull-left"
							>
							<img
								class="img-circle media-object stream-img-small"
								src="/portalexample/do/user/avatar/avatarStream.action?gravatarSize=56&username=<s:property value="#currentUsernameVar" />" />
						</span>
						<div class="media-body">
							<form id="addComment" name="addComment" action="#" class="form-horizontal">
								<wpsf:hidden name="streamRecordId" value="%{#actionLogRecordIdVar}" />
								<textarea
									role="textbox"
									aria-multiline="true"
									class="col-xs-12 col-sm-12 col-md-12 col-lg-12 form-control" cols="30" rows="1" placeholder="insert comment..." name="commentText"></textarea>
								<wpsf:submit type="button"
											 value="%{getText('activity.stream.button.submit.comment')}"
											 cssClass="margin-small-top pull-right btn btn-sm btn-default">
									<span class="icon fa fa-comment"></span>&#32;<s:text name="activity.stream.button.submit.comment" />
								</wpsf:submit>
							</form>
						</div>
					</div>
				</div>
		</div>
	</li>
</s:iterator>