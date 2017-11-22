//
//  LoginViewController.swift
//  ChatApp
//
//  Created by 倉富直城 on 2017/10/11.
//  Copyright © 2017年 com.kuratomi. All rights reserved.
//

import UIKit
import Firebase //Firebaseをインポート
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry  = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //ログインボタン
    @IBAction func didRegisterUser() {
        //ログインのためのメソッド
        login()
    }
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //ログイン完了後に、HomeViewControllerへの遷移のためのメソッド
    func transitionToView()  {
        self.performSegue(withIdentifier: "toVC", sender: self)
    }
    
    //ログインする時
    func login() {
        if self.emailTextField.text == "" || self.passwordTextField.text == "" {
            //どっちも空欄の場合
            let alertController = UIAlertController(title: "Error", message: "メールアドレスとパスワードが入力されていません。", preferredStyle: .alert)
            
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        } else {
            Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                if error == nil {
                    //Print into the console if successfully logged in
                    print("ログイン成功")
                    
                    //HomeViewControllerへ
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: true, completion: nil)
                } else {
                    //アカウントが間違っている場合
                    let alertController = UIAlertController(title: "エラー", message: "メールアドレスまたはパスワードが間違っています。", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
