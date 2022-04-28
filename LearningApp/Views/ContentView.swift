//
//  ContentView.swift
//  LearningApp
//
//  Created by Steve Kite on 4/24/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                //Confirm that current module is set
                if model.currentModule != nil {
                    ForEach(0..<model.currentModule!.content.lessons.count) { index in
                        NavigationLink(destination: {
                            ContentDetailView()
                                .onAppear(perform: {
                                    model.beginLesson(index)
                                })
                        }, label: {
                            ContentViewRow(index: index)
                        })
                       
                    
                    }
                }
                
            }
            .accentColor(.black)
            .padding()
            .navigationTitle("Learn \(model.currentModule?.category ?? "")")
        }
    }
}

