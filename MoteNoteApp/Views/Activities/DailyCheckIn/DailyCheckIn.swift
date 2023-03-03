//
//  DailyCheckIn.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/26/23.
//

import SwiftUI

struct DailyCheckIn: View {
    
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State private var currentRating: Double = Double()
    @State private var whyText: String = String()
    @State private var showSuggested: Bool = false
    
    var body: some View {
        VStack {
            Text("How are you feeling today?")
                .font(.title2)
            StarRatings(rating: $currentRating, starsLocked: $showSuggested)
                .scaleEffect(2.5)
                .padding()
            ScrollView {
                
                
                //            TextField(
                //                "Why?",
                //                text: $whyText,
                //                axis: .vertical
                //            )
                //            .textFieldStyle(.roundedBorder)
                //            .lineLimit(5, reservesSpace: true)
                //            .padding()
                if (showSuggested) {
                    SuggestedActivityView(rating: currentRating)
                }
                
                FunFactView()
                    .padding()
                
                AffirmationsView()
                
                Spacer()
            
                
                

            }
            if !showSuggested {
                Button(action: {
                    withAnimation {
                        self.showSuggested.toggle()
                    }
                    showSuggested = true
                    
                    let tempCheckIn = DailyCheckInTemplate(rating: currentRating,
                                                           why: whyText,
                                                           date: Date())
                    
                    DailyCheckInModel().submitCheckIn(submission: tempCheckIn)
                    profileViewModel.allDailyCheckIns.append(tempCheckIn)
                    
                }) {
                    Text("Submit")
                        .frame(width: 200, height: 60)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
            }
            
            

        }

    }
}

struct DailyCheckIn_Previews: PreviewProvider {
    static var previews: some View {
        DailyCheckIn()
            .environmentObject(ProfileViewModel())
    }
}
