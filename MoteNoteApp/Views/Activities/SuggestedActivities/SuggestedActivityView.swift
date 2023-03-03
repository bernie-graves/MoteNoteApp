//
//  SuggestedActivityView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/29/23.
//

import SwiftUI

struct SuggestedActivityView: View {
    
    var rating: Double
    
    var body: some View {
        
        VStack {
            if (rating < 2.5){
                NegativeActivites(neg: true)
            }
            if (rating >= 2.5) {
                NegativeActivites(neg: false)
            }
        }
    }
}

struct PositiveActivites: View {
    
    var body: some View {
        ZStack() {
            
            Rectangle()
                .fill(.blue)
                .frame(width: 350, height: 350)
                .cornerRadius(10)
                .layoutPriority(1)
            VStack(alignment: .leading) {
                Text("Suggested Activities")
                    .padding()
                    .font(.title3)
                
                ScrollView {
                    ForEach(ActivitiesModel().positiveSuggestedActivites) { a in
                        SuggestedActivityTabView(activity: a)
                        
                    }
                }
                Spacer()
            }
            
        }

    }
}

struct NegativeActivites: View {
    var neg: Bool
    
    var body: some View {
        
        ZStack {
                
            if neg {
                Rectangle()
                    .fill(.green)
                    .frame(width: 350, height: 250)
                    .cornerRadius(10)
                    .layoutPriority(1)
                    .shadow(radius: 10)
            }else {
                Rectangle()
                    .fill(.blue)
                    .frame(width: 350, height: 250)
                    .cornerRadius(10)
                    .layoutPriority(1)
                    .shadow(radius: 10)
            }

        
            VStack(spacing: 0) {
                
                // suggested activity title
                HStack {
                    Text("Suggested Activities")
                        .padding()
                        .font(.title3)
                    Spacer()
                }

                // suggested activities
                if neg {
                    ForEach(ActivitiesModel().negativeSuggestedActivites) { a in
                        SuggestedActivityTabView(activity: a)
                            .padding(5)
                        
                        }
                } else {
                    ForEach(ActivitiesModel().positiveSuggestedActivites) { a in
                        SuggestedActivityTabView(activity: a)
                            .padding(5)
                        
                        }
                }

                }

                Spacer()
            }
                
        }
    }


struct SuggestedActivityTabView: View {
    
    var activity: Activity
    
    
    var body: some View{
        
        NavigationLink{
            activity.activityView
        }
        label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(.thinMaterial)
                    .frame(width: 325, height: 40)
                Text(activity.activityName)
                    .font(.title3)
            
            
            }
        }
    }
}

struct SuggestedActivityView_Previews: PreviewProvider {
    static var previews: some View {
        SuggestedActivityView(rating: 3)
    }
}
