//
//  ServiceLayer.swift
//  TaksyKraft
//
//  Created by Nikhilesh on 29/06/17.
//  Copyright © 2017 TaksyKraft. All rights reserved.
//

import UIKit
public enum ParsingConstant : Int
{
    case Login
    case Vists
}
class ServiceLayer: NSObject {
    let SERVER_ERROR = "Server not responding.\nPlease try after some time."
    let BASE_URL = "http://staging.getion.in/index.php"
    let data_layer = CoreDataAccessLayer.sharedInstance

    public func loginWithUsername(username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        var params = [String:AnyObject]()
        params["username"] = username as AnyObject
        params["password"] = password as AnyObject
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "\(BASE_URL)?option=com_api&app=users&resource=login&format=raw"
        obj.params = params
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? String
                {
                    if code == "200"
                    {
                        if let id = obj.parsedDataDict["id"] as? String
                        {
                            GetIONUserDefaults.setUserId(object: id)
                        }
                        if let teamid = obj.parsedDataDict["teamid"] as? String
                        {
                            GetIONUserDefaults.setTeamId(object: teamid)
                        }
                        if let publishid = obj.parsedDataDict["publishid"] as? String
                        {
                            GetIONUserDefaults.setPublishId(object: publishid)
                        }
                        if let profile_image = obj.parsedDataDict["profile_image"] as? String
                        {
                            GetIONUserDefaults.setProfPic(object: profile_image)
                        }
                        if let auth = obj.parsedDataDict["auth"] as? String
                        {
                            GetIONUserDefaults.setAuth(object: auth)
                        }
                        if let firstname = obj.parsedDataDict["firstname"] as? String
                        {
                            GetIONUserDefaults.setFirstName(object: firstname)
                        }
                        if let lastname = obj.parsedDataDict["lastname"] as? String
                        {
                            GetIONUserDefaults.setLastName(object: lastname)
                        }
                        if let role = obj.parsedDataDict["role"] as? String
                        {
                            GetIONUserDefaults.setRole(object: role)
                        }
                        if let catID = obj.parsedDataDict["parent_category_id"] as? String
                        {
                            GetIONUserDefaults.setCatID(object: catID)
                        }
                        
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func resetPasswordWith(email:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "\(BASE_URL)/request?module=user&action=get&resource=reset&email=\(email)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["status"] as? String
                {
                    if code == "set"
                    {
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getIonisedReports(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)/request?action=ionizeddraftreport&module=ionize&resource=posts&userid=\(GetIONUserDefaults.getUserId())"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["status"] as? String
                {
                    if code == "ok"
                    {
                        if let description = obj.parsedDataDict["description"] as? [[String:AnyObject]]
                        {
                            if description.count > 0
                            {
                                let reports = description[0]
                                let bo = ReportsBO()
                                if let ionized = reports["ionized"] as? String
                                {
                                    bo.strIonized = ionized
                                }
                                if let draft = reports["draft"] as? String
                                {
                                    bo.strDraft = draft
                                }
                                if let draftionized = reports["draftionized"] as? NSNumber
                                {
                                    bo.strDraftIonized = String(Int(truncating: draftionized))
                                }
                                if let unanswered = reports["unanswered"] as? String
                                {
                                    bo.strUnanswered = unanswered
                                }
                                if let visitcount = reports["visitcount"] as? String
                                {
                                    bo.strVisitcount = visitcount
                                }
                                successMessage(bo)
                            }
                            else
                            {
                                failureMessage("Failure")
                            }
                        }
                        else
                        {
                            failureMessage("Failure")
                        }

                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func getFeeds(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)/request?action=get&module=feeds&resource=getfeeds&userid=\(GetIONUserDefaults.getUserId())"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["status"] as? String
                {
                    if code == "ok"
                    {
                        if let description = obj.parsedDataDict["description"] as? [[String:AnyObject]]
                        {
                            var arrFeeds = [FeedsBO]()
                            for feed in description
                            {
                                let bo = FeedsBO()
                                if let id = feed["id"] as? String
                                {
                                    bo.id = id
                                }
                                if let content = feed["content"] as? String
                                {
                                    bo.content = content
                                }
                                if let access = feed["access"] as? String
                                {
                                    bo.access = access
                                }
                                if let action = feed["action"] as? String
                                {
                                    bo.action = action
                                }
                                if let context = feed["context"] as? String
                                {
                                    bo.context = context
                                }
                                if let context_id = feed["context_id"] as? String
                                {
                                    bo.context_id = context_id
                                }
                                if let since = feed["since"] as? String
                                {
                                    bo.since = since
                                }
                                if let avatar = feed["avatar"] as? String
                                {
                                    bo.avatar = avatar
                                }
                                arrFeeds.append(bo)
                            }
                            successMessage(arrFeeds)
                        }
                        else
                        {
                            failureMessage("Failure")
                        }
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage("Failure")
                }

            }
        }
    }
    public func getBlogs(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=latest&user_id=\(GetIONUserDefaults.getUserId())&key=178b5f7f049b32a8fc34d9116099cd706b7f9631&promos=2&status=1"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                        {
                            var arrBlogs = [BlogBO]()
                            for blog in data
                            {
                                let bo = BlogBO()
                                if let postid = blog["postid"] as? String
                                {
                                    bo.postId = postid
                                }
                                if let title = blog["title"] as? String
                                {
                                    bo.title = title
                                }
                                if let textplain = blog["textplain"] as? String
                                {
                                    bo.textplain = textplain
                                }
                                if let image = blog["image"] as? [String:AnyObject]
                                {
                                    if let url = image["url"] as? String
                                    {
                                        bo.imageURL = url
                                    }
                                }
                                if let created_date = blog["created_date"] as? String
                                {
                                    bo.created_date = created_date
                                }
                                if let created_date_elapsed = blog["created_date_elapsed"] as? String
                                {
                                    bo.created_date_elapsed = created_date_elapsed
                                }
                                if let updated_date = blog["updated_date"] as? String
                                {
                                    bo.updated_date = updated_date
                                }
                                if let author = blog["author"] as? [String:AnyObject]
                                {
                                    if let name = author["name"] as? String
                                    {
                                        bo.authorName = name
                                    }
                                    if let email = author["email"] as? String
                                    {
                                        bo.authorEmail = email
                                    }
                                    if let photo = author["photo"] as? String
                                    {
                                        bo.authorPhoto = photo
                                    }
                                    if let website = author["website"] as? String
                                    {
                                        bo.authorWebsite = website
                                    }
                                    if let bio = author["bio"] as? String
                                    {
                                        bo.authorBio = bio
                                    }
                                }
                                if let comments = blog["comments"] as? String
                                {
                                    bo.comments = comments
                                }
                                if let url = blog["url"] as? String
                                {
                                    bo.url = url
                                }
                                if let tags = blog["tags"] as? [[String:AnyObject]]
                                {
                                    bo.tags = tags as [AnyObject]
                                }
                                if let rating = blog["rating"] as? String
                                {
                                    bo.rating = rating
                                }
                                if let rate = blog["rate"] as? [String:AnyObject]
                                {
                                    if let ratings = rate["ratings"] as? NSNumber
                                    {
                                        bo.ratings = Int(truncating: ratings)
                                    }
                                    if let total = rate["total"] as? String
                                    {
                                        bo.ratingTotal = total
                                    }
                                }
                                if let category = blog["category"] as? [String:AnyObject]
                                {
                                    if let categoryid = category["categoryid"] as? String
                                    {
                                        bo.categoryId = categoryid
                                    }
                                    if let title = category["title"] as? String
                                    {
                                        bo.categoryTitle = title
                                    }
                                    if let description = category["description"] as? String
                                    {
                                        bo.categoryDescription = description
                                    }
                                    if let created_date = category["created_date"] as? String
                                    {
                                        bo.categoryCreated_date = created_date
                                    }
                                    if let updated_date = category["updated_date"] as? String
                                    {
                                        bo.categoryUpdated_date = updated_date
                                    }
                                    if let scope = category["scope"] as? String
                                    {
                                        bo.categoryScope = scope
                                    }
                                }
                                if let permalink = blog["permalink"] as? String
                                {
                                    bo.permalink = permalink
                                }
                                if let modified_date = blog["modified_date"] as? String
                                {
                                    bo.modified_date = modified_date
                                }
                                if let isowner = blog["isowner"] as? Bool
                                {
                                    bo.isowner = isowner
                                }
                                if let ispassword = blog["ispassword"] as? Bool
                                {
                                    bo.ispassword = ispassword
                                }
                                if let blogpassword = blog["blogpassword"] as? String
                                {
                                    bo.blogpassword = blogpassword
                                }
                                if let views = blog["views"] as? NSNumber
                                {
                                    bo.views = Int(truncating: views)
                                }
                                if let vote = blog["vote"] as? String
                                {
                                    bo.vote = vote
                                }
                                if let state = blog["state"] as? NSNumber
                                {
                                    bo.state = Int(truncating: state)
                                }
                                if let published = blog["published"] as? String
                                {
                                    bo.published = published
                                }
                                if let like = blog["like"] as? NSNumber
                                {
                                    bo.like = Int(truncating: like)
                                }
                                if let intro = blog["intro"] as? String
                                {
                                    bo.intro = intro
                                }
                                if let isVoted = blog["isVoted"] as? NSNumber
                                {
                                    bo.isVoted = Int(truncating: isVoted)
                                }
                                if let userid = blog["userid"] as? String
                                {
                                    bo.userid = userid
                                }
                                arrBlogs.append(bo)
                            }
                            successMessage(arrBlogs)
                        }
                        else
                        {
                            failureMessage("Failure")
                        }
                
            }
        }
    }
    
    public func getQueries(status:String, andIsPopular isPopular: Bool,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let username = GetIONUserDefaults.getUserName()
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        if isPopular == true
        {
            obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=get&resource=posts&username=%@&limit=100", BASE_URL,username)
        }
        else
        {
            obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=get&resource=posts&username=%@&status=%@&limit=100", BASE_URL,username,status)
        }
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["posts"] as? [[String:AnyObject]]
                {
                    var arrQueries = [QueriesBO]()
                    for blog in posts
                    {
                        let query = QueriesBO()
                        if let id = blog["id"] as? String
                        {
                            query.id = id
                        }
                        if let title = blog["title"] as? String
                        {
                            query.title = title
                        }
                        if let alias = blog["alias"] as? String
                        {
                            query.alias = alias
                        }
                        if let created = blog["created"] as? String
                        {
                            query.created = created
                        }
                        if let display_time = blog["display_time"] as? String
                        {
                            query.display_time = display_time
                        }
                        if let display_date = blog["display_date"] as? String
                        {
                            query.display_date = display_date
                        }
                        if let modified_date = blog["modified_date"] as? String
                        {
                            query.modified_date = modified_date
                        }
                        if let state = blog["state"] as? String
                        {
                            query.state = state
                            if query.state == "0"
                            {
                                continue
                            }
                        }
                        if let modified = blog["modified"] as? String
                        {
                            query.modified = modified
                        }
                        if let replied = blog["replied"] as? String
                        {
                            query.replied = replied
                        }
                        if let content = blog["content"] as? String
                        {
                            query.content = content
                        }
                        if let featured = blog["featured"] as? String
                        {
                            query.featured = featured
                        }
                        if let answered = blog["answered"] as? String
                        {
                            query.answered = answered
                        }
                        if let hits = blog["hits"] as? String
                        {
                            query.hits = hits
                        }
                        if let num_likes = blog["num_likes"] as? String
                        {
                            query.num_likes = num_likes
                        }
                        if let user_id = blog["user_id"] as? String
                        {
                            query.user_id = user_id
                        }
                        if let poster_name = blog["poster_name"] as? String
                        {
                            query.poster_name = poster_name
                        }
                        if let poster_email = blog["poster_email"] as? String
                        {
                            query.poster_email = poster_email
                        }
                        if let imgTag = blog["imgTag"] as? String
                        {
                            query.imgTag = imgTag
                        }
                        if let image = blog["image"] as? String
                        {
                            query.image = image
                        }
                        if let gender = blog["gender"] as? String
                        {
                            query.gender = gender
                        }
                        if let age = blog["age"] as? String
                        {
                            query.age = age
                        }
                        if let mobile = blog["mobile"] as? String
                        {
                            query.mobile = mobile
                        }
                        if let category_id = blog["category_id"] as? String
                        {
                            query.category_id = category_id
                        }
                        if let post_type = blog["post_type"] as? String
                        {
                            query.post_type = post_type
                        }
                        if let category_name = blog["category_name"] as? String
                        {
                            query.category_name = category_name
                        }
                        arrQueries.append(query)
                    }
                    successMessage(arrQueries)
                }
                else
                {
                    failureMessage("Failure")
                }

            }
        }
    }
    
    public func getQueryDetailsWithId(id:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=get&resource=posts&id=%@", BASE_URL,id)
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["posts"] as? [[String:AnyObject]]
                {
                    var arrQueries = [QueriesBO]()
                    for blog in posts
                    {
                        let query = QueriesBO()
                        if let id = blog["id"] as? String
                        {
                            query.id = id
                        }
                        if let title = blog["title"] as? String
                        {
                            query.title = title
                        }
                        if let alias = blog["alias"] as? String
                        {
                            query.alias = alias
                        }
                        if let created = blog["created"] as? String
                        {
                            query.created = created
                        }
                        if let display_time = blog["display_time"] as? String
                        {
                            query.display_time = display_time
                        }
                        if let display_date = blog["display_date"] as? String
                        {
                            query.display_date = display_date
                        }
                        if let modified_date = blog["modified_date"] as? String
                        {
                            query.modified_date = modified_date
                        }
                        if let state = blog["state"] as? String
                        {
                            query.state = state
                        }
                        if let modified = blog["modified"] as? String
                        {
                            query.modified = modified
                        }
                        if let replied = blog["replied"] as? String
                        {
                            query.replied = replied
                        }
                        if let content = blog["content"] as? String
                        {
                            query.content = content
                        }
                        if let featured = blog["featured"] as? String
                        {
                            query.featured = featured
                        }
                        if let answered = blog["answered"] as? String
                        {
                            query.answered = answered
                        }
                        if let hits = blog["hits"] as? String
                        {
                            query.hits = hits
                        }
                        if let num_likes = blog["num_likes"] as? String
                        {
                            query.num_likes = num_likes
                        }
                        if let user_id = blog["user_id"] as? String
                        {
                            query.user_id = user_id
                        }
                        if let poster_name = blog["poster_name"] as? String
                        {
                            query.poster_name = poster_name
                        }
                        if let poster_email = blog["poster_email"] as? String
                        {
                            query.poster_email = poster_email
                        }
                        if let imgTag = blog["imgTag"] as? String
                        {
                            query.imgTag = imgTag
                        }
                        if let image = blog["image"] as? String
                        {
                            query.image = image
                        }
                        if let gender = blog["gender"] as? String
                        {
                            query.gender = gender
                        }
                        if let age = blog["age"] as? String
                        {
                            query.age = age
                        }
                        if let mobile = blog["mobile"] as? String
                        {
                            query.mobile = mobile
                        }
                        if let category_id = blog["category_id"] as? String
                        {
                            query.category_id = category_id
                        }
                        if let post_type = blog["post_type"] as? String
                        {
                            query.post_type = post_type
                        }
                        if let category_name = blog["category_name"] as? String
                        {
                            query.category_name = category_name
                        }
                        if let attachments = blog["attachments"] as? [[String:AnyObject]]
                        {
                            for attachemnt in attachments
                            {
                                if let title = attachemnt["title"] as? String
                                {
                                    query.arrImages.append(title)
                                }
                            }
                        }
                        
                        arrQueries.append(query)
                    }
                    successMessage(arrQueries)
                }
                else
                {
                    failureMessage("Failure")
                }

            }
        }
    }
    
    public func editQueryWithId(queryId:String, andQueryTitle title: String, withContent content: String, successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=put&resource=update&id=%@&title=%@&content=%@&username=%@&pwd=%@&encode=true", BASE_URL,queryId,title,content,GetIONUserDefaults.getUserName(),GetIONUserDefaults.getPassword())
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["status"] as? String
                {
                    if posts.caseInsensitiveCompare("ok") == .orderedSame
                    {
                        successMessage("success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
            }
        }
    }

    public func getQuickReplyTemplatesWithUserId(userId:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=get&resource=templateslist&userid=%@", BASE_URL,userId)
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["description"] as? [[String:AnyObject]]
                {
                    var quickReplyTemplates = [QuickReplyBO]()
                    for blog in posts
                    {
                        let reply = QuickReplyBO()
                        if let id = blog["id"] as? String
                        {
                            reply.id = id
                        }
                        if let title = blog["title"] as? String
                        {
                            reply.title = title
                        }

                        if let content = blog["content"] as? String
                        {
                            reply.content = content
                        }

                        if let created_by = blog["created_by"] as? String
                        {
                            reply.created_by = created_by
                        }

                        if let created_date = blog["created_date"] as? String
                        {
                            reply.created_date = created_date
                        }

                        if let modified_date = blog["modified_date"] as? String
                        {
                            reply.modified_date = modified_date
                        }
                        quickReplyTemplates.append(reply)
                    }
                    successMessage(quickReplyTemplates)
                }
                else
                {
                    failureMessage("Failure")
                }
            }
        }
    }
    
    public func addReplyForQuestion(id: String, withMessage message: String, forUser userId:String, withUserName userName: String, withPrivacy privacy: String, successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=post&resource=reply&encode=true&private=%@&pwd=cmFtZXNo&question_id=%@&reply=%@&userid=%@&username=%@", BASE_URL,privacy,id,message,userId,userName)
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["status"] as? String
                {
                    if posts.caseInsensitiveCompare("ok") == .orderedSame
                    {
                        successMessage("success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
            }
        }
    }

    public func addReplyForQuestionWithAttachmentsFor(id: String, withMessage message: String, forUser userId:String, withUserName userName: String, withPrivacy privacy: String, withAttachments attachments: [String], successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        var attachmentString = ""
        var count = 0
        while count < attachments.count
        {
            let imageUrl = attachments[count]
            if attachmentString.characters.count == 0
            {
                attachmentString = String(format: "&attachment1=%@", imageUrl)
            }
            else
            {
                attachmentString = String(format: "%@&attachment%d=%@", attachmentString,count+1,imageUrl)
            }
            count = count + 1
        }
        
        attachmentString = String(format: "%@&attachments=%d", attachmentString,attachments.count)
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=post&resource=reply&encode=true&private=%@&pwd=cmFtZXNo&question_id=%@&reply=%@&userid=%@&username=%@%@", BASE_URL,privacy,id,message,userId,userName,attachmentString)
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let posts = obj.parsedDataDict["status"] as? String
                {
                    if posts.caseInsensitiveCompare("ok") == .orderedSame
                    {
                        successMessage("success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
            }
        }
    }

    public func deleteReplyForQuestion(id: String, forUser userId:String, withUserName userName: String, successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)/request?module=easydiscuss&action=delete&resource=querydelete&id=\(id)&username=\(userName)&pwd=\(GetIONUserDefaults.getPassword())&encode=true"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let status = obj.parsedDataDict["status"] as? String
                {
                    if status == "ok"
                    {
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage(self.SERVER_ERROR)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
            }
        }
    }
    public func getVisitsFor(date:String,username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_rsappt_pro3&controller=json_x&fileout=yes&format=raw&task=get_adm_bookings&adm=1&list_type=daily&usr=\(username)&pwd=\(password)&adm=1&encode=true&sd=\(date)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                var arrVisitData = [VisitsBO]()
                if let data = obj.parsedDataDict["data"] as? [[String : AnyObject]]
                {
                    for item in data
                    {
                        let objVisits = VisitsBO()
                        if let id = item["id"] as?  String
                        {
                            objVisits.visitId = id
                        }
                        if let name = item["name"] as?  String
                        {
                            objVisits.name = name
                        }
                        if let email = item["email"] as?  String
                        {
                            objVisits.email = email
                        }
                        if let mobile = item["mobile"] as?  String
                        {
                            objVisits.mobile = mobile
                        }
                        if let resource = item["resource"] as?  String
                        {
                            objVisits.resource = resource
                        }
                        if let request_status = item["request_status"] as?  String
                        {
                            objVisits.requestStatus = request_status
                        }
                        if let payment_status = item["payment_status"] as?  String
                        {
                            objVisits.paymentStatus = payment_status
                        }
                        if let resource_admins = item["resource_admins"] as?  String
                        {
                            objVisits.resourceAdmins = resource_admins
                        }
                        if let booking_due = item["booking_due"] as?  String
                        {
                            objVisits.bookingDue = booking_due
                        }
                        if let booking_deposit = item["booking_deposit"] as?  String
                        {
                            objVisits.bookingDeposit = booking_deposit
                        }
                        if let booking_total = item["booking_total"] as?  String
                        {
                            objVisits.bookingTotal = booking_total
                        }
                        if let startdate = item["startdate"] as?  String
                        {
                            objVisits.startdate = startdate
                        }
                        if let starttime = item["starttime"] as?  String
                        {
                            objVisits.starttime = starttime
                        }
                        if let enddate = item["enddate"] as?  String
                        {
                            objVisits.enddate = enddate
                        }
                        if let endtime = item["endtime"] as?  String
                        {
                            objVisits.endtime = endtime
                        }
                        if let resname = item["resname"] as?  String
                        {
                            objVisits.resname = resname
                        }
                        if let ServiceName = item["ServiceName"] as?  String
                        {
                            objVisits.ServiceName = ServiceName
                        }
                        if let startdatetime = item["startdatetime"] as?  String
                        {
                            objVisits.startdatetime = startdatetime
                        }
                        if let display_startdate = item["display_startdate"] as?  String
                        {
                            objVisits.displayStartdate = display_startdate
                        }
                        if let display_starttime = item["display_starttime"] as?  String
                        {
                            objVisits.displayStarttime = display_starttime
                        }
                        if let image = item["image"] as?  String
                        {
                            objVisits.image = image
                        }
                        if let sex = item["sex"] as?  String
                        {
                            objVisits.sex = sex
                        }
                        if let age = item["age"] as?  String
                        {
                            objVisits.age = age
                        }
                        if let area = item["area"] as?  String
                        {
                            objVisits.area = area
                        }
                        if let city = item["city"] as?  String
                        {
                            objVisits.city = city
                        }
                        if let birthday = item["birthday"] as?  String
                        {
                            objVisits.birthday = birthday
                        }
                        if let remarks = item["remarks"] as?  String
                        {
                            objVisits.remarks = remarks
                        }
                        if let ce_id = item["ce_id"] as?  String
                        {
                            objVisits.ceId = ce_id
                        }
                        if let nametag = item["nametag"] as?  String
                        {
                            objVisits.nametag = nametag
                        }
                        
                        arrVisitData.append(objVisits)
                        
                    }
                    
                    successMessage (arrVisitData)
                    
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    
    public func deletVisitsWithID(visitID:String,username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_rsappt_pro3&controller=json_x&fileout=yes&format=raw&task=delete_visits&usr=\(username)&pwd=\(password)&encode=true&id=\(visitID)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let status = obj.parsedDataDict["Delete Result"] as? String
                {
                    if status == "OK"
                    {
                        successMessage (status)
                    }
                    else
                    {
                        failureMessage("unable to delete the visit")
                    }
                    
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    
    public func getCatagoryForVisitsWithCatID(CatID:String,username:String,password:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
       // http://staging.etion.in/index.php?option=com_rsappt_pro3&controller=json_x&fileout=yes&format=raw&task=get_categories&usr=ramesh&pwd=cmFtZXNo&encode=true&cat_id={paren_category_id(LoginResponse)}&sc=1
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_rsappt_pro3&controller=json_x&fileout=yes&format=raw&task=get_categories&usr=\(username)&pwd=\(password)&encode=true&cat_id=\(CatID)&sc=1"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                var arrCatData = [CatagoryBO]()
                if let data = obj.parsedDataDict["data"] as? [[String : AnyObject]]
                {
                    for item in data
                    {
                        let objCat = CatagoryBO()
                        if let id_categories = item["id_categories"] as?  String
                        {
                            objCat.id_categories = id_categories
                        }
                        if let name = item["name"] as?  String
                        {
                            objCat.name = name
                        }
                        if let description = item["description"] as?  String
                        {
                            objCat.catDescription = description
                        }
                        if let parent_category = item["parent_category"] as?  String
                        {
                            objCat.parent_category = parent_category
                        }
                        if let group_scope = item["group_scope"] as?  String
                        {
                            objCat.group_scope = group_scope
                        }
                        if let mail_id = item["mail_id"] as?  String
                        {
                            objCat.mail_id = mail_id
                        }
                        if let category_duration = item["category_duration"] as?  String
                        {
                            objCat.category_duration = category_duration
                        }
                        if let category_duration_unit = item["category_duration_unit"] as?  String
                        {
                            objCat.category_duration_unit = category_duration_unit
                        }
                        if let ddslick_image_path = item["ddslick_image_path"] as?  String
                        {
                            objCat.ddslick_image_path = ddslick_image_path
                        }
                        if let ddslick_image_text = item["ddslick_image_text"] as?  String
                        {
                            objCat.ddslick_image_text = ddslick_image_text
                        }
                        if let checked_out = item["checked_out"] as?  String
                        {
                            objCat.checked_out = checked_out
                        }
                        if let checked_out_time = item["checked_out_time"] as?  String
                        {
                            objCat.checked_out_time = checked_out_time
                        }
                        if let ordering = item["ordering"] as?  String
                        {
                            objCat.ordering = ordering
                        }
                        if let published = item["published"] as?  String
                        {
                            objCat.published = published
                        }
                        
                        arrCatData.append(objCat)
                    }
                    
                    successMessage (arrCatData)
                        
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }

    
    public func getAllPromotionsWith(parentId : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=category&key=e69071fc2d60078968041ecfaefe2675fafc8fd9&parentid=\(parentId)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let arrPromos = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrPromotions = [PromotionsBO]()
                    for promo in arrPromos
                    {
                        let bo = PromotionsBO()

                        if let id = promo["id"] as? String
                        {
                            bo.id = id
                        }
                        if let title = promo["title"] as? String
                        {
                            bo.title = title
                        }
                        if let alias = promo["alias"] as? String
                        {
                            bo.alias = alias
                        }
                        if let strPrivate = promo["private"] as? String
                        {
                            bo.strPrivate = strPrivate
                        }
                        if let parent_id = promo["parent_id"] as? String
                        {
                            bo.parent_id = parent_id
                        }
                        if let avatar = promo["avatar"] as? String
                        {
                            bo.avatar = avatar
                        }
                        arrPromotions.append(bo)
                    }
                    successMessage(arrPromotions)
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    func uploadImageWithData(imageData : Data,completion: @escaping (_ success: Bool,_ result : [String:AnyObject]) -> Void){
        
        let str = "http://www.dashboard.getion.in/index.php/request?action=post&module=user&resource=upload"//\(BASE_URL)
        var request  = URLRequest(url: URL(string:str as String)!)
        request.httpMethod = "POST"
        let params = ["username": GetIONUserDefaults.getUserName(), "userid": GetIONUserDefaults.getUserId(), "password" : GetIONUserDefaults.getPassword(), "auth_key": GetIONUserDefaults.getAuth(), "encode": true] as [String : Any]
        
        let boundary = NSString(format: "---------------------------14737809831466499882746641449")
        let contentType = NSString(format: "multipart/form-data; boundary=%@",boundary)
        request.addValue(contentType as String, forHTTPHeaderField: "Content-Type")
        let body = NSMutableData()
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format:"Content-Disposition: form-data; name=\"file\"; filename=\"img.jpg\"\\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(NSString(format: "Content-Type: application/octet-stream\r\n\r\n").data(using: String.Encoding.utf8.rawValue)!)
        body.append(imageData)
        
        body.append(NSString(format: "\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8.rawValue)!)
        
        for (key, value) in params {
            
            body.append(NSString(format:"--\(boundary)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format:"Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
            body.append(NSString(format:"\(value)\r\n" as NSString).data(using: String.Encoding.utf8.rawValue)!)
            
        }
        request.httpBody = body as Data
        
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 180.0
        config.timeoutIntervalForResource = 180.0
        let urlSession = URLSession(configuration: config)
        let task = urlSession.dataTask(with: request) { (data, response, err) in
            var parsedDataDict = [String:AnyObject]()
            if err == nil
            {
                if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                {
                    print("Response : ",dataString)
                    
                   if let data = self.convertStringToDictionary(dataString as String) as? [String:AnyObject]
                    {
                        parsedDataDict = data
                    }else
                    {
                        var dict =  [String:AnyObject]()
                        dict["data"] = self.convertStringToDictionary(dataString as String) as AnyObject?
                        parsedDataDict = dict
                    }
                    
                    completion (true,parsedDataDict)
                }
                else
                {
                    completion(false,parsedDataDict)
                }
                
            }
            else
            {
                completion(false,parsedDataDict)
            }
        }
        
        task.resume()
    }
    func addPromotionWith(dict : [String:AnyObject],successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //http://www.staging.getion.in/index.php?option=com_api&format=raw&app=easyblog&resource=blog

        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=blog"
        obj.params = dict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let postid = obj.parsedDataDict["postid"] as? String
                {
                    if postid != ""
                    {
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    
    func getIonizedBlogsWith(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=latest&user_id=\(GetIONUserDefaults.getUserId())&key=\(GetIONUserDefaults.getAuth())&promos=1&status=0"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrBlogs = [BlogBO]()
                    for blog in data
                    {
                        let bo = BlogBO()
                        if let postid = blog["postid"] as? String
                        {
                            bo.postId = postid
                        }
                        if let title = blog["title"] as? String
                        {
                            bo.title = title
                        }
                        if let textplain = blog["textplain"] as? String
                        {
                            bo.textplain = textplain
                        }
                        if let image = blog["image"] as? [String:AnyObject]
                        {
                            if let url = image["url"] as? String
                            {
                                bo.imageURL = url
                            }
                        }
                        if let created_date = blog["created_date"] as? String
                        {
                            bo.created_date = created_date
                        }
                        if let created_date_elapsed = blog["created_date_elapsed"] as? String
                        {
                            bo.created_date_elapsed = created_date_elapsed
                        }
                        if let updated_date = blog["updated_date"] as? String
                        {
                            bo.updated_date = updated_date
                        }
                        if let author = blog["author"] as? [String:AnyObject]
                        {
                            if let name = author["name"] as? String
                            {
                                bo.authorName = name
                            }
                            if let email = author["email"] as? String
                            {
                                bo.authorEmail = email
                            }
                            if let photo = author["photo"] as? String
                            {
                                bo.authorPhoto = photo
                            }
                            if let website = author["website"] as? String
                            {
                                bo.authorWebsite = website
                            }
                            if let bio = author["bio"] as? String
                            {
                                bo.authorBio = bio
                            }
                        }
                        if let comments = blog["comments"] as? String
                        {
                            bo.comments = comments
                        }
                        if let url = blog["url"] as? String
                        {
                            bo.url = url
                        }
                        if let tags = blog["tags"] as? [[String:AnyObject]]
                        {
                            bo.tags = tags as [AnyObject]
                        }
                        if let rating = blog["rating"] as? String
                        {
                            bo.rating = rating
                        }
                        if let rate = blog["rate"] as? [String:AnyObject]
                        {
                            if let ratings = rate["ratings"] as? NSNumber
                            {
                                bo.ratings = Int(truncating: ratings)
                            }
                            if let total = rate["total"] as? String
                            {
                                bo.ratingTotal = total
                            }
                        }
                        if let category = blog["category"] as? [String:AnyObject]
                        {
                            if let categoryid = category["categoryid"] as? String
                            {
                                bo.categoryId = categoryid
                            }
                            if let title = category["title"] as? String
                            {
                                bo.categoryTitle = title
                            }
                            if let description = category["description"] as? String
                            {
                                bo.categoryDescription = description
                            }
                            if let created_date = category["created_date"] as? String
                            {
                                bo.categoryCreated_date = created_date
                            }
                            if let updated_date = category["updated_date"] as? String
                            {
                                bo.categoryUpdated_date = updated_date
                            }
                            if let scope = category["scope"] as? String
                            {
                                bo.categoryScope = scope
                            }
                        }
                        if let permalink = blog["permalink"] as? String
                        {
                            bo.permalink = permalink
                        }
                        if let modified_date = blog["modified_date"] as? String
                        {
                            bo.modified_date = modified_date
                        }
                        if let isowner = blog["isowner"] as? Bool
                        {
                            bo.isowner = isowner
                        }
                        if let ispassword = blog["ispassword"] as? Bool
                        {
                            bo.ispassword = ispassword
                        }
                        if let blogpassword = blog["blogpassword"] as? String
                        {
                            bo.blogpassword = blogpassword
                        }
                        if let views = blog["views"] as? NSNumber
                        {
                            bo.views = Int(truncating: views)
                        }
                        if let vote = blog["vote"] as? String
                        {
                            bo.vote = vote
                        }
                        if let state = blog["state"] as? NSNumber
                        {
                            bo.state = Int(truncating: state)
                        }
                        if let published = blog["published"] as? String
                        {
                            bo.published = published
                        }
                        if let like = blog["like"] as? NSNumber
                        {
                            bo.like = Int(truncating: like)
                        }
                        if let intro = blog["intro"] as? String
                        {
                            bo.intro = intro
                        }
                        if let isVoted = blog["isVoted"] as? NSNumber
                        {
                            bo.isVoted = Int(truncating: isVoted)
                        }
                        if let userid = blog["userid"] as? String
                        {
                            bo.userid = userid
                        }
                        arrBlogs.append(bo)
                    }
                    successMessage(arrBlogs)
                }
                else
                {
                    failureMessage("Failure")
                }
                
            }
        }
    }
    
    func getAllTagSuggestion(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)/request/searchTags/contacts/contacts?user_id=180&filterVal="
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["status"] as? String
                {
                    if code == "ok"
                    {
                        if let arrPromos = obj.parsedDataDict["description"] as? [[String:AnyObject]]
                        {
                            var arrSuggestions = [TagSuggestionBO]()
                            for promo in arrPromos
                            {
                                let bo = TagSuggestionBO()
                                
                                if let id = promo["id"] as? String
                                {
                                    bo.id = id
                                }
                                if let title = promo["title"] as? String
                                {
                                    bo.title = title
                                }
                                if let created = promo["created"] as? String
                                {
                                    bo.created = created
                                }
                                arrSuggestions.append(bo)
                            }
                            successMessage(arrSuggestions)
                        }
                        else
                        {
                            failureMessage(self.SERVER_ERROR)
                        }
                    }
                    else
                    {
                        failureMessage(self.SERVER_ERROR)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }

            }
        }
    }
    func ionizePromotionWith(dict : [String:AnyObject],successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //title:First blog
        
        
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "PUT"
        obj._serviceURL = "http://www.dashboard.getion.in/index.php?option=com_api&format=raw&app=easyblog&resource=blog"
        obj.params = dict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["code"] as? String
                {
                    if code == "200"
                    {
                        if let id = obj.parsedDataDict["id"] as? String
                        {
                            GetIONUserDefaults.setUserId(object: id)
                        }
                        if let profile_image = obj.parsedDataDict["profile_image"] as? String
                        {
                            GetIONUserDefaults.setProfPic(object: profile_image)
                        }
                        if let auth = obj.parsedDataDict["auth"] as? String
                        {
                            GetIONUserDefaults.setAuth(object: auth)
                        }
                        if let firstname = obj.parsedDataDict["firstname"] as? String
                        {
                            GetIONUserDefaults.setFirstName(object: firstname)
                        }
                        if let lastname = obj.parsedDataDict["lastname"] as? String
                        {
                            GetIONUserDefaults.setLastName(object: lastname)
                        }
                        if let role = obj.parsedDataDict["role"] as? String
                        {
                            GetIONUserDefaults.setRole(object: role)
                        }
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage("Failure")
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    
    func btnPublishBlogWith(dict : [String:AnyObject],successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //http://www.staging.getion.in/index.php?option=com_api&format=raw&app=easyblog&resource=blog
        
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "PUT"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=blog"
        obj.params = dict
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let id = obj.parsedDataDict["id"] as? String,let message = obj.parsedDataDict["message"] as? String
                {
                    if id != ""
                    {
                        successMessage(message)
                    }
                    else
                    {
                        failureMessage(self.SERVER_ERROR)
                    }

                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    func sendSMSFromIONServerWith(message : String,MobileNo : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //http://www.staging.getion.in/index.php?option=com_api&format=raw&app=easyblog&resource=blog
        
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "\(BASE_URL)/request/sendSmsByPhoneNumb/contacts/contacts?username=\(GetIONUserDefaults.getUserName())&pwd=\(GetIONUserDefaults.getPassword())&encode=true&phone=\(MobileNo)&user_id=\(GetIONUserDefaults.getTeamId())&sendType=server&message=\(message)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let code = obj.parsedDataDict["status"] as? String
                {
                    if code == "ok"
                    {
                        successMessage("Success")
                    }
                    else
                    {
                        failureMessage(self.SERVER_ERROR)
                    }
                }
                else
                {
                    failureMessage(self.SERVER_ERROR)
                }
                
            }
        }
    }
    public func addQueryTemplateWith(message : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "POST"
        obj._serviceURL = "\(BASE_URL)/request?module=easydiscuss&action=post&resource=addtemplate&userid=\(GetIONUserDefaults.getUserId())&title=\(message)&content=\(message)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let status = obj.parsedDataDict["status"] as? String
                {
                    if status == "Query Template Added"
                    {
                        successMessage(status)
                    }
                    else
                    {
                        failureMessage(status)
                    }
                }
            }
        }
    }
    public func editQueryTemplateWith(id:String,oldMessage : String,newMessage : String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "PUT"
        obj._serviceURL = "\(BASE_URL)/request?module=easydiscuss&action=put&resource=edittemplate&id=\(id)&title=\(oldMessage)&content=\(newMessage)"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let status = obj.parsedDataDict["status"] as? String
                {
                    if status == "Query Template Updated"
                    {
                        successMessage(status)
                    }
                    else
                    {
                        failureMessage(status)
                    }
                }
            }
        }
    }
    func getAllPublishData(successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        //http://www.staging.getion.in/index.php?option=com_api&format=raw&app=easyblog&resource=latest&user_id=65&key=178b5f7f049b32a8fc34d9116099cd706b7f9631&limitstart=0&limit=20&Status=1
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Vists.rawValue
        obj.MethodNamee = "GET"
        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=latest&user_id=65&key=178b5f7f049b32a8fc34d9116099cd706b7f9631&limitstart=0&limit=20&Status=1"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                if let data = obj.parsedDataDict["data"] as? [[String:AnyObject]]
                {
                    var arrBlogs = [BlogBO]()
                    for blog in data
                    {
                        let bo = BlogBO()
                        if let postid = blog["postid"] as? String
                        {
                            bo.postId = postid
                        }
                        if let title = blog["title"] as? String
                        {
                            bo.title = title
                        }
                        if let textplain = blog["textplain"] as? String
                        {
                            bo.textplain = textplain
                        }
                        if let image = blog["image"] as? [String:AnyObject]
                        {
                            if let url = image["url"] as? String
                            {
                                bo.imageURL = url
                            }
                        }
                        if let created_date = blog["created_date"] as? String
                        {
                            bo.created_date = created_date
                        }
                        if let created_date_elapsed = blog["created_date_elapsed"] as? String
                        {
                            bo.created_date_elapsed = created_date_elapsed
                        }
                        if let updated_date = blog["updated_date"] as? String
                        {
                            bo.updated_date = updated_date
                        }
                        if let author = blog["author"] as? [String:AnyObject]
                        {
                            if let name = author["name"] as? String
                            {
                                bo.authorName = name
                            }
                            if let email = author["email"] as? String
                            {
                                bo.authorEmail = email
                            }
                            if let photo = author["photo"] as? String
                            {
                                bo.authorPhoto = photo
                            }
                            if let website = author["website"] as? String
                            {
                                bo.authorWebsite = website
                            }
                            if let bio = author["bio"] as? String
                            {
                                bo.authorBio = bio
                            }
                        }
                        if let comments = blog["comments"] as? String
                        {
                            bo.comments = comments
                        }
                        if let url = blog["url"] as? String
                        {
                            bo.url = url
                        }
                        if let tags = blog["tags"] as? [[String:AnyObject]]
                        {
                            bo.tags = tags as [AnyObject]
                        }
                        if let rating = blog["rating"] as? String
                        {
                            bo.rating = rating
                        }
                        if let rate = blog["rate"] as? [String:AnyObject]
                        {
                            if let ratings = rate["ratings"] as? NSNumber
                            {
                                bo.ratings = Int(truncating: ratings)
                            }
                            if let total = rate["total"] as? String
                            {
                                bo.ratingTotal = total
                            }
                        }
                        if let category = blog["category"] as? [String:AnyObject]
                        {
                            if let categoryid = category["categoryid"] as? String
                            {
                                bo.categoryId = categoryid
                            }
                            if let title = category["title"] as? String
                            {
                                bo.categoryTitle = title
                            }
                            if let description = category["description"] as? String
                            {
                                bo.categoryDescription = description
                            }
                            if let created_date = category["created_date"] as? String
                            {
                                bo.categoryCreated_date = created_date
                            }
                            if let updated_date = category["updated_date"] as? String
                            {
                                bo.categoryUpdated_date = updated_date
                            }
                            if let scope = category["scope"] as? String
                            {
                                bo.categoryScope = scope
                            }
                        }
                        if let permalink = blog["permalink"] as? String
                        {
                            bo.permalink = permalink
                        }
                        if let modified_date = blog["modified_date"] as? String
                        {
                            bo.modified_date = modified_date
                        }
                        if let isowner = blog["isowner"] as? Bool
                        {
                            bo.isowner = isowner
                        }
                        if let ispassword = blog["ispassword"] as? Bool
                        {
                            bo.ispassword = ispassword
                        }
                        if let blogpassword = blog["blogpassword"] as? String
                        {
                            bo.blogpassword = blogpassword
                        }
                        if let views = blog["views"] as? NSNumber
                        {
                            bo.views = Int(truncating: views)
                        }
                        if let vote = blog["vote"] as? String
                        {
                            bo.vote = vote
                        }
                        if let state = blog["state"] as? NSNumber
                        {
                            bo.state = Int(truncating: state)
                        }
                        if let published = blog["published"] as? String
                        {
                            bo.published = published
                        }
                        if let like = blog["like"] as? NSNumber
                        {
                            bo.like = Int(truncating: like)
                        }
                        if let intro = blog["intro"] as? String
                        {
                            bo.intro = intro
                        }
                        if let isVoted = blog["isVoted"] as? NSNumber
                        {
                            bo.isVoted = Int(truncating: isVoted)
                        }
                        if let userid = blog["userid"] as? String
                        {
                            bo.userid = userid
                        }
                        arrBlogs.append(bo)
                    }
                    self.data_layer.saveAllItemsIntoPublishTableInLocalDB(arrTmpItems: arrBlogs)
                    successMessage(arrBlogs)
                }
                else
                {
                    failureMessage("Failure")
                }
                
            }
        }
    }

    //MARK:- Utility Methods
    public func convertDictionaryToString(dict: [String:String]) -> String? {
        var strReturn = ""
        for (key,val) in dict
        {
            strReturn = strReturn.appending("\(key)=\(val)&")
        }
        strReturn = String(strReturn.characters.dropLast())
        
        return strReturn
    }
    
    
    
    public func convertStringToDictionary(_ text: String) -> [String:AnyObject]? {
        var str = text
        if str.contains("FILE BIGGER THAN 8MB")
        {
            str = text.replacingOccurrences(of: "FILE BIGGER THAN 8MB", with: "")
        }
        
        if let data = str.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:AnyObject]
                return json
            } catch {
                print("Something went wrong")
            }
        }
        return nil
    }
    
    public func encodeSpecialCharactersManually(_ strParam : String)-> String
    {
        
        var strParams = strParam.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)
        strParams = strParams!.replacingOccurrences(of: "&", with:"%26")
        return strParams!
    }
    
    public func convertSpecialCharactersFromStringForAddress(_ strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of: "&", with:"&amp;")
        strParams = strParams.replacingOccurrences(of: ">", with: "&gt;")
        strParams = strParams.replacingOccurrences(of: "<", with: "&lt;")
        strParams = strParams.replacingOccurrences(of: "\"", with: "&quot;")
        strParams = strParams.replacingOccurrences(of: "'", with: "&apos;")
        return strParams
    }
    public func convertStringFromSpecialCharacters(strParam : String)-> String
    {
        
        var strParams = strParam.replacingOccurrences(of:"%26", with:"&")
        strParams = strParams.replacingOccurrences(of:"&amp;", with:"&")
        strParams = strParams.replacingOccurrences(of:"%3E", with: ">")
        strParams = strParams.replacingOccurrences(of:"%3C" , with: "<")
        strParams = strParams.replacingOccurrences(of:"&quot;", with: "\"")
        strParams = strParams.replacingOccurrences(of:"&apos;" , with: "'")
        
        return strParams
    }

}
