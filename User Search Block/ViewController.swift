//
//  ViewController.swift
//  User Search Block
//
//  Created by Ruslan on 18.04.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var userSearchBlock: UIView!
    
    @IBOutlet weak var userSearchField: UITextField!
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfUsersFound
    }
    
    private struct userProfile {
        var name = String()
        var nick = String()
        var imageName = String()
        
        init(name: String, imageName: String) {
            self.name = name
            self.imageName = imageName
        }
    }
    
    private let usersInfo = [
        userProfile(name: "User 1", imageName: "profile-sample"),
        userProfile(name: "User 2", imageName: "girl"),
        userProfile(name: "User 3", imageName: "profile-sample"),
        userProfile(name: "User 4", imageName: "girl"),
        userProfile(name: "User 5", imageName: "girl"),
        userProfile(name: "User 6", imageName: "profile-sample")
    ]
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageViewOfCell.image = UIImage(named: usersInfo[indexPath.row].imageName)
        cell.imageLabel.text = usersInfo[indexPath.row].name
        return cell
    }
    

    
    var numberOfUsersFound: Int {
        get {
            return usersInfo.count
        }
    }
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    var bottomConstraint: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchField.delegate = self
        bottomConstraint = keyboardHeightLayoutConstraint?.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardNotification(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if (endFrame?.origin.y)! >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = bottomConstraint ?? 0.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? bottomConstraint ?? 0.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userSearchField.resignFirstResponder()
        return true
    }
}

