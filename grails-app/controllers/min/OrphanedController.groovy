package min

import grails.plugins.springsecurity.Secured

@Secured(['ROLE_ADMIN','ROLE_USER'])
class OrphanedController {

    def requirementService

    private static final REQIIREMENT_HISTORY = "requirementsHistory"

    def list() {

        List<Requirement> orphanedRequirements = Requirement.createCriteria().list {
            and{
                eq('topLevel',Boolean.FALSE)
                List<Step> steps = Step.list()
                if (steps){
                    List<Long> stepRequirementsIds = steps*.requirement*.id
                    not {'in'("id",stepRequirementsIds)}
                }
            }
        }

        session.removeAttribute(REQIIREMENT_HISTORY)

        [orphanedRequirements: orphanedRequirements]
    }

    def deleteRequirement(Long id){
        Requirement requirement = Requirement.findById(id)
        requirementService.deleteRequirement(requirement)
        redirect(action: 'list')
    }
}
