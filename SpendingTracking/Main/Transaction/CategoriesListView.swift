//
//  CategoriesListView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 15.02.2023..
//

import SwiftUI

struct CategoriesListView: View {
    
    @State private var name = ""
    @State private var color = Color.red
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp, ascending: false)],
        animation: .default)
    private var categories: FetchedResults<TransactionCategory>
    
    
    var body: some View {
        Form {
            Section(header: Text("Select a category")) {
                ForEach(categories) { category in
                    HStack {
                        if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                            let color = Color(uiColor)
                            Spacer()
                                .frame(width: 30, height: 10)
                                .background(color)
                                .padding(.trailing, 8)
                        }

                        Text(category.name ?? "")
                        Spacer()
                    }
                }.onDelete { indexSet in
                    indexSet.forEach { i in
                        viewContext.delete(categories[i])
                    }
                    
                    try? viewContext.save()
                }
            }
            
            Section(header: Text("Create a category")) {
                TextField("Name", text: $name)
                ColorPicker("Color", selection: $color)
                
                Button(action: handleCreate) {
                    HStack {
                        Spacer()
                        Text("Create")
                            .foregroundColor(Color.white)
                        Spacer()
                    }
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(5)
                }.buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func handleCreate() {
        let context = PersistenceController.shared.container.viewContext
        let category = TransactionCategory(context: context)
        category.name = self.name
        category.colorData = UIColor(color).encode()
        category.timestamp = Date()
        
        do {
            try context.save()
            self.name = ""
        } catch {
            print("Failed to add category: \(error)")
        }
    }
}

struct CategoriesListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        CategoriesListView()
            .environment(\.managedObjectContext, viewContext)
    }
}
