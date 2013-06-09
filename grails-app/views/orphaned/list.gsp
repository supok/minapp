<html>
<head>
    <title>Orphaned</title>
    <meta name="layout" content="main">
</head>

<body>

<div id="dashboard">
    <div class="row">
        <div class="span12">

            <h2>Orphaned requirements</h2>
            <div class="orphaned-requirements">
                <g:each in="${orphanedRequirements}" var="requirement">
                    <a href="<g:createLink controller="requirement" action="show" id="${requirement.id}"/>">
                        <div class="well lead requirement">
                            <div class="pull-left">${requirement.getLabelWithTags()}</div>
                            <a class="btn btn-mini pull-right" href="<g:createLink controller="orphaned" action="deleteRequirement" id="${requirement.id}" title="Remove" data-toggle="tooltip" data-confirm="Are you sure you want to delete?"/>"><i class="icon-remove-sign"></i> Delete</a>
                        </div>
                    </a>
                </g:each>
            </div>

        </div>
    </div>
</div>

</body>
</html>
