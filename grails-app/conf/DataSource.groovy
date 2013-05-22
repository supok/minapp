dataSource {
    pooled = true
    driverClassName = "org.h2.Driver"
    username = "sa"
    password = ""
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = false
    cache.region.factory_class = 'net.sf.ehcache.hibernate.EhCacheRegionFactory'
}
// environment specific settings
environments {
    development {

        println "USING DEVELOPEMENT DATABASE min"

        dataSource {
//            url = "jdbc:mysql://localhost/minapp"
//            username = "root"
//            password = ""
//            driverClassName = "com.mysql.jdbc.Driver"
//            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
//            logSql = false
            dbCreate = "update" // one of 'create', 'create-drop', 'update', 'validate', ''
        }

    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:h2:mem:testDb;MVCC=TRUE;LOCK_TIMEOUT=10000"
        }
    }
    production {
        def jdbc_url = System.getProperty("JDBC_CONNECTION_STRING")
        println "USING JDBC URL IN DATASOURCE: " + jdbc_url

        dataSource {
            url = jdbc_url
            username = System.getProperty("PARAM1")
            password = System.getProperty("PARAM2")
            driverClassName = "com.mysql.jdbc.Driver"
            dialect = org.hibernate.dialect.MySQL5InnoDBDialect
            pooled = true
            properties {
                maxActive = -1
                minEvictableIdleTimeMillis=1800000
                timeBetweenEvictionRunsMillis=1800000
                numTestsPerEvictionRun=3
                testOnBorrow=true
                testWhileIdle=true
                testOnReturn=true
                validationQuery="SELECT 1"
            }
        }
    }
}
