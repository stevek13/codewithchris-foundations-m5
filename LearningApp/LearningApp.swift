//
//  LearningAppA.swift
//  LearningApp
//
//  Created by Steve Kite on 4/22/22.
//

import SwiftUI

@main
struct LearningApp: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(ContentModel())
        }
    }
}
