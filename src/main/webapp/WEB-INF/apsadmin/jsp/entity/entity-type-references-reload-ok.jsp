<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="wp" uri="/aps-core" %>

<h1 class="panel panel-default title-page">
	<span class="panel-body display-block">
		<a href="<s:url action="viewManagers" namespace="/do/Entity" />" title="<s:text name="note.goToSomewhere" />: <s:text name="title.entityManagement" />">
		<s:text name="title.entityAdmin.manage" /></a>
	</span>
</h1>

<div id="main">

<h2><s:text name="title.entityAdmin.entityManagers.reload" /></h2>

<p class="message message_confirm">
	<span class="sr-only"><s:text name="messages.confirm" />: </span><s:text name="message.reloadEntities.ok" />.
</p>

<p>
	<a href="<s:url action="viewManagers" namespace="/do/Entity" />"><s:text name="note.backToSomewhere" />: <s:text name="title.entityManagement" /></a>
</p>

</div>