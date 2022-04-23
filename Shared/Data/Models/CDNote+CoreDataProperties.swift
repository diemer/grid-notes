//
//  CDNote+CoreDataProperties.swift
//  Grid Notes
//
//  Created by Dan Diemer on 4/22/22.
//
//

import Foundation
import CoreData


extension CDNote {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<CDNote> {
    return NSFetchRequest<CDNote>(entityName: "CDNote")
  }
  
  public static func lastUpdatedFetchRequest() -> NSFetchRequest<CDNote> {
    let request = fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "modifiedAt", ascending: true)]
    return request
  }
  
  public static func findByIdFetchRequest(_ id: String) -> NSFetchRequest<CDNote> {
    let request = fetchRequest()
    request.predicate = NSPredicate(format: "id = %@", id as NSString)
    return request
  }
  
  @NSManaged public var content: String
  @NSManaged public var width: Double
  @NSManaged public var height: Double
  @NSManaged public var positionX: Double
  @NSManaged public var positionY: Double
  @NSManaged public var id: String
  @NSManaged public var modifiedAt: Date?
  
}

extension CDNote : Identifiable {
  
}
