//
//  LockedStarView.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/8/23.
//

import SwiftUI

struct LockedStarView: View {
    
    let ratingsArray: [Double]
    let color: Color
    let rating: Double
    
    init(rating: Double, maxRating: Int = 5, starColor: Color = .yellow) {
        self.rating = rating
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
        }
    }
}

struct LockedStarView_Previews: PreviewProvider {
    static var previews: some View {
        LockedStarView(rating: 3)
            .scaleEffect(2.5)
    }
}
