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
}
class ServiceLayer: NSObject {
    let SERVER_ERROR = "Server not responding.\nPlease try after some time."
    let BASE_URL = "http://staging.getion.in/index.php"
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
                        if let profile_image = obj.parsedDataDict["profile_image"] as? String
                        {
                            GetIONUserDefaults.setProfPic(object: profile_image)
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
    
    public func getQueries(username:String,status:String,successMessage: @escaping (Any) -> Void , failureMessage : @escaping(Any) ->Void)
    {
        let obj : HttpRequest = HttpRequest()
        obj.tag = ParsingConstant.Login.rawValue
        obj.MethodNamee = "GET"
//        obj._serviceURL = String(format: "%@/request?module=easydiscuss&action=get&resource=posts&username=%@&status=%@&limit=10", BASE_URL,username,status)
        obj._serviceURL = "http://www.staging.getion.in/request?module=easydiscuss&action=get&resource=posts&username=ramesh&status=0&limit=10"

        //        obj._serviceURL = "\(BASE_URL)?option=com_api&format=raw&app=easyblog&resource=latest&user_id=\(GetIONUserDefaults.getUserId())&key=178b5f7f049b32a8fc34d9116099cd706b7f9631&promos=2&status=1"
        obj.params = [:]
        obj.doGetSOAPResponse {(success : Bool) -> Void in
            if !success
            {
                failureMessage(self.SERVER_ERROR)
            }
            else
            {
                successMessage("")
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
        if let data = text.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) {
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
