import Foundation

struct ArticleModelSX: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var category: String
    var summary: String
    var body: String
    var readingMinutes: Int
    var imageName: String
}

struct TrainingTaskModelSX: Identifiable, Codable, Hashable {
    var id: String
    var title: String
    var difficulty: String
    var durationMinutes: Int
    var category: String
    var description: String
    var steps: [TaskStepModelSX]
    var rewardPoints: Int
}

struct TaskStepModelSX: Identifiable, Codable, Hashable {
    var id: String
    var stepNumber: Int
    var title: String
    var instruction: String
    var tip: String
    var isQuiz: Bool
    var quizQuestion: String
    var quizOptions: [String]
    var correctAnswer: Int
}

struct HorseBreedModelSX: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var origin: String
    var height: String
    var weight: String
    var speedRating: Int
    var enduranceRating: Int
    var temperamentRating: Int
    var racingSuitability: Int
    var summary: String
    var history: String
    var physicalTraits: String
    var trainingRequirements: String
    var racingPotential: String
    var imageName: String
}

enum JSONLoaderSX {
    static func loadArticles() -> [ArticleModelSX] {
        guard let url = Bundle.main.url(forResource: "horse_training_articles", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([ArticleModelSX].self, from: data)
        else { return [] }
        return decoded
    }

    static func loadTasks() -> [TrainingTaskModelSX] {
        guard let url = Bundle.main.url(forResource: "training_tasks", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([TrainingTaskModelSX].self, from: data)
        else { return [] }
        return decoded
    }

    static func loadHorseBreeds() -> [HorseBreedModelSX] {
        guard let url = Bundle.main.url(forResource: "horse_breeds", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([HorseBreedModelSX].self, from: data)
        else { return [] }
        return decoded
    }
}
