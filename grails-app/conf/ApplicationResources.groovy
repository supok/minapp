modules = {
    application {
        resource url:'js/application.js'
    }

    'bootstrap' {
        resource url: '/ext/bootstrap-2.3.1/css/bootstrap.css'
        resource url: '/ext/bootstrap-2.3.1/js/bootstrap.js'
    }

    'app-main' {
        dependsOn "bootstrap"
        resource url:[dir: 'less/layouts', file: 'main.less'], attrs:[rel: "stylesheet/less", type:'css'], disposition: 'head'
    }

}