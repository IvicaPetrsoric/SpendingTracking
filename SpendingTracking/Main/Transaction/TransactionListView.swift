//
//  TransactionListView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 15.02.2023..
//

import SwiftUI

struct TransactionListView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    let card: Card
    
    var fetchRequest: FetchRequest<CardTransaction>
    
    @State private var shouldShowAddTransactionForm = false
    @State private var shouldShowFilterSheet = false
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)],
                                                     predicate: .init(format: "card == %@", self.card))
    }

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp,
//                                           ascending: false)],
//        animation: .default)
//    private var cardTransactions: FetchedResults<CardTransaction>

    var body: some View {
        VStack {
            if fetchRequest.wrappedValue.isEmpty {
                Text("Get started by adding your first transaction")

                Button {
                    shouldShowAddTransactionForm.toggle()
                } label: {
                    Text("+ Transaction")
                        .padding(.init(top: 10, leading: 14, bottom: 10, trailing: 14))
                        .background(Color(.label))
                        .foregroundColor(Color(.systemBackground))
                        .font(.headline)
                        .cornerRadius(5)
                }

            } else {
                HStack {
                    Spacer()
                    addTransaction
                    filterButton
                        .sheet(isPresented: $shouldShowFilterSheet) {
                            FilterSheet(selectedCategories: self.selectedCategories) { categories in
                                self.selectedCategories = categories
                            }
                        }
                }.padding()
                
                ForEach(filterTransactions(selectedCategories: selectedCategories)) { transaction in
                    CardTransactionView(transaction: transaction)
                }
            }
        }
        .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
            AddTransactionForm(card: self.card)
        }
    }
    
    @State var selectedCategories = Set<TransactionCategory>()
    
    private func filterTransactions(selectedCategories: Set<TransactionCategory>) -> [CardTransaction] {
        if selectedCategories.isEmpty {
            return Array(fetchRequest.wrappedValue)
        }
        
        return fetchRequest.wrappedValue.filter { transaction in
            var shouldKeep = false
            
            if let categories = transaction.categories as? Set<TransactionCategory> {
                categories.forEach({ category in
                    if selectedCategories.contains(category) {
                        shouldKeep = true
                    }
                })
            }
            
            return shouldKeep
        }
    }
    
    private var filterButton: some View {
        Button {
            shouldShowFilterSheet.toggle()
        } label: {
            HStack {
                Image(systemName: "line.horizontal.3.decrease.circle")
                Text("Filter")
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color(.systemBackground))
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color(.label))
            .cornerRadius(5)
        }
    }
    
    private var addTransaction: some View {
        Button {
            shouldShowAddTransactionForm.toggle()
        } label: {
            Text("+ Transaction")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(.systemBackground))
                .padding(.horizontal, 8)
                .padding(.vertical, 6)
                .background(Color(.label))
                .cornerRadius(5)
        }
    }

}

struct FilterSheet: View {
    
    @State var selectedCategories: Set<TransactionCategory>
    
    let didSaveFilters: (Set<TransactionCategory>) -> ()
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TransactionCategory.timestamp,
                                           ascending: false)],
        animation: .default)
    
    private var categories: FetchedResults<TransactionCategory>
    
//    @State var selectedCategories = Set<TransactionCategory>()
    
    var body: some View {
        NavigationView {
            Form {
                ForEach(categories) { category in
                    Button {
                        if selectedCategories.contains(category) {
                            selectedCategories.remove(category)
                        } else {
                            selectedCategories.insert(category)
                        }
                    } label: {
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
                            
                            if selectedCategories.contains(category) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            }.navigationTitle("Select filters")
                .navigationBarItems(trailing: saveButton)
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    
    private var saveButton: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
            didSaveFilters(selectedCategories)
        } label: {
            Text("Save")
        }
    }
}

struct CardTransactionView: View {
    
    let transaction: CardTransaction

    @State var shouldPresentActionSheet = false
    
    private func handleDelete() {
        withAnimation {
            do {
                let contest = PersistenceController.shared.container.viewContext
                contest.delete(transaction)
                
                try contest.save()
            } catch {
                print("Failed to delete transaction: \(error)")
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(transaction.name ?? "")
                        .font(.headline)
                    if let date = transaction.timestamp {
                        Text(dateFormatter.string(from: date))
                    }
                }
                
                Spacer()
                
                VStack (alignment: .trailing) {
                    Button {
                        shouldPresentActionSheet.toggle()
                    } label: {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                    .padding(.init(top: 6, leading: 8, bottom: 4, trailing: 0))
                    .actionSheet(isPresented: $shouldPresentActionSheet) {
                        .init(title: Text(transaction.name ?? ""), message: nil, buttons:
                            [
                                .destructive(Text("Delete"), action: handleDelete),
                                .cancel()
                            ])
                    }
                    
                    Text(String(format: "$%.2f", transaction.amount))
                }
            }
            
            if let categories = transaction.categories as? Set<TransactionCategory> {
//                let array = Array(categories)
                let sortedByTimestamp = Array(categories).sorted(by: { $0.timestamp?.compare($1.timestamp ?? Date()) == .orderedDescending })
                
                HStack {
                    ForEach(sortedByTimestamp) { category in
                        HStack {
                            if let data = category.colorData, let uiColor = UIColor.color(data: data) {
                                let color = Color(uiColor)
                                Text(category.name ?? "")
                                    .font(.system(size: 16, weight: .bold))
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 8)
                                    .background(color)
                                    .foregroundColor(.white)
                            }
                            
                        }
                     }
                    Spacer()
                }
            }
            
        
            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .foregroundColor(Color(.label))
        .padding()
//        .background(colorScheme == .dark ? Color.gray : .white)
        .background(Color.cardTransactionBackground)
        .cornerRadius(5)
        .shadow(radius: 5)
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    @Environment(\.colorScheme) var colorScheme
    
}


struct TransactionListView_Previews: PreviewProvider {
    
    static let firstCard: Card? = {
        let context = PersistenceController.shared.container.viewContext
        let request = Card.fetchRequest()
        request.sortDescriptors = [.init(key: "timestamp", ascending: false)]
        return try? context.fetch(request).first
    }()
    
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        NavigationView {
            ScrollView {
                if let card = firstCard {
                    TransactionListView(card: card)
                        .environment(\.managedObjectContext, context)
                }
            }
        }
        .colorScheme(.light)

    }

}
