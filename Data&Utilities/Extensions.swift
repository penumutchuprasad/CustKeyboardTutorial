//
//  Extensions.swift
//  RupeSoKeyboard
//
//  Created by Leela Prasad on 17/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

extension UIView {
    
    /** This helps to add VisualForamt Constraints by reducing Duplications in CODE*/
    func addConstraintsWithFormatString(formate: String, views: UIView...) {
        
        var viewsDictionary = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: formate, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        
    }
    
    
    /**Sets border at bottom for the Views */
    func setBottomLineForView(borderColor: UIColor) {
        
        self.backgroundColor = UIColor.clear
        
        let borderLine = UIView()
        let height = 1.0
        borderLine.frame = CGRect(x: 0, y: Double(self.frame.height) - height, width: Double(self.frame.width), height: height)
        
        borderLine.backgroundColor = borderColor
        self.addSubview(borderLine)
    }
    
}


extension UIColor {
    
    /**This returns the RGB Color by taking Parameters Red, Green and Blue Values*/
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        
        return UIColor.init(red: red/255, green: green/255, blue: blue/255, alpha: 1.0)
    }
    
    /**Gives Color from HEX Value, If there is more than 6 characters in HEX String, it returns "Magenta Color". If the HEX String is Correct, it returns it's Color*/
    static func colorFromHexValue(_ hex: String) -> UIColor {
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            
            return UIColor.magenta
        }
        
        var rgb: UInt32 = 0
        Scanner.init(string: hexString).scanHexInt32(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16)/255,
                            green: CGFloat((rgb & 0x00FF00) >> 8)/255,
                            blue: CGFloat(rgb & 0x0000FF)/255,
                            alpha: 1.0)
    }
    
}


extension UIInputView: UIInputViewAudioFeedback {
    
    public var enableInputClicksWhenVisible: Bool {
        get {
            return true
        }
    }
    
    func playInputClick​() {
        UIDevice.current.playInputClick()
    }
    
}

extension String {
    
    var length : Int {
        get{
            return self.count
        }
    }
}



extension Notification.Name {
    
    static var containerShowAndHideNotification = Notification.Name.init("containerShowAndHideNotification")
    
    static var textProxyForContainer = Notification.Name.init("HandleContainerText")
    
    static var textProxyNilNotification = Notification.Name.init("TextProxyNilNotification")
    
    // For notifying From Child View Controllers
    
    static var childVCInformation = Notification.Name.init("ChildVC Information")

}


extension UIReturnKeyType {
    
    func get (rawValue: Int)-> String {
        
        switch self.rawValue {
        case UIReturnKeyType.default.rawValue:
            return "Return"
        case UIReturnKeyType.continue.rawValue:
            return "Continue"
        case UIReturnKeyType.google.rawValue:
            return "google"
        case UIReturnKeyType.done.rawValue:
            return "Done"
        case UIReturnKeyType.search.rawValue:
            return "Search"
        case UIReturnKeyType.join.rawValue:
            return "Join"
        case UIReturnKeyType.next.rawValue:
            return "Next"
        case UIReturnKeyType.emergencyCall.rawValue:
            return "Emg Call"
        case UIReturnKeyType.route.rawValue:
            return "Route"
        case UIReturnKeyType.send.rawValue:
            return "Send"
        case UIReturnKeyType.yahoo.rawValue:
            return "search"
            
        default:
            return "Default"
        }
        
    }
    
}



extension UIViewController {
    
//    /**Adds View controoler as a child view controller, on current View  */
//    func addViewControllerAsChildViewController(childViewController: UIViewController) {
//        
//        addChildViewController(childViewController)
//        view.addSubview(childViewController.view)
//        childViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-225)
//        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        childViewController.didMove(toParentViewController: self)
//        
//    }
//    
//    /**Removes View controoler from  child view controller, on current View  */
//    func removeViewControllerAsChildViewController(childViewController: UIViewController) {
//        
//        childViewController.willMove(toParentViewController: nil)
//        childViewController.view.removeFromSuperview()
//        childViewController.removeFromParentViewController()
//        
//    }
    
    
}


















