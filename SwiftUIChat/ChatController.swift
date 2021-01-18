//
//  ChatController.swift
//  SwiftUIChat
//
//  Created by slava bily on 15.01.2021.
//

import Combine
import SwiftUI
import Firebase
import MessageKit
import FirebaseFirestore

// ChatController needs to be a ObservableObject in order
// to be accessible by SwiftUI
class ChatController : ObservableObject {
    
    private let db = Firestore.firestore()
    var reference: CollectionReference?
    // didChange will let the SwiftUI know that some changes have happened in this object
    // and we need to rebuild all the views related to that object
    var didChange = PassthroughSubject<Void, Never>()
    
    // We've relocated the messages from the main SwiftUI View. Now, if you wish, you can handle the networking part here and populate this array with any data from your database. If you do so, please share your code and let's build the first global open-source chat app in SwiftUI together
    // It has to be @Published in order for the new updated values to be accessible from the ContentView Controller
    @Published var messages = [
        ChatMessage(message: "Hello world", avatar: "A", color: .red, isMe: false),
        ChatMessage(message: "Hi", avatar: "B", color: .blue, isMe: false)
    ]
    
    init() {
        self.reference = db.collection(["thread"].joined(separator: "/"))
    }
    
    // this function will be accessible from SwiftUI main view
    // here you can add the necessary code to send your messages not only to the SwiftUI view, but also to the database so that other users of the app would be able to see it
    func sendMessage(_ chatMessage: ChatMessage) {
        
        reference?.addDocument(data: chatMessage.representation, completion: { (error) in
            if let error = error {
                print("Error sending message: \(error.localizedDescription)")
                return
            }  
        })
    }
    
    func fetchMessage(_ chatMessage: ChatMessage) {
        print("Messages fetched")
        
        guard !messages.contains(chatMessage) else {
            return
        }
        messages.append(chatMessage)
    }
}

