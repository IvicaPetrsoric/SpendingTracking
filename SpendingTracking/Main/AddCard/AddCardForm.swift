//
//  AddCardForm.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 14.02.2023..
//

import SwiftUI

enum CardType: String, CaseIterable {
    case visa = "visa"
    case masterCard = "mastercard"
    case discover = "discover"
}

struct AddCardForm: View {
    
    let card: Card?
    var didAddCard: ((Card) -> ())? = nil
    
    init(card: Card? = nil, didAddCard: ((Card) -> ())? = nil) {
        self.card = card
        self.didAddCard = didAddCard
        
        _name = State(initialValue: self.card?.name ?? "")
        _cardNumber = State(initialValue: self.card?.number ?? "")
        
        if let limit = card?.limit {
            _limit = State(initialValue: String(limit))
        }
        
        _cardType = State(initialValue: self.card?.cardType ?? CardType.visa.rawValue)
        
        _month = State(initialValue: Int(self.card?.expMonth ?? 1))
        _year = State(initialValue: Int(self.card?.expYear ?? Int16(currentYear)))
        
        if let data = self.card?.color, let uiColor = UIColor.color(data: data) {
            let color = Color(uiColor)
            _color = State(initialValue: color)
        }

    }
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var cardNumber = ""
    @State private var limit = ""
    
    @State private var cardType = CardType.visa.rawValue
    @State private var month = 3
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
                            let title = cardType.rawValue.capitalized
                            Text(title).tag(cardType.rawValue)
                        }
                    }
                }
                
                Section(header: Text("Expiration")) {
                    Picker("Mounth", selection: $month) {
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
            .navigationTitle(self.card != nil ? self.card?.name ?? "" : "Add Credit Card")
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton
            )
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            let viewContext = PersistenceController.shared.container.viewContext
            let card = self.card != nil ? self.card! :  Card(context: viewContext)
            
//            let card = Card(context: viewContext)
            
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.limit) ?? 0
            card.expMonth = Int16(self.month)
            card.expYear = Int16(self.year)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.cardType = self.cardType
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
                
                didAddCard?(card)
            } catch {
                print("Failed to persist new card \(error)")
            }
            
        }, label: {
            Text("Save")
        })
    }
    
    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
        })
    }
    
}

extension UIColor {

     class func color(data: Data) -> UIColor? {
          return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIColor
     }

     func encode() -> Data? {
          return try? NSKeyedArchiver.archivedData(withRootObject: self, requiringSecureCoding: false)
     }
}


struct AddCardForm_Previews: PreviewProvider {
    static var previews: some View {
        AddCardForm()
//        MainView()
    }
}
