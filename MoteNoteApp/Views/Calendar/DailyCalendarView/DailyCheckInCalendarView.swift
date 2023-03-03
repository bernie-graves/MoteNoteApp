//
//  DailyCheckInCalendarView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/8/23.
//

import SwiftUI

struct DailyCheckInCalendarView: View {
    
    @State private var showCheckInDetail = false
    @State private var currentCheckIn = 0
    @State private var offset = CGSize.zero
    var datesCheckIns : [DailyCheckInTemplate]
    
    var body: some View {
        
        
        ZStack {
            
            Rectangle()
                .fill(.thickMaterial)
                .frame(width: 375, height: showCheckInDetail ? 325 : 125)
                .layoutPriority(1)
            
            VStack {
                HStack {
                    Text("Daily Check-in")
                        .font(.headline)
                        .padding([.leading, .bottom, .trailing])
                        
                    Spacer()
                    
                    // button to see check in details
                    // only show if there is a check in for that day
                    
                    // Commented out button
                    // Uncomment it to add drop down button to see more detials about the check in
                    // Removed it bc Jen didn't think it was necessary to have "why" section
                    // of the daily check ins
                    
                    
//                    if datesCheckIns.count > 0 {
//                        Button {
//                            withAnimation(.easeInOut) {
//                                showCheckInDetail.toggle()
//                            }
//                        } label: {
//                            Label("Graph", systemImage: "chevron.down.circle")
//                                .labelStyle(.iconOnly)
//                                .imageScale(.large)
//                                .scaleEffect(showCheckInDetail ? 1.5 : 1)
//                                .padding([.bottom, .trailing])
//                        }
//                    }
                }
                if datesCheckIns.count > 0 {
                    LockedStarView(rating: datesCheckIns[currentCheckIn].rating)
                        .padding(.bottom, 4.0)
                        .scaleEffect(2.5)
                        
                } else {
                    VStack{
                        Text("No Daily Check Ins")
                            .font(.title3)
                            .foregroundColor(.orange)
                            .bold()
                    }
                }
                
                if showCheckInDetail {
                    VStack(alignment: .center) {
                        HStack {
                            Text("Why:")
                                .padding([.top, .leading])
                                .font(.subheadline)
                                .bold()
                            Spacer()
                            Text("Taken at")
                                .padding([.top, .leading])
                            Text(datesCheckIns[currentCheckIn].date, style: .time)
                                .padding([.top, .trailing])
                        }
                        Text(datesCheckIns[currentCheckIn].why)
                            .frame(width: 300.0, height: 75, alignment: .topLeading)
                            .padding(.all)
                            .background(Color("LightBlue"))
                            .multilineTextAlignment(.leading)
                            .cornerRadius(10)

                        
                        HStack{
                            Button {
                                withAnimation {
                                    currentCheckIn -= 1
                                }
                            } label: {
                                Label("Graph", systemImage: "chevron.left")
                                    .labelStyle(.iconOnly)
                                    .imageScale(.large)
                                    .scaleEffect(0.75)
                                    .padding(.leading)
                            }
                            .disabled(currentCheckIn == 0)
                            
                            Spacer()
                            
                            Text("Number of Check-Ins: \(datesCheckIns.count)")
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    currentCheckIn += 1
                                }
                            } label: {
                                Label("Graph", systemImage: "chevron.right")
                                    .labelStyle(.iconOnly)
                                    .imageScale(.large)
                                    .scaleEffect(0.75)
                                    .padding(.trailing)
                            }
                            .disabled(currentCheckIn == datesCheckIns.count-1)
                            
                        }
                        
                    }
                }
            
            }
            
        }
        
    }
}

struct DailyCheckInCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        DailyCheckInCalendarView(datesCheckIns: [
            DailyCheckInTemplate(rating: 3, why: "Felt Good because I got everything to work as expected.", date: Date()),
            DailyCheckInTemplate(rating: 4, why: "Felt Amazing because everything went my way. I got an A on my math test, I won my basketball game and got to play video games.", date: Date()),
            DailyCheckInTemplate(rating: 2, why: "Felt Bad", date: Date()),
            
        ])
    }
}
