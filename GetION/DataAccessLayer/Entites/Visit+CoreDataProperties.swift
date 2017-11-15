//
//  Visit+CoreDataProperties.swift
//  
//
//  Created by NIKHILESH on 15/11/17.
//
//

import Foundation
import CoreData


extension Visit {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Visit> {
        return NSFetchRequest<Visit>(entityName: "Visit")
    }

    @NSManaged public var visitId: String?
    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var mobile: String?
    @NSManaged public var resource: String?
    @NSManaged public var requestStatus: String?
    @NSManaged public var paymentStatus: String?
    @NSManaged public var resourceAdmins: String?
    @NSManaged public var bookingDue: String?
    @NSManaged public var bookingDeposit: String?
    @NSManaged public var bookingTotal: String?
    @NSManaged public var startdate: String?
    @NSManaged public var starttime: String?
    @NSManaged public var enddate: String?
    @NSManaged public var endtime: String?
    @NSManaged public var resname: String?
    @NSManaged public var serviceName: String?
    @NSManaged public var startdatetime: String?
    @NSManaged public var displayStartdate: String?
    @NSManaged public var displayStarttime: String?
    @NSManaged public var image: String?
    @NSManaged public var sex: String?
    @NSManaged public var age: String?
    @NSManaged public var area: String?
    @NSManaged public var city: String?
    @NSManaged public var birthday: String?
    @NSManaged public var remarks: String?
    @NSManaged public var ceId: String?
    @NSManaged public var nametag: String?

}
