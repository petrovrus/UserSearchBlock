//
//  ViewController.swift
//  User Search Block
//
//  Created by Ruslan on 18.04.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class UserSearchVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var userSearchBlock: UIView!
    
    @IBOutlet weak var userSearchField: UITextField! {
        didSet {
            NetworkingManager.getUsers(since: userSearchField.text ?? "")
        }
    }
    
    private var users: [User] = [] {
        didSet {
            userCollectionView.reloadData()
        }
    }
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell)
        
        DispatchQueue.global().async { [weak self] in
            do {
                let username = self?.users[indexPath.row].username
                let profileUrl = URL(string: (self?.users[indexPath.row].profileURL)!)
                let userImageData = try Data(contentsOf: profileUrl!)
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
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    var bottomConstraint: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userSearchField.delegate = self
        bottomConstraint = keyboardHeightLayoutConstraint?.constant
        NSNotificationCenter.defaultCenter().addObserver(self,
                                               selector: #selector(usersListUpdate),
                                               name: NSNotification.Name(rawValue: "GetUsersSuccess"),
                                               object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @objc private func usersListUpdate(notification: NSNotification) {
        guard let usersList = notification.object as? [User] else {
            print("Users not found")
            return
        }
        users = usersList
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
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
        userCollectionView.reloadData()
        return true
    }
}

