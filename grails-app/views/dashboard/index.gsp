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
                            <div class="pull-left requirement-label" style="width:80%">${requirement.label}</div>
						    
							<div style="float:right" class="btn btn-more-actions btn-mini"><i class="icon-plus-sign icon-white" title="More action"></i>  More</div>
							<div class="more-actions" style="display:none">
								<a class="btn btn-mini pull-right" title="Reorder" data-toggle="tooltip"><i class="icon-move"></i></a>
								<a class="btn btn-mini pull-right" href="<g:createLink controller="dashboard" action="removeRequirement" id="${requirement.id}"/>" title="Remove" data-toggle="tooltip" data-confirm="Are you sure you want to delete?"><i class="icon-remove-sign"></i></a>
								<a class="btn btn-mini pull-right btn-requirement-rename" title="Rename" data-toggle="tooltip"><i class="icon-pencil"></i></a>
                            </div>
							
                            <g:form action="renameRequirement" id="${requirement.id}">
                                <input class="span5 pull-left" name="label" type="text" value="${requirement.label}"
                                       autocomplete='off'
                                       placeholder="Enter a requirement label">
                                <button class="btn btn-small pull-left btn-primary btn-save" type="submit">Save</button>
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
		
		$('.btn-more-actions').mouseover(function(){
			$(this).hide();
			$('.showing-actions').prev('.btn-more-actions').show();
			$('.showing-actions').hide().removeClass('showing-actions');
			$(this).parent().next('div').fadeIn().addClass('showing-actions');
		});
		
		$('.requirement-label').mouseover(function(){
			$('.showing-actions').hide().removeClass('showing-actions');
			$('.btn-more-actions').fadeIn()
		});
		
	    $('a[data-confirm]').click(function(ev) {
	        var href = $(this).attr('href');

	        if (!$('#dataConfirmModal').length) {
	        	$('body').append('<div id="dataConfirmModal" class="modal" role="dialog" aria-labelledby="dataConfirmLabel" aria-hidden="true"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button><h3 id="dataConfirmLabel">Please Confirm</h3></div><div class="modal-body"></div><div class="modal-footer"><button class="btn" data-dismiss="modal" aria-hidden="true">Cancel</button><a class="btn btn-primary" id="dataConfirmOK">OK</a></div></div>');
	         } 
	         $('#dataConfirmModal').find('.modal-body').text($(this).attr('data-confirm'));
	         $('#dataConfirmOK').attr('href', href);
	         $('#dataConfirmModal').modal({show:true});
	         return false;
	     });

    });
</r:script>

</body>
</html>
