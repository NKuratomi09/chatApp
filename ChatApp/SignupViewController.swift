//
//  SignupViewController.swift
//  
//
//  Created by 倉富直城 on 2017/10/10.
//

import UIKit
import Firebase
import FirebaseAuth

class SignupViewController: UIViewController ,UITextFieldDelegate{
    
    @IBOutlet var displayNameTextField:UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayNameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //サインアップボタン
    @IBAction func willSignup() {
        //サインアップのための関数
        signup()
    }
    //ログイン画面への遷移ボタン
    @IBAction func willTransitionToLogin() {
        transitionToLogin()
    }
 
    //ログイン画面への遷移
    func transitionToLogin() {
        self.performSegue(withIdentifier: "toLogin", sender: self)
    }
 
 /*
    //ListViewControllerへの遷移
    func transitionToView() {
        self.performSegue(withIdentifier: "toView", sender: self)
    }
 */
    //Returnキーを押すと、キーボードを隠す
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Signupする時
    func signup() {
        //emailTextFieldとpasswordTextFieldに文字がなければ、その後の処理をしない
        guard let displayName = displayNameTextField.text else { return }
        guard let email = emailTextField.text else  { return }
        guard let password = passwordTextField.text else { return }
        
        let minLengh: Int = 5
        let str = passwordTextField.text!
        var passwordNumber: Bool
        
        if str.characters.count > minLengh {
            passwordNumber = true
        }else {
            passwordNumber = false
        }
            
        //FIRAuth.auth()?.createUserWithEmailでサインアップ
        //第一引数にEmail、第二引数にパスワード
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            //エラーなしなら、認証完了
            if error == nil{
                //Userの名前登録
                /*let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = displayName
                changeRequest?.commitChanges { (error) in
                    // ...
                }*/
                let user = Auth.auth().currentUser
                if let user = user {
                    let changeRequest = user.createProfileChangeRequest()
                    changeRequest.displayName = displayName
                    changeRequest.commitChanges { error in
                        if let error = error {
                            // An error happened.
                        } else {
                            // Profile updated.
                        }
                    }
                }
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(vc!, animated: true, completion: nil)
            }else if self.emailTextField.text == "" && self.passwordTextField.text == ""{
                let alert = UIAlertController(title: "エラー", message: "内容が入力されていません", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else if passwordNumber == false{
                let alert = UIAlertController(title: "エラー", message: "パスワードは6文字以上で入力してください。", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }else {
                print("\(error?.localizedDescription)")
                let alert = UIAlertController(title: "エラー", message: "入力いただいたメールアドレスでは、既にアカウントが登録してあります。", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    print("signup完了")
    
    }
    



}
