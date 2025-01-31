//
//  FixtureView.swift
//  SimpleSnapshotTesting
//
//  Created by Andreas Guenther on 30.01.25.
//

import SwiftUI

struct FixtureView: View {
    @State var isChanged = false

    var body: some View {
        VStack {
            // Toggle button to switch between initial and changed states
            Button(action: {
                isChanged.toggle()
            }) {
                Text("Toggle State")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }

            // Show the initial or changed view based on the toggle state
            if isChanged {
                // Changed view
                VStack {
                    Text("New Content")
                        .font(.largeTitle)
                        .foregroundColor(.red)
                        .padding()
                    Rectangle()
                        .fill(Color.green)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
                .padding()
                .background(Color.white)  // New background color to show a change
                .cornerRadius(12)
            } else {
                // Initial view
                VStack {
                    Text("Old Content")
                        .font(.largeTitle)
                        .foregroundColor(.blue)
                        .padding()
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 100, height: 100)
                        .cornerRadius(10)
                }
                .padding()
                .background(Color.white)  // Original background color
                .cornerRadius(12)
            }
        }
        .padding()
    }
}

#Preview {
    FixtureView()
}
