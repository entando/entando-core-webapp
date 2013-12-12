<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="wp" uri="/aps-core" %>
<%@ taglib prefix="wpsa" uri="/apsadmin-core" %>
<%@ taglib prefix="wpsf" uri="/apsadmin-form" %>
<wpsa:actionLogRecord key="%{#actionLogRecordIdVar}" var="actionLogRecordVar" />
<s:set var="usernameVar" value="#actionLogRecordVar.username" scope="page" />
<wp:userProfileAttribute username="${usernameVar}" attributeRoleName="userprofile:fullname" var="fullnameVar" />
<wp:userProfileAttribute username="${usernameVar}" attributeRoleName="userprofile:email" var="emailAttributeVar" />
<s:set var="fullnameVar" value="#attr.fullnameVar" />
<s:set var="emailAttributeVar" value="#attr.emailAttributeVar" />
<li class="media row padding-large-vertical">
	<div class="col-xs-12 col-sm-2 col-lg-1 margin-small-bottom activity-stream-picture">
		<img alt=" " src="<s:url action="avatarStream" namespace="/do/user/avatar">
						<s:param name="gravatarSize">56</s:param>
						<s:param name="username" value="#actionLogRecordVar.username" />
					</s:url>" width="56" height="56" class="img-circle media-object" />
	</div>
	<div class="media-body col-xs-12 col-sm-10 col-lg-11 activity-stream-event <s:if test="#currentEvent.first">event-first</s:if>">
		<s:set var="activityStreamInfoVar" value="#actionLogRecordVar.activityStreamInfo" />
		<s:set var="authGroupNameVar" value="#activityStreamInfoVar.linkAuthGroup" scope="page" />
		<s:set var="authPermissionNameVar" value="#activityStreamInfoVar.linkAuthPermission" scope="page" />
		<wp:ifauthorized groupName="${authGroupNameVar}" permission="${authPermissionNameVar}" var="isAuthorizedVar" />
		<div class="popover right display-block">
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
				<wpsa:activityStreamLikeRecords recordId="%{#actionLogRecordIdVar}" var="activityStreamLikeRecordsVar" />
				<p class="margin-small-vertical">
					<time datetime="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm" />" title="<s:date name="#actionLogRecordVar.actionDate" format="yyyy-MM-dd HH:mm" />" class="text-info">
						<s:date name="#actionLogRecordVar.actionDate" nice="true" />
					</time>
					<s:if test="#activityStreamLikeRecordsVar.size() > 0">
						&#32;&middot;&#32;
						<s:property value="#activityStreamLikeRecordsVar.size()" />
						&#32;
						<s:text name="label.like.number" />
					</s:if>
					&#32;&middot;&#32;
					<s:set value="%{#activityStreamLikeRecordsVar.containsUser(#currentUsernameVar)}" var="likeRecordsContainsUserVar" />
					<s:if test="%{#likeRecordsContainsUserVar}" >
						<a
							href="<s:url namespace="/do/ActivityStream" action="unlikeActivity">
								<s:param name="recordId" value="%{#actionLogRecordIdVar}" />
								</s:url>"
							data-toggle="tooltip"
							data-placement="right"
							data-original-title="<s:iterator value="#activityStreamLikeRecordsVar" var="activityStreamLikeRecordVar"><s:property value="#activityStreamLikeRecordVar.displayName" />&#32;<s:text name="label.like.likesthis" />
								</s:iterator>"
							>
								<s:text name="label.like.unlike" />
						</a>
					</s:if>
					<s:else>
						<a
							href="<s:url namespace="/do/ActivityStream" action="likeActivity">
								<s:param name="recordId" value="%{#actionLogRecordIdVar}" /></s:url>"
							data-toggle="tooltip"
							data-placement="right"
							data-original-title="<s:iterator value="#activityStreamLikeRecordsVar" var="activityStreamLikeRecordVar"><s:property value="#activityStreamLikeRecordVar.displayName" />&#32;<s:text name="label.like.likesthis" />
								</s:iterator>"
							>
								<s:text name="label.like.like" />
						</a>
					</s:else>
				</p>



			</div>
		</div>
		<div class="padding-base-left" style="margin-left: 20px">
			<h4 class="sr-only">Comments</h4>
			<c:forEach begin="0" end="4" varStatus="commentUser">
				<jsp:useBean id="testDate" class="java.util.Date" />
				<s:set var="comment" value="#{
				 'username': 'username-'+#attr.commentUser.count,
				 'displayName': 'display name '+#attr.commentUser.count,
				 'text': 'Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmodtempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodoconsequat. Duis aute irure dolor in reprehenderit in voluptate velit essecillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat nonproident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
				 'date': #attr.testDate
				}" />
				<div class="media">
					<a
						class="pull-left"
						href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#comment.username"/></s:url>"
						title="<s:text name="label.viewProfile" />:&#32;<s:property value="#comment.displayName" />"
						>
						<img
							class="img-circle media-object"
							src="/portalexample/do/user/avatar/avatarStream.action?gravatarSize=56&username=<s:property value="#comment.username" />"
							style="width: 32px; height: 32px" />
					</a>
					<div class="media-body">
						<h5 class="media-heading">
							<a
								href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#comment.username"/></s:url>"
								title="<s:text name="label.viewProfile" />:&#32;<s:property value="#comment.displayName" />">
								<s:property value="#comment.displayName" /></a>
							,&#32;<s:date name="%{#comment.date}" nice="true" />
						</h5>
						<s:property value="#comment.text" />
					</div>
				</div>
			</c:forEach>

		</div>
		<%--
		<s:if test="#activityStreamLikeRecordsVar.size() > 0">
			<ul class="list-unstyled padding-base-top padding-base-bottom padding-base-left">
				<s:iterator value="#activityStreamLikeRecordsVar" var="activityStreamLikeRecordVar">
					<li class="margin-small-vertical">
						<a
							href="<s:url action="view" namespace="/do/userprofile"><s:param name="username" value="#activityStreamLikeRecordVar.username"/></s:url>"
							title="<s:text name="label.viewProfile" />: <s:property value="#activityStreamLikeRecordVar.username" />">
								<s:property value="#activityStreamLikeRecordVar.displayName" />
						</a>
						&#32;<s:text name="label.like.likesthis" />
					</li>
				</s:iterator>
			</ul>
		</s:if>
		--%>
	</div>
</li>