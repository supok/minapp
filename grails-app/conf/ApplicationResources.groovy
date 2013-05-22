modules = {
    application {
        resource url:'js/application.js'
    }

    'bootstrap' {
        resource url: '/ext/bootstrap-2.3.1/css/bootstrap.css'
        resource url: '/ext/bootstrap-2.3.1/js/bootstrap.js'
        resource url: '/ext/font-awesome/css/font-awesome.min.css'
    }

    'fineuploader' {
        dependsOn 'jquery'
        resource url: '/ext/jquery-fineuploader-3.5.0/iframe.xss.response-3.5.0.js'
        resource url: '/ext/jquery-fineuploader-3.5.0/jquery.fineuploader-3.5.0.js'
        resource url: '/ext/jquery-fineuploader-3.5.0/fineuploader-3.5.0.css'
    }

    'app-main' {
        dependsOn "bootstrap"
        resource url:[dir: 'less/layouts', file: 'main.less'], attrs:[rel: "stylesheet/less", type:'css'], disposition: 'head'
    }

}