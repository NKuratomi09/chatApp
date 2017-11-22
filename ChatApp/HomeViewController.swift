//
//  HomeViewController.swift
//  ChatApp
//
//  Created by 倉富直城 on 2017/10/11.
//  Copyright © 2017年 com.kuratomi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {
    
    @IBOutlet var adressLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("ログイン成功")
        print(Auth.auth().currentUser?.displayName)
        adressLabel.text = (Auth.auth().currentUser?.email)! + "さん。ようこそ。"
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOutAction(sender: AnyObject) {
        if Auth.auth().currentUser != nil {
            do {
                try Auth.auth().signOut()
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SignUp")
                present(vc, animated: true, completion: nil)
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
    }
    

   

}
