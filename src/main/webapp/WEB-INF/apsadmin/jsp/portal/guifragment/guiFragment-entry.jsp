<%@ taglib prefix="s" uri="/struts-tags" %>
<%@ taglib prefix="wpsa" uri="/apsadmin-core" %>
<%@ taglib prefix="wpsf" uri="/apsadmin-form" %>
<%@ taglib prefix="wp" uri="/aps-core" %>
<h1 class="panel panel-default title-page">
	<span class="panel-body display-block">
		<a href="<s:url action="list" />"><s:text name="title.guiFragmentManagement" /></a>
		&#32;/&#32;
		<s:if test="getStrutsAction() == 1">
			<s:text name="guiFragment.label.new" />
		</s:if>
		<s:elseif test="getStrutsAction() == 2">
			<s:text name="guiFragment.label.edit" />
		</s:elseif>
	</span>
</h1>
	<s:form action="save" cssClass="form-horizontal">
	<s:if test="hasFieldErrors()">
		<div class="alert alert-danger alert-dismissable">
			<button type="button" class="close" data-dismiss="alert"><span class="icon fa fa-times"></span></button>
			<p><s:text name="message.title.FieldErrors" /></p>
		</div>
	</s:if>
	<s:if test="hasActionErrors()">
		<div class="alert alert-danger alert-dismissable fade in">
			<button class="close" data-dismiss="alert"><span class="icon icon-remove"></span></button>
			<h2 class="h4 margin-none"><s:text name="message.title.ActionErrors" /></h2>
			<ul class="margin-base-top">
				<s:iterator value="actionErrors">
					<li><s:property escape="false" /></li>
				</s:iterator>
			</ul>
		</div>
	</s:if>

	<p class="sr-only">
		<wpsf:hidden name="strutsAction" />
		<s:if test="getStrutsAction() == 2">
			<wpsf:hidden name="id" />
		</s:if>
	</p>
	


	<%-- code --%>
		<s:set var="fieldFieldErrorsVar" value="%{fieldErrors['code']}" />
		<s:set var="fieldHasFieldErrorVar" value="#fieldFieldErrorsVar != null && !#fieldFieldErrorsVar.isEmpty()" />
		<s:set var="controlGroupErrorClassVar" value="%{#fieldHasFieldErrorVar ? ' has-error' : ''}" />
		<div class="form-group<s:property value="#controlGroupErrorClassVar" />">
			<div class="col-xs-12">
				<label for="guiFragment_code"><s:text name="label.code" /></label>
				<wpsf:textfield name="code" id="guiFragment_code" cssClass="form-control" />
				<s:if test="#fieldHasFieldErrorVar">
					<p class="text-danger padding-small-vertical"><s:iterator value="%{#fieldFieldErrorsVar}"><s:property />&#32;</s:iterator></p>
				</s:if>
			</div>
		</div> 
	<%-- widgetCode --%>
		<s:set var="fieldFieldErrorsVar" value="%{fieldErrors['widgetCode']}" />
		<s:set var="fieldHasFieldErrorVar" value="#fieldFieldErrorsVar != null && !#fieldFieldErrorsVar.isEmpty()" />
		<s:set var="controlGroupErrorClassVar" value="%{#fieldHasFieldErrorVar ? ' has-error' : ''}" />
		<div class="form-group<s:property value="#controlGroupErrorClassVar" />">
			<div class="col-xs-12">
				<label for="guiFragment_widgetCode"><s:text name="label.widgetCode" /></label>
				<wpsf:textfield name="widgetCode" id="guiFragment_widgetCode" cssClass="form-control" />
				<s:if test="#fieldHasFieldErrorVar">
					<p class="text-danger padding-small-vertical"><s:iterator value="%{#fieldFieldErrorsVar}"><s:property />&#32;</s:iterator></p>
				</s:if>
			</div>
		</div> 
	<%-- pluginCode --%>
		<s:set var="fieldFieldErrorsVar" value="%{fieldErrors['pluginCode']}" />
		<s:set var="fieldHasFieldErrorVar" value="#fieldFieldErrorsVar != null && !#fieldFieldErrorsVar.isEmpty()" />
		<s:set var="controlGroupErrorClassVar" value="%{#fieldHasFieldErrorVar ? ' has-error' : ''}" />
		<div class="form-group<s:property value="#controlGroupErrorClassVar" />">
			<div class="col-xs-12">
				<label for="guiFragment_pluginCode"><s:text name="label.pluginCode" /></label>
				<wpsf:textfield name="pluginCode" id="guiFragment_pluginCode" cssClass="form-control" />
				<s:if test="#fieldHasFieldErrorVar">
					<p class="text-danger padding-small-vertical"><s:iterator value="%{#fieldFieldErrorsVar}"><s:property />&#32;</s:iterator></p>
				</s:if>
			</div>
		</div> 
	<%-- gui --%>
		<s:set var="fieldFieldErrorsVar" value="%{fieldErrors['gui']}" />
		<s:set var="fieldHasFieldErrorVar" value="#fieldFieldErrorsVar != null && !#fieldFieldErrorsVar.isEmpty()" />
		<s:set var="controlGroupErrorClassVar" value="%{#fieldHasFieldErrorVar ? ' has-error' : ''}" />
		<div class="form-group<s:property value="#controlGroupErrorClassVar" />">
			<div class="col-xs-12">
				<label for="guiFragment_gui"><s:text name="label.gui" /></label>
				<wpsf:textarea name="gui" id="guiFragment_gui" cssClass="form-control" rows="8" cols="50" />
				<s:if test="#fieldHasFieldErrorVar">
					<p class="text-danger padding-small-vertical"><s:iterator value="%{#fieldFieldErrorsVar}"><s:property />&#32;</s:iterator></p>
				</s:if>
			</div>
		</div> 

	<%-- save button --%>
	<div class="form-group">
		<div class="col-xs-12 col-sm-4 col-md-3 margin-small-vertical">
			<s:submit type="button" action="save" cssClass="btn btn-primary btn-block">
				<span class="icon icon-save"></span>&#32;
				<s:text name="label.save" />
			</s:submit>
		</div>
	</div>

	</s:form>

</div>
