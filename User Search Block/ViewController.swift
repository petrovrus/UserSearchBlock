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
    
    @IBOutlet weak var userSearchField: UITextField! {
        didSet {
            NetworkingManager.getUsers(since: userSearchField.text ?? "")
        }
    }
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfUsersFound
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell)
        let (pictureUrl, username) = (users[indexPath.row].0, users[indexPath.row].1)
        DispatchQueue.global().async {
            do {
                let userImageData = try Data(contentsOf: pictureUrl)
                DispatchQueue.global().sync {
                    cell.imageViewOfCell.image = UIImage(data: userImageData)
                    cell.imageLabel.text = username
                }
            } catch {
                print("url problem")
            }
        }
        return cell
    }
    
    var users: [(URL, String)] = []
    
    var numberOfUsersFound: Int {
        get {
            return users.count
        }
    }
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var bottomConstraint: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchField.delegate = self
        bottomConstraint = keyboardHeightLayoutConstraint?.constant
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(usersListUpdate),
                                               name: Notification.Name(rawValue: "GetUsersSuccess"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: Notification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc private func usersListUpdate(notification: Notification) {
        guard let usersList = notification.object as? Array<(URL, String)> else {
            print("Users not found")
            return
        }
        users = usersList
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //function for moving view when keyboard appears
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

