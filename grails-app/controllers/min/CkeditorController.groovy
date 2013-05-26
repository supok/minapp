package min

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN','ROLE_USER'])
class CkeditorController {

    def basicConfig() {
        render(contentType: 'application/javascript',view: 'basicConfig')
    }
}
