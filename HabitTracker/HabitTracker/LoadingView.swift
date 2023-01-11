//
//  LoadingView.swift
//  HabitTracker
//
//  Created by Kieran on 02/07/2022.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            Spacer()
            Image(systemName: "pencil")
                .resizable().frame(width: 50, height: 50).foregroundColor(Color(.systemPink))
            Text("Goal Tracker!").foregroundColor(Color(.systemPink))
            Spacer()
        }
    }
}


struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
