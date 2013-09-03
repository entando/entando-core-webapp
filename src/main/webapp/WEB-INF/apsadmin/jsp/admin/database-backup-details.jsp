<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="wpsf" uri="/apsadmin-form" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<h1 class="panel panel-default title-page">
	<span class="panel-body display-block">
		<a href="<s:url namespace="/do/BaseAdmin" action="settings" />"><s:text name="menu.configure" /></a> 
		&#32;/&#32; 
		<a href="<s:url namespace="/do/Admin/Database" action="entry" />"><s:text name="title.databaseManagement" /></a>
		&#32;/&#32;
		<s:text name="title.databaseBackup.details" />
	</span>
</h1>
<s:set var="subFolderNameVar" value="subFolderName" />
<s:if test="hasActionErrors()">
	<div class="alert alert-warning alert-dismissable fade in">
		<button class="close" data-dismiss="alert"><span class="icon icon-remove"></span></button>
		<h2 class="h4 margin-none"><s:text name="message.title.ActionErrors" /></h2>
		<ul class="margin-base-vertical">
			<s:iterator value="actionErrors">
				<li><s:property escape="false" /></li>
			</s:iterator>
		</ul>
	</div>
</s:if>
<s:if test="hasFieldErrors()">
	<div class="alert alert-warning alert-dismissable fade in">
		<button class="close" data-dismiss="alert"><span class="icon icon-remove"></span></button>
		<h2 class="h4 margin-none"><s:text name="message.title.FieldErrors" /></h2>
		<ul class="margin-base-vertical">
			<s:iterator value="fieldErrors">
					<s:iterator value="value">
						<li><s:property escape="false" /></li>
					</s:iterator>
				</s:iterator>
		</ul>
	</div>
</s:if>
<s:if test="hasActionMessages()">
	<div class="alert alert-warning alert-dismissable fade in">
		<button class="close" data-dismiss="alert"><span class="icon icon-remove"></span></button>
		<h2 class="h4 margin-none"><s:text name="messages.confirm" /></h2>
		<ul class="margin-base-vertical">
			<s:iterator value="actionMessages">
				<li><s:property escape="false" /></li>
			</s:iterator>
		</ul>
	</div>
</s:if>
<s:if test="managerStatus != 0" >
	<div class="alert alert-warning alert-dismissable fade in">
			<s:text name="database.management.note.dump.in.progress" /> ( <a href="<s:url namespace="/do/Admin/Database" action="entry" />"><s:text name="database.management.refresh" /></a> )
	</div>
</s:if>
<s:else>
	<s:set var="dumpReportVar" value="getDumpReport(#subFolderNameVar)" />
	<s:if test="null == #dumpReportVar">
		<div class="alert alert-warning">
			<s:text name="database.management.note.dump.not.available" />
		</div>
	</s:if>
	<s:else>
		<p class="lead">
				<s:text name="database.management.label.date" />:
				<code><s:date name="#dumpReportVar.date" format="EEEE dd/MMM/yyyy, HH:mm:ss" /></code>
		</p>
		<p class="lead">
			<s:text name="database.management.label.time.required" />:
			<code><s:property value="#dumpReportVar.requiredTime" /></code>&#32;
			<s:text name="database.management.label.milliseconds" />
		</p>
		
		<div class="table-responsive">
			<table class="table table-bordered table-hover table-condensed table-striped">
				<caption><s:text name="database.management.label.components.backup" /></caption>
				<tr>
					<th>Component Name</th>
					<th>Dump Date</th>
				</tr>
				<s:iterator var="componentHistoryVar" value="#dumpReportVar.componentsHistory">
					<tr>
						<th>
							<s:set var="labelComponentDescrVar" value="%{#componentHistoryVar.componentCode + '.name'}" />
							<s:text name="%{#labelComponentDescrVar}" var="componentDescrVar" />
							<s:if test="%{#componentDescrVar.equals(#labelComponentDescrVar)}"><s:property value="#componentHistoryVar.componentCode" /></s:if>
							<s:else><s:property value="#componentDescrVar" /></s:else>
						</th>
						<td class="text-right">
							<code><s:date name="#componentHistoryVar.date" format="dd/MM/yyyy HH:mm:ss" /></code>
						</td>
					</tr>
				</s:iterator>
			</table>
		</div>
		
		<p class="help-block text-right">
				<button type="button" data-toggle="collapse" data-target="#datasource-details" class="btn btn-link">
					<s:text name="DataSource Details"/> <span class="icon-chevron-down"></span>
				</button>
		</p>
		<div id="datasource-details" class="collapse">
			<div class="table-responsive">
					<s:iterator var="dataSourceNameVar" value="#dumpReportVar.dataSourceNames" begin="0" end="%{(#dumpReportVar.dataSourceNames.size()/2)-1}" status="status">
						<table class="table table-bordered table-hover table-condensed">
							<caption>
								<span>
									<span lang="en">Datasource</span>&#32;<em><s:property value="#dataSourceNameVar" /></em>
								</span>
							</caption>
							<s:set var="tableReportsVar" value="#dumpReportVar.dataSourcesReports[#dataSourceNameVar]" />
							<tr>
								<th><s:text name="database.management.label.table" /></th>
								<th><s:text name="database.management.label.rows" /></th>
								<th><s:text name="database.management.label.time.required" /></th>
							</tr>
							<s:iterator var="tableReportVar" value="#tableReportsVar">
								<tr>
									<td>
										<s:if test="#tableReportVar.rows == 0"><s:property value="#tableReportVar.tableName" /></s:if>
										<s:else>
												<a
													title="<s:text name="database.management.label.download" />: <s:property value="#dataSourceNameVar" />/<s:property value="#tableReportVar.tableName" />"
													href="<s:url namespace="/do/Admin/Database" action="extractTableDump" >
													<s:param name="tableName" value="#tableReportVar.tableName" />
													<s:param name="dataSourceName" value="#dataSourceNameVar" />
													<s:param name="subFolderName" value="#dumpReportVar.subFolderName" />
												</s:url>"><span class="icon icon-download" />&#32;<s:property value="#tableReportVar.tableName" /></a>
										</s:else>
									</td>
									<td class="text-right text-nowrap">
										<code><s:property value="#tableReportVar.rows" /></code>
									</td>
									<td class="text-right text-nowrap">
										<code><s:property value="#tableReportVar.requiredTime" /></code>&#32;<abbr title="<s:text name="database.management.label.milliseconds" />"><s:text name="database.management.label.milliseconds.short" /></abbr>
									</td>
								</tr>
							</s:iterator>
						</table>
					</s:iterator>
			</div>
			<s:iterator var="dataSourceNameVar" value="#dumpReportVar.dataSourceNames" begin="%{(#dumpReportVar.dataSourceNames.size()/2)}" status="status">
				<div class="table-responsive">
					<table class="table table-bordered table-hover table-condensed">
						<caption>
							<span>
								<span lang="en">Datasource</span>&#32;<em><s:property value="#dataSourceNameVar" /></em>
							</span>
						</caption>
						<s:set var="tableReportsVar" value="#dumpReportVar.dataSourcesReports[#dataSourceNameVar]" />
						<tr>
							<th><s:text name="database.management.label.table" /></th>
							<th><s:text name="database.management.label.rows" /></th>
							<th><s:text name="database.management.label.time.required" /></th>
						</tr>
						<s:iterator var="tableReportVar" value="#tableReportsVar">
							<tr>
								<td>
									<s:if test="#tableReportVar.rows == 0"><s:property value="#tableReportVar.tableName" /></s:if>
									<s:else>
											<a
												title="<s:text name="database.management.label.download" />: <s:property value="#dataSourceNameVar" />/<s:property value="#tableReportVar.tableName" />"
												href="<s:url namespace="/do/Admin/Database" action="extractTableDump" >
												<s:param name="tableName" value="#tableReportVar.tableName" />
												<s:param name="dataSourceName" value="#dataSourceNameVar" />
												<s:param name="subFolderName" value="#dumpReportVar.subFolderName" />
											</s:url>"><span class="icon icon-download" />&#32;<s:property value="#tableReportVar.tableName" /></a>
									</s:else>
								</td>
								<td class="text-right text-nowrap">
									<s:property value="#tableReportVar.rows" />
								</td>
								<td class="text-right text-nowrap">
									<s:property value="#tableReportVar.requiredTime" />&#32;<abbr title="<s:text name="database.management.label.milliseconds" />"><s:text name="database.management.label.milliseconds.short" /></abbr>
								</td>
							</tr>
						</s:iterator>
					</table>
				</div>
			</s:iterator>
		</div>
		<hr />
		<s:form namespace="/do/Admin/Database" method="get" cssClass="margin-more-top">
			<p class="text-center">
				<s:hidden name="subFolderName" value="%{#dumpReportVar.subFolderName}" />
				<s:submit type="button" action="restoreIntro" cssClass="btn btn-primary">
					<s:text name="database.management.label.restore" />
				</s:submit>
			</p>
		</s:form>
	</s:else>
</s:else>

<%--
<h1><a href="<s:url namespace="/do/Admin/Database" action="entry" />">Database Management</a></h1>
<div id="main">
	<s:set var="subFolderNameVar" value="subFolderName" />
	<h2><s:text name="title.databaseBackup.details" /></h2>
	<s:if test="hasActionErrors()">
		<div class="message message_error">
			<h3><s:text name="message.title.ActionErrors" /></h3>
			<ul>
				<s:iterator value="actionErrors">
					<li><s:property escape="false" /></li>
				</s:iterator>
			</ul>
		</div>
	</s:if>
	<s:if test="hasFieldErrors()">
		<div class="message message_error">
			<h3><s:text name="message.title.FieldErrors" /></h3>
			<ul>
				<s:iterator value="fieldErrors">
					<s:iterator value="value">
					<li><s:property escape="false" /></li>
					</s:iterator>
				</s:iterator>
			</ul>
		</div>
	</s:if>
	<s:if test="hasActionMessages()">
		<div class="message message_confirm">
			<h3><s:text name="messages.confirm" /></h3>
			<ul>
				<s:iterator value="actionMessages">
					<li><s:property escape="false" /></li>
				</s:iterator>
			</ul>
		</div>
	</s:if>
	<s:if test="managerStatus != 0" >
		<p class="message message_error">
			<s:text name="database.management.note.dump.in.progress" />&#32;(&#32;<a href="<s:url namespace="/do/Admin/Database" action="entry" />"><s:text name="database.management.refresh" /></a>&#32;)
		</p>
	</s:if>
	<s:else>
		<s:set var="dumpReportVar" value="getDumpReport(#subFolderNameVar)" />
		<s:if test="null == #dumpReportVar">
			<p>
				<s:text name="database.management.note.dump.not.available" />
			</p>
		</s:if>
		<s:else>
			<dl class="dl-horizontal">
				<dt>
					<s:text name="database.management.label.date" />
				</dt>
					<dd>
						<s:date name="#dumpReportVar.date" format="dd/MM/yyyy HH:mm:ss" />
					</dd>
				<dt>
					<s:text name="database.management.label.time.required" />
				</dt>
					<dd><s:property value="#dumpReportVar.requiredTime" />&#32;<s:text name="database.management.label.milliseconds" /></dd>
			</dl>

			<h3 class="centerText">
				<s:text name="database.management.label.components.backup" />
			</h3>
			<dl class="dl-horizontal">
				<s:iterator var="componentHistoryVar" value="#dumpReportVar.componentsHistory">
					<dt>
						<s:set var="labelComponentDescrVar" value="%{#componentHistoryVar.componentCode + '.name'}" />
						<s:text name="%{#labelComponentDescrVar}" var="componentDescrVar" />
						<s:if test="%{#componentDescrVar.equals(#labelComponentDescrVar)}"><s:property value="#componentHistoryVar.componentCode" /></s:if>
						<s:else><s:property value="#componentDescrVar" /></s:else>
					</dt>
						<dd>
							<s:date name="#componentHistoryVar.date" format="dd/MM/yyyy HH:mm:ss" />
						</dd>
				</s:iterator>
			</dl>
			<div class="block-column-container margin-more-bottom">
				<div class="block-column-left">
					<s:iterator var="dataSourceNameVar" value="#dumpReportVar.dataSourceNames" begin="0" end="%{(#dumpReportVar.dataSourceNames.size()/2)-1}" status="status">
						<table class="generic reset_<s:property value="#status.count%2" />">
							<caption>
								<span>
									<span lang="en">Datasource</span>&#32;<em><s:property value="#dataSourceNameVar" /></em>
								</span>
							</caption>
							<s:set var="tableReportsVar" value="#dumpReportVar.dataSourcesReports[#dataSourceNameVar]" />
							<tr>
								<th><s:text name="database.management.label.table" /></th>
								<th><s:text name="database.management.label.rows" /></th>
								<th><s:text name="database.management.label.time.required" /></th>
							</tr>
							<s:iterator var="tableReportVar" value="#tableReportsVar">
								<tr>
									<td>
										<s:if test="#tableReportVar.rows == 0"><s:property value="#tableReportVar.tableName" /></s:if>
										<s:else>
												<a
													title="<s:text name="database.management.label.download" />: <s:property value="#dataSourceNameVar" />/<s:property value="#tableReportVar.tableName" />"
													href="<s:url namespace="/do/Admin/Database" action="extractTableDump" >
													<s:param name="tableName" value="#tableReportVar.tableName" />
													<s:param name="dataSourceName" value="#dataSourceNameVar" />
													<s:param name="subFolderName" value="#dumpReportVar.subFolderName" />
												</s:url>"><s:property value="#tableReportVar.tableName" /></a>
										</s:else>
									</td>
									<td class="text-right text-nowrap">
										<s:property value="#tableReportVar.rows" />
									</td>
									<td class="text-right text-nowrap">
										<s:property value="#tableReportVar.requiredTime" />&#32;<abbr title="<s:text name="database.management.label.milliseconds" />"><s:text name="database.management.label.milliseconds.short" /></abbr>
									</td>
								</tr>
							</s:iterator>
						</table>
					</s:iterator>
				</div>
				<div class="block-column-right">
					<s:iterator var="dataSourceNameVar" value="#dumpReportVar.dataSourceNames" begin="%{(#dumpReportVar.dataSourceNames.size()/2)}" status="status">
						<table class="generic reset_<s:property value="#status.count%2" />">
							<caption>
								<span>
									<span lang="en">Datasource</span>&#32;<em><s:property value="#dataSourceNameVar" /></em>
								</span>
							</caption>
							<s:set var="tableReportsVar" value="#dumpReportVar.dataSourcesReports[#dataSourceNameVar]" />
							<tr>
								<th><s:text name="database.management.label.table" /></th>
								<th><s:text name="database.management.label.rows" /></th>
								<th><s:text name="database.management.label.time.required" /></th>
							</tr>
							<s:iterator var="tableReportVar" value="#tableReportsVar">
								<tr>
									<td>
										<s:if test="#tableReportVar.rows == 0"><s:property value="#tableReportVar.tableName" /></s:if>
										<s:else>
												<a
													title="<s:text name="database.management.label.download" />: <s:property value="#dataSourceNameVar" />/<s:property value="#tableReportVar.tableName" />"
													href="<s:url namespace="/do/Admin/Database" action="extractTableDump" >
													<s:param name="tableName" value="#tableReportVar.tableName" />
													<s:param name="dataSourceName" value="#dataSourceNameVar" />
													<s:param name="subFolderName" value="#dumpReportVar.subFolderName" />
												</s:url>"><s:property value="#tableReportVar.tableName" /></a>
										</s:else>
									</td>
									<td class="text-right text-nowrap">
										<s:property value="#tableReportVar.rows" />
									</td>
									<td class="text-right text-nowrap">
										<s:property value="#tableReportVar.requiredTime" />&#32;<abbr title="<s:text name="database.management.label.milliseconds" />"><s:text name="database.management.label.milliseconds.short" /></abbr>
									</td>
								</tr>
							</s:iterator>
						</table>
					</s:iterator>
				</div>
			</div>
			<s:form namespace="/do/Admin/Database" method="get" cssClass="margin-more-top">
				<p class="centerText">
					<wpsf:hidden name="subFolderName" value="%{#dumpReportVar.subFolderName}" />
					<wpsf:submit action="restoreIntro" value="%{getText('database.management.label.restore')}" cssClass="button" />
				</p>
			</s:form>
		</s:else>
		<p>
			<a href="<s:url namespace="/do/Admin/Database" action="entry" />"><s:text name="database.management.label.go.to.list" /></a>
		</p>
	</s:else>
</div>
--%>