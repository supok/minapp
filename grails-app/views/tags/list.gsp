<html>
<head>
    <title>Tags</title>
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

            <h1>Manage tags</h1>
            <table class="table">
                <thead>
                    <tr>
                        <th>Tag Group Name</th>
                        <th>Tag Name</th>
                        <th>Name Code</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>

                    <g:each in="${tagGroups}" var="tagGroup">
                        <tr style="background-color: #f9f9f9;">
                            <g:form action="updateTagGroup" id="${tagGroup.id}">

                                <td>
                                    %{--<input type="text" name="nameCode" value="${tagGroup.nameCode}" style="margin-bottom: 0px;"/>--}%
                                    ${tagGroup.nameCode}
                                </td>
                                <td></td>
                                <td><input type="text" name="name" value="${tagGroup.name}" style="margin-bottom: 0px;"/></td>
                                <td><button type="submit" class="btn btn-primary btn-small" >Update</button> </td>
                            </g:form>
                        </tr>
                        <g:each in="${tagGroup.getAllTags()}" var="tag">
                            <tr>
                                <g:form action="updateTag" id="${tag.id}">
                                    <td></td>
                                    <td>
                                        %{--<input type="text" name="nameCode" value="${tag.nameCode}" style="margin-bottom: 0px;"/>--}%
                                        ${tag.nameCode}
                                    </td>
                                    <td><input type="text" name="name" value="${tag.name}" style="margin-bottom: 0px;"/></td>
                                    <td><button type="submit" class="btn btn-primary btn-small" >Update</button> </td></td>
                                </g:form>
                            </tr>
                        </g:each>
                    </g:each>

                </tbody>

            </table>

        </div>
    </div>
</div>

<r:script>
    $(document).ready(function(){

    });
</r:script>

</body>
</html>
