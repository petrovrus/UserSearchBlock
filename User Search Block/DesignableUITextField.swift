//
//  DesignableUITextField.swift
//  User Search Block
//
//  Created by Ruslan on 18.04.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableUITextField: UITextField {

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateUI()
        }
    }
        
    private func updateUI() {
        if let image = leftImage {
            leftViewMode = .always
            let imageView = UIImageView(frame: CGRect(x: 15, y: 0, width: 20, height: 20))
            imageView.image = image
            
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 20))
            view.addSubview(imageView)
            
            leftView = view
        } else {
            leftViewMode = .never
        }
    }

}
