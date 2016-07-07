//
//  HomeViewController.swift
//  Instagram
//
//  Created by 宮崎英美 on 2016/06/27.
//  Copyright © 2016年 e-miya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var postArray: [PostData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "Cell")
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // 要素が追加されたらpostArrayに追加してTableViewを再表示する
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            // PostDataクラスを生成して受け取ったデータを設定する
            if let uid = FIRAuth.auth()?.currentUser?.uid {
                let postData = PostData(snapshot: snapshot, myId: uid)
                self.postArray.insert(postData, atIndex: 0)
                
                // TableViewを再表示する
                self.tableView.reloadData()
            }
        })
        
        //要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
        FIRDatabase.database().reference().child(CommonConst.PostPATH).observeEventType(.ChildChanged, withBlock: {snapshot in
            if let uid = FIRAuth.auth()?.currentUser?.uid{
                //PostDataクラスを生成して受け取ったデータを設定する
                let postData = PostData(snapshot: snapshot, myId: uid)
                
                //保持している配列からidが同じものを探す
                var index: Int = 0
                for post in self.postArray {
                    if post.id == postData.id {
                        index = self.postArray.indexOf(post)!
                        break
                    }
                }
                
                //差し変えるために一度削除する
                self.postArray.removeAtIndex(index)
                
                //削除したところに更新済みのデータを追加する
                self.postArray.insert(postData, atIndex: index)
                
                //TableViewの該当セルだけを更新する
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PostTableViewCell
        cell.postData = postArray[indexPath.row]
        
        //セルのボタンアクションをソースコードで設定する
//        cell.likeButton.addTarget(self, action: "handleButton:event:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.likeButton.addTarget(self, action: #selector(self.handleButton(_:event:)), forControlEvents: UIControlEvents.TouchUpInside)    //変更
        //コメントボタンにアクション追加
        cell.commentButton.addTarget(self, action: #selector(self.handleButton(_:event:)), forControlEvents: UIControlEvents.TouchUpInside)    //課題追加
        
        //UILabelの行数が変わっている可能性があるので再描画させる
        cell.layoutIfNeeded()
        
        return cell
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // Auto Layoutを使ってセルの高さを動的に変更する
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // セルをタップされたら何もせずに選択状態を解除する
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //セル内のボタンがタップされた時に呼ばれるメソッド
    func handleButton(sender: UIButton, event: UIEvent){
        //タップされた時のインデックスを求める
        let touch = event.allTouches()?.first
        let point = touch!.locationInView(self.tableView)
        let indexPath = tableView.indexPathForRowAtPoint(point)
        
        //配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        //Firebaseに保存するデータの準備
        if let uid = FIRAuth.auth()?.currentUser?.uid {
            // ボタンアクションを分岐（課題追加）
            switch sender.tag {
            case 0:
                if postData.isLiked {
                    //すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                    var index = -1
                    for likeId in postData.likes {
                        if likeId == uid{
                            //削除するためにインデックスを保持しておく
                            index = postData.likes.indexOf(likeId)!
                            break
                        }
                    }
                    postData.likes.removeAtIndex(index)
                }else{
                    postData.likes.append(uid)
                }
                break
            case 1:
                let imageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PostComment") as! PostCommentViewController
                imageViewController.postData = postData
                self.presentViewController(imageViewController, animated: true, completion: nil)
               
                break
            default:
                break
            }
            
            if sender.tag != 1 {
                let imageString = postData.imageString
                let name = postData.name
                let caption = postData.caption
                let time = (postData.date?.timeIntervalSinceReferenceDate)! as NSTimeInterval
                let likes = postData.likes
                var comment: [String] = []
                if !postData.commentList.isEmpty{
                    comment = postData.commentList
                }
            
                //辞書を作成してFirebaseに保存する
                let post = ["caption": caption!, "image": imageString!, "name": name!, "time": time, "likes": likes, "comment": comment]     //課題変更
                let postRef = FIRDatabase.database().reference().child(CommonConst.PostPATH)
                postRef.child(postData.id!).setValue(post)
                
            }
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
