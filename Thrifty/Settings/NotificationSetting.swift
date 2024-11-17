//
//  NotificationSetting.swift
//  Thrifty
//
//  Created by Jason Li on 11/14/24.
//

import SwiftUI

struct NotificationSetting: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var firestoreManager: FirebaseService
    
    var body: some View {
        
        
        VStack {
            Text("Billing Cycle Notifications")
                .font(.title)
                .padding()
            Divider()
                .frame(width: 300)
        
            
            Image("SettingsHelper")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding()
            

            Button(action: {
                NotificationsManager.shared.openNotificationSettings()
            }) {
                NotificationsCard()
                    .foregroundColor(.black)
                    .frame(maxWidth: 225)
                
            }.padding()
            
            
//            Button(action: {
//                //NotificationsManager.shared.scheduleMonthlyNotification(billingDate: firestoreManager.currentUser.billingCycle)
//                
//                NotificationsManager.shared.triggerTestNotification()
//            }) {
//                Label("Test", systemImage: "rectangle")
//            }
//            .padding()
        }
    }
}

struct NotificationSetting_Previews: PreviewProvider {
    
    static var previews: some View {
        let firePreview = FirebaseService()
        NotificationSetting().environmentObject(firePreview)
    }
}
