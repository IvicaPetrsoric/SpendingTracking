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
                            let title = cardType.rawValue.capitalized
                            Text(title).tag(cardType.rawValue)
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
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton
            )
        }
    }
    
    private var saveButton: some View {
        Button(action: {
            let viewContext = PersistenceController.shared.container.viewContext
            let card = Card(context: viewContext)
            
            card.name = self.name
            card.number = self.cardNumber
            card.limit = Int32(self.limit) ?? 0
            card.expMonth = Int16(self.mounth)
            card.expYear = Int16(self.year)
            card.timestamp = Date()
            card.color = UIColor(self.color).encode()
            card.cardType = self.cardType.rawValue
            
            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()

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
