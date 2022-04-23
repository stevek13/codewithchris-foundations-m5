//
//  HomeView.swift
//  LearningApp
//
//  Created by Steve Kite on 4/22/22.
//

import SwiftUI

struct HomeView: View {

    @EnvironmentObject var model: ContentModel

    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
