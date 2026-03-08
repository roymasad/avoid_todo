import WidgetKit
import SwiftUI

// MARK: - Timeline entry

struct AvoidEntry: TimelineEntry {
    let date: Date
    let habitName: String
    let streakLabel: String
    let habitCount: Int
    let colorIndex: Int
    let habits: [(name: String, streak: String)]
}

// MARK: - Color themes (matches Android gradient colours)

private func widgetGradient(colorIndex: Int) -> LinearGradient {
    let pairs: [(String, String)] = [
        ("2E7D32", "0D2E0F"),  // 0 Forest
        ("1A2E42", "050C15"),  // 1 Midnight
        ("0E4A7A", "051828"),  // 2 Ocean
        ("3D2490", "150938"),  // 3 Purple
    ]
    let (start, end) = pairs[max(0, min(colorIndex, pairs.count - 1))]
    return LinearGradient(
        colors: [Color(hex: start), Color(hex: end)],
        startPoint: .top,
        endPoint: .bottom
    )
}

// MARK: - Timeline provider

struct AvoidProvider: TimelineProvider {
    private let groupId = "group.com.roymassaad.avoid_todo"

    func placeholder(in context: Context) -> AvoidEntry {
        AvoidEntry(
            date: Date(),
            habitName: "No smoking",
            streakLabel: "21 days",
            habitCount: 3,
            colorIndex: 0,
            habits: [
                (name: "No smoking",   streak: "21 days"),
                (name: "No alcohol",   streak: "14 days"),
                (name: "No junk food", streak: "7 days"),
            ]
        )
    }

    func getSnapshot(in context: Context, completion: @escaping (AvoidEntry) -> Void) {
        completion(readEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AvoidEntry>) -> Void) {
        let entry = readEntry()
        let next = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
        completion(Timeline(entries: [entry], policy: .after(next)))
    }

    private func readEntry() -> AvoidEntry {
        let ud = UserDefaults(suiteName: groupId)
        let habitName   = ud?.string(forKey: "habit_name")          ?? ""
        let streakLabel = ud?.string(forKey: "streak_label")        ?? ""
        let habitCount  = ud?.integer(forKey: "habit_count")        ?? 0
        let colorIndex  = ud?.integer(forKey: "widget_color_index") ?? 0
        let itemCount   = ud?.integer(forKey: "widget_item_count")  ?? 0

        var habits: [(String, String)] = []
        for i in 0..<min(itemCount, 5) {
            let name   = ud?.string(forKey: "habit_\(i)_name")   ?? ""
            let streak = ud?.string(forKey: "habit_\(i)_streak") ?? ""
            if !name.isEmpty { habits.append((name, streak)) }
        }

        return AvoidEntry(
            date:        Date(),
            habitName:   habitName,
            streakLabel: streakLabel,
            habitCount:  habitCount,
            colorIndex:  colorIndex,
            habits:      habits
        )
    }
}

// MARK: - Streak pill

private struct StreakPill: View {
    let text: String
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.white.opacity(0.16))
            Text(text)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.vertical, 7)
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Small widget

private struct SmallView: View {
    let entry: AvoidEntry

    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(headerLabel)
                .font(.system(size: 9, weight: .medium))
                .tracking(1.5)
                .textCase(.uppercase)
                .foregroundColor(.white.opacity(0.53))
                .frame(maxWidth: .infinity, alignment: .leading)

            Spacer()

            if entry.habitName.isEmpty {
                Text("No active habits")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.87))
                    .frame(maxWidth: .infinity)

                StreakPill(text: "–")

                Text("Open app to start")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            } else {
                Text(entry.habitName)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white.opacity(0.93))
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)

                StreakPill(text: entry.streakLabel)

                Text("🔥 streak-free")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }

            Spacer()
        }
        .padding(14)
    }

    private var headerLabel: String {
        switch entry.habitCount {
        case 0:  return "Avoid Todo"
        case 1:  return "Avoiding 1 Habit"
        default: return "Avoiding \(entry.habitCount) Habits"
        }
    }
}

// MARK: - Medium widget

private struct MediumView: View {
    let entry: AvoidEntry

    var body: some View {
        HStack(spacing: 0) {
            // Left: top habit + big streak
            VStack(alignment: .leading, spacing: 4) {
                Text(headerLabel)
                    .font(.system(size: 9, weight: .medium))
                    .tracking(1.5)
                    .textCase(.uppercase)
                    .foregroundColor(.white.opacity(0.53))

                Spacer()

                if entry.habitName.isEmpty {
                    Text("No active habits")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white.opacity(0.87))
                    Text("Open app to start")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                } else {
                    Text(entry.habitName)
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    Text(entry.streakLabel)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                    Text("🔥 streak-free")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.6))
                }

                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 14)
            .padding(.vertical, 14)

            // Right: other habits
            let others = Array(entry.habits.dropFirst().prefix(3))
            if !others.isEmpty {
                Rectangle()
                    .fill(.white.opacity(0.15))
                    .frame(width: 1)
                    .padding(.vertical, 14)

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(Array(others.enumerated()), id: \.offset) { _, habit in
                        HStack {
                            VStack(alignment: .leading, spacing: 1) {
                                Text(habit.name)
                                    .font(.system(size: 11, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                                    .lineLimit(1)
                                Text(habit.streak)
                                    .font(.system(size: 10))
                                    .foregroundColor(.white.opacity(0.6))
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(.white.opacity(0.09))
                        .cornerRadius(8)
                    }
                    Spacer()
                }
                .padding(.trailing, 14)
                .padding(.vertical, 14)
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var headerLabel: String {
        switch entry.habitCount {
        case 0:  return "Avoid Todo"
        case 1:  return "Avoiding 1 Habit"
        default: return "Avoiding \(entry.habitCount) Habits"
        }
    }
}

// MARK: - Entry view dispatcher

struct AvoidWidgetEntryView: View {
    var entry: AvoidEntry
    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                MediumView(entry: entry)
            default:
                SmallView(entry: entry)
            }
        }
        .background(widgetGradient(colorIndex: entry.colorIndex))
    }
}

// MARK: - Widget declaration

struct AvoidWidget: Widget {
    let kind: String = "AvoidWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: AvoidProvider()) { entry in
            if #available(iOS 17.0, *) {
                AvoidWidgetEntryView(entry: entry)
                    .containerBackground(
                        widgetGradient(colorIndex: entry.colorIndex),
                        for: .widget
                    )
            } else {
                AvoidWidgetEntryView(entry: entry)
            }
        }
        .configurationDisplayName("Avoid Widget")
        .description("Shows your streak-free habits.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

// MARK: - Color hex helper

extension Color {
    init(hex: String) {
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        self.init(
            red:   Double((int >> 16) & 0xFF) / 255,
            green: Double((int >> 8)  & 0xFF) / 255,
            blue:  Double( int        & 0xFF) / 255
        )
    }
}
