//
//  Constants.swift
//  CornerVideoPlayer
//
//  Created by Nirzar Gandhi on 18/05/25.
//

import Foundation
import UIKit

let BASEWIDTH = 375.0
let SCREENSIZE: CGRect      = UIScreen.main.bounds
let SCREENWIDTH             = UIScreen.main.bounds.width
let SCREENHEIGHT            = UIScreen.main.bounds.height
let WINDOWSCENE             = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
let STATUSBARHEIGHT         = WINDOWSCENE?.statusBarManager?.statusBarFrame.height ?? 0.0
var NAVBARHEIGHT            = 44.0

let APPDELEOBJ                      = UIApplication.shared.delegate as! AppDelegate
let NC                              = NotificationCenter.default

struct Constants {
    
    struct Storyboard {
        
        static let Main = "Main"
    }
}
