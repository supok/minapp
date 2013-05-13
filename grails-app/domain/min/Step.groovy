package min

class Step {

    Date dateCreated
    Date lastUpdated

    Requirement requirement
    Long position

    static belongsTo = [sequence: Sequence]

    static constraints = {
    }

}
