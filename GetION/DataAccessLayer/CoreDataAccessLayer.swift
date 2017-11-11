//
//  CoreDataAccessLayer.swift
//  CapillaryFramework
//
//  Created by Nikhilesh on 05/05/17.
//  Copyright © 2017 Capillary Technologies. All rights reserved.
//

import UIKit
import CoreData

class CoreDataAccessLayer: NSObject {
    
   static let sharedInstance = CoreDataAccessLayer()
    
    func getListOfObjectsForEntityForName(strClass :String,strFetcher:String) -> [NSManagedObject]?
    {
        let request:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: strClass)
        
        if strFetcher.characters.count > 0
        {
            let resultPredicate = NSPredicate(format: strFetcher as String)
            request.predicate = resultPredicate
        }
        
        do {
            let searchResults  = try managedObjectContext.fetch(request)
            return searchResults as? [NSManagedObject]
        } catch {
            print("Error with request: \(error)")
        }
        return nil
        
    }
    
    func getListDataForEntity(strclass:String, strFormat:String) -> [NSManagedObject]?
    {
        
        let arrMutable = self.getListOfObjectsForEntityForName(strClass: strclass,strFetcher: strFormat)
        if arrMutable == nil
        {
            return nil
        }
        else
        {
            return arrMutable!
        }
        
    }
    
    //MARK:- iOS 10 CoreData for Configuration
    
    public func getDataForPublish(strFetcher:String) -> [NSManagedObject]?
    {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Publish",
                                                           in: managedObjectContext)
        
        let request: NSFetchRequest<Publish> = Publish.fetchRequest()
        request.entity = entityDescription
        
        if strFetcher.characters.count > 0
        {
            let resultPredicate = NSPredicate(format: strFetcher as String)
            request.predicate = resultPredicate
        }
        
        do
        {
            let results = try  managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            return results as? [NSManagedObject]
        }
        catch _
        {
            
        }
        return[]
        
    }

    

    //MARK:- Publish methods
    func getAllPublishFromLocalDB() -> [BlogBO]
    {
        let arrPublish = self.getListDataForEntity(strclass: "Publish",strFormat:"")
        if arrPublish == nil || arrPublish?.count == 0
        {
            return [BlogBO]()
        }
        
        if arrPublish!.count > 0
        {
            return self.convertPublishArrayToBlogBOArray(arr: arrPublish as! [Publish])
        }
        else
        {
            return [BlogBO]()
        }
        
    }
    func getPublishBlogsFromLocalDB() -> [BlogBO]
    {
        let arrPublish = self.getListDataForEntity(strclass: "Publish",strFormat:"status == '1'")
        if arrPublish == nil || arrPublish?.count == 0
        {
            return [BlogBO]()
        }
        
        if arrPublish!.count > 0
        {
            return self.convertPublishArrayToBlogBOArray(arr: arrPublish as! [Publish])
        }
        else
        {
            return [BlogBO]()
        }
        
    }
    func getDraftBlogsFromLocalDB() -> [BlogBO]
    {
        let arrPublish = self.getListDataForEntity(strclass: "Publish",strFormat:"status == '3'")
        if arrPublish == nil || arrPublish?.count == 0
        {
            return [BlogBO]()
        }
        
        if arrPublish!.count > 0
        {
            return self.convertPublishArrayToBlogBOArray(arr: arrPublish as! [Publish])
        }
        else
        {
            return [BlogBO]()
        }
        
    }
    func getOnlineBlogsFromLocalDB() -> [BlogBO]
    {
        let arrPublish = self.getListDataForEntity(strclass: "Publish",strFormat:"status == '0'")
        if arrPublish == nil || arrPublish?.count == 0
        {
            return [BlogBO]()
        }
        
        if arrPublish!.count > 0
        {
            return self.convertPublishArrayToBlogBOArray(arr: arrPublish as! [Publish])
        }
        else
        {
            return [BlogBO]()
        }
        
    }

    
    func getPublishItemsWith(postId : String) -> [BlogBO]
    {
        let arrPublish  =  self.checkAvaibleVersionIs10() ? self.getDataForPublish(strFetcher:"postId == '" +  postId + "'")  : self.getListDataForEntity(strclass: "Publish",strFormat:"postId == '" +  postId + "'")
        
        if arrPublish == nil
        {
            return [BlogBO]()
        }
        if arrPublish!.count > 0
        {
            return self.convertPublishArrayToBlogBOArray(arr: arrPublish as! [Publish])
        }
        else {
            return [BlogBO]()
        }
    }
    func saveAllItemsIntoPublishTableInLocalDB( arrTmpItems : [BlogBO])
    {
        for tmpItem in arrTmpItems
        {
            self.saveItemIntoPublishTableInLocalDB(tmpItem: tmpItem)
        }
    }
    
    func saveItemIntoPublishTableInLocalDB( tmpItem : BlogBO)
    {
        
        let entity =  NSEntityDescription.entity(forEntityName: "Publish",in:managedObjectContext)
        
        let blogItem = NSManagedObject(entity: entity!,insertInto: managedObjectContext) as! Publish
        
        blogItem.title = tmpItem.title
        blogItem.textplain = tmpItem.textplain
        blogItem.imageURL = tmpItem.imageURL
        blogItem.like = Int64(tmpItem.like)
        blogItem.intro = tmpItem.intro
        blogItem.userid = tmpItem.userid
        blogItem.published = tmpItem.published
        blogItem.state = Int64(tmpItem.state)
        blogItem.vote = tmpItem.vote
        blogItem.views = Int64(tmpItem.views)
        blogItem.blogpassword = tmpItem.blogpassword
        blogItem.ispassword = tmpItem.ispassword
        blogItem.isowner = tmpItem.isowner
        blogItem.modified_date = tmpItem.modified_date
        blogItem.permalink = tmpItem.permalink
        blogItem.categoryScope = tmpItem.categoryScope
        blogItem.categoryUpdated_date = tmpItem.categoryUpdated_date
        blogItem.categoryCreated_date = tmpItem.categoryCreated_date
        blogItem.categoryDescription = tmpItem.categoryDescription
        blogItem.categoryTitle = tmpItem.categoryTitle
        blogItem.categoryId = tmpItem.categoryId
        blogItem.ratingTotal = tmpItem.ratingTotal
        blogItem.rating = tmpItem.rating
        //            blogItem.tags = Int(tmpItem.tags)!
        blogItem.url = tmpItem.url
        blogItem.comments = tmpItem.comments
        blogItem.authorBio = tmpItem.authorBio
        blogItem.authorWebsite = tmpItem.authorWebsite
        blogItem.authorPhoto = tmpItem.authorPhoto
        blogItem.authorEmail = tmpItem.authorEmail
        blogItem.authorName = tmpItem.authorName
        blogItem.updated_date = tmpItem.updated_date
        blogItem.created_date_elapsed = tmpItem.created_date_elapsed
        blogItem.created_date = tmpItem.created_date
        blogItem.postId = tmpItem.postId
        blogItem.isVoted = Int64(tmpItem.isVoted)
        blogItem.status = tmpItem.status
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    func removeAllPublishItems()
    {
        let arrPublish = self.getAllPublishFromLocalDB()
        
        for publish in arrPublish
        {
            self.removePublishItemFromLocalDBWith(publishId: publish.postId)
        }
    }
    func removePublishItemFromLocalDBWith(publishId : String)
    {
        
        var results : [Publish]
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Publish")
        let predicate = NSPredicate(format: "postId == %@", publishId)
        request.predicate = predicate
        do{
            
            
            results = try managedObjectContext.fetch(request) as! [Publish]
            if (results.count > 0) {
                managedObjectContext.delete( results[0])
                
            } else {
                
            }
        } catch let error as NSError {
            
            print("Fetch failed: \(error.localizedDescription)")
        }
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    //MARK:- Lead methods
    public func getDataForLead(strFetcher:String) -> [NSManagedObject]?
    {
        let entityDescription = NSEntityDescription.entity(forEntityName: "Lead",
                                                           in: managedObjectContext)
        
        let request: NSFetchRequest<Lead> = Lead.fetchRequest()
        request.entity = entityDescription
        
        if strFetcher.characters.count > 0
        {
            let resultPredicate = NSPredicate(format: strFetcher as String)
            request.predicate = resultPredicate
        }
        
        do
        {
            let results = try  managedObjectContext.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
            
            return results as? [NSManagedObject]
        }
        catch _
        {
            
        }
        return[]
        
    }

    func getAllLeadsFromLocalDB() -> [LeadsBO]
    {
        let arrLead = self.getListDataForEntity(strclass: "Lead",strFormat:"")
        if arrLead == nil || arrLead?.count == 0
        {
            return [LeadsBO]()
        }
        
        if arrLead!.count > 0
        {
            return self.convertLeadArrayToLeadsBOArray(arr: arrLead as! [Lead])
        }
        else
        {
            return [LeadsBO]()
        }
        
    }
    
    
    func getLeadItemsWith(leadId : String) -> [LeadsBO]
    {
        let arrLead  =  self.checkAvaibleVersionIs10() ? self.getDataForPublish(strFetcher:"id == '" +  leadId + "'")  : self.getListDataForEntity(strclass: "Lead",strFormat:"id == '" +  leadId + "'")
        
        if arrLead == nil
        {
            return [LeadsBO]()
        }
        if arrLead!.count > 0
        {
            return self.convertLeadArrayToLeadsBOArray(arr: arrLead as! [Lead])
        }
        else {
            return [LeadsBO]()
        }
    }
    func saveAllItemsIntoLeadTableInLocalDB( arrTmpItems : [LeadsBO])
    {
        for tmpItem in arrTmpItems
        {
            if tmpItem.flag == "1"
            {
                self.saveItemIntoLeadTableInLocalDB(tmpItem: tmpItem)
            }
        }
    }
    
    func saveItemIntoLeadTableInLocalDB( tmpItem : LeadsBO)
    {
        
        let arrLead = self.getListDataForEntity(strclass: "Lead",strFormat:"id == \(tmpItem.id)")
        if arrLead?.count == 0
        {
            let entity =  NSEntityDescription.entity(forEntityName: "Lead",in:managedObjectContext)
            
            let leadItem = NSManagedObject(entity: entity!,insertInto: managedObjectContext) as! Lead
            
            leadItem.id = tmpItem.id
            leadItem.department = tmpItem.department
            leadItem.age = tmpItem.age
            leadItem.firstname = tmpItem.firstname
            leadItem.surname = tmpItem.surname
            leadItem.mobile = tmpItem.mobile
            leadItem.email = tmpItem.email
            leadItem.birthday = tmpItem.birthday
            leadItem.sex = tmpItem.sex
            leadItem.purpose = tmpItem.purpose
            leadItem.area = tmpItem.area
            leadItem.city = tmpItem.city
            leadItem.pincode = tmpItem.pincode
            leadItem.remarks = tmpItem.remarks
            leadItem.login_id = tmpItem.login_id
            leadItem.lastupdated = tmpItem.lastupdated
            leadItem.flag = tmpItem.flag
            leadItem.image = tmpItem.image
            leadItem.source = tmpItem.source
            leadItem.imgTag = tmpItem.imgTag
            leadItem.leadsTags = tmpItem.leadsTags
            do {
                try managedObjectContext.save()
                
            } catch let error as NSError  {
                print("Could not save \(error), \(error.userInfo)")
            }
        }
    }
    func removeAllLeads()
    {
        let arrLeads = self.getAllLeadsFromLocalDB()
        
        for lead in arrLeads
        {
            self.removeLeadItemFromLocalDBWith(leadId: lead.id)
        }
    }
    func removeLeadItemFromLocalDBWith(leadId : String)
    {
        
        var results : [Lead]!
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Lead")
        let predicate = NSPredicate(format: "id == %@", leadId)
        request.predicate = predicate
        do{
            
            
            results = try managedObjectContext.fetch(request) as! [Lead]
            if (results.count > 0) {
                managedObjectContext.delete( results[0])
                
            } else {
                
            }
        } catch let error as NSError {
            
            print("Fetch failed: \(error.localizedDescription)")
        }
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    //MARK: - Utiltiy Method
    func  convertPublishArrayToBlogBOArray (arr : [Publish]) -> [BlogBO]
    {
        var arrblogItems = [BlogBO]()
        for tmpItem in arr
        {
            let blogItem = BlogBO()
            blogItem.title = tmpItem.title!
            blogItem.textplain = tmpItem.textplain!
            blogItem.imageURL = tmpItem.imageURL!
            blogItem.like = Int(tmpItem.like)
            blogItem.intro = tmpItem.intro!
            blogItem.userid = tmpItem.userid!
            blogItem.published = tmpItem.published!
            blogItem.state = Int(tmpItem.state)
            blogItem.vote = tmpItem.vote!
            blogItem.views = Int(tmpItem.views)
            blogItem.blogpassword = tmpItem.blogpassword!
            blogItem.ispassword = tmpItem.ispassword
            blogItem.isowner = tmpItem.isowner
            blogItem.modified_date = tmpItem.modified_date!
            blogItem.permalink = tmpItem.permalink!
            blogItem.categoryScope = tmpItem.categoryScope!
            blogItem.categoryUpdated_date = tmpItem.categoryUpdated_date!
            blogItem.categoryCreated_date = tmpItem.categoryCreated_date!
            blogItem.categoryDescription = tmpItem.categoryDescription!
            blogItem.categoryTitle = tmpItem.categoryTitle!
            blogItem.categoryId = tmpItem.categoryId!
            blogItem.ratingTotal = tmpItem.ratingTotal!
            blogItem.rating = tmpItem.rating!
//            blogItem.tags = Int(tmpItem.tags)!
            blogItem.url = tmpItem.url!
            blogItem.comments = tmpItem.comments!
            blogItem.authorBio = tmpItem.authorBio!
            blogItem.authorWebsite = tmpItem.authorWebsite!
            blogItem.authorPhoto = tmpItem.authorPhoto!
            blogItem.authorEmail = tmpItem.authorEmail!
            blogItem.authorName = tmpItem.authorName!
            blogItem.updated_date = tmpItem.updated_date!
            blogItem.created_date_elapsed = tmpItem.created_date_elapsed!
            blogItem.created_date = tmpItem.created_date!
            blogItem.postId = tmpItem.postId!
            blogItem.isVoted = Int(tmpItem.isVoted)
            blogItem.status = tmpItem.status!
            arrblogItems.append(blogItem)
        }
        return arrblogItems
        
    }

    func  convertLeadArrayToLeadsBOArray (arr : [Lead]) -> [LeadsBO]
    {
        var arrLeadItems = [LeadsBO]()
        for tmpItem in arr
        {
            let leadItem = LeadsBO()
            leadItem.id = tmpItem.id!
            leadItem.department = tmpItem.department!
            leadItem.age = tmpItem.age!
            leadItem.firstname = tmpItem.firstname!
            leadItem.surname = tmpItem.surname!
            leadItem.mobile = tmpItem.mobile!
            leadItem.email = tmpItem.email!
            leadItem.birthday = tmpItem.birthday!
            leadItem.sex = tmpItem.sex!
            leadItem.purpose = tmpItem.purpose!
            leadItem.area = tmpItem.area!
            leadItem.city = tmpItem.city!
            leadItem.pincode = tmpItem.pincode!
            leadItem.remarks = tmpItem.remarks!
            leadItem.login_id = tmpItem.login_id!
            leadItem.lastupdated = tmpItem.lastupdated!
            leadItem.flag = tmpItem.flag!
            leadItem.image = tmpItem.image!
            leadItem.source = tmpItem.source!
            leadItem.imgTag = tmpItem.imgTag!
            leadItem.leadsTags = tmpItem.leadsTags!
            arrLeadItems.append(leadItem)
        }
        return arrLeadItems
        
    }
    

    func checkAvaibleVersionIs10()->Bool{
        if #available(iOS 10.0, *)
        {
            return true
        }
        return false
    }
    
    
    
    
    // MARK: - Core Data stack
    
    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        //        let container = NSPersistentContainer(name: "Capillary")
        let container = NSPersistentContainer(name: "GetION", managedObjectModel: self.managedObjectModel)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com._Fingers" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1] as NSURL
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let carKitBundle = Bundle(identifier: "com.medicodesk.nativeionapp")
        let modelURL = carKitBundle?.url(forResource: "GetION", withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        print(self.applicationDocumentsDirectory)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("GetION.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as AnyObject?
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        if #available(iOS 10.0, *) {
            let context = persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        } else {
            
            
            do {
                try managedObjectContext.save()
                
            } catch let error  {
                print("Could not save \(error), \(error.localizedDescription)")
            }
            
            // Fallback on earlier versions
            if managedObjectContext.hasChanges {
                
                
                do {
                    try managedObjectContext.save()
                    
                } catch let error  {
                    print("Could not save \(error), \(error.localizedDescription)")
                    let nserror = error as NSError
                    NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                    abort()
                    
                    
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                }
            }
            
        }
        
    }
    
}

