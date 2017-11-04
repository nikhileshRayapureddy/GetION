//
//  Publish+CoreDataProperties.swift
//  GetION
//
//  Created by NIKHILESH on 04/11/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//
//

import Foundation
import CoreData


extension Publish {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Publish> {
        return NSFetchRequest<Publish>(entityName: "Publish")
    }

    @NSManaged public var authorBio: String?
    @NSManaged public var authorEmail: String?
    @NSManaged public var authorName: String?
    @NSManaged public var authorPhoto: String?
    @NSManaged public var authorWebsite: String?
    @NSManaged public var blogpassword: String?
    @NSManaged public var categoryCreated_date: String?
    @NSManaged public var categoryDescription: String?
    @NSManaged public var categoryId: String?
    @NSManaged public var categoryScope: String?
    @NSManaged public var categoryTitle: String?
    @NSManaged public var categoryUpdated_date: String?
    @NSManaged public var comments: String?
    @NSManaged public var created_date: String?
    @NSManaged public var created_date_elapsed: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var intro: String?
    @NSManaged public var isowner: Bool
    @NSManaged public var ispassword: Bool
    @NSManaged public var isVoted: Int64
    @NSManaged public var like: Int64
    @NSManaged public var modified_date: String?
    @NSManaged public var permalink: String?
    @NSManaged public var postId: String?
    @NSManaged public var published: String?
    @NSManaged public var rating: String?
    @NSManaged public var ratings: Int64
    @NSManaged public var ratingTotal: String?
    @NSManaged public var state: Int64
    @NSManaged public var tags: NSObject?
    @NSManaged public var textplain: String?
    @NSManaged public var title: String?
    @NSManaged public var updated_date: String?
    @NSManaged public var url: String?
    @NSManaged public var userid: String?
    @NSManaged public var views: Int64
    @NSManaged public var vote: String?
    @NSManaged public var status: String?

}
