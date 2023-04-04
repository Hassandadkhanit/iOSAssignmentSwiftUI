//
//  iOSAssignmentSwiftUIApp.swift
//  iOSAssignmentSwiftUI
//
//  Created by Hassan dad khan on 03/04/2023.
//

import SwiftUI


@main
struct iOSAssignmentSwiftUIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
//            NavigationView {
                LessonsListView()
//            }
        }
    }
}
