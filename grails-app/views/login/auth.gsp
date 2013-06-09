<html>
<head>
    <title>Login</title>
    <meta name="layout" content="main">
</head>

<body>

<div class="hero-unit">
    <g:if test="${firstUser}">
        <h1>Please create first user</h1>
        <g:form controller="login" action="createFirstUser" autocomplete='off' style="margin: 20px 0;">
            <div class="control-group">
                <label class="control-label" for="new_firstName">First Name</label>
                <div class="controls">
                    <input type='text' name='firstName' id='new_firstName'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="new_lastName">Last Name</label>
                <div class="controls">
                    <input type='text' name='lastName' id='new_lastName'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="new_email">Email</label>
                <div class="controls">
                    <input type='text' name='email' id='new_email'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="new_username">Username</label>
                <div class="controls">
                    <input type='text' name="username" id='new_username'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="new_password">Password</label>
                <div class="controls">
                    <input type='password' name='password' id='new_password'/>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Create</button>
        </g:form>
    </g:if>
    <g:else>
        <h1>Login</h1>
        <form action='${postUrl}' method='POST' id='loginForm' autocomplete='off' style="margin: 20px 0;">
            <div class="control-group">
                <label class="control-label" for="username">Username</label>
                <div class="controls">
                    <input type='text' class='text_' name='j_username' id='username'/>
                </div>
            </div>
            <div class="control-group">
                <label class="control-label" for="password">Password</label>
                <div class="controls">
                    <input type='password' class='text_' name='j_password' id='password'/>
                </div>
            </div>
            <div class="control-group">
                <div class="controls">
                    <label class="checkbox">
                        <input type='checkbox' class='chk' name='${rememberMeParameter}' id='remember_me' <g:if test='${hasCookie}'>checked='checked'</g:if>/>
                        Stay logged in
                    </label>
                </div>
            </div>
            <button type="submit" class="btn btn-primary">Login</button>
        </form>
    </g:else>


</div>

<r:script>
    $(document).ready(function(){
        document.getElementById('username').focus();
    });
</r:script>

</body>
</html>
