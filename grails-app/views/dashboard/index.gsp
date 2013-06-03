<html>
<head>
    <title>Dashboard</title>
    <meta name="layout" content="main">
</head>

<body>

<div id="dashboard">
    <div class="row">
        <div class="span12">

            <g:if test="${flash.error}">
                <div class="alert alert-error" >
                    <button type="button" class="close" data-dismiss="alert">&times;</button>
                    <strong>Error!</strong> ${flash.error}
                </div>
            </g:if>

            <h1>Existing requirements</h1>
            <div class="requirement-list">
                <g:each in="${requirements}" var="requirement">
                    <a href="<g:createLink controller="requirement" action="show" id="${requirement.id}"/>">
                        <div class="well lead requirement" requirementid="${requirement.id}">
                            <div class="pull-left requirement-label">${requirement.getLabelWithTags()}</div>
                            <a class="btn btn-danger btn-small pull-right" href="<g:createLink controller="dashboard" action="removeRequirement" id="${requirement.id}"/>">Remove</a>
                            <a class="btn btn-small pull-right btn-rename btn-requirement-rename">Rename</a>

                            <g:form action="renameRequirement" id="${requirement.id}">
                                <input class="span5" name="label" type="text" value="${requirement.label}"
                                       autocomplete='off'
                                       placeholder="Enter a requirement label">
                                <button class="btn btn-small pull-right btn-primary btn-save" type="submit">Save</button>
                            </g:form>

                        </div>
                    </a>
                </g:each>
            </div>

            <g:form action="createTopLevelRequirement">
                <div class="input-append">
                    <input class="span5" name="label" type="text" id="input-add-requirement"
                           data-provide="typeahead"
                           autocomplete='off'
                           placeholder="Enter a new requirement label"
                           data-source='${allRequirementLabels}'>
                    <button class="btn btn-primary" type="submit">Create</button>
                </div>
            </g:form>
            <g:if test="${orphanedRequirements.size()>0}">
                <hr/>
                <h1>Orphaned requirements</h1>
                <div class="orphaned-requirements">
                    <g:each in="${orphanedRequirements}" var="requirement">
                        <a href="<g:createLink controller="requirement" action="show" id="${requirement.id}"/>">
                            <div class="well lead requirement">
                                <div class="pull-left">${requirement.label}</div>
                                <a class="btn btn-danger btn-small pull-right" href="<g:createLink controller="dashboard" action="deleteRequirement" id="${requirement.id}"/>">Delete</a>
                            </div>
                        </a>
                    </g:each>
                </div>
            </g:if>

        </div>
    </div>
</div>

<r:script>
    $(document).ready(function(){
        document.getElementById('input-add-requirement').focus();

        $( ".requirement-list" ).sortable({
            stop: function(event, ui) {
                var requirementsOrder = new Array();
                var listRequirements = $(this).find(".requirement");
                listRequirements.each(function(idx, requirement) {
                    var id = $(requirement).attr("requirementid");
                    requirementsOrder.push(id);
                });
                var requirementsIdOrder = requirementsOrder.join("-");
                jQuery.getJSON('${createLink(controller: "dashboard", action: "updateRequirementsOrder")}',
                {requirementsIdOrder: requirementsIdOrder}, function(data) {
                    if (data.status=="success"){
                        window.location.href = window.location.href;
                    }else{
                        alert("Error");
                    }
                });
            }
        });
        $( ".requirement-list").disableSelection();

        $(".btn-requirement-rename").click(function(e){
            var requirement = $(this).closest(".requirement");

            $(requirement).find(".requirement-label").hide();
            $(requirement).find(".btn-rename").hide();
            $(requirement).find("form").show();
            $(requirement).find("input").focus();

        });

    });
</r:script>

</body>
</html>
