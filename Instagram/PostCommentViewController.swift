//
//  PostCommentViewController.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/07/04.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import SVProgressHUD

class PostCommentViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postData: PostData!
    var commentArray: [String] = []
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBAction func postCommentButton(sender: AnyObject) {
        if commentTextField.text != nil {
            if !(commentTextField.text!.characters.isEmpty) {

                let imageString = postData.imageString
                let name = postData.name
                let caption = postData.caption
                let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
                let likes = postData.likes
                let comment = (postData.name! + " " + commentTextField.text!) as String
                commentArray = postData.commentList
                commentArray.append(comment)
                postData.commentList = commentArray

                //辞書を作成してFirebaseに保存する
                let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comment": commentArray]
                let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
                postRef.child(postData.id!).setValue(post)

                // HUDで投稿完了を表示する
                SVProgressHUD.showSuccessWithStatus("投稿しました")
            
            }else{
                SVProgressHUD.showErrorWithStatus("コメントを入力してください")
                return
            }
        }

        dispatch_async(dispatch_get_main_queue()) {
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
            self.presentViewController(imageViewController, animated: true, completion: nil)
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Do any additional setup after loading the view.
        // 背景をタップしたらdismissKeyboardメソッドを呼ぶように設定する
        let tapGestuer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tapGestuer)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        cell.commentList = commentArray

        //UILabelの行数が変わっている可能性があるので再描画させる
        cell.layoutIfNeeded()

        return cell
    }
    
    func dismissKeyboard(){
        //キーボードを閉じる
        view.endEditing(true)
    }

    @IBAction func cancelButton(sender: AnyObject) {
        dispatch_async(dispatch_get_main_queue()) {
            let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Home") as! HomeViewController
            self.presentViewController(imageViewController, animated: true, completion: nil)
        }    
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
