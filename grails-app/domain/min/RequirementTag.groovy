package min

class RequirementTag {

    Date dateCreated
    Date lastUpdated

    TagGroup tagGroup
    Tag tag

    static hasMany = [requirements: Requirement]

    static belongsTo = Requirement

    static constraints = {

    }
}
