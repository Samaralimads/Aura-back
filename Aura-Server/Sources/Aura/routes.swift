import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    try app.register(collection: AuthController())
    try app.register(collection: UserController())
    try app.register(collection: DayController())
    try app.register(collection: ReasonController())
    try app.register(collection: SleepController())
    try app.register(collection: JournalController())
    try app.register(collection: MoodController())
    try app.register(collection: EmotionController())
    try app.register(collection: BreathingController())
    try app.register(collection: UserBreathingController())  
    try app.register(collection: BadgeController())
}
