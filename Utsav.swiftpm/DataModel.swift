import SwiftUI

enum FestivalCategory {
    case harvest
    case community
    case nature
    case religious
}

struct Festival: Identifiable {

    let id = UUID()
    let name: String
    let date: String
    let month: String
    let day: String
    let description: String
    let location: String
    let iconName: String
    let color: Color
    let type: FestivalType
    let season: Season
    let category: FestivalCategory
    let rituals: [String]

    var actualDate: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: date) ?? Date.distantPast
    }
}

enum FestivalType {
    case national
    case regional
}

enum Season: String, CaseIterable, Identifiable {

    case spring = "Spring"
    case summer = "Summer"
    case monsoon = "Monsoon"
    case winter = "Winter"

    var id: String {
        self.rawValue
    }

    var icon: String {
        switch self {
        case .spring:
            return "leaf.fill"
        case .summer:
            return "sun.max.fill"
        case .monsoon:
            return "cloud.rain.fill"
        case .winter:
            return "snowflake"
        }
    }
}

class FestivalData: ObservableObject {

    @Published var festivals: [Festival] = [

        Festival(
            name: "Holi",
            date: "March 04, 2026",
            month: "Mar",
            day: "25",
            description: "The vibrant festival of colors and love.",
            location: "All India",
            iconName: "paintpalette.fill",
            color: .pink,
            type: .national,
            season: .spring,
            category: .community,
            rituals: [
                "Bonfire (Holika Dahan)",
                "Throwing Colors",
                "Thandai Drink"
            ]
        ),

        Festival(
            name: "Eid al-Fitr",
            date: "March 20, 2026",
            month: "Mar",
            day: "20",
            description: "The joyous festival of breaking the fast, marking the end of Ramadan with feasts and charity.",
            location: "All India",
            iconName: "moon.stars.fill",
            color: .green,
            type: .national,
            season: .spring,
            category: .religious,
            rituals: [
                "Morning Prayers (Salat al-Eid)",
                "Giving Charity (Zakat al-Fitr)",
                "Feasting with Family"
            ]
        ),

        Festival(
            name: "Hemis",
            date: "July 06, 2026",
            month: "Jul",
            day: "06",
            description: "A colorful celebration of Guru Padmasambhava's birth.",
            location: "Ladakh",
            iconName: "mountain.2.fill",
            color: .purple,
            type: .regional,
            season: .summer,
            category: .nature,
            rituals: [
                "Cham Dance",
                "Blowing Trumpets",
                "Thangka Unfurling"
            ]
        ),

        Festival(
            name: "Diwali",
            date: "November 01, 2026",
            month: "Nov",
            day: "01",
            description: "The Festival of Lights celebrating victory of good over evil.",
            location: "All India",
            iconName: "fireworks",
            color: .orange,
            type: .national,
            season: .winter,
            category: .community,
            rituals: [
                "Lighting Diyas",
                "Rangoli",
                "Fireworks",
                "Lakshmi Puja"
            ]
        ),

        Festival(
            name: "Bihu",
            date: "April 14, 2026",
            month: "Apr",
            day: "14",
            description: "The vibrant Assamese New Year and spring festival celebrating the onset of the agricultural season.",
            location: "Assam",
            iconName: "music.note.list",
            color: .brown,
            type: .regional,
            season: .spring,
            category: .harvest,
            rituals: [
                "Bihu Dance",
                "Singing Bihu Geet",
                "Feasting on Pitha"
            ]
        ),

        Festival(
            name: "Onam",
            date: "August 28, 2026",
            month: "Aug",
            day: "28",
            description: "The harvest festival welcoming King Mahabali.",
            location: "Kerala",
            iconName: "laurel.leading.laurel.trailing",
            color: .teal,
            type: .regional,
            season: .monsoon,
            category: .harvest,
            rituals: [
                "Pookkalam (Flower Carpet)",
                "Boat Race",
                "Grand Feast"
            ]
        ),

        Festival(
            name: "Chhath Puja",
            date: "November 15, 2026",
            month: "Nov",
            day: "15",
            description: "An ancient festival dedicated to the Sun God.",
            location: "Bihar",
            iconName: "sun.haze.fill",
            color: .orange,
            type: .regional,
            season: .winter,
            category: .nature,
            rituals: [
                "River Bathing",
                "Fasting",
                "Offering to Sun"
            ]
        ),

        Festival(
            name: "Christmas",
            date: "December 25, 2026",
            month: "Dec",
            day: "25",
            description: "A magical celebration of joy, illuminated by twinkling lights, carols, and the spirit of giving.",
            location: "All India",
            iconName: "gift.fill",
            color: .red,
            type: .national,
            season: .winter,
            category: .community,
            rituals: [
                "Decorating the Tree",
                "Exchanging Gifts",
                "Baking Plum Cake"
            ]
        ),

        Festival(
            name: "Guru Nanak Jayanti",
            date: "November 24, 2026",
            month: "Nov",
            day: "24",
            description: "Celebrating the birth of Guru Nanak Dev Ji with service, humility, and equality.",
            location: "All India",
            iconName: "sun.max.fill",
            color: .yellow,
            type: .national,
            season: .winter,
            category: .religious,
            rituals: [
                "Nagar Kirtan",
                "Langar Seva",
                "Prakash (Lighting)"
            ]
        ),

        Festival(
            name: "Buddha Purnima",
            date: "May 01, 2026",
            month: "May",
            day: "01",
            description: "A day of peace, reflection, and enlightenment honoring Lord Buddha.",
            location: "All India",
            iconName: "moon.circle.fill",
            color: .teal,
            type: .national,
            season: .summer,
            category: .religious,
            rituals: [
                "Meditation",
                "Lighting Lamps",
                "Offering Lotus"
            ]
        )
    ]
}
