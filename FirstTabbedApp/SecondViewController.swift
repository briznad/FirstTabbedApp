//
//  SecondViewController.swift
//  FirstTabbedApp
//
//  Created by Brad Mallow on 18/8/18.
//  Copyright © 2018 Brad Mallow. All rights reserved.
//

 import UIKit

class SecondViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var RFIDTextField: UITextField!
    @IBOutlet weak var testTextField: UITextField!
    
    weak var activeField: UITextField?

    @IBOutlet weak var RFIDLabel: UILabel!
    @IBOutlet weak var LocateLabel: UILabel!

    @IBOutlet weak var LocateButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        setupUIElements()
        setupEventListeners()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func setupUIElements() {
        LocateLabel.isEnabled = false
        LocateButton.isEnabled = false
        CancelButton.isEnabled = false
    }
    
    private func setupEventListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyboardDidShow(_ notification: Notification) {
        if let activeField = activeField, let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let contentInsets = UIEdgeInsets(
                top: 0.0,
                left: 0.0,
                bottom: keyboardSize.height - self.tabBarController!.tabBar.frame.size.height,
                right: 0.0
            )
            
            updateScrollViewInsets(contentInsets)
            
            var viewFrame = view.frame
            
            viewFrame.size.height -= keyboardSize.size.height
            
            if (!viewFrame.contains(activeField.frame.origin)) {
                scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        
        updateScrollViewInsets(contentInsets)
    }
    
    private func updateScrollViewInsets(_ contentInsets : UIEdgeInsets) {
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }

//    private func toggleEnterRFID(_ enable : Bool) {
//        RFIDLabel.isEnabled = enable
//        RFIDTextField.isEnabled = enable
//    }
//
//    private func toggleLocateRFID(_ enable : Bool) {
//        LocateLabel.isEnabled = enable
//        LocateButton.isEnabled = enable
//        CancelButton.isEnabled = enable
//    }
}

extension SecondViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.activeField = nil
    }
}
