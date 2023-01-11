//
//  ContentView.swift
//  HabitTracker
//
//  Created by Kieran on 12/06/2022.
//

import SwiftUI
import Foundation

extension Date {
    static func - (lhs: Date, rhs: Date) -> TimeInterval {
        return lhs.timeIntervalSinceReferenceDate - rhs.timeIntervalSinceReferenceDate
    }
}



struct ContentView: View {
    
    @State private var isLoading = false;
    
    var body: some View {
        ZStack {
            if isLoading {
                LoadingView();
            } else {
                HomeView();
            }
        }.onAppear { Loading() }
    }
    
    func Loading() {
        isLoading = true;
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false;
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        }
    }

