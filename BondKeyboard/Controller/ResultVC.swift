//
//  ResultVC.swift
//  BondKeyboard
//
//  Created by Leela Prasad on 30/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class ResultVC: UIViewController {
    
    
    var passCodeTF: UITextField!
    
    var payButton: UIButton!
    
    var originalPassCode: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        self.passCodeTF = UITextField.init()
        passCodeTF.placeholder = "Enter Passcode"
        passCodeTF.textAlignment = .center
        passCodeTF.backgroundColor = #colorLiteral(red: 0.955975412, green: 0.8367665422, blue: 1, alpha: 1)
        view.addSubview(passCodeTF)
        
        
        self.payButton = UIButton.init(type: .system)
        payButton.setTitle("Pay", for: .normal)
        payButton.addTarget(self, action: #selector(onPay(sender:)), for: .touchUpInside)
        payButton.backgroundColor = .yellow
        self.view.addSubview(payButton)
        
        self.view.addConstraintsWithFormatString(formate: "H:|-65-[v0]-65-|", views: self.passCodeTF)
        self.view.addConstraintsWithFormatString(formate: "V:|-12-[v0(35)]", views: self.passCodeTF)
        
        self.view.addConstraintsWithFormatString(formate: "H:[v0(75)]-8-|", views: payButton)
        self.view.addConstraintsWithFormatString(formate: "V:[v0(50)]-8-|", views: payButton)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.post(name: .textProxyNilNotification, object: nil)
        NotificationCenter.default.post(name: .childVCInformation, object: self)

        NotificationCenter.default.addObserver(self, selector: #selector(handleText(notf:)), name: .textProxyForContainer, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.passCodeTF.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .textProxyNilNotification, object: nil)
        
    }
    
    var passcode = ""
    
    @objc func handleText(notf: Notification) {
        
        if let txttttt = notf.userInfo?["txt"] as? String {
            
            self.originalPassCode = txttttt
            
            passcode.removeAll()
            
            for _ in self.originalPassCode {
                
                passcode.append("*")
            }
            self.passCodeTF.text = passcode
            
        }
        
    }
    
    @objc func onPay(sender: UIButton) {
        
        print("Your PassCode is: \(originalPassCode)")
        NotificationCenter.default.post(name: .containerShowAndHideNotification, object: nil)
        
        
    }
    
}
