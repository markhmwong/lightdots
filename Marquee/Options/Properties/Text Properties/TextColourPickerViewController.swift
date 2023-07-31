//
//  TextColourPickerViewController.swift
//  Marquee
//
//  Created by Mark Wong on 6/10/2022.
//

import UIKit

/*
 
 Selects colour for the text
 please find the delegate methods to assign the colour to LedOptions in LedOptionsViewController
 
 */
class TextColourViewController: UIColorPickerViewController {
    
    override init() {
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.post(name: .optionsEnableKeyboard, object: nil, userInfo: nil)
    }
}
