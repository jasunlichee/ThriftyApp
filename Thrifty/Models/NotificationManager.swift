//
//  NotificationManager.swift
//  Thrifty
//
//  Created by Jason Li on 11/11/24.
//

import Foundation
import UserNotifications
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn
import UIKit

class NotificationsManager: ObservableObject {
    static let shared = NotificationsManager()

    private init() {} 
    
    func requestPermission() {
        let hasRequestedPermission = UserDefaults.standard.bool(forKey: "hasRequestedNotificationPermission")
        if !hasRequestedPermission {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                if let error = error {
                    print("Error requesting notifications permission: \(error)")
                } else {
                    print("Notification permission granted: \(granted)")
                }
            }
        }
    }
    
    func removeAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UserDefaults.standard.set(false, forKey: "notificationsEnabled")
    }
    
    
    func scheduleMonthlyNotification(billingDate: Date) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        
        let content = UNMutableNotificationContent()
        content.title = "Thrifty"
        content.body = "Reminder to pay your credit card bill!"
        content.sound = .default

        let daysBeforeDue = [5, 4, 3, 2, 1]
        
        var monthAdd: Int = 0
        
        if(billingDate < Date()){
            monthAdd = 1
        }
        
        if let adjustedBillingDate = Calendar.current.date(byAdding: .month, value: monthAdd, to: billingDate) {
            for day in daysBeforeDue {
                if let notificationDate = Calendar.current.date(byAdding: .day, value: -day, to: adjustedBillingDate) {
                    var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: notificationDate)
                    dateComponents.hour = 10
                    
                    print(notificationDate)

                    let identifier = "monthlyCreditCardBillReminder-\(day)DaysBefore"
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                    
                    UNUserNotificationCenter.current().add(request) { error in
                        if let error = error {
                            print("Error scheduling notification for \(day) days before: \(error)")
                        }
                    }
                }
            }
        }
    }
    
    func triggerTestNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Thrifty Reminder"
        content.body = "Don't forget to pay your credit card bill"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "testNotification", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling test notification: \(error)")
            } else {
                print("Test notification scheduled to trigger in 5 seconds.")
            }
        }
    }

    
    
    func openNotificationSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
    }

    
    
}
