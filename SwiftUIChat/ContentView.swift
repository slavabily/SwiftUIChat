//
//  ContentView.swift
//  SwiftUIChat
//
//  Created by slava bily on 14.01.2021.
//

import SwiftUI

// ChatRow will be a view similar to a Cell in standard Swift
struct ChatRow : View {
    
    // we will need to access and represent the chatMessages here
    var chatMessage: ChatMessage
    
    // body - is the body of the view, just like the body of the first view we created when opened the project
    var body: some View {
        // HStack - is a horizontal stack. We let the SwiftUI know that we need to place
        // all the following contents horizontally one after another
        Group {
            if !chatMessage.isMe {
                HStack {
                    Group {
                        Text(chatMessage.avatar)
                        Text(chatMessage.message)
                            .bold()
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                    }
                }
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(Color.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Text(chatMessage.avatar)
                    }
                }
            }
        }
    }
}

struct ContentView : View {
    
     // @State here is necessary to make the composedMessage variable accessible from different views
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController: ChatController
    
    var body: some View {
      
        // the VStack is a vertical stack where we place all our substacks like the List and the TextField
        VStack {
            // I've removed the text line from here and replaced it with a list
            // List is the way you should create any list in SwiftUI
            List {
                // we have several messages so we use the For Loop
                ForEach(chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }
            
            // TextField are aligned with the Send Button in the same line so we put them in HStack
            HStack {
                // this textField generates the value for the composedMessage @State var
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                // the button triggers the sendMessage() function written in the end of current View
                Button(action: sendMessage) {
                    Text("Send")
                }
            }.frame(minHeight: CGFloat(50)).padding()
            // that's the height of the HStack
        }
        .onAppear {
            chatController.reference?.addSnapshotListener({ (querySnapshot, error) in
                guard let snapshot = querySnapshot else {
                    print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
                    return
                }
                snapshot.documentChanges.forEach { (change) in
                    guard let chatMessage = ChatMessage(document: change.document) else {
                      print("There are no chatMessages observed...")
                        return
                    }
                    chatController.fetchMessage(chatMessage)   
                }
            })
        }
    }
    
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "C", color: .green, isMe: true))
        
        composedMessage = ""
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}
#endif
