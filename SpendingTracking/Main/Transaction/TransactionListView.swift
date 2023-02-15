//
//  TransactionListView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 15.02.2023..
//

import SwiftUI

struct TransactionListView: View {

    @Environment(\.managedObjectContext) private var viewContext

    @State private var shouldShowAddTransactionForm = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \CardTransaction.timestamp, ascending: false)],
        animation: .default)
    private var cardTransactions: FetchedResults<CardTransaction>

    var body: some View {
        VStack {
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
            .fullScreenCover(isPresented: $shouldShowAddTransactionForm) {
                AddTransactionForm()
            }
            
            ForEach(cardTransactions) { transaction in
                CardTransactionView(transaction: transaction)
            }
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

            if let photoData = transaction.photoData, let uiImage = UIImage(data: photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            }
        }
        .foregroundColor(Color(.label))
        .padding()
        .background(Color.white)
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
    
}

struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        ScrollView {
            TransactionListView()
                .environment(\.managedObjectContext, context)
        }

    }
}
