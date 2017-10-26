//
//  GetIONUserDefaults.swift
//  GetION
//
//  Created by NIKHILESH on 13/10/17.
//  Copyright © 2017 Nikhilesh. All rights reserved.
//

import UIKit
let isRemember = "isRemember"
let UserId = "UserId"
let ProfPic = "ProfilePic"
let FirstName = "FirstName"
let LastName = "LastName"
let Role = "Role"
let UserName = "UserName"
let Password = "Password"
let Auth = "Auth"

class GetIONUserDefaults: NSObject {
    class func setLoginStatus (object : String)
    {
        UserDefaults.standard.set(object, forKey: isRemember)
        UserDefaults.standard.synchronize()
    }
    
    class func getLoginStatus () -> String
    {
        if UserDefaults.standard.object(forKey: isRemember) as? String == nil
        {
            return "false"
        }
        else
        {
            return UserDefaults.standard.object(forKey: isRemember) as! String
            
        }
    }
    class func setUserId (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserId)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserId () -> String
    {
        if UserDefaults.standard.object(forKey: UserId) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: UserId) as! String
            
        }
    }
    
    class func setUserName (object : String)
    {
        UserDefaults.standard.set(object, forKey: UserName)
        UserDefaults.standard.synchronize()
    }
    
    class func getUserName () -> String
    {
        if UserDefaults.standard.object(forKey: UserName) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: UserName) as! String
            
        }
    }
    
    class func setPassword (object : String)
    {
        UserDefaults.standard.set(object, forKey: Password)
        UserDefaults.standard.synchronize()
    }
    class func getPassword () -> String
    {
        if UserDefaults.standard.object(forKey: Password) as? String == nil
        {
            return "0"
        }
        else
        {
            return UserDefaults.standard.object(forKey: Password) as! String
            
        }
    }
    
    class func setProfPic (object : String)
    {
        UserDefaults.standard.set(object, forKey: ProfPic)
        UserDefaults.standard.synchronize()
    }
    
    class func getProfPic () -> String
    {
        if UserDefaults.standard.object(forKey: ProfPic) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: ProfPic) as! String
            
        }
    }
    class func setFirstName (object : String)
    {
        UserDefaults.standard.set(object, forKey: FirstName)
        UserDefaults.standard.synchronize()
    }
    
    class func getFirstName () -> String
    {
        if UserDefaults.standard.object(forKey: FirstName) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: FirstName) as! String
            
        }
    }
    class func setLastName (object : String)
    {
        UserDefaults.standard.set(object, forKey: LastName)
        UserDefaults.standard.synchronize()
    }
    
    class func getLastName () -> String
    {
        if UserDefaults.standard.object(forKey: LastName) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: LastName) as! String
            
        }
    }
    class func setRole (object : String)
    {
        UserDefaults.standard.set(object, forKey: Role)
        UserDefaults.standard.synchronize()
    }
    
    class func getRole () -> String
    {
        if UserDefaults.standard.object(forKey: Role) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Role) as! String
            
        }
    }
    class func setAuth (object : String)
    {
        UserDefaults.standard.set(object, forKey: Auth)
        UserDefaults.standard.synchronize()
    }
    
    class func getAuth () -> String
    {
        if UserDefaults.standard.object(forKey: Auth) as? String == nil
        {
            return ""
        }
        else
        {
            return UserDefaults.standard.object(forKey: Auth) as! String
            
        }
    }

}
