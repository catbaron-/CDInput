//
//  KeyboardViewController.swift
//  CDInputMethod
//
//  Created by catbaron on 15/11/1.
//  Copyright © 2015年 catbaron. All rights reserved.
//

import UIKit
import Swifter
class KeyboardViewController: UIInputViewController {
    
    @IBOutlet var nextKeyboardButton: UIButton!
    @IBOutlet var infoLabel:UILabel!
    @IBOutlet var delButton: UIButton!
    @IBOutlet var ClearButton: UIButton!
    @IBOutlet var sendButton: UIButton!
    
    private var buttonWidth:CGFloat = 90.0
    private var buttonHeight:CGFloat = 45.0
    private var between:CGFloat = 3
    var server = HttpServer()

    var submit = false // Insert a /n after text if true
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewDidAppear(animated: Bool) {
        //adjust the height and color of keybord
        let keybordHeight = (self.buttonHeight + self.between)*2
        let keyboardHightConstraint = NSLayoutConstraint(item: self.view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: keybordHeight)
        self.view.addConstraint(keyboardHightConstraint)
        self.view.backgroundColor = UIColor.grayColor()
        // Initserver evertime the keyboard appears
        // Updte the keyboardviewcontroller object of server
        self.initServer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        //stop server if keybord is dispear
        self.server.stop()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Perform custom UI setup here
        // Load Items
        self.addDelButton()
        self.addSendButton()
        self.addNextKeybordButton()
        self.addClearButton()
        self.addInfoLable()
        self.initServer()
        self.startServer(2333)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func textWillChange(textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
        self.nextKeyboardButton.setTitleColor(textColor, forState: .Normal)
    }
    // MARK: items
    func addInfoLable(){
        self.infoLabel = UILabel()
        self.infoLabel.numberOfLines=0
        self.infoLabel.lineBreakMode = .ByCharWrapping
        self.infoLabel.sizeToFit()
        self.infoLabel.center = self.view.center
        self.infoLabel.textAlignment = NSTextAlignment.Center
        self.infoLabel.translatesAutoresizingMaskIntoConstraints = false
        self.infoLabel.backgroundColor = UIColor.grayColor()
        self.view.addSubview(self.infoLabel)
        let height = self.buttonHeight * 2 + self.between
        let width = UIScreen.mainScreen().bounds.width - (self.buttonWidth * 2)
        let infoLabelTopConsraint = NSLayoutConstraint(item: self.infoLabel, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 0.0)
        let infoLabelLeftConsraint = NSLayoutConstraint(item: self.infoLabel, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: self.buttonWidth)
        let infoLabelWidthConsraint = NSLayoutConstraint(item: self.infoLabel, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: width)
        let infoLabelHeightConsraint = NSLayoutConstraint(item: self.infoLabel, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: height)
        self.view.addConstraints([infoLabelTopConsraint, infoLabelLeftConsraint,infoLabelWidthConsraint,infoLabelHeightConsraint])
    }
    func addNextKeybordButton(){
        self.nextKeyboardButton = UIButton(type: .System)
        self.nextKeyboardButton.frame = CGRect(x: 0, y: 0, width: 40, height: 20)
        self.nextKeyboardButton.backgroundColor = UIColor.whiteColor()
        self.nextKeyboardButton.setTitle(NSLocalizedString("N", comment: "Title for 'Next Keyboard' button"), forState: .Normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.nextKeyboardButton)
        let nextKeyboardButtonWidthConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonWidth)
        let nextKeyboardButtonHeightConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonHeight)
        let nextKeyboardButtonLeftSideConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let nextKeyboardButtonBottomConstraint = NSLayoutConstraint(item: self.nextKeyboardButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([nextKeyboardButtonLeftSideConstraint, nextKeyboardButtonBottomConstraint,nextKeyboardButtonWidthConstraint,nextKeyboardButtonHeightConstraint])
    }
    func addSendButton(){
        self.sendButton = UIButton(type: .System)
        self.sendButton.backgroundColor = UIColor.whiteColor()
        self.sendButton.setTitle(NSLocalizedString("SEND", comment: "Submit Message"), forState: .Normal)
        self.sendButton.sizeToFit()
        self.sendButton.translatesAutoresizingMaskIntoConstraints = false
        self.sendButton.addTarget(self, action: "send", forControlEvents: .TouchUpInside)
        self.view.addSubview(sendButton)
        let buttonWidthConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonWidth)
        let buttonHeightConstraint = NSLayoutConstraint(item: self.sendButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonHeight)
        let buttonConstraintRight = NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let buttonConstraintBottom = NSLayoutConstraint(item: self.sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
        self.view.addConstraints([buttonWidthConstraint,buttonHeightConstraint,buttonConstraintRight,buttonConstraintBottom])
    }
    func addDelButton(){
        self.delButton = UIButton(type: .System)
        self.delButton.backgroundColor = UIColor.whiteColor()
        self.delButton.setTitle(NSLocalizedString("<<Del<<", comment: "Title for button"), forState: .Normal)
        self.delButton.sizeToFit()
        self.delButton.translatesAutoresizingMaskIntoConstraints = false
        self.delButton.addTarget(self, action: "backDel", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.delButton)
        let buttonWidthConstraint = NSLayoutConstraint(item: self.delButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonWidth)
        let buttonHeightConstraint = NSLayoutConstraint(item: self.delButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonHeight)
        let buttonConstraintRight = NSLayoutConstraint(item: self.delButton, attribute: .Right, relatedBy: .Equal, toItem: self.view, attribute: .Right, multiplier: 1.0, constant: 0.0)
        let buttonConstraintTop = NSLayoutConstraint(item: self.delButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: 3.0)
        self.view.addConstraints([buttonConstraintRight, buttonConstraintTop,buttonWidthConstraint,buttonHeightConstraint])
    }
    func addClearButton(){
        self.ClearButton = UIButton(type: .System)
        self.ClearButton.backgroundColor = UIColor.whiteColor()
        self.ClearButton.setTitle(NSLocalizedString("<<Clear>>", comment: "Title for button"), forState: .Normal)
        self.ClearButton.sizeToFit()
        self.ClearButton.translatesAutoresizingMaskIntoConstraints = false
        self.ClearButton.addTarget(self, action: "clearText", forControlEvents: .TouchUpInside)
        self.view.addSubview(self.ClearButton)
        let buttonWidthConstraint = NSLayoutConstraint(item: self.ClearButton, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonWidth)
        let buttonHeightConstraint = NSLayoutConstraint(item: self.ClearButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0.0, constant: self.buttonHeight)
        let buttonConstraintLeft = NSLayoutConstraint(item: self.ClearButton, attribute: .Left, relatedBy: .Equal, toItem: self.view, attribute: .Left, multiplier: 1.0, constant: 0.0)
        let buttonConstraintTop = NSLayoutConstraint(item: self.ClearButton, attribute: .Top, relatedBy: .Equal, toItem: self.view, attribute: .Top, multiplier: 1.0, constant: self.between)
        self.view.addConstraints([buttonWidthConstraint,buttonHeightConstraint,buttonConstraintLeft,buttonConstraintTop])
    }
    
    func backDel(){
        let proxy = self.textDocumentProxy
        proxy.deleteBackward()
    }
    func initServer(){
        self.server = HttpServer()

        self.server["/input"] = { request in
            var text = "2333"
            for (name, value) in request.urlParams {
                if(name == "input"){
                    text = String(value).htmlToString!
                }
                if(name == "submit"){
                    if(value == "true"){
                        self.submit = true
                    }else{
                        self.submit = false
                    }
                }
            }
            self.infoLabel.text="to update"
            //text = text.htmlToString!
            self.infoLabel.text="did update"
            self.updateText(text)
            if(self.submit){
                self.send()
            }
            return .OK(.HTML("UPDATED"))
        }
        self.server["/"] = { request in
            let rootDir = NSBundle.mainBundle().resourcePath!
            if let html = NSData(contentsOfFile:"\(rootDir)/input.html") {
                return HttpResponse.RAW(200, "OK", nil, html)
            } else {
                return .NotFound
            }
        }
    }
    func startServer(port:in_port_t)
    {
        self.infoLabel.text = "Working..."
        self.server.start(port)
        if let addr = getWiFiAddress() {
            let text = "http://" + addr + ":"+String(2333)
            self.infoLabel.text = text
        } else {
            let text = "Your device is not connecting to a Wifi network!"
            self.infoLabel.text = text
        }
        
    }
    func send(){
        self.textDocumentProxy.insertText("\n")
    }
    func clearText(){
        // Move cursor to the end
        let proxy = self.textDocumentProxy
        if let chars = proxy.documentContextAfterInput{
            let countAfter = chars.characters.count
            proxy.adjustTextPositionByCharacterOffset(countAfter)
        }
        while(self.textDocumentProxy.hasText()){
            proxy.deleteBackward()
        }
    }
    
    func updateText(text:String){
        let proxy = self.textDocumentProxy
        self.clearText()
        proxy.insertText(text)
        if(self.submit){
            proxy.insertText(" \n")
        }
    }
}