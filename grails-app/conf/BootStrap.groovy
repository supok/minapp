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
            if (!System.getProperty('mysqldb')) {
                println "LOADING DEVELOPEMENT MYSQL DATABASE"
//                new DomainLoader().load()
            }else{
                // Comment the following lines if you do not want to load initial data in database
                // every time server starts up
                println "LOADING DEVELOPEMENT H2 DATABASE"
                new DomainLoader().load()
            }


        }


    }
    def destroy = {
    }
}
