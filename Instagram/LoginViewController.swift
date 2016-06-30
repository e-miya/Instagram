//
//  LoginViewController.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/06/27.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SVProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet weak var mailAddressTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    // ログインボタンをタップした時に呼ばれるメソッド
    @IBAction func handleLoginButton(sender: AnyObject) {
        if let address = mailAddressTextField.text,let password = passwordTextField.text {
            // アドレスとパスワードのいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                return
            }
            
            //処理中を表示
            SVProgressHUD.show()
            
            FIRAuth.auth()?.signInWithEmail(address, password: password){ user, error in
                if error != nil {
                    // エラー表示
                    SVProgressHUD.showErrorWithStatus("エラー")
                    
                    print(error)
                }else{
                    //Firebaseからログインしたユーザの表示名を取得してNSUserDefaultに保存する
                    if let displayName = user?.displayName {
                        self.setDisplayName(displayName)
                    }
                    
                    // HUDを消す
                    SVProgressHUD.dismiss()
                    
                    // 画面を閉じる
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            }
        }
    }
    
    
    // アカウント作成ボタンをタップした時に呼ばれるメソッド
    @IBAction func handleCreateAcountButton(sender: AnyObject) {
        if let address = mailAddressTextField.text,let password = passwordTextField.text, let displayName = displayNameTextField.text {
            // アドレスとパスワードと表示名のいずれかでも入力されていない時は何もしない
            if address.characters.isEmpty || password.characters.isEmpty || displayName.characters.isEmpty {
                SVProgressHUD.showErrorWithStatus("必要項目を入力してください")
                return
            }
            
            //HUDで処理中を表示
            SVProgressHUD.show()
            
            FIRAuth.auth()?.createUserWithEmail(address, password: password){ user, error in
                if error != nil {
                    // エラー表示
                    SVProgressHUD.showErrorWithStatus("エラー")
                    print(error)
                }else{
                    // ユーザを作成できたらそのままログインする
                    FIRAuth.auth()?.signInWithEmail(address, password: password){ user, error in
                        
                        if error != nil {
                            SVProgressHUD.showErrorWithStatus("エラー")
                            print(error)
                        }else{
                            if let user = user {
                                // Firebaseに表示名を保存する
                                let request = user.profileChangeRequest()
                                request.displayName = displayName
                                request.commitChangesWithCompletion(){ error in
                                    if error != nil {
                                        print(error)
                                    }else{
                                        //NSUserDefaultsに表示名を保存する
                                        self.setDisplayName(displayName)
                                        
                                        //HUDを消す
                                        SVProgressHUD.dismiss()
                                        
                                        //画面を閉じる
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // NSUserDefaultsに表示名を保持する
    func setDisplayName(name: String) {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.setValue(name, forKey: CommonConst.DisplayNameKey)
        ud.synchronize()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
