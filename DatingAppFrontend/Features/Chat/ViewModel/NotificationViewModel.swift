//
//  NotificationViewModel.swift
//  DatingAppFrontend
//
//  Created by Mukul Bhatt on 16/02/26.
//

import Foundation
import Combine

class NotificationViewModel: ObservableObject{
    // Redirect to NotificationsManager which is the centralized source of truth
    func fetchNotifications(manager: NotificationsManager) async {
        await manager.fetchHistoricalNotifications()
    }
    
    
}

