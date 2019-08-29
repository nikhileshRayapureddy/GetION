//
//  Lead+CoreDataProperties.swift
//  GetION
//
//  Created by Nikhilesh on 02/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//
//

import Foundation
import CoreData


extension Lead {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lead> {
        return NSFetchRequest<Lead>(entityName: "Lead")
    }

    @NSManaged public var id: String?
    @NSManaged public var department: String?
    @NSManaged public var age: String?
    @NSManaged public var firstname: String?
    @NSManaged public var surname: String?
    @NSManaged public var mobile: String?
    @NSManaged public var email: String?
    @NSManaged public var birthday: String?
    @NSManaged public var sex: String?
    @NSManaged public var purpose: String?
    @NSManaged public var area: String?
    @NSManaged public var city: String?
    @NSManaged public var pincode: String?
    @NSManaged public var remarks: String?
    @NSManaged public var login_id: String?
    @NSManaged public var lastupdated: String?
    @NSManaged public var flag: String?
    @NSManaged public var image: String?
    @NSManaged public var source: String?
    @NSManaged public var imgTag: String?
    @NSManaged public var leadsTags: String?

}
