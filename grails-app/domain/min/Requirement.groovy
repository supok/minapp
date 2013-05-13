package min

import grails.gorm.DetachedCriteria

class Requirement extends Sequence {

    Boolean topLevel = Boolean.FALSE

    static mapping = {
        topLevel type: 'yes_no'
    }

    static constraints = {
    }

    public Map<Exception, List<Step>> getExtensionsMap(){

        Map<Extension, List<Step>> extensionsMap = new HashMap<Extension, List<Step>>();

        steps.each {Step step ->
            List<Extension> stepExtensions = ExtensionRelationship.createCriteria().list {
                eq("requirement", step.requirement)
            }*.extension

            for (Extension extension : stepExtensions) {
                List<Step> steps = extensionsMap.get(extension);
                if (steps == null) {
                    steps = new ArrayList<Step>();
                    extensionsMap.put(extension, steps);
                }
                steps.add(step);
            }
        }

        List<Extension> selfExtensions = ExtensionRelationship.createCriteria().list {
            eq("requirement", this)
        }*.extension

        for (Extension extension : selfExtensions) {
            List<Step> steps = extensionsMap.get(extension);
            if (steps == null) {
                steps = new ArrayList<Step>();
                extensionsMap.put(extension, null);
            }
            steps.add(null);
        }

        def sortedMap = extensionsMap.sort( { e1, e2 ->
            ExtensionOrder eo1 = ExtensionOrder.findByExtensionAndRequirement(e1, this)
            ExtensionOrder eo2 = ExtensionOrder.findByExtensionAndRequirement(e2, this)
            eo1.position <=> eo2.position
        } as Comparator )

        return sortedMap
    }

    public List<Sequence> getParents(){
        List<Sequence> parents = Step.createCriteria().list {
            eq('requirement', this)
        }*.sequence

        return parents
    }

    public List<Requirement> getParentRequirements(){

        List<Requirement> requirements = []
        getParents().each {
            if (it.instanceOf(Requirement)){
                requirements << it
            }
        }
        return requirements
    }

    public List<Extension> getParentExtensions(){
        List<Extension> extensions = []

        this.getParents().each {
            if (it.instanceOf(Extension)){
                extensions << it
            }
        }
        return extensions
    }

    public deepDelete(){
        for (Step step : steps) {
            step.deepDelete();
        }

        def s = Step.createCriteria().list {
            or{
                eq('requirement', this)
                eq('sequence',this)
            }
        }
        s.each {
            it.delete()
        }

        new DetachedCriteria(ExtensionOrder).build {
            eq('requirement', this)
        }.deleteAll()

        new DetachedCriteria(ExtensionRelationship).build {
            eq('requirement', this)
        }.deleteAll()

        this.delete();
    }

}
