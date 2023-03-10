//
//  MainView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 13.02.2023..
//

import SwiftUI



struct MainView: View {
    
    @State private var shouldPresentAddCardForm = false
    @State private var shouldShowAddTransactionForm = false
    
    // amount of credit card variables
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Card.timestamp, ascending: false)],
        animation: .default)
    private var cards: FetchedResults<Card>
    
    @State private var cardSelectedIndex = 0
    
    @State private var selectedCardHash = -1
    
    var body: some View {
        NavigationView {
            ScrollView {
                if !cards.isEmpty {
                    TabView(selection: $selectedCardHash) {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .padding(.bottom, 50)
                                .tag(card.hash)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                    .frame(height: 280)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .onAppear {
                        self.selectedCardHash = cards.first?.hash ?? -1
                    }
                    
                    if let firstIndex = cards.firstIndex(where: { $0.hash == selectedCardHash }) {
                        let card = self.cards[firstIndex]
                        TransactionListView(card: card)

                    }

                } else {
                    emptyPromtMessage
                }

                //hack
//                .onAppear {
//                    shouldPresentAddCardForm.toggle()
//                }
                
                Spacer()
                    .fullScreenCover(isPresented: $shouldPresentAddCardForm, onDismiss: nil) {
                        AddCardForm(card: nil) { card in
                            self.selectedCardHash = card.hash
                        }
                    }
            }
            .navigationTitle("Credit cards")
            //            .navigationBarItems(trailing: addCardButton)
            .navigationBarItems(leading:
                                    HStack {
//                addItemButton
//                deleteAllButton
            },
                                trailing: addCardButton)
            
        }
    }
        
    private var emptyPromtMessage: some View {
        VStack {
            Text("You currently have no cards in the sysyem")
                .padding(.horizontal, 48)
                .padding(.vertical)
                .multilineTextAlignment(.center)
            Button {
                shouldPresentAddCardForm.toggle()
            } label: {
                Text("+ Add Your first Card")
                    .foregroundColor(Color(.systemBackground))
            }
            .padding(.init(top: 10, leading: 14, bottom: 10, trailing: 14))
            .background(Color(.label))
            .cornerRadius(5)
        }.font(.system(size: 22, weight: .semibold))
    }
    
    private var deleteAllButton: some View {
        Button(action: {
            cards.forEach { card in
                viewContext.delete(card)
            }
            do {
                try viewContext.save()
            } catch {
                
            }
            
        }, label: {
            Text("Delete All")
        })
    }
    
    var addItemButton: some View {
        Button(action: {
            withAnimation {
                let viewContext = PersistenceController.shared.container.viewContext
                let cardItem = Card(context: viewContext)
                cardItem.timestamp = Date()

                do {
                    try viewContext.save()
                } catch {
//                    let nsError = error as NSError
//                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }

        }, label: {
            Text("Add item")
        })
    }
    
    var addCardButton: some View {
        Button(action: {
            shouldPresentAddCardForm.toggle()
        }, label: {
            Text("+ Card")
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .bold))
                .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
                .background(Color.black)
                .cornerRadius(5)
        })
    }
}

struct CreditCardView: View {
    @Environment(\.managedObjectContext) private var viewContext
    var fetchRequest: FetchRequest<CardTransaction>

    let card: Card
    
    init(card: Card) {
        self.card = card
        
        fetchRequest = FetchRequest<CardTransaction>(entity: CardTransaction.entity(), sortDescriptors: [.init(key: "timestamp", ascending: false)],
                                                     predicate: .init(format: "card == %@", self.card))
        
        
        
    }
    
    @State private var shouldShowActionSheet = false
    @State private var shouldShowEditForm = false
    
    // hack
    @State var refreshId = UUID()
    
    private func handleDelete() {
        let viewContext = PersistenceController.shared.container.viewContext
        
        viewContext.delete(card)
        
        do {
            try viewContext.save()
        } catch {
            // eror handling
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text(card.name ?? "")
                    .font(.system(size: 24, weight: .semibold))
                Spacer()
                Button {
                    shouldShowActionSheet.toggle()
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 28, weight: .bold))
                }
                .actionSheet(isPresented: $shouldShowActionSheet) {
                    .init(title: Text(self.card.name ?? ""), message: Text("Options"), buttons: [
                        .default(Text("Edit"), action: {
                            shouldShowEditForm.toggle()
                        }),
                        .destructive(Text("Delete Card"), action: handleDelete),
                        .cancel()
                    ])
                }
            }
            
            HStack {
                Image(card.cardType ?? "")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 44)
                Spacer()
                
                if let balance = fetchRequest.wrappedValue.reduce(0, {$0 + $1.amount} ) {
                    Text("Balance: $\(String(format: "%.2f", balance))")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
            
            Text(card.number ?? "")
            
            HStack {
                Text("Credit Limit: $\(card.limit)")
                Spacer()
                VStack(alignment: .trailing) {
                    Text("Valid Thru")
                    Text("\(String(format: "%02d", card.expMonth))/\(String(card.expYear % 2000))")
                }
            }
            
            HStack { Spacer() }
        }
        .foregroundColor(.white)
        .padding()
        .background(
            
            VStack {
                if let colorData = card.color,
                    let uiColor = UIColor.color(data: colorData),
                   let actualColor = Color(uiColor) {
                    LinearGradient(colors: [actualColor.opacity(0.6), actualColor],
                                   startPoint: .center, endPoint: .bottom)
                } else {
                    LinearGradient(colors: [Color.cyan.opacity(0.6), Color.cyan],
                                   startPoint: .center, endPoint: .bottom)
                }
            }
        )
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black.opacity(0.5), lineWidth: 2)
        )
        .cornerRadius(8)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.top, 8)
        
        .fullScreenCover(isPresented: $shouldShowEditForm) {
            AddCardForm(card: card)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.shared.container.viewContext
        MainView()
            .environment(\.managedObjectContext, viewContext)
    }
}
