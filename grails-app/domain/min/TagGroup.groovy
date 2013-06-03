package min

class TagGroup {

    Date dateCreated
    Date lastUpdated

    String name
    String nameCode

    static constraints = {
    }

    public List getAllTags(){

        List requirementTags = RequirementTag.findAllByTagGroup(this)

        return requirementTags*.tag

    }
}
