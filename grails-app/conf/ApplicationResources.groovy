modules = {
    application {
        resource url:'js/application.js'
    }

    'bootstrap' {
        resource url: '/ext/bootstrap-2.3.1/css/bootstrap.css'
        resource url: '/ext/bootstrap-2.3.1/js/bootstrap.js'
        resource url: '/ext/font-awesome/css/font-awesome.min.css'
        resource url: '/ext/bootstrap-lightbox/css/bootstrap-lightbox.css'
        resource url: '/ext/bootstrap-lightbox/js/bootstrap-lightbox.js'
        //resource url: '/ext/bootstrap-2.3.1/js/typeahead.js'
    }

    'fineuploader' {
        dependsOn 'jquery'
        resource url: '/ext/jquery-fineuploader-3.5.0/iframe.xss.response-3.5.0.js'
        resource url: '/ext/jquery-fineuploader-3.5.0/jquery.fineuploader-3.5.0.js'
        resource url: '/ext/jquery-fineuploader-3.5.0/fineuploader-3.5.0.css'
    }

    'nailthumb' {
        dependsOn 'jquery'
        resource url: '/ext/nailthumb/jquery.nailthumb.1.1.min.css'
        resource url: '/ext/nailthumb/jquery.nailthumb.1.1.min.js'
    }

    'jsizes' {
        dependsOn 'jquery'
        resource url: '/ext/jquery.sizes.js'
    }

    'app-main' {
        dependsOn "bootstrap"
        resource url:[dir: 'less/layouts', file: 'main.less'], attrs:[rel: "stylesheet/less", type:'css'], disposition: 'head'
    }


}