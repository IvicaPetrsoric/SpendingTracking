//
//  MainPadDeviceView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 16.02.2023..
//

import SwiftUI

struct MainPadDeviceView: View {
    
    @State var shouldShowAddCardForm = false
    
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @State var selectedCard: Card?
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .frame(width: 350)
                                .onTapGesture {
                                    withAnimation {
                                        self.selectedCard = card
                                    }
                                }
                                .scaleEffect(self.selectedCard == card ? 1.1 : 1)
                        }
                    }
                    .frame(height: 250)
                    .onAppear {
                        self.selectedCard = cards.first
                    }
                    .padding(.leading)
                }
                
                if let card = self.selectedCard {
                    TransactionGriedView(card: card)
                }
            }
            .navigationTitle("Money Transaction")
            .navigationBarItems(trailing: addCardButton)
            .sheet(isPresented: $shouldShowAddCardForm) {
                AddCardForm(card: nil, didAddCard: nil)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var addCardButton: some View {
        Button {
            shouldShowAddCardForm.toggle()
        } label: {
            Text("+ Card")
        }
    }
}

struct TransactionGriedView: View {
    
    @Environment(\.managedObjectContext) private var viewContext

    let card: Card
    
    var fetchRequest: FetchRequest<CardTransaction>
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)],
                                                     predicate: .init(format: "card == %@", self.card))
    }
    
    @State private var shouldShowTrasnsactionForm = false
    
    var body: some View {
        VStack {
            HStack {
                Text("Transactions")
                Spacer()
                Button {
                    shouldShowTrasnsactionForm.toggle()
                } label: {
                    Text("+ Transaction")
                }
            }
            .sheet(isPresented: $shouldShowTrasnsactionForm) {
                AddTransactionForm(card: card)
            }
            
            let columns: [GridItem] = [
                .init(.fixed(100), spacing: 16, alignment: .leading),
                .init(.fixed(200), spacing: 16, alignment: .leading),
                .init(.flexible(minimum: 300, maximum: 800), spacing: 16),
                .init(.flexible(minimum: 100, maximum: 450), spacing: 16, alignment: .trailing),
            ]
            
            LazyVGrid(columns: columns) {
                HStack {
                    Text("Date")
                    Image(systemName: "arrow.up.arrow.down")
                }
                
                Text("Phoyo / Receipt")
                
                HStack {
                    Text("Name")
                    Image(systemName: "arrow.up.arrow.down")
                    Spacer()
                }
                
                HStack {
//                    Spacer()
                    Text("Amount")
                    Image(systemName: "arrow.up.arrow.down")
                }
            }
            .foregroundColor(Color(.darkGray))
            
            LazyVStack(spacing: 0) {
                ForEach(fetchRequest.wrappedValue) { transaction in
                    VStack(spacing: 0) {
                        Divider()
                        if let index = fetchRequest.wrappedValue.firstIndex(of: transaction) {
                            LazyVGrid(columns: columns) {
                                Group {
                                    if let date = transaction.timestamp {
                                        Text(dateFormatter.string(from: date))
                                    }
                                    
                                    if let data = transaction.photoData, let uiImage = UIImage(data: data) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: 100)
                                            .cornerRadius(8)
                                    } else {
                                        Text("No photo available")
                                    }
                                    
                                    
                                    HStack {
                                        Text(transaction.name ?? "")
                                        Spacer()
                                    }
                                    
                                    Text(String(format: "%.2f", transaction.amount))
                                }
                                .multilineTextAlignment(.leading)
                                
                            }
                            .padding(.vertical)
                            .background(index % 2 == 0 ? Color(.systemBackground) : Color(.init(white: 0, alpha: 0.03)))
                        }
                    }
                    
                }
            }
        }
        .font(.system(size: 24, weight: .semibold))
        .padding()
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
}

struct MainPadDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MainPadDeviceView()
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.portrait)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
