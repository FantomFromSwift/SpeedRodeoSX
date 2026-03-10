import Foundation
import Observation
import SwiftData
import SwiftUI

@Observable
final class MainViewModelSX {

    var selectedTab: TabSX = .home
    var showSplash: Bool = true
    var showOnboarding: Bool = false
    var showPaywall: Bool = false
    var selectedArticle: ArticleModelSX?
    var selectedTask: TrainingTaskModelSX?
    var selectedHorse: HorseBreedModelSX?
    var activeTaskStep: Int = 0
    var taskInProgress: TrainingTaskModelSX?
    var searchQuery: String = ""

    var articles: [ArticleModelSX] = []
    var trainingTasks: [TrainingTaskModelSX] = []
    var horseBreeds: [HorseBreedModelSX] = []

    var simulatorHorse: String = "Thoroughbred"
    var simulatorTrack: String = "Turf"
    var simulatorWeather: String = "Clear"
    var simulatorIntensity: Double = 0.6
    var simulatorResult: Double? = nil

    var nutritionGrain: Double = 0.5
    var nutritionHay: Double = 0.7
    var nutritionSupplements: Double = 0.3
    var nutritionResult: NutritionResultSX? = nil

    var raceStartPace: Double = 0.5
    var raceMidPacing: Double = 0.6
    var raceFinalSprint: Double = 0.8
    var racePrediction: RacePredictionSX? = nil

    var weeklyChallenge: WeeklyChallengeModelSX = WeeklyChallengeModelSX.sample
    var dailyInsight: String = ""

    var taskStepAnswers: [Int: Bool] = [:]
    var taskScore: Int = 0

    init() {
        loadContent()
        pickDailyInsight()
    }

    func loadContent() {
        articles = JSONLoaderSX.loadArticles()
        trainingTasks = JSONLoaderSX.loadTasks()
        horseBreeds = JSONLoaderSX.loadHorseBreeds()
    }

    func pickDailyInsight() {
        let insights = [
            "A horse's heart rate peaks at 240 bpm during a full gallop.",
            "Thoroughbreds cover 400m in under 22 seconds at top speed.",
            "A jockey's balance shifts every 0.3 seconds during a race bend.",
            "Morning training sessions improve muscle memory retention by 34%.",
            "Hydration before race day increases stamina by up to 18%.",
            "The ideal saddle fit distributes weight across 18 contact points.",
            "Gate reaction time under 0.15 seconds gives a 12% positional edge.",
            "Stride length, not speed, determines a Thoroughbred's efficiency.",
            "A horse in peak condition has a resting heart rate of 28–44 bpm.",
            "Rain-softened turf reduces optimal stride rate by approximately 8%."
        ]
        dailyInsight = insights.randomElement() ?? insights[0]
    }

    func runSimulator() {
        let baseScore = simulatorIntensity * 100
        var modifier = 1.0
        if simulatorTrack == "Sand" { modifier *= 0.92 }
        if simulatorTrack == "Synthetic" { modifier *= 1.05 }
        if simulatorWeather == "Rain" { modifier *= 0.88 }
        if simulatorWeather == "Wind" { modifier *= 0.94 }
        if simulatorHorse == "Thoroughbred" { modifier *= 1.10 }
        if simulatorHorse == "Arabian" { modifier *= 1.05 }
        simulatorResult = min(baseScore * modifier, 100)
    }

    func evaluateNutrition() {
        let energy = (nutritionGrain * 40 + nutritionHay * 30 + nutritionSupplements * 20)
        let muscle = (nutritionGrain * 25 + nutritionSupplements * 55)
        let recovery = (nutritionHay * 45 + nutritionSupplements * 35)
        nutritionResult = NutritionResultSX(
            energy: min(energy, 100),
            muscle: min(muscle, 100),
            recovery: min(recovery, 100)
        )
    }

    func buildRaceStrategy() {
        let paceScore = (raceStartPace * 0.8 + raceMidPacing * 1.2 + raceFinalSprint * 1.4) / 3.4 * 100
        let energyLeft = max(0, 100 - raceStartPace * 50 - raceMidPacing * 30)
        let finalBurst = energyLeft > 20 ? raceFinalSprint * 100 : raceFinalSprint * 65
        let predicted = (paceScore * 0.6 + finalBurst * 0.4)
        let label: String
        switch predicted {
        case 80...: label = "Podium Finish Likely"
        case 65..<80: label = "Top 5 Probable"
        case 50..<65: label = "Midfield Result"
        default: label = "Needs Improvement"
        }
        racePrediction = RacePredictionSX(score: predicted, label: label, energyReserve: energyLeft)
    }

    func startTask(_ task: TrainingTaskModelSX) {
        taskInProgress = task
        activeTaskStep = 0
        taskStepAnswers = [:]
        taskScore = 0
    }

    func answerStep(index: Int, correct: Bool) {
        taskStepAnswers[index] = correct
        if correct { taskScore += 20 }
    }

    func finishTask() {
        taskInProgress = nil
        activeTaskStep = 0
    }

    func searchResults() -> SearchResultsSX {
        let q = searchQuery.lowercased()
        if q.isEmpty {
            return SearchResultsSX(articles: articles, tasks: trainingTasks, horses: horseBreeds)
        }
        return SearchResultsSX(
            articles: articles.filter { $0.title.lowercased().contains(q) || $0.summary.lowercased().contains(q) },
            tasks: trainingTasks.filter { $0.title.lowercased().contains(q) },
            horses: horseBreeds.filter { $0.name.lowercased().contains(q) || $0.origin.lowercased().contains(q) }
        )
    }
}

enum TabSX: String, CaseIterable {
    case home = "Home"
    case journal = "Journal"
    case search = "Search"
    case favorites = "Favorites"
    case settings = "Settings"

    var icon: String {
        switch self {
        case .home: return "house.fill"
        case .journal: return "book.fill"
        case .search: return "magnifyingglass"
        case .favorites: return "heart.fill"
        case .settings: return "gearshape.fill"
        }
    }
}

struct NutritionResultSX {
    var energy: Double
    var muscle: Double
    var recovery: Double
}

struct RacePredictionSX {
    var score: Double
    var label: String
    var energyReserve: Double
}

struct SearchResultsSX {
    var articles: [ArticleModelSX]
    var tasks: [TrainingTaskModelSX]
    var horses: [HorseBreedModelSX]
}

struct WeeklyChallengeModelSX {
    var title: String
    var description: String
    var reward: String
    var progress: Double

    static let sample = WeeklyChallengeModelSX(
        title: "Iron Stirrup Week",
        description: "Complete 3 training tasks and read 2 articles on race strategy to earn the Iron Stirrup badge.",
        reward: "Iron Stirrup Badge",
        progress: 0.4
    )
}
