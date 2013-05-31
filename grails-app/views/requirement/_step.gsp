<div class="step" stepid="${step.id}">
    <a class="step-label" href="<g:createLink controller="requirement" action="show" id="${step.requirement.id}"/>">
        <div class="span1">
            <label class="checkbox">
                <g:if test="${!extensionId}">
                    <g:checkBox class="step-select" name="steps" value="${step.id}" checked="false"/>
                </g:if>
            </label>
        </div>
        <div class="span1">${step.position}.</div>
        <div class="span8">
            ${step.requirement.label}
            <g:set var="substepsCount" value="${step.requirement.steps.size()}"/>
            <g:if test="${substepsCount > 0}">
                <i class="icon-plus-sign child-steps-tooltip" data-original-title="This requirement has ${substepsCount} step<g:if test="${substepsCount > 1}">s</g:if>"></i>
            </g:if>
        </div>

    </a>
	
	<div style="float:right" class="btn btn-more-actions btn-mini"><i class="icon-plus-sign" title="More action"></i>  More</div>
	<div class="more-actions" style="display:none">
	<a class="btn btn-mini pull-right" title="Reorder" data-toggle="tooltip"><i class="icon-move"></i></a>
    <g:if test="${extensionId}">
        <a class="btn btn-mini pull-right" title="Remove" data-toggle="tooltip" href="<g:createLink controller="requirement" action="removeExtensionStep" id="${step.id}" params="[requirementId: requirement.id, extensionId: extensionId]" />" data-confirm="Are you sure you want to delete?"><i class="icon-remove-sign"></i></a> <!-- Remove -->
    </g:if>
    <g:else>
        <a class="btn btn-mini pull-right" title="Remove" data-toggle="tooltip" href="<g:createLink controller="requirement" action="removeRequirementStep" id="${step.id}" params="[requirementId: requirement.id]" />" data-confirm="Are you sure you want to delete?"><i class="icon-remove-sign"></i></a> <!-- Remove -->
    </g:else>
    <a class="btn btn-mini pull-right btn-rename" title="Rename" data-toggle="tooltip"><i class="icon-pencil"></i></a> <!-- Rename -->
	
   </div>
	
	
    <g:form style="float:left" action="renameStep" id="${step.id}">
        <input type="hidden" name="requirementId" value="${requirement.id}">
        <input style="float:left" class="span5" name="label" type="text" value="${step.requirement.label}"
               autocomplete='off'
               placeholder="Enter step label"
               data-provide="typeahead"
               data-source='${allRequirementLabels}' >
        <button style="float:left;margin-left:5px" class="btn btn-mini btn-primary btn-save" type="submit" >Save</button>
    </g:form>
</div>