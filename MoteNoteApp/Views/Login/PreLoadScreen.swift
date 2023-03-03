//
//  PreLoadScreen.swift
//  MoteNoteApp
//
//  Created by Bernie Graves on 2/14/23.
//

import SwiftUI

struct PreLoadScreen: View {
    var body: some View {
        LogoView()
            .scaleEffect(2.1)
    }
}

struct PreLoadScreen_Previews: PreviewProvider {
    static var previews: some View {
        PreLoadScreen()
    }
}
