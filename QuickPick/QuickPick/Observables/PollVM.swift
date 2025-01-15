//
//  PollVM.swift
//  QuickPick
//
//  Created by Nahian Zarif on 3/1/25.
//
import ActivityKit
import FirebaseFirestore
import Foundation
import SwiftUI
import Observation
import FirebaseAuth

@Observable
class PollViewModel {
    
    let db = Firestore.firestore()
    let pollId: String
    
    var poll: Poll? = nil
    var activity: Activity<LivePollsWidgetAttributes>? = nil
    
    init(pollId: String, poll: Poll? = nil) {
        self.pollId = pollId
        self.poll = poll
    }
    
    @MainActor
    func listenToPoll() {
        db.document("polls/\(pollId)")
            .addSnapshotListener { snapshot, error in
                guard let snapshot else { return }
                do {
                    let poll = try snapshot.data(as: Poll.self)
                    withAnimation {
                        self.poll = poll
                    }
                    self.startActivityIfNeeded()
                } catch {
                    print("Failed to fetch poll")
                }
            }
    }
    
    func incrementOption(_ option: Option) {
        guard let poll else { return }

        // Get the authenticated user's unique UID
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not logged in. Cannot vote.")
            return
        }

        let voteRef = db.collection("polls/\(pollId)/votes").document(userId)

        Task {
            do {
                // Check if the user has already voted
                let currentVote = try await voteRef.getDocument(as: UserVote?.self)

                if let currentVote {
                    // User has already voted, check if they are voting for the same option
                    if currentVote.optionId == option.id {
                        print("User already voted for this option, ignoring")
                        return
                    }

                    // User is changing their vote to a different option
                    if let oldOptionIndex = poll.options.firstIndex(where: { $0.id == currentVote.optionId }) {
                        let oldOptionCount = poll.options[oldOptionIndex].count
                        if oldOptionCount > 0 {
                            try await db.document("polls/\(pollId)").updateData([
                                "option\(oldOptionIndex).count": FieldValue.increment(Int64(-1))
                            ])
                        }
                    }

                    // Increment the new option's vote count
                    if let newOptionIndex = poll.options.firstIndex(where: { $0.id == option.id }) {
                        try await db.document("polls/\(pollId)").updateData([
                            "option\(newOptionIndex).count": FieldValue.increment(Int64(1))
                        ])
                    }

                    // Update the user's vote in Firestore
                    try await voteRef.setData([
                        "optionId": option.id,
                        "timestamp": FieldValue.serverTimestamp()
                    ])
                } else {
                    // User hasn't voted yet, record their vote
                    if let optionIndex = poll.options.firstIndex(where: { $0.id == option.id }) {
                        try await db.document("polls/\(pollId)").updateData([
                            "option\(optionIndex).count": FieldValue.increment(Int64(1)),
                            "totalCount": FieldValue.increment(Int64(1)) // Increment totalCount for new vote
                        ])

                        // Add vote document for the user
                        try await voteRef.setData([
                            "optionId": option.id,
                            "timestamp": FieldValue.serverTimestamp()
                        ])
                    }
                }
            } catch {
                print("Failed to record vote: \(error.localizedDescription)")
            }
        }
    }



    
    func startActivityIfNeeded() {
        guard let poll = self.poll, activity == nil, ActivityAuthorizationInfo().frequentPushesEnabled else { return }
        if let currentPollIdActivity = Activity<LivePollsWidgetAttributes>.activities.first(where: { activity in activity.attributes.pollId == pollId }) {
            self.activity = currentPollIdActivity
        } else {
            do {
                let activityAttributes = LivePollsWidgetAttributes(pollId: pollId)
                let activityContent = ActivityContent(state: poll, staleDate: Calendar.current.date(byAdding: .hour, value: 8, to: Date())!)
                activity = try Activity.request(attributes: activityAttributes, content: activityContent, pushType: .token)
                print("Requested a live activity \(String(describing: activity?.id))")
            } catch {
                print("Error requesting live activity \(error.localizedDescription)")
            }
        }
        
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
        Task {
            guard let activity else { return }
            for try await token in activity.pushTokenUpdates {
                let tokenParts = token.map { data in String(format: "%02.2hhx", data) }
                let token = tokenParts.joined()
                print("Live activity token updated: \(token)")
                
                do {
                    try await db.collection("polls/\(pollId)/push_tokens")
                        .document(deviceId)
                        .setData([ "token": token ])
                } catch {
                    print("failed to update token: \(error.localizedDescription)")
                }
            }
        }
    }
    
}
