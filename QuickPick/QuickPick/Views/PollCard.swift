//
//  PollCard.swift
//  QuickPick
//
//  Created by Nahian Zarif on 16/1/25.
//

import Foundation
import SwiftUI

public struct PollCard: View {
    let title: String
    let subtitle: String
    let backgroundColor: LinearGradient
    let iconName: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: iconName)
                    .font(.title)
                    .foregroundColor(.white)
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.9))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(15)
        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
    
    // Add public initializer
    public init(title: String, subtitle: String, backgroundColor: LinearGradient, iconName: String) {
        self.title = title
        self.subtitle = subtitle
        self.backgroundColor = backgroundColor
        self.iconName = iconName
    }
}

// Add preview
#Preview {
    VStack {
        PollCard(
            title: "Join a Poll",
            subtitle: "Participate in live polls",
            backgroundColor: LinearGradient(
                colors: [.purple, .blue],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            iconName: "person.3.fill"
        )
        
        PollCard(
            title: "Latest Live Polls",
            subtitle: "See the latest polls",
            backgroundColor: LinearGradient(
                colors: [.orange, .pink],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ),
            iconName: "chart.bar.xaxis"
        )
    }
    .padding()
    .background(Color.black)
}