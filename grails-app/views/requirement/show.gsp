<html>
<head>
    <title>Requirement</title>
    <meta name="layout" content="main">
    <r:require modules="fineuploader, nailthumb, jsizes"/>
    <ckeditor:resources/>
</head>
<body>

<div id="requirement">
    <div class="row">
        <div class="span12">

            <div class="min-nav">
                <h3>
                    <a href="<g:createLink controller="requirement" action="back"/>" class="btn btn-small" type="button" > <i class="icon-arrow-left"></i> Back</a>
                    <span>${requirement.getLabelWithTags()}</span>
                </h3>
            </div>

            <g:if test="${requirement.getParentRequirements() || requirement.getParentExtensions()}">
                <div class="row">
                    <div class="span12">
                        <table class="table table-condensed table-bordered table-hover">
                            <tbody>
                            <g:if test="${requirement.getParentRequirements()}">
                                <tr class="table-header">
                                    <td><strong>Substep of requirement(s)</strong></td>
                                </tr>
                                <g:each in="${requirement.getParentRequirements()}" var="parent">
                                    <tr>
                                        <td><a href="<g:createLink controller="requirement" action="show" id="${parent.id}"/>">${parent.getLabelWithTags()}</a></td>
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
                                <div class="input-append input-prepend">
                                    <span class="add-on">${requirement.steps.size() + 1}.</span>
                                    <input class="span4" name="stepLabel" type="text" id="add-main-path-step"
                                           data-provide="typeahead"
                                           autocomplete='off'
                                           placeholder="Enter a new step label"
                                           data-source='${allRequirementLabels}'>
                                    <button class="btn btn-primary" type="submit">Add Step</button>
                                </div>
                                <a href="#step-help-modal" role="button" data-toggle="modal" class="btn btn-mini">Help</a>
                            </g:form>
                        </td>
                    </tr>
                </tbody>
            </table>

			<!-- Add Notes & Images -->
            <table class="table table-bordered">
                <tbody>
                <tr class="table-header">
                    <td>
                        <strong>Notes &amp; Images</strong>
                    </td>
                </tr>
				<tr>
                    <td style="overflow: hidden;">
                    <g:if test="${requirement.photos || requirement.description}">   
					    <div class="pull-left" style="width: 550px;">
                            ${requirement.description}
                        </div>
                        <g:if test="${requirement.photos}">
                            <div class="pull-right" style="height: 70px;">
                                <g:each in="${requirement.photos}" var="photo">
                                    <div style="float: right; margin-left: 10px;">
                                        <a class="icon-remove" style="color: #da4f49; text-decoration: none; position: relative; z-index: 1; left: 64px; top: -10px;" href="<g:createLink action="deletePhoto" id="${photo.id}"/>"></a>
                                        <div class="nailthumb-container" style="margin-top: -20px;">
                                            <img class="preview-photo" src="<g:createLink controller="requirement" action="showImage" id="${photo.id}"/>" height="70" width="70">
                                        </div>
                                    </div>
                                </g:each>
                            </div>
                        </g:if>
                    </g:if>
                    <g:else>
                        <p class="muted text-center">There are no notes or images</p>
                    </g:else>
					</td>
                </tr>
				<tr class="table-footer">
					<td><a href="#requirement-modal" role="button" data-toggle="modal" class="btn btn-primary pull-right">Add Notes &amp; Images</a></td>
				</tr>
                </tbody>
            </table>
            

            <%-- Show Extensions --%>
            <div class="extension-list">
            <g:each in="${requirement.getExtensionsMap()}" var="extensionMap">

                <table class="table table-bordered extension" extensionid="${extensionMap.key.id}">
                    <tbody>
                    <tr class="table-header" style="cursor: pointer; cursor: hand;">
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
                           
						    <div style="float:right" class="btn btn-more-actions btn-mini btn-inverse"><i class="icon-plus-sign icon-white" title="More action"></i>  More</div>
							<div class="more-actions" style="display:none">
								<a class="btn btn-mini pull-right" title="Reorder" data-toggle="tooltip"><i class="icon-move"></i></a>
                            	<a class="btn btn-mini pull-right" href="<g:createLink controller="requirement" action="deleteExtension" id="${extensionMap.key.id}" params="[requirementId: requirement.id]"/>" title="Remove" data-toggle="tooltip" data-confirm="Are you sure you want to delete?"><i class="icon-remove-sign"></i></a>
								<a class="btn btn-mini pull-right btn-extension-rename" title="Rename" data-toggle="tooltip"><i class="icon-pencil"></i></a>
								
                            </div>
							<g:form action="renameExtension" id="${extensionMap.key.id}">
                                <input type="hidden" name="requirementId" value="${requirement.id}">
                                <input class="span5" style="float:left" name="label" type="text" value="${extensionMap.key.label}"
                                       autocomplete='off'
                                       placeholder="Enter extensiono label">
                                <button style="float:left;margin-left:10px" class="btn btn-mini btn-primary btn-save" type="submit">Save</button>
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
                                <div class="input-append input-prepend">
                                    <span class="add-on">${extensionMap.key.steps.size() + 1}.</span>
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

<div class="modal hide fade" id="requirement-modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Requirement notes and images</h3>
    </div>
    <div class="modal-body">
        <%-- Notes and upload images --%>
        <p>
            <strong>Upload images</strong>
        </p>
        <div class="upload-container">
            <div id="requirement-photo-container">
                <g:set var="uploadedImagesCount" value="${0}"/>
                <g:each in="${requirement.photos}" var="photo" status="index">
                    <div class="photo-space taken nailthumb-container" style="overflow: hidden; padding: 0px; width: 70px; height: 70px;">
                        <img src="<g:createLink controller="requirement" action="showImage" id="${photo.id}"/>" class="nailthumb-image">
                    </div>
                    <g:set var="uploadedImagesCount" value="${index + 1}"/>
                </g:each>
                <g:if test="${uploadedImagesCount < 4}">
                    <g:each in="${ (uploadedImagesCount ..< 3) }">
                        <div class="photo-space"><i class="icon-refresh icon-spin icon-2x"></i></div>
                    </g:each>
                    <div style="margin-right: 0px;" class="photo-space"><i class="icon-refresh icon-spin icon-2x"></i></div>
                    <div id="requirement-uploader" style="margin-left: ${10*uploadedImagesCount + 70*uploadedImagesCount}px;"></div>
                </g:if>
            </div>
        </div>
        <p>
            <strong>Edit notes</strong>
        </p>
        <g:form action="saveNotes" id="${requirement.id}">
            <div id="post-modal-photos">

            </div>
            <div class="controls">
                <ckeditor:editor height="150" width="100%" id="editor-1"
                                 name="notes"
                                 customConfig="${createLink(controller: 'ckeditor', action: 'basicConfig')}">
                    ${requirement.description}
                </ckeditor:editor>
            </div>
    </div>
    <div class="modal-footer">
        <a class="btn" data-dismiss="modal" aria-hidden="true">Close</a>
        <button class="btn btn-primary" type="submit">Save</button>
         </g:form>
    </div>
</div>

<div class="modal hide fade" id="step-help-modal">
    <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h3>Help</h3>
    </div>
    <div class="modal-body">
        <p>You can use tags in a step label. No spaces are allowed.</p>
        <p>Use <span class="tag">@tagGroup:tag</span> tag format. For example <span class="tag">@user:maxim</span> or <span class="tag">@action:login</span>.</p>
        <p>You can go to Tags section to edit how tags are displayed. For example you can make <span class="tag">@user:maxim</span> to look like <span class="tag">@user:Maxim</span> when it is displayed.</p>
    </div>
    <div class="modal-footer">
        <a href="#" class="btn" data-dismiss="modal">Close</a>
    </div>
</div>

<div id="preview-image-modal" class="lightbox hide fade"  tabindex="-1" role="dialog" aria-hidden="true">
    <div class='lightbox-header'>
        <button type="button" class="close" data-dismiss="lightbox" aria-hidden="true">&times;</button>
    </div>
    <div class='lightbox-content'>
    </div>
</div>


<r:script>
    $(document).ready(function(){
        // Use to get json taggroups for autocomplete
        $.getJSON('${createLink(controller: "requirement", action: "ajaxTagGroups")}',
            {}, function(data) {
                //alert(data.tagGroups);
            });

        $('.preview-photo').click(function (e) {
            var html = "<img src='" + $(this).attr('src') + "'/>";
            var m = $('#preview-image-modal');
            m.find('.lightbox-content').html(html);
            m.lightbox({keyboard:true, show:true, resizeToFit: true})
            e.preventDefault();
        });

        $('.nailthumb-container').nailthumb({animationTime:0,width:70,height:70});

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
            connectWith: ".extension-list",
            start: function(e, ui){
                ui.placeholder.height(ui.item.height());
            },
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

        $(".child-steps-tooltip").tooltip({"placement":"top"});
		
		$('#add-main-path-step').focus();
		
		$('.btn-more-actions').mouseover(function(){
			$(this).hide();
			$('.showing-actions').prev('.btn-more-actions').show();
			$('.showing-actions').hide().removeClass('showing-actions');
			$(this).next('div').fadeIn().addClass('showing-actions');
		});
		
		$('.step-label').mouseover(function(){
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

        $('#add-main-path-step').focus();


        /* --- UPLOADER --- */
        $('#requirement-uploader').fineUploader({
            validation: {
                allowedExtensions: ['jpeg', 'jpg'],
                sizeLimit: 5242880
            },
            showMessage: function(message) {
                $('#requirement-error').html(message);
                $('#requirement-error').show();
            },
            text: {
                uploadButton: '<div><i class="icon-camera icon-2x"></i></div>'
            },
            template:'<div class="qq-uploader">' +
'<pre class="qq-upload-drop-area">{dragZoneText}</pre>' +
'<div class="qq-upload-button btn btn-primary"> {uploadButtonText} </div>' +
'<span class="qq-drop-processing"><span>{dropProcessingText}</span><span class="qq-drop-processing-spinner"></span></span>' +
'<ul class="qq-upload-list"></ul>' +
'</div>',
            request: {
                endpoint: "<g:createLink controller="requirement" action="upload" id="${requirement.id}"/>",
                paramsInBody:true
            }
        }).on('complete', function(event, id, fileName, response) {
            if($("input[name='photoIds']").length < 4) {
                var url = response.photoUrl;
                var id = response.photoId;
                var photoIndex = $("#requirement-photo-container .photo-space.taken").length;
                var $photoSpace = $($("#requirement-photo-container .photo-space")[photoIndex]);
                $("#requirement-photos").append('<input type="hidden" name="photoIds" value="' + id + '"/>');
                $photoSpace.removeClass('loading');
                $photoSpace.html('<img src="' + url + '"/>');
                $photoSpace.nailthumb({animationTime:0, width:$photoSpace.outerWidth(), height:$photoSpace.outerHeight()});
                $photoSpace.addClass('taken');
            }
        }).on('upload', function(event, id, fileName, response) {

            // Set the last photo-space to loading.
            var photoIndex = $("#requirement-photo-container .photo-space.taken, #requirement-photo-container .photo-space.loading").length;
            var photoSpace = $("#requirement-photo-container .photo-space")[photoIndex];
            var $photoSpace = $(photoSpace);
            $photoSpace.addClass('loading');

            // Hide the upload button if necessary.
            if(photoIndex == 3) {
                $('#requirement-uploader').hide();
            } else {
                $('#requirement-uploader').css({
                    marginLeft: (photoIndex + 1) * ($photoSpace.outerWidth() + $photoSpace.margin().right)
                });
            }
        }).on('error', function(event, id, fileName, response) {

        });

    });
</r:script>

</body>
</html>