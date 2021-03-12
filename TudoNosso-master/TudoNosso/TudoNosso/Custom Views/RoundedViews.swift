//
//  RoundedViews.swift
//  TudoNosso
//
//  Created by Priscila Zucato on 06/11/19.
//  Copyright © 2019 Joao Flores. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    @IBInspectable
    var activeAppColor: Bool = false {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            setBorder(width: border)
        }
    }

    private func setBorder(width: CGFloat) {
        let color = activeAppColor ? UIColor.thinGray : borderColor
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color?.cgColor
        layer.masksToBounds = true
    }

    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setRadius(corner: Double(radius))
        }
    }

    private func setRadius(corner: Double) {
        guard corner != 0.5 else {
            circle()
            return
        }
        rounded(corner: corner)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setRadius(corner: Double(radius))
        setBorder(width: border)
    }
}

class RoundedView: UIView {

    @IBInspectable
    var activeAppColor: Bool = false {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layoutIfNeeded()
        }
    }
    

    private func setBorder(width: CGFloat) {
        let color = activeAppColor ? UIColor.thinGray : borderColor
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color?.cgColor
        layer.masksToBounds = true
    }
    
    @IBInspectable
    var dropShadow: Bool = false {
        didSet {
            setShadow(haveShadow: dropShadow)
        }
    }
    
    private func setShadow(haveShadow: Bool) {
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowRadius = 4
            layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            layer.shadowOpacity = 0.3
            layer.shadowOffset = CGSize (width: 1, height: 1)
        }
    }
    

    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setRadius(corner: Double(radius))
        }
    }

    private func setRadius(corner: Double) {
        guard corner != 0.5 else {
            circle()
            return
        }
        rounded(corner: corner)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setRadius(corner: Double(radius))
        setBorder(width: border)
    }
}

class RoundTextView: UITextView {
    
    @IBInspectable
    var activeAppColor: Bool = false {
        didSet {
            setBorder(width: border)
        }
    }
    
    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            setBorder(width: border)
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layoutIfNeeded()
        }
    }
    
    private func setBorder(width: CGFloat) {
        let color = activeAppColor ? UIColor.thinGray : borderColor
        layer.borderWidth = CGFloat(width)
        layer.borderColor = color?.cgColor
        layer.masksToBounds = true
    }
    
    @IBInspectable
    var dropShadow: Bool = false {
        didSet {
            setShadow(haveShadow: dropShadow)
        }
    }
    
    private func setShadow(haveShadow: Bool) {
        if haveShadow {
            layer.masksToBounds = false
            layer.shadowRadius = 4
            layer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            layer.shadowOpacity = 0.3
            layer.shadowOffset = CGSize (width: 1, height: 1)
        }
    }
    
    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setRadius(corner: Double(radius))
        }
    }
    
    private func setRadius(corner: Double) {
        guard corner != 0.5 else {
            circle()
            return
        }
        rounded(corner: corner)
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setRadius(corner: Double(radius))
        setBorder(width: border)
    }
}

class RoundedImageView: UIImageView {

    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layoutIfNeeded()
        }
    }

    private func setBorder(width: CGFloat) {
        layer.borderWidth = CGFloat(width)
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }

    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setRadius(corner: Double(radius))
        }
    }

    private func setRadius(corner: Double) {
        guard corner != 0.5 else {
            circle()
            return
        }
        rounded(corner: corner)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setRadius(corner: Double(radius))
        setBorder(width: border)
    }
}

class RoundedLabel: UILabel {
    

    @IBInspectable
    var border: CGFloat = 0 {
        didSet {
            setBorder(width: border)
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        didSet {
            layoutIfNeeded()
        }
    }

    private func setBorder(width: CGFloat) {
        layer.borderWidth = CGFloat(width)
        layer.borderColor = borderColor?.cgColor
        layer.masksToBounds = true
    }

    @IBInspectable
    var radius: CGFloat = 0 {
        didSet {
            setRadius(corner: Double(radius))
        }
    }

    private func setRadius(corner: Double) {
        guard corner != 0.5 else {
            circle()
            return
        }
        rounded(corner: corner)
    }

    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        setRadius(corner: Double(radius))
        setBorder(width: border)
    }
}

