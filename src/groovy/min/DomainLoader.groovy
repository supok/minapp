package min

/**
 * User: maxim
 * Date: 6/05/13
 * Time: 2:09 PM
 */
class DomainLoader {

    void loadUsers(){
        /*
         * Load users
         */
        def roleAdmin = new Role(name: 'Admin user', authority: 'ROLE_ADMIN').save()
        def roleUser = new Role(name: 'Regular user', authority: 'ROLE_USER').save()

        def minUser = new User(firstName: "Min", lastName: "Min",
                email: "min@gmail.com", username: "min",
                password: "uni715", enabled: true).save(failOnError: true);

        UserRole.create(minUser, Role.findByAuthority('ROLE_USER'));

    }

    void loadData(){
        /*
         * Load test requirements
         */
        def req1 = new Requirement()
        req1.topLevel = Boolean.TRUE
        req1.label = "Req1"
        req1.position = 1
        req1.save()

        def req11 = new Requirement()
        req11.label = "Req1.1"
        req11.position = 1
        req11.save()

        def step11 = new Step()
        step11.requirement = req11
        step11.position = 1
        req1.addToSteps(step11)
        req1.save()

        TagGroup tagGroup = new TagGroup()
        tagGroup.name = "Actor"
        tagGroup.nameCode = "A"
        tagGroup.save()

        Tag tag = new Tag()
        tag.name = "Casual Customer"
        tag.nameCode = "CC"
        tag.save()

        RequirementTag requirementTag = new RequirementTag()
        requirementTag.tag = tag
        requirementTag.tagGroup = tagGroup
        req1.addToRequirementTags(requirementTag)
        req1.save()
    }
}
