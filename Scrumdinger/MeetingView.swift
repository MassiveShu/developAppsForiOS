//
//  MeetingView.swift
//  Scrumdinger
//
//  Created by Max Shu on 03.01.2023.
//

import SwiftUI
import AVFoundation

struct MeetingView: View {
    @Binding var scrum: DailyScrum
    @StateObject var scrumTimer = ScrumTimer()
    // The initializer requests access to the speech recognizer and microphone the first time the system calls the object.
    @StateObject var speechRecognizer = SpeechRecognizer()
    // You’ll use this variable in the next section to display recording indicators.
    @State private var isRecording = false

    private var player: AVPlayer { AVPlayer.sharedDingPlayer }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16.0)
                .fill(scrum.theme.mainColor)
            VStack {
                MeetingHeaderView(secondsElapsed: scrumTimer.secondsElapsed, secondsRemaining: scrumTimer.secondsRemaining, theme: scrum.theme)

                MeetingTimerView(speakers: scrumTimer.speakers, theme: scrum.theme, isRecording: isRecording)
                
                MeetingFooterView(speakers: scrumTimer.speakers, skipAction: scrumTimer.skipSpeaker)
            }
        }
        .padding()
        .foregroundColor(scrum.theme.accentColor)
        .onAppear {
            scrumTimer.reset(lengthInMinutes: scrum.lengthInMinutes, attendees: scrum.attendees)
            scrumTimer.speakerChangedAction = {
                player.seek(to: .zero)
                player.play()
            }
            // Calling reset() ensures that the speech recognizer is ready to begin.
            speechRecognizer.reset()
            speechRecognizer.transcribe()
            // After you call speechRecognizer.transcribe() in onAppear, set the value of isRecording to true.
            isRecording = true
            scrumTimer.startScrum()
        }
        .onDisappear {
            scrumTimer.stopScrum()
            // When the meeting timer screen disappears, the stopTranscribing() method stops the transcription.
            speechRecognizer.stopTranscribing()
            // After you call speechRecognizer.stopTranscribing() in onDisappear, set the value of isRecording to false.
            isRecording = false
            let newHistory = History(attendees: scrum.attendees, lengthInMinutes: scrum.timer.secondsElapsed / 60, transcript: speechRecognizer.transcript)
            scrum.history.insert(newHistory, at: 0)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MeetingView_Previews: PreviewProvider {
    static var previews: some View {
        MeetingView(scrum: .constant(DailyScrum.sampleData[0]))
    }
}
