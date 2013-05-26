package min

class RequirementService {

    public List<Requirement> getAllTopLevelRequirementsSorted(){
        List<Requirement> requirements = Requirement.createCriteria().list {
            eq("topLevel", Boolean.TRUE)
            order("position", "asc")
        }
        return requirements
    }

    public Requirement createTopLevelRequirement(String label){

        Integer topLevelRequirementsCount = Requirement.createCriteria().count {
            eq("topLevel", Boolean.TRUE)
        }

        Requirement requirement = Requirement.findByLabel(label)
        if (requirement){
            requirement.topLevel = Boolean.TRUE
            requirement.position = topLevelRequirementsCount
        }else{
            requirement = new Requirement()
            requirement.label = label
            requirement.topLevel = Boolean.TRUE
            requirement.position = topLevelRequirementsCount + 1
        }
        requirement.save(flush: true)

        normalize()

        return requirement
    }

    public void removeRequirement(Requirement requirement){
        requirement.topLevel = Boolean.FALSE
        requirement.position = 0
        requirement.save()
    }

    private void normalize(){
        List<Requirement> requirements = getAllTopLevelRequirementsSorted()
        requirements.eachWithIndex {Requirement req, Long idx ->
            req.position = ++idx;
            req.save()
        }
    }

    public void createStep(String stepLabel, Sequence sequence){

        Requirement linkedRequirement = Requirement.findByLabel(stepLabel);

        if (linkedRequirement) {
            Step newStep = new Step();
            newStep.requirement = linkedRequirement
            newStep.position = sequence.getStepsSorted().size() + 1
            sequence.addToSteps(newStep)
            sequence.save();

        } else {
            Requirement newRequirement = new Requirement();
            newRequirement.label = stepLabel;
            newRequirement.save();

            Step newStep = new Step();
            newStep.requirement = newRequirement
            if (sequence.steps){
                newStep.position = sequence.getStepsSorted().last().position + 1
            }else{
                newStep.position = 1
            }
            sequence.addToSteps(newStep);
            sequence.save();
        }
    }

    public void createExtension(String extensionLabel, Requirement requirement, List<String> checkedSteps) {
        Extension extension = new Extension();
        extension.label = extensionLabel;
        extension.save();

        /* Add ExtensionOrder for current Requirement */
        createExtensionOrder(requirement, extension)

        if (checkedSteps == null || checkedSteps.size() == 0) {

            createExtensionRelationship(requirement, extension)

            /* Check if current extension is a step of any other extension and add an ExtensionOrder for it */
            List<Step> steps = Step.findAllByRequirement(requirement)
            steps.each {
                createExtensionOrder(it.sequence, extension)
            }

        } else {
            for (stepId in checkedSteps) {

                Step step = Step.findById(new Long(stepId));

                /* Add ext relationship */
                createExtensionRelationship(step.requirement, extension)

                /* Add ExtensionOrder for step Requirement */
                createExtensionOrder(step.requirement, extension)

                /* Check if current extension is a step of any other extension and add an ExtensionOrder for it */
                List<Step> steps = Step.findAllByRequirement(step.requirement)
                steps.each {
                    createExtensionOrder(it.sequence, extension)
                }

            }
        }
    }

    private void createExtensionRelationship(Requirement requirement, Extension extension){
        ExtensionRelationship rel = new ExtensionRelationship();
        rel.requirement = requirement;
        rel.extension = extension;
        rel.save();
    }

    private void createExtensionOrder(Requirement requirement, Extension extension){
        ExtensionOrder extensionOrder = new ExtensionOrder()
        extensionOrder.requirement = requirement
        extensionOrder.extension = extension
        ExtensionOrder order = ExtensionOrder.findByRequirement(requirement,[sort:"position", order: "desc"])
        if (order) {
            extensionOrder.position = order.position + 1
        } else {
            extensionOrder.position = 1
        }
        extensionOrder.save()
    }

    public void removeStep(Long id, Long extensionId){
        Sequence parent = Sequence.findById(extensionId)
        try{
            Step step = Step.findById(id)
            parent.removeFromSteps(step)
            parent.save()
            step.delete()
        }catch (Exception e){
            e.printStackTrace()
        }

        List<Step> steps = parent.getStepsSorted()
        steps.eachWithIndex {step, idx ->
            step.position = idx + 1;
            step.save()
        }
    }

    public void deleteRequirement(Requirement requirement){

        requirement.getExtensionsMap().each {k, v->
            deleteExtension(k)
        }
        requirement.delete()

    }

    public void deleteExtension(Extension extension) {
        def requirementExtensionOrders = ExtensionOrder.createCriteria().list {
            eq("extension", extension)
        }
        requirementExtensionOrders.each {
            it.delete()
        }

        def requirementExtensionRelationships = ExtensionRelationship.createCriteria().list {
            eq("extension", extension)
        }
        requirementExtensionRelationships.each {
            it.delete()
        }

        extension.delete()
    }

    public void updateStepsOrder(String[] ids) {
        ids.eachWithIndex { it, idx ->
            Step s = Step.findById(it)
            s.position = idx + 1
            s.save()
        }
    }

    public void updateRequirementsOrder(String[] ids) {
        ids.eachWithIndex { it, idx ->
            Requirement s = Requirement.findById(it)
            s.position = idx + 1
            s.save()
        }
    }

    public void updateExtensionsOrder(String[] ids, Requirement requirement) {

        ids.eachWithIndex { it, idx ->
            Extension extension = Extension.findById(it)
            ExtensionOrder extensionOrder = ExtensionOrder.findByExtensionAndRequirement(extension, requirement)
            extensionOrder.position = idx + 1
            extensionOrder.save()
        }
    }

}
