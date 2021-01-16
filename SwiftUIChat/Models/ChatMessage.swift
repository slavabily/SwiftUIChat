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
    
    var senderID: String?
    var downloadURL: URL? = nil
    
    var message: String
    var avatar: String
    var color: Color
    // isMe will be true if We sent the message
        var isMe: Bool = false
    
    var representation: [String : Any] {
      var rep: [String : Any] = [
//        "created": sentDate,
        "senderID": senderID ?? "0",
        "senderName": avatar
      ]
      
      if let url = downloadURL {
        rep["url"] = url.absoluteString
      } else {
        rep["content"] = message
      } 
      return rep
    }
}
