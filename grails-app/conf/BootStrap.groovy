import min.DomainLoader
import min.Role
import min.User
import min.UserRole
import grails.util.Environment

class BootStrap {

    def init = { servletContext ->


        if (Environment.getCurrent().name == 'production') {

            /*
             *  Production
             */

            println 'IN PRODUCTION: MIN'

        } else if (Environment.getCurrent().name == 'development') {

            /*
             *  Development
             */

            println "LOADING DEV DATABASE"

            new DomainLoader().load()


        }


    }
    def destroy = {
    }
}
