//
//  Queries+CoreDataProperties.swift
//  GetION
//
//  Created by NIKHILESH on 15/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//
//

import Foundation
import CoreData


extension Queries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Queries> {
        return NSFetchRequest<Queries>(entityName: "Queries")
    }

    @NSManaged public var id: String?
    @NSManaged public var title: String?
    @NSManaged public var alias: String?
    @NSManaged public var created: String?
    @NSManaged public var display_time: String?
    @NSManaged public var display_date: String?
    @NSManaged public var modified_date: String?
    @NSManaged public var state: String?
    @NSManaged public var modified: String?
    @NSManaged public var replied: String?
    @NSManaged public var content: String?
    @NSManaged public var featured: String?
    @NSManaged public var answered: String?
    @NSManaged public var hits: String?
    @NSManaged public var num_likes: String?
    @NSManaged public var user_id: String?
    @NSManaged public var poster_name: String?
    @NSManaged public var poster_email: String?
    @NSManaged public var imgTag: String?
    @NSManaged public var image: String?
    @NSManaged public var gender: String?
    @NSManaged public var age: String?
    @NSManaged public var mobile: String?
    @NSManaged public var category_id: String?
    @NSManaged public var post_type: String?
    @NSManaged public var category_name: String?

}
