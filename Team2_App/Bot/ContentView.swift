//
//  ContentView.swift
//  Team2_App
//
//  Created by Sri Vaishnavi Kosana on 11/29/23.
//
import SwiftUI
struct ContentView: View {
    @State private var messageText = ""
    @State var messages: [Message] = [Message(text: "Welcome to Easy Travel!", isUser: false)]
    
    var body: some View {
        VStack {
            // Title
            HStack {
                Spacer() // Pushes the title to the center
                Text("EasyTravel Bot")
                    .font(.title3)
                    .bold()
                Spacer()
            }
            .padding(.top, 20)
            
            // Chat messages
            ScrollView {
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(messages, id: \.id) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                .frame(maxHeight: .infinity)
            }
            
            // Message input
            HStack {
                TextField("Type something", text: $messageText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal)
                
                Button(action: sendMessage, label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                })
                .padding(.trailing)
            }
            .padding(.bottom)
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
    
    func sendMessage() {
        let userMessage = Message(text: messageText, isUser: true)
        messages.append(userMessage)
        messageText = ""
        
        // Simulate bot response after a delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let botResponse = Message(text: getBotResponse(message: userMessage.text), isUser: false)
            messages.append(botResponse)
        }
    }
}

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

struct MessageBubble: View {
    let message: Message
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
            }
            Text(message.text)
                .padding(10)
                .foregroundColor(message.isUser ? .white : .black)
                .background(messageBackground(for: message))
                .cornerRadius(10)
            if !message.isUser {
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
    
    func messageBackground(for message: Message) -> Color {
        return message.isUser ? Color.blue.opacity(0.8) : Color.gray.opacity(0.5)
    }
}
