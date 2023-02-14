//
//  AddTransactionForm.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 14.02.2023..
//

import SwiftUI

struct AddTransactionForm: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var account = ""
    @State private var date = Date()

    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Information")) {
                    TextField("Name", text: $name)
                    TextField("Account", text: $account)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    
                    NavigationLink {
                        Text("New cat page").navigationTitle(Text("Nav Title"))
                    } label: {
                        Text("Many to many")
                    }

                }
                
                Section(header: Text("Photo/Receipt")) {
                    Button {
                        
                    } label: {
                        Text("Select Photo")
                    }

                }
            }
            .navigationTitle("Add Transaction")
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
        }
    }
    
    private var saveButton: some View {
        Button {
            
        } label: {
            Text("Save")
        }
    }
    
    private var cancelButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Text("Cancel")
        }
    }
}

struct AddTransactionForm_Previews: PreviewProvider {
    static var previews: some View {
        AddTransactionForm()
    }
}
