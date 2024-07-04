//
//  NotificationView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-17.
//

import SwiftUI

import SwiftUI

struct NotificationView: View {
    @StateObject var viewModel = NotificationsViewModel()
    @EnvironmentObject var homeVM: HomeViewModel
    
    @State var last30daysExist = false
    @State var last7daysExist = false
    @State var newExists = false
    @State var todayExists = false
    
    var body: some View {
        let now = Date()
        let startOfToday = Calendar.current.startOfDay(for: now)
        let last7daysDate = Calendar.current.date(byAdding: .day, value: -7, to: now) ?? now
        let last30daysDate = Calendar.current.date(byAdding: .day, value: -30, to: now) ?? now
        
        VStack {
            LazyVStack(alignment: .leading) {
                if newExists {
                    Text("New")
                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                        .fontWeight(.semibold)
                }
                
                ForEach(viewModel.notifications.filter { $0.read == false }) { notification in
                    NotificationCell(notification: notification)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(.colorWhite)
                                .shadow(radius: 2).opacity(0.2)
                        )
                        .onAppear {
                            newExists = true
                        }
                        .onFirstAppear {
                            if notification == viewModel.notifications.last{
                                Task{
                                    try await viewModel.fetchNotifications()
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(alignment: .leading) {
                if todayExists {
                    Text("Today")
                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                        .fontWeight(.semibold)
                }
                
                ForEach(viewModel.notifications.filter {
                    $0.read == true && $0.timestamp.dateValue() >= startOfToday
                }) { notification in
                    NotificationCell(notification: notification)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.colorWhite))
                                .shadow(radius: 2).opacity(0.2)
                        )
                        .onAppear {
                            todayExists = true
                        }
                        .onFirstAppear {
                            if notification == viewModel.notifications.last{
                                Task{
                                    try await viewModel.fetchNotifications()
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(alignment: .leading) {
                if last7daysExist {
                    Text("Last 7 days")
                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                        .fontWeight(.semibold)
                }
                
                ForEach(viewModel.notifications.filter {
                    $0.read == true && $0.timestamp.dateValue() >= last7daysDate && $0.timestamp.dateValue() < startOfToday
                }) { notification in
                    NotificationCell(notification: notification)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.colorWhite))
                                .shadow(radius: 2).opacity(0.2)
                        )
                        .onAppear {
                            last7daysExist = true
                        }
                        .onFirstAppear {
                            if notification == viewModel.notifications.last{
                                Task{
                                    print("NEW FETCH")
                                    try await viewModel.fetchNotifications()
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            LazyVStack(alignment: .leading) {
                if last30daysExist {
                    Text("Last 30 days")
                        .font(.custom("HankenGrotesk-Regular", size: .P1))
                        .fontWeight(.semibold)
                }
                
                ForEach(viewModel.notifications.filter {
                    let dateValue = $0.timestamp.dateValue()
                    return $0.read == true && dateValue >= last30daysDate && dateValue < last7daysDate
                }) { notification in
                    NotificationCell(notification: notification)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color(.colorWhite))
                                .shadow(radius: 2).opacity(0.2)
                        )
                        .onAppear {
                            last30daysExist = true
                        }
                        .onFirstAppear {
                            if notification == viewModel.notifications.last{
                                Task{
                                    try await viewModel.fetchNotifications()
                                }
                            }
                        }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            
            if viewModel.fetchingNotifications {
                Loading()
            }
        }.padding(.horizontal, 16)
        .onFirstAppear {
            Task {
                homeVM.userHasNotification = false
                try await viewModel.fetchNotifications()
            }
        }
    }
}

#Preview {
    NotificationView()
}


#Preview {
    NotificationView()
}
