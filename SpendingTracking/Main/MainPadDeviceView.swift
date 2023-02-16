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
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(cards) { card in
                            CreditCardView(card: card)
                                .frame(width: 350)
                        }
                    }
                }
                
                TransactionGriedView()
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
    
    var body: some View {
        VStack {
            HStack {
                Text("Transactions")
                Spacer()
                Button {
                    
                } label: {
                    Text("+ Transaction")
                }
            }
            
            let colums: [GridItem] = [
                .init(.fixed(100), spacing: 16, alignment: .leading),
                .init(.fixed(200), spacing: 16, alignment: .leading),
                .init(.flexible(minimum: 300, maximum: 800), spacing: 16),
                .init(.flexible(minimum: 100, maximum: 450), spacing: 16, alignment: .trailing),
            ]
            
            LazyVGrid(columns: colums) {
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
        }
        .font(.system(size: 24, weight: .semibold))
        .padding()
    }
    
}

struct MainPadDeviceView_Previews: PreviewProvider {
    static var previews: some View {
        MainPadDeviceView()
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.portrait)
            .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
    }
}
