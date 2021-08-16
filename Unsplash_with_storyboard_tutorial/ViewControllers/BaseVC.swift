//
//  BaseVC.swift
//  Unsplash_with_storyboard_tutorial
//
//  Created by 임재훈 on 2021/08/17.
//

import UIKit

class BaseVC: UIViewController {
    
    var vcTitle : String = ""{
        didSet{
            print("UserListVC - vcTitle didSet() called / vcTitle : \(vcTitle)")
            self.title = vcTitle
        }
    }
}
