//
//  ChatMessage.swift
//  SwiftUIChat
//
//  Created by slava bily on 15.01.2021.
//

import Firebase
import MessageKit
import FirebaseFirestore
import SwiftUI

struct ChatMessage : Hashable {
    var id: String?
    var senderID: String?
    var downloadURL: URL? = nil
    
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
        var isMe: Bool
    
    init(message: String, avatar: String, color: Color, isMe: Bool) {
        self.message = message
        self.avatar = avatar
        self.color = color
        self.isMe = isMe
    }
    
    init?(document: QueryDocumentSnapshot) {
        let data = document.data()
        
        guard let senderID = data["senderID"] as? String else {
            return nil
        }
        guard let avatar = data["senderName"] as? String else {
            return nil
        }
//        guard let color = data["color"] as? Color else {
//            return nil
//        }
        guard let isMe = data["isMe"] as? Bool else {
            return nil
        }
        
        id = document.documentID
        self.senderID = senderID
        self.avatar = avatar
        self.isMe = isMe
        self.color = isMe ? .green : .gray
        
        if let message = data["content"] as? String {
            self.message = message
            downloadURL = nil
        } else if let urlString = data["url"] as? String, let url = URL(string: urlString) {
            downloadURL = url
            message = ""
        } else {
            return nil
        }
    }
}

extension ChatMessage {
    var representation: [String : Any] {
      var rep: [String : Any] = [
//        "created": sentDate,
        "senderID": senderID ?? "0",
        "senderName": avatar,
//        "color": color,
        "isMe": isMe
      ]
      
      if let url = downloadURL {
        rep["url"] = url.absoluteString
      } else {
        rep["content"] = message
      }
      return rep
    }
}
