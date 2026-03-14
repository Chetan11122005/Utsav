import SwiftUI

struct Tale: Identifiable {

    let id = UUID()
    let festivalName: String
    let headline: String
    let story: String
    let rituals: [String]
    let funFact: String
    let image: String
    let color: Color
    var isLiked: Bool = false
}

class TalesData: ObservableObject {

    @Published var tales: [Tale] = [

        Tale(
            festivalName: "Makar Sankranti",
            headline: "The Journey of the Sun",
            story: "This festival marks the transition of the Sun into the zodiac sign of Makara (Capricorn). It symbolizes the end of the winter solstice and the start of longer, warmer days. It is a thanksgiving to Surya, the Sun God, for a bountiful harvest and new beginnings.",
            rituals: [
                "Flying Kites",
                "Taking holy river dips",
                "Eating sesame & jaggery (Til-Gud)",
                "Offering prayers to Surya"
            ],
            funFact: "It is one of the very few ancient Indian festivals observed according to solar cycles rather than the lunar calendar.",
            image: "sun.max.fill",
            color: .blue,
            isLiked: false
        ),

        Tale(
            festivalName: "Holi",
            headline: "Victory of Prahlad",
            story: "The demon King Hiranyakashipu demanded everyone worship him. His son, Prahlad, refused and worshipped Vishnu. The king's sister, Holika, who was immune to fire, sat in a pyre with Prahlad to burn him. She burned, but Prahlad survived.",
            rituals: [
                "Holika Dahan (Bonfire)",
                "Playing with Gulal",
                "Drinking Thandai",
                "Singing & Dancing"
            ],
            funFact: "The color blue represents Lord Krishna, who was jealous of Radha's fair skin.",
            image: "paintpalette.fill",
            color: .pink,
            isLiked: false
        ),

        Tale(
            festivalName: "Hemis",
            headline: "The Triumph of Padmasambhava",
            story: "Celebrated at the Hemis Monastery in Ladakh, this festival honors Guru Padmasambhava. Legend says he fought a great battle against demons to protect the people. The lamas perform the sacred Mask Dance (Cham) to reenact this victory.",
            rituals: [
                "Masked Cham Dance",
                "Blowing trumpets",
                "Unfurling the Thangka",
                "Visiting the monastery"
            ],
            funFact: "The festival takes place in the courtyard of the largest Buddhist monastery in Ladakh.",
            image: "mountain.2.fill",
            color: .purple,
            isLiked: false
        ),

        Tale(
            festivalName: "Lohri",
            headline: "The Legend of Dulla Bhatti",
            story: "Lohri commemorates the winter solstice. The legend tells of Dulla Bhatti, a hero of Punjab who led a rebellion against the Mughals. He stole from the rich to rescue poor girls from being sold into slavery, arranging their marriages and providing dowries. The bonfires lit on Lohri represent the fire of his spirit.",
            rituals: [
                "Lighting a huge bonfire",
                "Offering sesame & jaggery",
                "Bhangra dance",
                "Singing folk songs"
            ],
            funFact: "Lohri is essentially a thanksgiving festival to the Sun God for the harvest.",
            image: "flame.circle",
            color: .yellow,
            isLiked: false
        ),

        Tale(
            festivalName: "Diwali",
            headline: "The Return of Rama",
            story: "After 14 years of exile and defeating the ten-headed demon king Ravana, Lord Rama returned to his kingdom of Ayodhya with Sita and Lakshmana. To welcome their King on a moonless night, the citizens lit millions of earthen lamps.",
            rituals: [
                "Lighting Diyas",
                "Rangoli Art",
                "Lakshmi Puja",
                "Bursting Crackers"
            ],
            funFact: "Diwali is also celebrated by Jains, Sikhs, and Buddhists for different historical reasons.",
            image: "fireworks",
            color: .orange,
            isLiked: false
        ),

        Tale(
            festivalName: "Eid al-Fitr",
            headline: "The Reward of Patience",
            story: "Marking the end of Ramadan—the holy month of fasting—Eid al-Fitr is a celebration of spiritual growth and gratitude. It is believed that the Quran was first revealed to Prophet Muhammad during Ramadan. Eid is a day to thank Allah for the strength to complete the fast.",
            rituals: [
                "Morning Prayers (Salat al-Eid)",
                "Giving Charity (Zakat)",
                "Feasting with family",
                "Exchanging Eidi (gifts)"
            ],
            funFact: "It is strictly forbidden to fast on the day of Eid al-Fitr.",
            image: "moon.stars.fill",
            color: .green,
            isLiked: false
        ),

        Tale(
            festivalName: "Christmas",
            headline: "The Star of Bethlehem",
            story: "Christmas celebrates the birth of Jesus Christ. According to the legend, a brilliant star appeared in the night sky over Bethlehem, guiding shepherds and three wise men to the humble stable where the newborn king lay, bringing gifts of gold, frankincense, and myrrh.",
            rituals: [
                "Attending Midnight Mass",
                "Decorating the Christmas Tree",
                "Exchanging Gifts",
                "Singing Carols"
            ],
            funFact: "The tradition of setting up a decorated Christmas tree originated in Germany in the 16th century.",
            image: "gift.fill",
            color: .red,
            isLiked: false
        ),

        Tale(
            festivalName: "Raksha Bandhan",
            headline: "Krishna and Draupadi",
            story: "During the Mahabharata, Lord Krishna cut his finger. Draupadi immediately tore a piece of her beautiful saree and tied it around his wound to stop the bleeding. Deeply touched, Krishna promised to protect her forever—a vow he kept when she faced humiliation.",
            rituals: [
                "Tying the Rakhi thread",
                "Performing Aarti",
                "Exchanging sweets",
                "Brothers gifting sisters"
            ],
            funFact: "In 1905, poet Rabindranath Tagore used Raksha Bandhan to inspire unity between Hindus and Muslims in Bengal.",
            image: "heart.fill",
            color: .cyan,
            isLiked: false
        )
    ]

    func toggleLike(for tale: Tale) {
        if let index = tales.firstIndex(where: { $0.id == tale.id }) {
            tales[index].isLiked.toggle()
        }
    }
}
