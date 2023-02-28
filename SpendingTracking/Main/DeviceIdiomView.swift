//
//  DeviceIdiomView.swift
//  SpendingTracking
//
//  Created by Ivica Petrsoric on 16.02.2023..
//

import SwiftUI

struct DeviceIdiomView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            MainView()
        } else {
            if horizontalSizeClass == .compact {
                MainView()
            } else {
                MainPadDeviceView()
            }
        }
    }
}

struct DeviceIdiomView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceIdiomView()
            .environment(\.horizontalSizeClass, .compact)
        
        DeviceIdiomView()
            .environment(\.horizontalSizeClass, .regular)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
