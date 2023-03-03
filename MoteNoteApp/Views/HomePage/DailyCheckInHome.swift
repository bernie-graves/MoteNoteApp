//
//  DailyCheckInHome.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/25/23.
//

import SwiftUI

struct DailyCheckInHome: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    

    
    var body: some View {
        
        let currentStreak = DailyCheckInModel().getCheckInStreak(allCheckIns: profileViewModel.allDailyCheckIns)
        
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .fill(.green)
                .frame(width: 350, height: 150)
                .layoutPriority(1)
                .bold()
            
            VStack() {
                
                HStack {
                    Text("Daily Check-in")
                        .padding([.top, .leading], 20)
                        .font(.headline)
                    Spacer()
                }
                Divider()
                HStack {
                    
                    if (currentStreak > 0) {
                        Text("\(currentStreak) day streak! 🔥 ")
                            .padding()
                    } else {
                        Text("Check-In to start your streak! 👍")
                            .padding()
                    }
                    
                    
                    
                    Spacer()
                    
                    NavigationLink {
                        DailyCheckIn()
                            .environmentObject(profileViewModel)
                    } label: {
                        Text("Check-In")
                            .frame(width: 150, height: 50)
                            .background(.thickMaterial)
                            .foregroundColor(.mint)
                            .cornerRadius(10)
                            .padding()
                        }
                
                }
                Spacer()
            }
            
            
        }
    }
}

struct DailyCheckInHome_Previews: PreviewProvider {
    static var previews: some View {
        DailyCheckInHome()
            .environmentObject(ProfileViewModel())
    }
}
