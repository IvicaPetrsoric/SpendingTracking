//
//  AddCardForm.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 14.02.2023..
//

import SwiftUI

enum CardType: String, CaseIterable {
    case visa = "Visa"
    case masterCard = "Mastercard"
    case discover = "Discover"
}

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    
    @State private var cardType = CardType.visa
    @State private var mounth = 3
    @State private var year = Calendar.current.component(.year, from: Date())
    
    @State private var color = Color.blue
    
    let currentYear = Calendar.current.component(.year, from: Date())

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Card Info")) {
                    TextField("Name", text: $name)
                    TextField("Credit Card Number", text: $cardNumber)
                        .keyboardType(.numberPad)
                    TextField("Credit Limit", text: $limit)
                        .keyboardType(.numberPad)
                    
                    Picker("Type", selection: $cardType) {
//                        ForEach(["Visa", "Mastercard", "Discover"], id: \.self) { cardType in
                        ForEach(CardType.allCases, id: \.self) { cardType in
                            Text(cardType.rawValue).tag(cardType.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Expiration")) {
                    Picker("Mounth", selection: $mounth) {
                        ForEach(1..<13, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                    
                    Picker("Year", selection: $year) {
                        ForEach(currentYear..<currentYear+20, id: \.self) { num in
                            Text(String(num)).tag(String(num))
                        }
                    }
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Color", selection: $color)
                }
            }
            .navigationTitle("Add Credit Card")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Cancel")
            })
            )
        }
    }
}
struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
//        MainView()
    }
}
