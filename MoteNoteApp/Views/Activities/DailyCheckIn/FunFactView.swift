//
//  FunFactView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/12/23.
//

import SwiftUI

struct FunFactView: View {
    @ObservedObject var funFactFetcher = FunFactFetcher()


    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(LinearGradient(gradient: Gradient(colors: [.yellow, .green, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 350, height: 200)
                .shadow(radius: 10)
                .layoutPriority(1)
            VStack(alignment: .leading) {
                
                HStack {
                    Text("Fact of the Day:")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }


                if funFactFetcher.fact != nil {
                        Text(funFactFetcher.fact!)
                            .font(.body)
                            .padding([.top, .leading, .trailing], -2.0)
                            .foregroundColor(.white)
                            .lineLimit(5)


                } else {
                    Text("Loading...")
                        .font(.body)
                        .padding()
                }
                Spacer()
            }
            .padding()
            .onAppear(perform: funFactFetcher.fetchFact)
        }

    }
}

struct FunFactView_Previews: PreviewProvider {
    static var previews: some View {
        FunFactView()
    }
}
