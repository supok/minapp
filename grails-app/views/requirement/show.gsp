<html>
<head>
    <title>Requirement</title>
    <meta name="layout" content="main">
</head>
<body>

<div id="requirement">
    <div class="row">
        <div class="span12">

            <div class="min-nav">
                <h3>
                    <a href="<g:createLink controller="requirement" action="back"/>" class="btn btn-small" type="button" > <i class="icon-arrow-left"></i> Back</a>
                    <span>${requirement.label}</span>
                </h3>
            </div>

            <g:if test="${requirement.getParentRequirements() || requirement.getParentExtensions()}">
                <div class="row">
                    <div class="span12">
                        <table class="table table-condensed table-bordered">
                            <tbody>
                            <g:if test="${requirement.getParentRequirements()}">
                                <tr class="table-header">
                                    <td><strong>Substep of requirement(s)</strong></td>
                                </tr>
                                <g:each in="${requirement.getParentRequirements()}" var="parent">
                                    <tr>
                                        <td><a href="<g:createLink controller="requirement" action="show" id="${parent.id}"/>">${parent.label}</a></td>
                                    </tr>
                                </g:each>
                            </g:if>
                            <g:if test="${requirement.getParentExtensions()}">
                                <tr class="table-header">
                                    <td><strong>Substep of extension(s)</strong></td>
                                </tr>
                                <g:each in="${requirement.getParentExtensions()}" var="extension">
                                    <tr>
                                        <td>${extension.label}</td>
                                    </tr>
                                </g:each>
                            </g:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </g:if>

            <g:if test="${flash.error}">
                <div class="alert alert-error">
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <strong>Error!</strong> ${flash.error}
                </div>
            </g:if>

            <%-- Show Primary Path's steps --%>

            <table class="table table-bordered">
                <tbody>
                    <tr class="table-header">
                        <td>
                            <strong>Primary Path</strong>
                        </td>
                    </tr>
                    <tr>
                        <td class="step-list">
                            <g:if test="${requirement.steps.size()>0}">
                                <g:each in="${requirement.getStepsSorted()}" var="step">
                                    <g:render template="step" model="[step:step, requirement: requirement, allRequirementLabels: allRequirementLabels]"/>
                                </g:each>
                            </g:if>
                            <g:else>
                                <p class="muted text-center">This requirement has no steps</p>
                            </g:else>
                        </td>
                    </tr>
                    <tr class="table-footer">
                        <td>
                            <g:form  class="form-add-extension" action="addExtension" params="[requirementId: requirement.id]">
                                <div class="input-append pull-right new-extension-label">
                                    <input class="form-add-extension-steps" name="steps" type="hidden" value=""/>
                                    <input class="span4" name="extensionLabel" type="text" placeholder="Enter a new extension label"/>
                                    <button class="btn btn-primary" type="submit">Add Extension</button>
                                </div>
                            </g:form>

                            <g:form class="form-add-step" action="addRequirementStep" params="[requirementId: requirement.id]">
                                <div class="input-append">
                                    <input class="span4" name="stepLabel" type="text" id="add-main-path-step"
                                           data-provide="typeahead"
                                           autocomplete='off'
                                           placeholder="Enter a new step label"
                                           data-source='${allRequirementLabels}'>
                                    <button class="btn btn-primary" type="submit">Add Step</button>
                                </div>
                            </g:form>
                        </td>
                    </tr>
                </tbody>
            </table>

            <%-- Show Extensions --%>
            <div class="extension-list">
            <g:each in="${requirement.getExtensionsMap()}" var="extensionMap">

                <table class="table table-bordered extension" extensionid="${extensionMap.key.id}">
                    <tbody>
                    <tr class="table-header">
                        <td class="extension-header">
                            <div class="pull-left relationship">
                                <g:if test="${extensionMap.value == null}">
                                    ( * )
                                </g:if>
                                <g:else>
                                    (
                                    <g:each in="${extensionMap.value}" var="step" status="i">
                                        <g:if test="${step?.position}">
                                            ${step.position}
                                        </g:if>
                                        <g:else>
                                            *
                                        </g:else>
                                        <g:if test="${i+1 < extensionMap.value.size()}">, </g:if>
                                    </g:each>
                                    )
                                </g:else>
                            </div>
                            <div class="pull-left extension-label">${extensionMap.key.label}</div>
                            <a class="btn btn-danger btn-mini pull-right" href="<g:createLink controller="requirement" action="deleteExtension" id="${extensionMap.key.id}" params="[requirementId: requirement.id]"/>">Delete</a>
                            <a class="btn btn-mini pull-right btn-extension-rename">Rename</a>
                            <g:form action="renameExtension" id="${extensionMap.key.id}">
                                <input type="hidden" name="requirementId" value="${requirement.id}">
                                <input class="span5" name="label" type="text" value="${extensionMap.key.label}"
                                       autocomplete='off'
                                       placeholder="Enter extensiono label">
                                <button class="btn btn-mini pull-right btn-primary btn-save" type="submit">Save</button>
                            </g:form>

                        </td>
                    </tr>
                    <tr class="table-body">
                        <td class="step-list">
                            <g:if test="${extensionMap.key.steps.size() == 0}">
                                <p class="muted text-center">This extension has no steps</p>
                            </g:if>
                            <g:else>
                                <g:each in="${extensionMap.key.getStepsSorted()}" var="step">
                                    <g:render template="step" model="[step:step, requirement: requirement, allRequirementLabels: allRequirementLabels, extensionId: extensionMap.key.id]"/>
                                </g:each>
                            </g:else>
                        </td>
                    </tr>
                    <tr class="table-footer">
                        <td>
                            <g:form class="form-add-step" action="addExtensionStep" params="[requirementId: requirement.id, extensionId: extensionMap.key.id]">
                                <div class="input-append">
                                    <input class="span4" name="stepLabel" type="text"
                                           data-provide="typeahead"
                                           data-source='${allRequirementLabels}'
                                           autocomplete='off'
                                           placeholder="Enter a new step label">
                                    <button class="btn btn-primary" type="submit">Add Step</button>
                                </div>
                            </g:form>
                        </td>
                    </tr>
                    </tbody>
                </table>

            </g:each>
            </div>
        </div>
    </div>
</div>


<r:script>
    $(document).ready(function(){
		
		document.getElementById('add-main-path-step').focus();
		
        $('.form-add-extension').submit(function() {
            var selectedSteps = [];
            $('.step-select').each(function() {
                if ($(this).attr('checked')) {
                    selectedSteps.push($(this).val());
                }
            });
            $(".form-add-extension-steps").val(selectedSteps);
            return true;
        });

        $( ".step-list" ).sortable({
            stop: function(event, ui) {
                var stepsOrder = new Array();
                var listSteps = $(this).find(".step");
                listSteps.each(function(idx, step) {
                    var id = $(step).attr("stepid");
                    stepsOrder.push(id);
                });
                var stepsIdOrder = stepsOrder.join("-");
                jQuery.getJSON('${createLink(controller: "requirement", action: "updateStepsOrder", id: requirement.id)}',
                {stepsIdOrder: stepsIdOrder}, function(data) {
                    if (data.status=="success"){
                        window.location.href = window.location.href;
                    }else{
                        alert("Error");
                    }
                });

            }
        });
        $( ".step-list").disableSelection();

        $( ".extension-list" ).sortable({
            stop: function(event, ui) {
                var extensionsOrder = new Array();
                var listExtensions = $(this).find(".extension");
                listExtensions.each(function(idx, extension) {
                    var id = $(extension).attr("extensionid");
                    extensionsOrder.push(id);
                });
                var extensionsIdOrder = extensionsOrder.join("-");
                jQuery.getJSON('${createLink(controller: "requirement", action: "updateExtensionsOrder", id: requirement.id)}',
                {extensionsIdOrder: extensionsIdOrder}, function(data) {
                    if (data.status=="success"){
                        window.location.href = window.location.href;
                    }else{
                        alert("Error");
                    }
                });
            }
        });
        $( ".extension-list").disableSelection();

        $(".btn-rename").click(function(e){
            var requirement = $(this).closest(".step");
            $(requirement).find(".step-label").hide();
            $(requirement).find(".btn-rename").hide();
            $(requirement).find("form").show();
            $(requirement).find("input").focus();
        });

        $(".btn-extension-rename").click(function(e){
            var extension = $(this).closest(".extension-header");
            $(extension).find(".btn-extension-rename").hide();
            $(extension).find(".extension-label").hide();
            $(extension).find("form").show();
            $(extension).find("input").focus();
        });

        $(".child-steps-tooltip").tooltip({"placement":"top"})

    });
</r:script>

</body>
</html>