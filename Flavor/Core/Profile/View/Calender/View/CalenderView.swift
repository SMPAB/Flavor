//
//  CalenderView.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-06-11.
//

import SwiftUI

struct CalendarView: View {
    
    //let user: USER
    
    @Environment(\.dismiss) var dismiss
    
    @State var currentDate: Date = Date()
    @State var currentMonth: Int = 0
    
    @State var hasSelectedDate = false
    
    @EnvironmentObject var homeVM: HomeViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    private var user: User{
        return profileViewModel.user
    }
    
    
    
    var body: some View {
        
       
            ScrollView(.vertical, showsIndicators: false){
                    VStack(spacing: 20){
            

                        
                //TOP OF VIEW
                        
                        let days: [String] =
                        ["Sön", "Mån", "Tis", "Ons", "Tor", "Fre", "Lör"]
                        
                        
                        
                        HStack{
                            Button(action: {
                                if !hasSelectedDate{
                                    currentMonth -= 1
                                } else {
                                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: currentDate) ?? currentDate
                                }
                                
                            }){
                                Image(systemName: "chevron.left")
                                    .foregroundStyle(.black)
                            }
                            
                            Spacer()
                            
                            Text("\(majorityMonthInWeek())")
                                .font(.custom("HankenGrotesk-Regular", size: 18))
                                .fontWeight(.semibold)
                                .onTapGesture {
                                    hasSelectedDate = false
                                }
                            
                            Spacer()
                            
                            Button(action: {
                                if !hasSelectedDate{
                                    currentMonth += 1
                                } else {
                                    currentDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: currentDate) ?? currentDate
                                }
                                
                            }){
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.black)
                            }
                        }.padding(.horizontal, 35)
                        
                        //Divider()
            
                        
                            //SÖN-SÖN
                            VStack(spacing: 2){
                                HStack(spacing: 0){
                                    ForEach(days, id: \.self){ day in
                                        Text(day)
                                            .font(.custom("HankenGrotesk-Regular", size: 18))
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity)
                                            .foregroundStyle(Color(.systemGray))
                                    }
                                }.padding(.horizontal, 25)
                                
                                
                //ALL DATES
                                
                                let colums = Array(repeating: GridItem(.flexible()), count: 7)
                                
                                LazyVGrid(columns: colums, spacing: -10){
                                    ForEach(extractDate()){ value in
                                        CardView(value: value)
                                            .background(
                                            
                                                
                                            ).onTapGesture {
                                                
                                                    currentDate = value.date
                                                    hasSelectedDate = true
                                                   
                                                
                                                
                                            }
                                    }
                                }.padding(.horizontal, 30)
                            }
                                            
                        
        
                        
                        if hasSelectedDate{
                            Rectangle()
                                .fill(.black)
                                .frame(height: 1)
                                .padding(.horizontal, 16)
                                
                            
                            ForEach(Array(profileViewModel.calenderStorys.filter{ isSameDay(date1: $0.timestamp.dateValue(), date2: currentDate) }.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()}).enumerated()), id: \.element.id) { index, story in
                                
                               
                                StoryCell(story: story, oddStory: index % 2 != 0)
                                    .environmentObject(homeVM)
                                    .padding(.horizontal, 16)
                                   
                            }
                        }
                        

                        
                        //MARK: STORYS
                        //CustomDatePicker(user: user, currentDate: $currentDate)
                        
                       // CustomDateGrid(user: user, currentDate: $currentDate)
                    }
            }.navigationBarBackButtonHidden(true)
            .onChange(of: currentDate){
                //print("DEBUG APP currentDAte: \(currentDate)")
                Task{
                    try await profileViewModel.fetchStorysForDate(date: currentDate)
                }
            }
        
        
    }
    
    @ViewBuilder
    func CardView(value: DateValue) -> some View {
        if value.day != -1 {
            VStack {
                Text("\(value.day)")
                    .font(.custom("HankenGrotesk-Regular", size: 18))
                    .frame(width: 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .foregroundStyle(isInStoryUploadDays(date: value.date) ? Color.colorWhite : Color.black)
                    .fontWeight(.semibold)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            //.fill(isSameDay(date1: value.date, date2: currentDate) ? Color.colorOrange : Color.colorOrange)
                            .fill(isInStoryUploadDays(date: value.date) ? Color.colorOrange : Color.white)
                            .stroke(isInStoryUploadDays(date: value.date) ? Color.colorOrange : Color(.systemGray))
                            .opacity(isSameDay(date1: value.date, date2: currentDate) ? 1 : 0.7) // Adjust opacity based on the date
                            
                    )
            }.padding(.vertical, 4)
                .onAppear{
                    print("DEBUG APP DATEVALUE: \(value)")
                }
        }
    }
    
    func isInStoryUploadDays(date: Date) -> Bool {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMMdd"
            let dateString = dateFormatter.string(from: date)
            return profileViewModel.userStoryDats.contains(dateString)
        }

    
//FUNCTIONS
    func isSameDay(date1: Date,date2: Date)->Bool{
        let calendar = Calendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    func getCurrentMonth()->Date{
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extraDate()->[String]{
        
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let date = formatter.string(from: getCurrentMonth())
        
        return date.components(separatedBy: " ")
    }
    
    
    func extractDate()->[DateValue]{
        
        if !hasSelectedDate{
            let calendar = Calendar.current
            
            let currentMonth = getCurrentMonth()
            
            var days = currentMonth.getAllDates().compactMap{ date -> DateValue in
                
                let day = calendar.component(.day, from: date)
                
                return DateValue(day: day, date: date)
                
            }
            
            let firstWeekday = calendar.component(.weekday, from: days.first?.date ?? Date())
            
            for _ in 0..<firstWeekday - 1{
                days.insert(DateValue(day: -1, date: Date()), at: 0)
            }
            
            return days
        } else {
            let calendar = Calendar.current

                // Get the start of the week for the currentDate
                guard let weekStartDate = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate)) else {
                    return []
                }

                // Generate an array of DateValue for the week
                return (0..<7).compactMap { offset in
                    guard let weekDate = calendar.date(byAdding: .day, value: offset, to: weekStartDate) else {
                        return nil
                    }
                    let day = calendar.component(.day, from: weekDate)
                    return DateValue(day: day, date: weekDate)
                }
        }
        
    }
    
    func majorityMonthInWeek() -> String {
        let datesInWeek = extractDate().map { $0.date }
        let calendar = Calendar.current
        var monthTally: [Int: Int] = [:] // Dictionary to tally the occurrences of each month along with year

        datesInWeek.forEach { date in
            let month = calendar.component(.month, from: date)
            monthTally[month, default: 0] += 1
        }

        // Determine the month that appears most frequently
        if let majorityMonth = monthTally.max(by: { $0.value < $1.value })?.key,
           let majorityMonthDate = datesInWeek.first(where: { calendar.component(.month, from: $0) == majorityMonth }) {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM YYYY" // Format including month and year
            return formatter.string(from: majorityMonthDate)
        } else {
            // Fallback to the current month and year if unable to determine
            let formatter = DateFormatter()
            formatter.dateFormat = "MMMM YYYY"
            return formatter.string(from: Date())
        }
    }

}


extension Date{
    func getAllDates()->[Date]{
        let calender = Calendar.current
        
        let startDate = calender.date(from:
        Calendar.current.dateComponents([.year,.month], from: self))!
        
        let range = calender.range(of: .day, in: .month, for: self)!
        
        return range.compactMap { day -> Date in
            return calender.date(byAdding: .day, value: day - 1, to: startDate)!
        }
    }
}

struct DateValue: Identifiable{
    var id = UUID().uuidString
    var day: Int
    var date: Date
}


#Preview {
    CalendarView()
        .environmentObject(ProfileViewModel(user: User.mockUsers[0]))
}
