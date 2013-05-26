package min

import grails.converters.JSON
import grails.plugins.springsecurity.Secured
import org.springframework.web.multipart.commons.CommonsMultipartFile

@Secured(['ROLE_ADMIN','ROLE_USER'])
class RequirementController {

    def requirementService

    private static final REQIIREMENT_HISTORY = "requirementsHistory"

    def show(Long id){
        def requirement = Requirement.findById(id)
        def allRequirementLabels = Requirement.list()*.label as JSON

        List<Long> history = session.getAttribute(REQIIREMENT_HISTORY)
        if (history){
            if(history.last() != id){
                history.add(id)
            }
        }else{
            history = new ArrayList<Long>()
            history.add(id)
        }

        session.setAttribute(REQIIREMENT_HISTORY, history)

        [requirement: requirement, allRequirementLabels: allRequirementLabels]
    }

    def back(){
        List<Long> history = session.getAttribute(REQIIREMENT_HISTORY)
        if (history && history.size() > 1){
            history.remove(history.size()-1)
            session.setAttribute(REQIIREMENT_HISTORY, history)

            def requirement = Requirement.findById(history.last())

            redirect (action: 'show', id: requirement.id)

        }else{
            session.removeAttribute(REQIIREMENT_HISTORY)
            redirect(controller: 'dashboard', action: 'index')
        }
    }

    def renameStep(Long id, String label, Long requirementId){

        if (label){
            Step step = Step.findById(id)
            Requirement existingRequirement = Requirement.findByLabel(label)

            if(existingRequirement && existingRequirement.id != step.requirement.id){
                step.requirement = existingRequirement
                step.save()
            }else{
                Requirement r = step.requirement
                r.label = label
                r.save()
            }
        }else{
            flash.error = g.message(code:"min.ExtensionController.step.rename.blank")
        }

        redirect (action: 'show', id: requirementId)
    }

    def renameExtension(Long id, String label, Long requirementId){

        if (label){
            Extension extension = Extension.findById(id)
            extension.label = label
            extension.save()
        }else{
            flash.error = g.message(code:"min.ExtensionController.extension.rename.blank")
        }

        redirect (action: 'show', id: requirementId)
    }

    def addRequirementStep(Long requirementId, String stepLabel){
        if (stepLabel){
            Sequence sequence = Sequence.findById(requirementId);
            requirementService.createStep(stepLabel, sequence)
        }else{
            flash.error = g.message(code:"min.ExtensionController.step.add.blank")
        }
        redirect (action: 'show', id: requirementId)
    }

    def addExtensionStep(Long requirementId, Long extensionId, String stepLabel){
        if (stepLabel){
            Sequence sequence = Sequence.findById(extensionId);
            requirementService.createStep(stepLabel, sequence)
        }else{
            flash.error = g.message(code:"min.ExtensionController.step.add.blank")
        }
        redirect (action: 'show', id: requirementId)
    }

    def removeRequirementStep(Long id, Long requirementId){
        requirementService.removeStep(id, requirementId)
        redirect(action: 'show', id: requirementId)
    }

    def removeExtensionStep(Long id, Long requirementId, Long extensionId){
        requirementService.removeStep(id, extensionId)
        redirect(action: 'show', id: requirementId)
    }

    def addExtension(Long requirementId, String extensionLabel, String steps) throws Exception {
        if (extensionLabel){

            Requirement requirement = Requirement.findById(requirementId);
            List<String> checkedSteps = steps.tokenize(",")

            requirementService.createExtension(extensionLabel, requirement, checkedSteps)
        }else{
            flash.error = g.message(code:"min.ExtensionController.extension.add.blank")
        }

        redirect(action: 'show', id: requirementId)
    }

    def deleteExtension(Long id, Long requirementId){
        Extension extension = Extension.findById(id)

        requirementService.deleteExtension(extension)

        redirect(action: 'show', id: requirementId)
    }

    def updateStepsOrder() {

        def stepsIdOrder = params.stepsIdOrder
        String[] ids = stepsIdOrder.split("-")

        requirementService.updateStepsOrder(ids)

        def map = [status: "success"]
        render map as JSON
    }

    def updateExtensionsOrder(Long id) {

        Requirement requirement = Requirement.findById(id)

        def extensionsIdOrder = params.extensionsIdOrder
        String[] ids = extensionsIdOrder.split("-")

        requirementService.updateExtensionsOrder(ids, requirement)

        def map = [status: "success"]
        render map as JSON
    }

    def upload() {
        HashMap json = ['success':true];
        if(params.qqfile) {
            CommonsMultipartFile file = params.qqfile
            if (file && file.getSize() > 0) {
                Photo photo = new Photo()
                photo.image = file.getBytes()
                Requirement requirement = Requirement.findById(params.id)
                requirement.addToPhotos(photo)
                requirement.save()
                photo.save()

                json.put('photoId', photo.id);
                json.put('photoUrl', g.createLink(controller: 'requirement', action: 'showImage', id:photo.id));
            }
        }
        return render(text: json as JSON, contentType:"text/html");
    }

    def deletePhoto(Long id){

        Photo photo = Photo.findById(id)
        Requirement requirement = photo.requirement
        requirement.removeFromPhotos(photo)
        requirement.save()
        photo.delete()

        redirect(action: 'show', id: requirement.id)
    }

    def showImage(Long id){
        def photo = Photo.findById(id)
        response.contentType = "image/jpeg"
        response.contentLength = photo?.image.length
        response.outputStream.write(photo?.image)
    }

    def saveNotes(Long id, String notes){

        Requirement requirement = Requirement.findById(id)
        requirement.description = notes
        requirement.save()

        redirect(action: 'show', id: id)
    }

}
