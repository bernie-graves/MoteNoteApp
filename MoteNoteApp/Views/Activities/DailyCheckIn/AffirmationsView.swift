//
//  AffirmationsView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/12/23.
//

import SwiftUI

struct AffirmationsView: View {
    @ObservedObject var affirmationFetcher = AffirmationFetcher()

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [.green, .blue, .purple, .red]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 350, height: 200)
                .shadow(radius: 10)
                .layoutPriority(1)
            VStack(alignment: .leading) {
                
                HStack {
                    Spacer()
                    Text("Affirmations of the Day:")
                        .font(.title2)
                        .bold()
                        .padding(0.0)
                        .foregroundColor(.white)
                    
                    Spacer()
                }


                if affirmationFetcher.affirmation1 != nil && affirmationFetcher.affirmation2 != nil && affirmationFetcher.affirmation3 != nil {
                    ScrollView {
                        VStack (alignment: .leading) {
                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                    .scaleEffect(0.4)
                                Text("\(affirmationFetcher.affirmation1!)")
                                    .font(.body)
                                    .lineLimit(5)
                                    .foregroundColor(.white)
                                    .padding(.bottom, -3.0)
                            }
  
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                    .scaleEffect(0.4)
                                Text("\(affirmationFetcher.affirmation2!)")
                                    .font(.body)
                                    .lineLimit(5)
                                    .foregroundColor(.white)
                                    .padding(.bottom, -3.0)
                            }

                            
                            HStack {
                                Image(systemName: "circle.fill")
                                    .foregroundColor(.white)
                                    .scaleEffect(0.4)
                                Text("\(affirmationFetcher.affirmation3!)")
                                    .font(.body)
                                    .lineLimit(5)
                                    .foregroundColor(.white)
                            }
                        }


                    }

                } else {
                    Text("Loading...")
                        .font(.body)
                        .padding()
                }
                Spacer()
            }
            .padding()
            .onAppear{
                affirmationFetcher.fetchAffirmation(num: 1)
                affirmationFetcher.fetchAffirmation(num: 2)
                affirmationFetcher.fetchAffirmation(num: 3)
            }
        }

    }
}


struct AffirmationsView_Previews: PreviewProvider {
    static var previews: some View {
        AffirmationsView()
    }
}
