//
//  StarRatings.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 1/29/23.
//

import SwiftUI

struct StarRatings: View {
    let ratingsArray: [Double]
    let color: Color
    @Binding var rating: Double
    @Binding var starsLocked: Bool
    
    init(rating: Binding<Double>, maxRating: Int = 5, starColor: Color = .yellow, starsLocked: Binding<Bool>) {
        _rating = rating
        _starsLocked = starsLocked
        ratingsArray = Array(stride(from: 0.0, through: Double(max(1, maxRating)), by: 0.5))
        color = starColor
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(ratingsArray, id: \.self) { ratingElement in
                    if ratingElement > 0 {
                        if Int(exactly: ratingElement) != nil && ratingElement <= rating {
                            Image(systemName: "star.fill")
                                .foregroundColor(color)
                        } else if Int(exactly: ratingElement) == nil && ratingElement == rating {
                            Image(systemName: "star.leadinghalf.fill")
                                .foregroundColor(color)
                        } else if Int(exactly: ratingElement) != nil && rating + 0.5 != ratingElement {
                            Image(systemName: "star")
                                .foregroundColor(color)
                        }
                    }
                }
            }
            .overlay(
                Slider(value: $rating, in: 0.0...ratingsArray.last!, step: 0.5)
                    .tint(.clear)
                    .opacity(0.1)
                    .disabled(starsLocked)
            )
        }
        .onAppear {
            rating = Int(exactly: rating) != nil ? rating : Double(Int(rating)) + 0.5
        }
    }
}

