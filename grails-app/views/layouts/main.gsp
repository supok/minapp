<!DOCTYPE html>
<!--[if lt IE 7 ]> <html lang="en" class="no-js ie6"> <![endif]-->
<!--[if IE 7 ]>    <html lang="en" class="no-js ie7"> <![endif]-->
<!--[if IE 8 ]>    <html lang="en" class="no-js ie8"> <![endif]-->
<!--[if IE 9 ]>    <html lang="en" class="no-js ie9"> <![endif]-->
<!--[if (gt IE 9)|!(IE)]><!--> <html lang="en" class="no-js"><!--<![endif]-->

	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

    <title>MIN &mdash; <g:layoutTitle/></title>

        <meta name="viewport" content="width=1050">

        <r:require modules="jquery, jquery-ui, app-main"/>

        <g:layoutHead/>
		<r:layoutResources />
	</head>

	<body>

        <div class="navbar navbar-inverse navbar-fixed-top">
            <div class="navbar-inner">
                <div class="container">
                    <sec:ifLoggedIn>

                        <div class="btn-group pull-right">
                            <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
                                <sec:username/><span class="caret"></span>
                            </a>
                            <ul class="dropdown-menu">
                                <li><a href="${createLink(controller: 'logout')}">Sign Out</a></li>
                            </ul>
                        </div>
                    </sec:ifLoggedIn>

                    <sec:ifLoggedIn>
                        <ul class="nav">

                            <sec:ifAnyGranted roles="ROLE_USER">

                                <li <g:if test="${controllerName=='dashboard'}">class="active"</g:if>><a class="tab-orders" href="${createLink(controller: 'dashboard',action: 'index')}">MIN Dashboard </a></li>

                            </sec:ifAnyGranted>
                        </ul>
                    </sec:ifLoggedIn>
                    <sec:ifNotLoggedIn>
                        <g:if test="${controllerName!='login'}">
                            <ul class="nav pull-right">
                                <li> <a class="tab-orders" href="${createLink(controller: 'login')}">Sign in</a> </li>
                            </ul>
                        </g:if>
                    </sec:ifNotLoggedIn>
                </div>
            </div>
        </div>

        <div class="container">

            <g:layoutBody/>

            <hr>

            <footer>
                <p>Powered by <a href="http://www.3wks.com.au">3WKS</a></p>
            </footer>

        </div>

        <r:script>
            $(document).ready(function(){

            });
        </r:script>

        <g:javascript library="application"/>
		<r:layoutResources />

	</body>

</html>
