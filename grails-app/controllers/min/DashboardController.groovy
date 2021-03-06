package min

import grails.converters.JSON
import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN','ROLE_USER'])
class DashboardController {

    def requirementService

    private static final REQIIREMENT_HISTORY = "requirementsHistory"

    def index() {

        List<Requirement> requirements = requirementService.getAllTopLevelRequirementsSorted()

        def allRequirementLabels = Requirement.list()*.label as JSON

        session.removeAttribute(REQIIREMENT_HISTORY)

        [requirements: requirements, allRequirementLabels: allRequirementLabels]
    }

    def createTopLevelRequirement(String label){

        if (label){
            Requirement requirement = requirementService.createTopLevelRequirement(label)
            redirect (controller: "requirement", action: "show", id: requirement.id)
        }else{
            flash.error = g.message(code:"min.ExtensionController.requirement.add.blank")
            redirect (action: "index")
        }

    }

    def renameRequirement(Long id, String label){
        if (label){
            Requirement requirement = Requirement.findById(id)
            Requirement existingRequirement = Requirement.findByLabel(label)

            if(existingRequirement && existingRequirement.id!=requirement.id){
                if(existingRequirement.topLevel){
                    flash.error = g.message(code:"min.ExtensionController.requirement.rename.exists.topLevel")
                }else{
                    flash.error = g.message(code:"min.ExtensionController.requirement.rename.exists")
                }
            }else{
                requirement.label = label
                requirement.save()

                requirementService.assignTagsToRequirement(label, requirement)

            }
        }else{
            flash.error = g.message(code:"min.ExtensionController.requirement.rename.blank")
        }

        redirect(action: "index")
    }

    def updateRequirementsOrder(){
        def requirementsIdOrder = params.requirementsIdOrder
        String[] ids = requirementsIdOrder.split("-")

        requirementService.updateRequirementsOrder(ids)

        def map = [status: "success"]
        render map as JSON
    }

    def removeRequirement(Long id){
        Requirement requirement = Requirement.findById(id)
        requirementService.removeRequirement(requirement)
        List<Requirement> requirements = requirementService.getAllTopLevelRequirementsSorted()
        requirements.eachWithIndex {it, idx ->
            it.position = idx + 1
            it.save()
        }
        redirect(action: 'index')
    }

}
