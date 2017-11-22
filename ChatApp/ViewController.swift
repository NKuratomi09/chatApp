//
//  ViewController.swift
//  ChatApp
//
//  Created by 倉富直城 on 2017/10/07.
//  Copyright © 2017年 com.kuratomi. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseAuth

import FirebaseDatabase

class ViewController: JSQMessagesViewController {
    
    var messages = [JSQMessage]()
    
    @IBAction func back(){
        //戻るコード
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //senderDisplayName = Auth.auth().currentUser?.displayName
        senderDisplayName = "B"
        senderId = String(describing: Auth.auth().currentUser)
        let ref = Database.database().reference()
        ref.observe(.value, with: { snapshot in
            guard let dic = snapshot.value as? Dictionary<String, AnyObject> else {
                return
            }
            guard let posts = dic["messages"] as? Dictionary<String, Dictionary<String, AnyObject>> else {
                return
            }
            
            var keyValueArray: [(String, Int)] = []
            for (key, value) in posts {
                keyValueArray.append((key: key ,date: value["date"] as! Int))
            }
            
            //順番の並び替え
            keyValueArray.sort{$0.1 < $1.1}
            // messagesを再構成
            var preMessages = [JSQMessage]()
            for sortedTuple in keyValueArray {
                for (key, value) in posts {
                    if key == sortedTuple.0 {
                        let senderId = value["senderId"] as! String!
                        let text = value["text"] as! String!
                        let displayName = value["displayName"] as! String!
                        preMessages.append(JSQMessage(senderId: senderId, displayName: displayName, text: text))
                    }
                }
            }
            
           //並び替える時
            self.messages = preMessages
            self.collectionView.reloadData()
        }
    )}
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.row]
    }
    
    // コメントの背景色の指定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        if messages[indexPath.row].senderId == senderId {
            return JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor(red: 112/255, green: 192/255, blue:  75/255, alpha: 1))
        } else {
            return JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor(red: 229/255, green: 229/255, blue: 229/255, alpha: 1))
        }
    }
    
    // コメントの文字色の指定
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        if messages[indexPath.row].senderId == senderId {
            cell.textView.textColor = UIColor.white
        } else {
            cell.textView.textColor = UIColor.darkGray
        }
        return cell
    }
    
    // メッセージの数
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    // ユーザのアバターの設定
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return JSQMessagesAvatarImageFactory.avatarImage(
            withUserInitials: messages[indexPath.row].senderDisplayName,
            backgroundColor: UIColor.lightGray,
            textColor: UIColor.white,
            font: UIFont.systemFont(ofSize: 10),
            diameter: 30)
    }
    
   // 送信ボタンを押した時
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        inputToolbar.contentView.textView.text = ""
        //70,71行目が間違っている。
        let ref = Database.database().reference()
        ref.child("messages").childByAutoId().setValue(["senderId": senderId, "text": text, "displayName": senderDisplayName, "date": [".sv": "timestamp"]])
        }
    
    
    
    }
    

