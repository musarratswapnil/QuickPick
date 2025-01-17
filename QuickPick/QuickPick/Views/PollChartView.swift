//
//  PollChartView.swift
//  QuickPick
//
//  Created by Nahian Zarif on 3/1/25.
//

import Charts
import SwiftUI

struct PollChartView: View {
    
    let options: [Option]
    
    // Define different colors for the dots
    private let dotColors: [Color] = [
        .blue,
        .green,
        .orange,
        .purple,
        .pink,
        .yellow,
        .cyan
    ]
    
    var body: some View {
        Chart {
            ForEach(options) { option in
                SectorMark(
                    angle: .value("Count", option.count),
                    innerRadius: .ratio(0.618),
                    angularInset: 1.5
                )
                .cornerRadius(5)
                .foregroundStyle(by: .value("Name", option.name))
            }
        }
        .chartLegend(position: .bottom) {
            HStack {
                ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                    HStack {
                        Circle()
                            .fill(dotColors[index % dotColors.count]) // Different color for each dot
                            .frame(width: 10, height: 10)
                        Text(option.name)
                            .foregroundColor(.red)
                    }
                }
            }
        }
    }
}

#Preview {
    PollChartView(options: [
        .init(count: 2, name: "PS5"),
        .init(count: 1, name: "Xbox SX"),
        .init(count: 2, name: "Switch"),
        .init(count: 1, name: "PC")
    ])
}
