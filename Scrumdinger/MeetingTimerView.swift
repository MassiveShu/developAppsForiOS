//
//  MeetingTimerView.swift
//  Scrumdinger
//
//  Created by Max Shu on 04.01.2023.
//

import SwiftUI

struct MeetingTimerView: View {
    let speakers: [ScrumTimer.Speaker]
    let theme: Theme

    // Add a computed property named currentSpeaker that returns the name of the current speaker.
    private var currentSpeaker: String {
        speakers.first(where: { !$0.isCompleted })?.name ?? "Someone"
    }

    var body: some View {
        Circle()
            .strokeBorder(lineWidth: 24)
            .overlay {
                VStack {
                    Text(currentSpeaker)
                        .font(.title)
                    Text("is speaking")
                }
                // Use the accessibilityElement modifier to combine the elements inside the VStack.
                // This modifier makes VoiceOver read the two text views as one sentence.
                .accessibilityElement(children: .combine)
                .foregroundStyle(theme.accentColor)
            }
        // This layer will display the list of speakers.
            .overlay  {
                // Add a ForEach view that takes an array of speakers.
                ForEach(speakers) { speaker in
                    // Add an if statement that checks whether the speaker is finished and uses optional binding to find the index of the speaker.
                    if speaker.isCompleted, let index = speakers.firstIndex(where: { $0.id == speaker.id }) {
                        // Add a speaker arc using the index and the count of the speakers array.
                        SpeakerArc(speakerIndex: index, totalSpeakers: speakers.count)
                        // Add a rotation modifier that rotates the speaker arc by -90 degrees.
                        // Rotating the arc moves the 0-degree angle to the 12 o’clock position.
                            .rotation(Angle(degrees: -90))
                        // Add a stroke modifier passing theme.mainColor and a line width of 12.
                        // The stroke modifier traces a line along the path of the shape.
                            .stroke(theme.mainColor, lineWidth: 12)
                    }
                }
            }
            .padding(.horizontal)
    }
}

struct MeetingTimerView_Previews: PreviewProvider {
    static var speakers: [ScrumTimer.Speaker] {
        [ScrumTimer.Speaker(name: "Bill", isCompleted: true), ScrumTimer.Speaker(name: "Cathy", isCompleted: false)]
    }

    static var previews: some View {
        MeetingTimerView(speakers: speakers, theme: .yellow)
    }
}
