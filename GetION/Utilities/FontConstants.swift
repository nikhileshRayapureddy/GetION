//
//  FontConstants.swift
//  PizzaHut
//
//  Created by kiran on 10/9/17.
//  Copyright © 2017 Capillary. All rights reserved.
//

import UIKit

protocol UIFontMyrid {
    
    static func myridFontOfSize(size: Float) -> UIFont!
    
    static func myridBoldFontOfSize(size: Float) -> UIFont!
    
    static func myridSemiboldFontOfSize(size: Float) -> UIFont!
    
    static func quicksandBoldItalicFontOfSize(size: Float) -> UIFont!
    
}

class FontConstants: NSObject {
    
    /// scale factor for retina devices. Default 2.0
    public static var retinaScaleFactor: Float = 2.0
    
    public class func registerFonts() -> Bool {
        let fontNames = [
            "Myriad_Pro_Bold",
            "Myriad_Pro_Regular",
            "Myriad_Pro_Semibold",
            "Quicksand-Bold"
        ]
        
        var error: Unmanaged<CFError>? = nil
        
        for font in fontNames {
            let url = Bundle(for: self).url(forResource: font, withExtension: "ttf")
            if (url != nil) {
                CTFontManagerRegisterFontsForURL(url! as CFURL, CTFontManagerScope.none, &error)
            }
        }
        
        return error == nil
    }
}

extension UIFont : UIFontMyrid {
    static func myridSemiboldFontOfSize(size: Float) -> UIFont! {
        return UIFont(name: "MyriadPro-Semibold", size: makeSize(size: size))

    }
    
    static func myridFontOfSize(size: Float) -> UIFont! {
        return UIFont(name: "MyriadPro-Regular", size: makeSize(size: size))

    }
    
    static func myridBoldFontOfSize(size: Float) -> UIFont! {
        return UIFont(name: "MyriadPro-Bold", size: makeSize(size: size))

    }
    static func quicksandBoldItalicFontOfSize(size: Float) -> UIFont!
    {
        return UIFont(name: "Quicksand-Bold", size: makeSize(size: size))
    }
    
    
    class func makeSize(size: Float) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
            return CGFloat(size * FontConstants.retinaScaleFactor)
        }
        
        return CGFloat(size)
    }
    
}
