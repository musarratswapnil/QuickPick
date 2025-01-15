import Foundation
import SwiftUI

struct ReviewsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var reviews: [Review] = []
    @State private var isLoading = true

    var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Loading Reviews...")
                            .font(.subheadline)
                            .padding(.top, 8)
                    }
                } else {
                    if reviews.isEmpty {
                        NoReviewsView()
                    } else {
                        ReviewsListView(reviews: reviews)
                    }
                }
            }
            .navigationBarTitle("Reviews", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            .onAppear {
                fetchReviewsFromLocalJSON()
            }
        }
    }

    private func fetchReviewsFromLocalJSON() {
        guard let url = Bundle.main.url(forResource: "reviews", withExtension: "json") else {
            print("Failed to locate reviews.json in the app bundle.")
            self.isLoading = false
            return
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let loadedReviews = try decoder.decode([Review].self, from: data)
            self.reviews = loadedReviews
        } catch {
            print("Error loading or decoding reviews.json: \(error)")
        }

        self.isLoading = false
    }
}

struct LoadingView: View {
    var body: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
            Text("Loading Reviews...")
                .font(.subheadline)
                .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct NoReviewsView: View {
    var body: some View {
        VStack {
            Text("No reviews available.")
                .font(.headline)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ReviewsListView: View {
    let reviews: [Review]

    var body: some View {
        List(reviews) { review in
            VStack(alignment: .leading) {
                Text(review.username)
                    .font(.headline)
                HStack(spacing: 4) {
                    ForEach(0..<review.rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                    ForEach(0..<(5 - review.rating), id: \.self) { _ in
                        Image(systemName: "star")
                            .foregroundColor(.gray)
                    }
                }
                Text(review.reviewText)
                    .font(.body)
                if let parsedDate = ISO8601DateFormatter().date(from: review.date) {
                    Text(parsedDate, style: .date)
                        .font(.caption)
                } else {
                    Text("Invalid Date")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            .padding()
        }
    }
}

struct Review: Identifiable, Codable {
    let id: String // Use String to match the JSON's string-based IDs
    let username: String
    let rating: Int
    let reviewText: String // Match the JSON key directly
    let date: String

    enum CodingKeys: String, CodingKey {
        case id
        case username
        case rating
        case reviewText // No mapping needed
        case date
    }
}


#Preview {
    NavigationStack {
        ReviewsView()
    }
}


