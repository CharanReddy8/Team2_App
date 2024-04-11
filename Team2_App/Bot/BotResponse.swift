//
//  BotResponse.swift
//  Team2_App
//
//  Created by Sri Vaishnavi Kosana on 11/29/23.
//
import Foundation

func getBotResponse(message: String) -> String {
    let tempMessage = message.lowercased()
    
    if tempMessage.contains("hello") {
        return "Hey there! Welcome to Easy Travel. How can I assist you today?"
    } else if tempMessage.contains("goodbye") {
        return "Talk to you later! If you need any help, feel free to ask."
    } else if tempMessage.contains("how are you") {
        return "I'm an AI, so I don't have feelings, but I'm here to help you with your travel inquiries."
    } else if tempMessage.contains("book a flight") {
        return "Sure! Where would you like to fly to and when?"
    } else if tempMessage.contains("hotel reservation") || tempMessage.contains("book a hotel") {
        return "Great choice! When and where do you need the hotel?"
    } else if tempMessage.contains("weather") || tempMessage.contains("forecast") {
        return "To check the weather, please provide the location and date."
    } else if tempMessage.contains("places to visit") || tempMessage.contains("attractions") {
        return "Sure, which city or country are you interested in exploring?"
    } else if tempMessage.contains("travel tips") || tempMessage.contains("advice") {
        return "Absolutely! What specific tips or information are you looking for?"
    } else if tempMessage.contains("cancel reservation") || tempMessage.contains("modify booking") {
        return "I can assist you with cancellations or modifications. Please provide the reservation details."
    } else if tempMessage.contains("thank you") {
        return "You're welcome! If you need any further assistance, feel free to ask."
    } else if tempMessage.contains("packages") || tempMessage.contains("view packages") {
        return "We have a variety of travel packages available. Would you like me to show you the available packages?"
    } else if tempMessage.contains("show packages") {
        return "Sure, here are our latest packages: [Package 1, Package 2, Package 3]. Let me know if you need details on any specific package."
    } else if tempMessage.contains("details about package") {
        return "Which package are you interested in? Please provide the package name or ID."
    } else if tempMessage.contains("book package") || tempMessage.contains("reserve package") {
        return "Excellent choice! To book a package, please provide the package name or ID along with your details."
    } else if tempMessage.contains("suggest packages") || tempMessage.contains("recommend packages") {
        return "Certainly! Here are some suggested packages: [Beach Getaway, City Explorer, Mountain Adventure]."
    } else if tempMessage.contains("available commands") || tempMessage.contains("help") {
        return """
        Here are some commands you can try:
        - Book a flight
        - Hotel reservation
        - Weather forecast
        - Places to visit
        - Travel tips
        - Cancel reservation
        - View packages
        - Suggest packages
        - And more! Feel free to ask about any travel-related queries.
        """
    } else {
        return "I'm here to help with your travel needs. Feel free to ask me anything!"
    }
}
