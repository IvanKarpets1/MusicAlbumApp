import Foundation
import CoreData


extension AlbumEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AlbumEntity> {
        return NSFetchRequest<AlbumEntity>(entityName: "AlbumEntity")
    }

    @NSManaged public var thumbData: NSData?
    @NSManaged public var title: String?
    @NSManaged public var albumDescription: String?

}
