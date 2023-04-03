//
//  LessonsListView.swift
//  iOS Assignment
//
//  Created by Hassan dad khan on 31/03/2023.
//

import SwiftUI
import SDWebImageSwiftUI

struct LessonsListView: View {
    
    @ObservedObject var viewModel = LessonsListViewModel()
    @State var isNavigationAllowed = false
    var body: some View {
        ZStack {
//            Color.customBackgroundColor
//                .ignoresSafeArea()
            VStack {
                Rectangle()
                    .frame(height: 0.5)
                    .foregroundColor(.black)
                    .padding(.bottom,16)
                List {
                    ForEach(Array((viewModel.lessons?.lessons ?? []).enumerated()), id: \.offset) { offset,lesson in
                        LessonCellView(lesson: lesson)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isNavigationAllowed = true
                            }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .listRowInsets(EdgeInsets())
                .listRowSeparator(.hidden)
                .navigationTitle("Lessons")
                .navigationBarTitleTextColor(Color.customTextColor)
                .navigationBarTitleDisplayMode(.automatic)
                .listStyle(PlainListStyle())
                .background(Color.customBackgroundColor)
                
                NavigationLink(destination: LessonDetailControllerView(), isActive: $isNavigationAllowed) {
                    EmptyView()
                }
            }
            .background(Color.customBackgroundColor)

        }
        
    }

    
    init(viewModel: LessonsListViewModel = LessonsListViewModel()) {
        self.viewModel = viewModel
        NetworkMonitor.shared.startMonitoring()
        self.viewModel.getLessonsList()
        
    }
}

struct LessonsListView_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView()
        LessonsListView().preferredColorScheme(.dark)
    }
}


