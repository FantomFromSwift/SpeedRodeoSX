import Foundation
import SwiftData

@Model
final class UserStatsSX {
    var totalTrainingMinutes: Int
    var completedTasksCount: Int
    var articlesRead: Int
    var simulatorRuns: Int
    var averageScore: Double
    var streak: Int
    var lastActiveDate: Date
    var createdAt: Date

    init() {
        self.totalTrainingMinutes = 0
        self.completedTasksCount = 0
        self.articlesRead = 0
        self.simulatorRuns = 0
        self.averageScore = 0.0
        self.streak = 0
        self.lastActiveDate = Date()
        self.createdAt = Date()
    }
}

@Model
final class CompletedTaskSX {
    var taskId: String
    var taskTitle: String
    var score: Int
    var duration: Int
    var completedAt: Date
    var difficulty: String

    init(taskId: String, taskTitle: String, score: Int, duration: Int, difficulty: String) {
        self.taskId = taskId
        self.taskTitle = taskTitle
        self.score = score
        self.duration = duration
        self.difficulty = difficulty
        self.completedAt = Date()
    }
}

@Model
final class FavoriteItemSX {
    var itemId: String
    var itemType: String
    var title: String
    var subtitle: String
    var savedAt: Date

    init(itemId: String, itemType: String, title: String, subtitle: String) {
        self.itemId = itemId
        self.itemType = itemType
        self.title = title
        self.subtitle = subtitle
        self.savedAt = Date()
    }
}

@Model
final class HorseBreedSX {
    var breedId: String
    var name: String
    var origin: String
    var speedRating: Int
    var enduranceRating: Int
    var temperamentRating: Int
    var racingSuitability: Int
    var isFavorite: Bool

    init(breedId: String, name: String, origin: String, speedRating: Int, enduranceRating: Int, temperamentRating: Int, racingSuitability: Int) {
        self.breedId = breedId
        self.name = name
        self.origin = origin
        self.speedRating = speedRating
        self.enduranceRating = enduranceRating
        self.temperamentRating = temperamentRating
        self.racingSuitability = racingSuitability
        self.isFavorite = false
    }
}

@Model
final class TrainingSessionSX {
    var sessionId: String
    var horse: String
    var trackType: String
    var weather: String
    var intensity: Int
    var effectivenessScore: Double
    var createdAt: Date

    init(sessionId: String, horse: String, trackType: String, weather: String, intensity: Int, effectivenessScore: Double) {
        self.sessionId = sessionId
        self.horse = horse
        self.trackType = trackType
        self.weather = weather
        self.intensity = intensity
        self.effectivenessScore = effectivenessScore
        self.createdAt = Date()
    }
}
