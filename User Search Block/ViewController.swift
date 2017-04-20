//
//  ViewController.swift
//  User Search Block
//
//  Created by Ruslan on 18.04.17.
//  Copyright © 2017 Ruslan Petrov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var userSearchField: UITextField!
    
    @IBOutlet weak var userCollectionView: UICollectionView!
    
    struct userProfile {
        var name = String()
        var imageName = String()
        
        init() {
            name = ""
            imageName = ""
        }
        init(name: String, imageName: String) {
            self.name = name
            self.imageName = imageName
        }
        
    }
    let userImages = [
        userProfile(name: "User 1", imageName: "profile-sample"),
        userProfile(name: "User 2", imageName: "girl"),
        userProfile(name: "User 3", imageName: "profile-sample"),
        userProfile(name: "User 4", imageName: "girl"),
        userProfile(name: "User 5", imageName: "girl"),
        userProfile(name: "User 6", imageName: "profile-sample")
    ]
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfUsersFound
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageViewOfCell.image = UIImage(named: userImages[indexPath.row].imageName)
        cell.imageLabel.text = userImages[indexPath.row].name
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    var numberOfUsersFound: Int {
        get {
            return userImages.count
        }
    }
    

}

