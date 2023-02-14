//
//  AddCardForm.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 14.02.2023..
//

import SwiftUI

struct AddCardForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    
//    @Binding var shouldPresentAddCardForm: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Text("asd")
                TextField("Name", text: $name)
            }
            .navigationTitle("Add Credit Card")
            .navigationBarItems(leading:
                                    Button(action: {
                presentationMode.wrappedValue.dismiss()
//                shouldPresentAddCardForm.toggle()
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
    }
}
