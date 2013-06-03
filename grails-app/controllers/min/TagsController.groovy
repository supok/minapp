package min

class TagsController {

    def list() {

        List tagGroups = TagGroup.findAll()

        [tagGroups: tagGroups]
    }

    def updateTagGroup(Long id, String nameCode, String name){
        String message = ""
//        if(TagGroup.findByNameCodeAndIdNotEqual(nameCode,id)){
//            message += "Tag Group with the same name already exists. "
//        }
//        if (!nameCode){
//            message += "Please enter Name Code. "
//        }
        if (!name){
            message += "Please enter Name. "
        }

        if (message){
            flash.error = message
        }else{
            TagGroup tagGroup = TagGroup.findById(id)
//            tagGroup.nameCode = nameCode
            tagGroup.name = name
            tagGroup.save()
        }

        redirect(action: 'list')
    }

    def updateTag(Long id, String nameCode, String name){
        String message = ""
//        if(TagGroup.findByNameCodeAndIdNotEqual(nameCode,id)){
//            message += "Tag with the same name already exists. "
//        }
//        if (!nameCode){
//            message += "Please enter Name Code. "
//        }
        if (!name){
            message += "Please enter Name. "
        }

        if (message){
            flash.error = message
        }else{
            Tag tag = Tag.findById(id)
//            tag.nameCode = nameCode
            tag.name = name
            tag.save()
        }

        redirect(action: 'list')
    }
}
