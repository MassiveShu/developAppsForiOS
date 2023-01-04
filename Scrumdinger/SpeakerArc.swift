//
//  SpeakerArc.swift
//  Scrumdinger
//
//  Created by Max Shu on 04.01.2023.
//

import SwiftUI

struct SpeakerArc: Shape {
    // Add constant properties for speakerIndex and totalSpeakers.
    // You’ll base the number of arc segments on the number of total speakers. The speaker index indicates which attendee is speaking and how many segments to draw.
    let speakerIndex: Int
    let totalSpeakers: Int

    // Add the private computed property degreesPerSpeaker.
    // Use totalSpeakers to calculate the degrees of a single arc.
    private var degreesPerSpeaker: Double {
        360.0 / Double(totalSpeakers)
    }

    // Add a private computed property named startAngle, and calculate the value using degreesPerSpeaker and speakerIndex.
    // When you draw a path, you’ll need an angle for the start and end of the arc. The additional 1.0 degree is for visual separation between arc segments.
    private var startAngle: Angle {
        Angle(degrees: degreesPerSpeaker * Double(speakerIndex) + 1.0)
    }

    // Add a private computed property named endAngle that returns the ending angle using the startAngle and degreesPerSpeaker.
    // The subtracted 1.0 degree is for visual separation between arc segments.
    private var endAngle: Angle {
        Angle(degrees: startAngle.degrees + degreesPerSpeaker - 1.0)
    }

    func path(in rect: CGRect) -> Path {
        // In the path(in:) function, create a constant diameter for the circle of the arc.
        // The path(in:) function takes a CGRect parameter. The coordinate system contains an origin in the lower left corner, with positive values extending up and to the right.
        let diameter = min(rect.size.width, rect.size.height) - 24.0
        // Calculate the radius from the diameter, and store it in a constant named radius.
        let radius = diameter / 2.0
        // Create a constant to store the center of the rectangle.
        // The CGRect structure supplies two properties that provide the x- and y-coordinates for the center of the rectangle.
        let center = CGPoint(x: rect.midX, y: rect.midY)

        return Path { path in
            // Add an arc to the path using the constants you defined above.
            path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        }
    }
}
