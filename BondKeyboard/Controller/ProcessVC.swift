//
//  ProcessVC.swift
//  BondKeyboard
//
//  Created by Leela Prasad on 30/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class ProcessVC: UIViewController {

    var amountTF: UITextField!
    var nextButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.amountTF = UITextField.init()
        amountTF.placeholder = "Enter Amount"
        amountTF.backgroundColor = .white
        view.addSubview(amountTF)
        
        self.nextButton = UIButton.init(type: .system)
        nextButton.setTitle("Next", for: .normal)
        nextButton.backgroundColor = .yellow
        nextButton.addTarget(self, action: #selector(onNext(sender:)), for: .touchUpInside)
        self.view.addSubview(nextButton)
        
        self.view.addConstraintsWithFormatString(formate: "H:|-35-[v0]-35-|", views: amountTF)
        self.view.addConstraintsWithFormatString(formate: "V:|-12-[v0(35)]", views: amountTF)
        self.view.addConstraintsWithFormatString(formate: "H:[v0(75)]-8-|", views: nextButton)
        self.view.addConstraintsWithFormatString(formate: "V:[v0(50)]-8-|", views: nextButton)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Make Text nil, as it is appeaaring first time...
        
        NotificationCenter.default.post(name: .textProxyNilNotification, object: nil)
        NotificationCenter.default.post(name: .childVCInformation, object: self)
        self.view.backgroundColor = #colorLiteral(red: 1, green: 0.8980991223, blue: 0.8880640628, alpha: 1)
        NotificationCenter.default.addObserver(self, selector: #selector(handleText(notf:)), name: .textProxyForContainer, object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.amountTF.becomeFirstResponder()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: .textProxyNilNotification, object: nil)
        self.removeViewControllerAsChildViewController(childViewController: vc2)
        
    }
    
    
    
    
    @objc func handleText(notf: Notification) {
        
        if let txttttt = notf.userInfo?["txt"] as? String {
            self.amountTF.text = txttttt
        }
        
    }
    
    let vc2 = ResultVC()
    
    @objc func onNext(sender: UIButton) {
        
        self.view.addSubview(vc2.view)
        self.addViewControllerAsChildViewController(childViewController: vc2)
        
    }
  
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
        
    }
    
    private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
        
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
        
    }
    

}
