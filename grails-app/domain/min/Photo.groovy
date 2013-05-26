package min

/**
 * User: maxim
 * Date: 26/05/13
 * Time: 12:14 PM
 */
class Photo {
    Date dateCreated
    Date lastUpdated

    byte[] image
    Requirement requirement
    String filename;
    String extension;

    static belongsTo = [requirement: Requirement]

    static constraints = {
        image(maxSize:1073741824)
        filename nullable: true
        extension nullable: true
    }
}
