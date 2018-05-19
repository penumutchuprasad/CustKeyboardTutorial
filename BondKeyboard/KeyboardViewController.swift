//
//  KeyboardViewController.swift
//  BondKeyboard
//
//  Created by Leela Prasad on 30/04/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {
    

    var capButton: KeyboardButton!
    var numericButton: KeyboardButton!
    var deleteButton: KeyboardButton!
    var nextKeyboardButton: KeyboardButton!
    var rupeSoButton: KeyboardButton!
    var returnButton: KeyboardButton!
    
    var isCapitalsShowing = false
    
    var areLettersShowing = true {
        
        didSet{
            
            if areLettersShowing {
                for view in mainStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.addKeyboardButtons()
                
            }else{
                displayNumericKeys()
            }
            
        }
        
    }
    
    var isContainerShowing = false {
        
        didSet{
            if isContainerShowing {
                self.childVCsNotif()
            }else {
                NotificationCenter.default.removeObserver(self, name: .childVCInformation, object: nil)
            }
        }
        
    }
    
    var allTextButtons = [KeyboardButton]()
    
    var keyboardHeight: CGFloat = 225
    var KeyboardVCHeightConstraint: NSLayoutConstraint!
    var containerViewHeight: CGFloat = 0
    
    var userLexicon: UILexicon?
    
    var notificationDictionary = [String: Any]()
    
    var containerText: String = "" {
        
        didSet{
            self.notificationDictionary["txt"] = self.containerText
            NotificationCenter.default.post(name: .textProxyForContainer, object: nil, userInfo: self.notificationDictionary)
        }
        
    }
    
    
    var currentWord: String? {
        var lastWord: String?
        // 1
        if let stringBeforeCursor = textDocumentProxy.documentContextBeforeInput {
            // 2
            stringBeforeCursor.enumerateSubstrings(in: stringBeforeCursor.startIndex...,
                                                   options: .byWords)
            { word, _, _, _ in
                // 3
                if let word = word {
                    lastWord = word
                }
            }
        }
        return lastWord
    }
    
    var isNumberPadNeeded: Bool = false {
        
        didSet{
            
            if isNumberPadNeeded {
                // Show Number Pad
                self.showNumberPad()
            }else {
                // Show Default Keyboard
                for view in mainStackView.arrangedSubviews {
                    view.removeFromSuperview()
                }
                self.addKeyboardButtons()
            }
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addKeyboardButtons()
        self.setNextKeyboardVisible(needsInputModeSwitchKey)
        self.KeyboardVCHeightConstraint = NSLayoutConstraint(item: self.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: keyboardHeight+containerViewHeight)
        self.view.addConstraint(self.KeyboardVCHeightConstraint)
        self.requestSupplementaryLexicon { (lexicon) in
            self.userLexicon = lexicon
        }
        self.createObeservers()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.removeConstraint(KeyboardVCHeightConstraint)
        self.view.addConstraint(self.KeyboardVCHeightConstraint)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        let colorScheme: KBColorScheme
        if textDocumentProxy.keyboardAppearance == .dark {
            colorScheme = .dark
        } else {
            colorScheme = .light
        }
        self.setColorScheme(colorScheme)
        //Sets return key title on keyboard...
        if let returnTitle = self.textDocumentProxy.returnKeyType {
            let type = UIReturnKeyType(rawValue: returnTitle.rawValue)
            guard let retTitle = type?.get(rawValue: (type?.rawValue)!) else {return}
            self.returnButton.setTitle(retTitle, for: .normal)
        }
    }
    
    //Handles NextKeyBoard Button Appearance..
    
    func setNextKeyboardVisible(_ visible: Bool) {
        nextKeyboardButton.isHidden = !visible
    }
    
    //Set color scheme For keyboard appearance...
    func setColorScheme(_ colorScheme: KBColorScheme) {
        
        let themeColor = KBColors(colorScheme: colorScheme)
    
        self.capButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        self.deleteButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        self.numericButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        self.rupeSoButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        self.nextKeyboardButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        self.returnButton.defaultBackgroundColor = themeColor.buttonHighlightColor
        
        self.capButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        self.deleteButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        self.nextKeyboardButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        self.returnButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        self.numericButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        self.rupeSoButton.highlightBackgroundColor = themeColor.buttonBackgroundColor
        
        for button in allTextButtons {
            button.tintColor = themeColor.buttonTintColor
            button.defaultBackgroundColor = themeColor.buttonBackgroundColor
            button.highlightBackgroundColor = themeColor.buttonHighlightColor
            button.setTitleColor(themeColor.buttonTextColor, for: .normal)
            
        }
    
    }
    
    var mainStackView: UIStackView!
    
    private func addKeyboardButtons() {
        //My Custom Keys...
        
        let firstRowView = addRowsOnKeyboard(kbKeys: ["q","w","e","r","t","y","u","i","o","p"])
        let secondRowView = addRowsOnKeyboard(kbKeys: ["a","s","d","f","g","h","j","k","l"])
        
        let thirdRowkeysView = addRowsOnKeyboard(kbKeys: ["z","x","c","v","b","n","m"])
        
        let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: thirdRowkeysView)
        
        // Add Row Views on Keyboard View... With a Single Stack View..
        
        self.mainStackView = UIStackView(arrangedSubviews: [firstRowView,secondRowView,thirdRowSV,fourthRowSV])
        mainStackView.axis = .vertical
        mainStackView.spacing = 3.0
        mainStackView.distribution = .fillEqually
        mainStackView.alignment = .fill
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 2).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 2).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -2).isActive = true
        mainStackView.heightAnchor.constraint(equalToConstant: keyboardHeight).isActive = true
        
//        secondRowView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.90, constant: 1).isActive = true
//        secondRowView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

    }
    
    func serveiceKeys(midRow: UIView)->(UIStackView, UIStackView) {
        self.capButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "captial1"), tag: 1)
        self.deleteButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "backspace"), tag: 2)
        
        let thirdRowSV = UIStackView(arrangedSubviews: [self.capButton,midRow,self.deleteButton])
        thirdRowSV.distribution = .fillProportionally
        thirdRowSV.spacing = 5
        
        self.numericButton = accessoryButtons(title: "123", img: nil, tag: 3)
        self.nextKeyboardButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "globe"), tag: 4)
        self.rupeSoButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "RupeSoKey"), tag: 5)
        let spaceKey = accessoryButtons(title: "space", img: nil, tag: 6)
        self.returnButton = accessoryButtons(title: "return", img: nil, tag: 7)
        
        let fourthRowSV = UIStackView(arrangedSubviews: [self.numericButton,self.nextKeyboardButton,self.rupeSoButton,spaceKey,self.returnButton])
        fourthRowSV.distribution = .fillProportionally
        fourthRowSV.spacing = 5
        
        return (thirdRowSV,fourthRowSV)
    }
    
    
    // Adding Keys on UIView with UIStack View..
    func addRowsOnKeyboard(kbKeys: [String]) -> UIView {
        
        let RowStackView = UIStackView.init()
        RowStackView.spacing = 5
        RowStackView.axis = .horizontal
        RowStackView.alignment = .fill
        RowStackView.distribution = .fillEqually
        
        for key in kbKeys {
            RowStackView.addArrangedSubview(createButtonWithTitle(title: key))
        }
        
        let keysView = UIView()
        keysView.backgroundColor = .clear
        keysView.addSubview(RowStackView)
        keysView.addConstraintsWithFormatString(formate: "H:|[v0]|", views: RowStackView)
        keysView.addConstraintsWithFormatString(formate: "V:|[v0]|", views: RowStackView)
        return keysView
    }

    // Creates Buttons on Keyboard...
    func createButtonWithTitle(title: String) -> KeyboardButton {
        
        let button = KeyboardButton(type: .system)
        button.setTitle(title, for: .normal)
        button.sizeToFit()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.translatesAutoresizingMaskIntoConstraints = false
       // button.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
       // button.setTitleColor(UIColor.darkGray, for: .normal)
        button.addTarget(self, action: #selector(didTapButton(sender:)), for: .touchUpInside)
        allTextButtons.append(button)
        
        return button
    }
    
    @objc func didTapButton(sender: UIButton) {
        
        let button = sender as UIButton
//        self.manageShadowsOnKeys(button: button, isShadowsNeeded: false)
        guard let title = button.titleLabel?.text else { return }
        let proxy = self.textDocumentProxy
        
        UIView.animate(withDuration: 0.25, animations: {
            button.transform = CGAffineTransform(scaleX: 1.20, y: 1.20)
            self.inputView?.playInputClick​()
            if self.isContainerShowing {
                self.containerText = self.containerText + title
                
            }else{
                if !self.isContainerShowing {
                    proxy.insertText(title)
                }
            }
            
        }) { (_) in
            UIView.animate(withDuration: 0.10, animations: {
                button.transform = CGAffineTransform.identity
//                self.manageShadowsOnKeys(button: button, isShadowsNeeded: true)
            })
        }
        
    }
    
    // Accesory Buttons On Keyboard...
    
    func accessoryButtons(title: String?, img: UIImage?, tag: Int) -> KeyboardButton {
        
        let button = KeyboardButton.init(type: .system)
        
        if let buttonTitle = title {
            button.setTitle(buttonTitle, for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        if let buttonImage = img {
            button.setImage(buttonImage.withRenderingMode(.alwaysOriginal), for: .normal)
        }
       
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tag = tag
        
        //For Capitals...
        if button.tag == 1 {
            button.addTarget(self, action: #selector(handleCapitalsAndLowerCase(sender:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 45).isActive = true
            return button
        }
        //For BackDelete Key // Install Once Only..
        if button.tag == 2 {
            let longPrssRcngr = UILongPressGestureRecognizer.init(target: self, action: #selector(onLongPressOfBackSpaceKey(longGestr:)))
            
            //if !(button.gestureRecognizers?.contains(longPrssRcngr))! {
            longPrssRcngr.minimumPressDuration = 0.5
            longPrssRcngr.numberOfTouchesRequired = 1
            longPrssRcngr.allowableMovement = 0.1
            button.addGestureRecognizer(longPrssRcngr)
            //}
            button.widthAnchor.constraint(equalToConstant: 45).isActive = true
        }
        //Switch to and From Letters & Numeric Keys
        if button.tag == 3 {
            button.addTarget(self, action: #selector(handleSwitchingNumericsAndLetters(sender:)), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true

            return button
        }
        //Next Keyboard Button... Globe Button Usually...
        if button.tag == 4 {
            button.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true

            return button
        }
        //Handle Rupee Button// For Showing Payment Container...
        if button.tag == 5 {
            
            button.addTarget(self, action: #selector(HandlePaymentContainer), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return button
        }
        //White Space Button...
        if button.tag == 6 {

            button.addTarget(self, action: #selector(insertWhiteSpace), for: .touchUpInside)
            button.widthAnchor.constraint(equalToConstant: 100).isActive = true

            return button
        }
        //Handle return Button...//Usually depends on Texyfiled'd return Type...
        if button.tag == 7 {
            button.addTarget(self, action: #selector(handleReturnKey(sender:)), for: .touchUpInside)
            return button
        }
        //Else Case... For Others
        button.addTarget(self, action: #selector(manualAction(sender:)), for: .touchUpInside)
        return button
        
    }
    
    @objc func onLongPressOfBackSpaceKey(longGestr: UILongPressGestureRecognizer) {
        
        switch longGestr.state {
        case .began:
            if isContainerShowing {
                
                self.containerText = String.init((self.containerText.dropLast()))
                
            } else {
                self.textDocumentProxy.deleteBackward()
               // deleteLastWord()
            }
            
        case .ended:
            print("Ended")
            return
        default:
            self.textDocumentProxy.deleteBackward()
            //deleteLastWord()
        }
        
    }
    
    @objc func handleCapitalsAndLowerCase(sender: UIButton) {
        for button in allTextButtons {
            
            if let title = button.currentTitle {
                button.setTitle(isCapitalsShowing ? title.lowercased() : title.uppercased(), for: .normal)
            }
        }
        isCapitalsShowing = !isCapitalsShowing
    }
    
    @objc func handleSwitchingNumericsAndLetters(sender: UIButton) {
        
        areLettersShowing = !areLettersShowing
        print("Switching To and From Numeric and Alphabets")
    }
    
    @objc func HandlePaymentContainer() {
        isContainerShowing = !isContainerShowing
        self.handleContainerDisplay()
    }
    
    @objc func insertWhiteSpace() {
        
        attemptToReplaceCurrentWord()
        let proxy = self.textDocumentProxy
        proxy.insertText(" ")
        print("white space")
    }
    
    @objc func handleReturnKey(sender: UIButton) {
//        if let _ = self.textDocumentProxy.documentContextBeforeInput {
             self.textDocumentProxy.insertText("\n")
//        }
       
       // print("Return Type is handled here...")
    }
    
    
    @objc func manualAction(sender: UIButton) {
        let proxy = self.textDocumentProxy
        
        if isContainerShowing {
            
            self.containerText = String.init((self.containerText.dropLast()))
            
        } else {
            proxy.deleteBackward()
        }
        print("Else Case... Remaining Keys")
    }
    
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func createObeservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifs(notf:)), name: .containerShowAndHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotifs(notf:)), name: .textProxyNilNotification, object: nil)
    }
    
    
    @objc func handleNotifs(notf: Notification) {
        if notf.name == .textProxyNilNotification {
            self.containerText = ""
            return
        }
        if notf.name == .containerShowAndHideNotification {
            resignFirstResponder()
            self.HandlePaymentContainer()
            
            OperationQueue.current?.addOperation {
                self.textDocumentProxy.insertText("The amount Rs.100 has been credited to your wallet...")
            }
            //self.textDocumentProxy.insertText("The amount Rs.100 has been credited to your wallet...")
        }
    }
    
    //Show Payments Container as needed...
    func handleContainerDisplay() {
        self.KeyboardVCHeightConstraint.isActive = false
        
        UIView.animate(withDuration: 0.35) {
            self.KeyboardVCHeightConstraint.isActive = true
            
            if self.isContainerShowing {
                self.containerViewHeight = 150
                self.KeyboardVCHeightConstraint.constant = self.keyboardHeight+self.containerViewHeight
                self.presentContainerVC()
                return
            } else {
                self.isNumberPadNeeded = false
                self.containerViewHeight = 0
                self.KeyboardVCHeightConstraint.constant = self.keyboardHeight
                if self.view.subviews.contains(self.mainVC.view) {
//                    self.view.addConstraintsWithFormatString(formate: "H:|[v0]|", views: self.mainVC.view)
//                    self.view.addConstraintsWithFormatString(formate: "V:|[v0(0)]", views: self.mainVC.view)
                    self.removeViewControllerAsChildViewController(childViewController: self.mainVC)
                }
                return
            }
        }
        self.view.layoutIfNeeded()

    }
    
    
    // Add Child VC as container...
    
    lazy var mainVC: MainVC = {
        var viewController = MainVC()
        return viewController
    }()
    
    func presentContainerVC() {
        self.addViewControllerAsChildViewController(childViewController: mainVC)
    }
    
    
    private func addViewControllerAsChildViewController(childViewController: UIViewController) {
        
        addChildViewController(childViewController)
        view.addSubview(childViewController.view)
        childViewController.view.frame = CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height-keyboardHeight)
        childViewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        childViewController.didMove(toParentViewController: self)
        
    }
    
    private func removeViewControllerAsChildViewController(childViewController: UIViewController) {
        
        childViewController.willMove(toParentViewController: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParentViewController()
        
    }
    
    func childVCsNotif() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleChildVCNotifs(notf:)), name: .childVCInformation, object: nil)
        
    }
    
    @objc func handleChildVCNotifs(notf: Notification) {
        
        if let _ = notf.object as? ProcessVC {
           // Show Number Pad on View
            isNumberPadNeeded = true
            return
        }
        
        if let _ = notf.object as? ResultVC {
            // Show Number Pad on View
            isNumberPadNeeded = true
            return
        }
        
        isNumberPadNeeded = false
        
    }
    
    
    func showNumberPad() {
        
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        let firstRow = [".","0"]
        let secRow = ["1","2","3"]
        let thirdRow = ["4","5","6"]
        let fourthRow = ["7","8","9"]
        
        self.deleteButton = accessoryButtons(title: nil, img: #imageLiteral(resourceName: "backspace"), tag: 2)

        let first = addRowsOnKeyboard(kbKeys: firstRow)
        let second = addRowsOnKeyboard(kbKeys: secRow)
        let third = addRowsOnKeyboard(kbKeys: thirdRow)
        let fourth = addRowsOnKeyboard(kbKeys: fourthRow)
        
        let fsv = UIStackView(arrangedSubviews: [first, deleteButton])
        fsv.alignment = .fill
        fsv.distribution = .fill
        fsv.spacing = 5
        
        deleteButton.widthAnchor.constraint(equalTo: fsv.widthAnchor, multiplier: 1.0/3.0, constant: -5.0).isActive = true

        mainStackView.addArrangedSubview(fourth)
        mainStackView.addArrangedSubview(third)
        mainStackView.addArrangedSubview(second)
        mainStackView.addArrangedSubview(fsv)

    }
    
    func displayNumericKeys() {
        
        for view in mainStackView.arrangedSubviews {
            view.removeFromSuperview()
        }
        
        let nums = ["1","2","3","4","5","6","7","8","9","0"]
        let splChars1 = ["-","/",":",";","(",")","\u{20B9}","&","@","*"]
        let splChars2 = [".",",","?","!","#"]
        
        let numsRow = self.addRowsOnKeyboard(kbKeys: nums)
        let splChars1Row = self.addRowsOnKeyboard(kbKeys: splChars1)
        let splChars2Row = self.addRowsOnKeyboard(kbKeys: splChars2)

         let (thirdRowSV,fourthRowSV) = serveiceKeys(midRow: splChars2Row)
        
        mainStackView.addArrangedSubview(numsRow)
        mainStackView.addArrangedSubview(splChars1Row)
        mainStackView.addArrangedSubview(thirdRowSV)
        mainStackView.addArrangedSubview(fourthRowSV)

    }
    
    
    
}


private extension KeyboardViewController {
    func attemptToReplaceCurrentWord() {
        // 1
        guard let entries = userLexicon?.entries,
            let currentWord = currentWord?.lowercased() else {
                return
        }
        
        // 2
        let replacementEntries = entries.filter {
            $0.userInput.lowercased() == currentWord
        }
        
        if let replacement = replacementEntries.first {
            // 3
            for _ in 0..<currentWord.count {
                textDocumentProxy.deleteBackward()
            }
            
            // 4
            textDocumentProxy.insertText(replacement.documentText)
        }
    }
}
