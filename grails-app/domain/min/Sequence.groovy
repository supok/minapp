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

    public List<Step> getStepsSorted(){
        Step.findAllBySequence(this,  [sort: "position", order: "asc"]);
    }

}
