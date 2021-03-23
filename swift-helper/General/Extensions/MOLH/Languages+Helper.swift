//
//  Languages+Extensions.swift
//  
//
//  Created by Trieu Dinh Quy on 1/15/20.
//  Copyright © 2020 TDQ. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {
    @IBInspectable var localizeText: String {
        set(value) {
            self.text = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UIButton {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.setTitle(NSLocalizedString(value, comment: ""), for: .normal)
        }
        get {
            return ""
        }
    }
}

extension UITextField {
    @IBInspectable var localizePlaceholder: String {
        set(value) {
            self.placeholder = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UITabBarItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UIBarButtonItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}

extension UINavigationItem {
    @IBInspectable var localizeTitle: String {
        set(value) {
            self.title = NSLocalizedString(value, comment: "")
        }
        get {
            return ""
        }
    }
}
