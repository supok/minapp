package min

class RequirementTag {

    Date dateCreated
    Date lastUpdated

    TagGroup tagGroup
    Tag tag

    Boolean dirty = Boolean.FALSE

    static hasMany = [requirements: Requirement]

    static belongsTo = Requirement

    static constraints = {
        dirty nullable: true
    }

    static mapping = {
        dirty(type: "yes_no")
    }
}
