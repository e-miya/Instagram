//
//  ViewController.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/06/29.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import FirebaseAuth

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //setupTab()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//    } 説明文＆序盤の画面でViewWill〜ですが、途中でviewDid〜に…
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // currentUserがnilならログインしていない
        if FIRAuth.auth()?.currentUser != nil {
            // ログインユーザーがnilでない場合は、ログインしている状態なので、setupTabメソッドを呼び出してタブを表示する
            setupTab()
        } else {
            // ログインしていなければログインの画面を表示する
            // viewWillAppear内でpresentViewControllerを呼び出しても表示されないため、メソッドが終了してから呼ばれるようにする
            dispatch_async(dispatch_get_main_queue()) {
                let loginViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Login")
                self.presentViewController(loginViewController!, animated: true, completion: nil)
            }
        }
    }

    func setupTab(){
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController = ESTabBarController(tabIconNames: ["home","camera","setting"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 1.0, green: 0.44, blue: 0.11, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 0.96, green: 0.91, blue: 0.87, alpha: 1)
        
        // 作成したESTabBarControllerを親のViewControllerを設定する
        addChildViewController(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.view.frame = view.bounds
        tabBarController.didMoveToParentViewController(self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let homeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Home")
        let settingViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Setting")
        
        tabBarController.setViewController(homeViewController, atIndex: 0)
        tabBarController.setViewController(settingViewController, atIndex: 2)
        
        //真ん中のタブはボタンとして扱う
        tabBarController.highlightButtonAtIndex(1)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ImageSelect")
            self.presentViewController(imageViewController!, animated: true, completion: nil)
            }, atIndex: 1)
    }

    
}

