package min

class Role {

    Date dateCreated
    Date lastUpdated

	String authority

	static mapping = {
		cache true
	}

	static constraints = {
		authority blank: false, unique: true
	}
}
