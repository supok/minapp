package min

class Sequence {

    Date dateCreated
    Date lastUpdated

    String label
    String description
    Long position

    List<Step> steps

    static mappedBy = [steps: 'sequence']

    static hasMany = [steps:Step]

    static constraints = {
        description nullable: true
        position nullable: true
    }

    static mapping = {
        description(type: "text")
    }

    public List<Step> getStepsSorted(){
        Step.findAllBySequence(this,  [sort: "position", order: "asc"]);
    }

    public String getLabelWithTags(){
        label.replaceAll(/@(\w+):(\w+)/,{

            String first = it[0].tokenize(':').first()
            first = first.substring(1,first.length())

            String second = it[0].tokenize(':').last()

            return "<span class='tag'>@${TagGroup.findByNameCode(first)?.name}:${Tag.findByNameCode(second)?.name}</span>"
        })
    }

}
