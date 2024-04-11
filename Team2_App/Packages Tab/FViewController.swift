

import UIKit
import CoreLocation

struct Activity: Codable {
    let title: String
    let imageName: String
    let address: String
    let duration: String
    let occupancy: String
    let needBooking: Bool
    let price: String
    let previousPrice: String
    // Add other properties as needed
}

struct Flight: Codable {
    let from: String
    let to: String
    let startTime: String
    let landingTime: String
    let flightNumber: String
    let duration: String
    let boardingTime: String
}

struct Hotel: Codable {
    let hotelName: String
    let occupancyNumber: Int
    let numberOfNights: Int
    let numberOfDays: Int
}

struct Place: Codable {
    let index: Int
    let name: String
    let date: String
    let imageName: String
    let departureDayLeft: String
    let activities: [Activity]
    let occupancy: String
    var flight: Flight   // Change 'let' to 'var'
    var hotel: Hotel     // Change 'let' to 'var'
}

class FViewController: UIViewController {
    @IBOutlet weak var REView: UITableView!
    private var imageCache: [String: UIImage] = [:]
    @IBOutlet weak var searchBar: UISearchBar!  // Added search bar outlet

    
    private var selectedRestaurant: Place?
    var places: [Place] = []

    override func viewDidLoad() {
        
        
        let blueColor = UIColor(red: 189/255.0, green: 235/255.0, blue: 245/255.0, alpha: 1.0)
        let pinkColor = UIColor(red: 245/255.0, green: 189/255.0, blue: 189/255.0, alpha: 1.0)
                // Create a gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [blueColor.cgColor, pinkColor.cgColor]
                
                // Adjust the startPoint and endPoint for a vertical gradient
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

                // Add the gradient layer to the view's layer
        view.layer.insertSublayer(gradientLayer, at: 0)
        super.viewDidLoad()
        searchBar?.delegate = self
        REView.delegate = self
        REView.dataSource = self
        REView.allowsSelection = true
        
        //-----
        REView.backgroundColor = .clear
        
        //----
        
        //border

        
        // Load the static data
        loadStaticData()
        REView.reloadData()
    }

    
    private func loadStaticData() {
            for (index, var place) in FViewController.staticPlaces.enumerated() {
                place.flight = FViewController.staticFlights[index]
                place.hotel = FViewController.staticHotels[index]
                self.places.append(place)
            }
        }

    
    // Static data
        static let staticPlaces: [Place] = [
            Place(index: 0, name: "Boracay", date: "01.02.2024 - 06.02.2024", imageName: "boracay", departureDayLeft: "1 Days until departure", activities: staticActivities0, occupancy:"4500", flight: staticFlights[0], hotel: staticHotels[0]),
            Place(index: 1, name: "Dominican Republic", date: "01.02.2024 - 26.02.2024", imageName: "dominican", departureDayLeft: "15 Days until departure", activities: staticActivities1, occupancy: "3000", flight: staticFlights[1], hotel: staticHotels[1]),
            Place(index: 2, name: "Ecuador", date: "11.01.2024 - 16.01.2024", imageName: "ecuador_galapagos", departureDayLeft: "1 Months until departure", activities: staticActivities2, occupancy: "3999", flight: staticFlights[2], hotel: staticHotels[2]),
            Place(index: 3, name: "Maldives", date: "15.02.2024 - 20.02.2024", imageName: "maldives", departureDayLeft: "2 Months until departure", activities: staticActivities3, occupancy: "2900", flight: staticFlights[3], hotel: staticHotels[3]),
            Place(index: 4, name: "Santorini", date: "10.03.2024 - 15.03.2024", imageName: "santorini", departureDayLeft: "1 Month until departure", activities: staticActivities4, occupancy: "2999", flight: staticFlights[4], hotel: staticHotels[4]),
            Place(index: 5, name: "Kyoto", date: "5.09.2024 - 10.09.2024", imageName: "kyoto", departureDayLeft: "10 Days until departure", activities: staticActivities5, occupancy: "3299", flight: staticFlights[5], hotel: staticHotels[5]),
            Place(index: 6, name: "Paris", date: "7.12.2023 - 12.12.2023", imageName: "paris", departureDayLeft: "2 Months until departure", activities: staticActivities6, occupancy: "5000", flight: staticFlights[6], hotel: staticHotels[6]),
            Place(index: 7, name: "Machu Picchu", date: "20.04.2024 - 25.04.2024", imageName: "machupichu", departureDayLeft: "1 Month until departure", activities: staticActivities7, occupancy: "3330", flight: staticFlights[7], hotel: staticHotels[7]),
            Place(index: 8, name: "Iceland", date: "25.04.2024 - 30.04.2024", imageName: "iceland", departureDayLeft: "1 Week until departure", activities: staticActivities8, occupancy: "3000", flight: staticFlights[8], hotel: staticHotels[8]),
            Place(index: 9, name: "Tokyo", date: "14.01.2024 - 19.01.2024", imageName: "tokyo", departureDayLeft: "1 Month until departure", activities: staticActivities9, occupancy: "5999", flight: staticFlights[9], hotel: staticHotels[9]),
            Place(index: 10, name: "Barcelona", date: "5.1.2024 - 10.1.2024", imageName: "barcelona", departureDayLeft: "2 Months until departure", activities: staticActivities11, occupancy: "3500", flight: staticFlights[10], hotel: staticHotels[10]),
            Place(index: 11, name: "Cape Town", date: "10.2.2024 - 15.2.2024", imageName: "cape_town", departureDayLeft: "1 Month until departure", activities: staticActivities12, occupancy: "4200", flight: staticFlights[11], hotel: staticHotels[11]),
            Place(index: 12, name: "Rio de Janeiro", date: "15.3.2024 - 20.3.2024", imageName: "rio_de_janeiro", departureDayLeft: "1 Week until departure", activities: staticActivities13, occupancy: "5200", flight: staticFlights[12], hotel: staticHotels[12]),
            Place(index: 13, name: "Sydney", date: "20.4.2024 - 25.4.2024", imageName: "sydney", departureDayLeft: "15 Days until departure", activities: staticActivities14, occupancy: "2800", flight: staticFlights[13], hotel: staticHotels[13]),
            Place(index: 14, name: "Marrakech", date: "25.5.2024 - 30.5.2024", imageName: "marrakech", departureDayLeft: "1 Month until departure", activities: staticActivities15, occupancy: "4500", flight: staticFlights[14], hotel: staticHotels[14]),
            Place(index: 15, name: "Bangkok", date: "30.6.2024 - 4.7.2024", imageName: "bangkok", departureDayLeft: "2 Weeks until departure", activities: staticActivities16, occupancy: "6100", flight: staticFlights[15], hotel: staticHotels[15]),
            Place(index: 16, name: "Amsterdam", date: "4.8.2024 - 9.8.2024", imageName: "amsterdam", departureDayLeft: "1 Month until departure", activities: staticActivities17, occupancy: "3200", flight: staticFlights[16], hotel: staticHotels[16]),
            Place(index: 17, name: "Hawaii", date: "9.9.2024 - 14.9.2024", imageName: "hawaii", departureDayLeft: "1 Month until departure", activities: staticActivities18, occupancy: "3700", flight: staticFlights[17], hotel: staticHotels[17]),
            Place(index: 18, name: "Prague", date: "14.10.2024 - 19.10.2024", imageName: "prague", departureDayLeft: "2 Weeks until departure", activities: staticActivities19, occupancy: "5700", flight: staticFlights[18], hotel: staticHotels[18]),
            Place(index: 19, name: "Dubai", date: "19.11.2024 - 24.11.2024", imageName: "dubai", departureDayLeft: "1 Month until departure", activities: staticActivities20, occupancy: "4800", flight: staticFlights[19], hotel: staticHotels[19]),
            Place(index: 20, name: "Vienna", date: "24.12.2024 - 29.12.2024", imageName: "vienna", departureDayLeft: "2 Weeks until departure", activities: staticActivities21, occupancy: "3900", flight: staticFlights[20], hotel: staticHotels[20]),
            Place(index: 21, name: "Seoul", date: "29.1.2025 - 5.2.2025", imageName: "seoul", departureDayLeft: "1 Month until departure", activities: staticActivities22, occupancy: "2600", flight: staticFlights[21], hotel: staticHotels[21]),
            Place(index: 22, name: "Cancun", date: "5.3.2025 - 10.3.2025", imageName: "cancun", departureDayLeft: "2 Weeks until departure", activities: staticActivities23, occupancy: "4800", flight: staticFlights[22], hotel: staticHotels[22]),
            Place(index: 23, name: "Phuket", date: "10.4.2025 - 15.4.2025", imageName: "phuket", departureDayLeft: "1 Month until departure", activities: staticActivities24, occupancy: "3500", flight: staticFlights[23], hotel: staticHotels[23]),
            Place(index: 24, name: "New Orleans", date: "15.5.2025 - 20.5.2025", imageName: "new_orleans", departureDayLeft: "2 Weeks until departure",activities: staticActivities25, occupancy: "3500", flight: staticFlights[24], hotel: staticHotels[24]),


        ]


        // Static data for activities
        static let staticActivities0 = [
            Activity(title: "SNORKLING", imageName: "snorkiling2", address: "White Beach Boracay, Lalawigan ng Aklan", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "SURFING", imageName: "snorkling", address: "Bulabog Beach, Malay, Philippines, Lalawigan ng Aklan", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$29", previousPrice: "$59"),
            Activity(title: "HORSEBACK RIDING", imageName: "horse", address: "Boracay Island, Philippines", duration: "1 Hour", occupancy: "1 Person", needBooking: true, price: "$20", previousPrice: "$25")
        ]

        static let staticActivities1 = [
            Activity(title: "ZIP LINE", imageName: "zipline", address: "Nuestra Senora de la Altagracia", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "4x4 ATV", imageName: "ATV", address: "Bavaro Racing, Tours Point", duration: "8 Hours", occupancy: "2 People", needBooking: true, price: "$99", previousPrice: "$149"),
            Activity(title: "PARASAILING", imageName: "parasailing", address: "Bavaro Beach, Punta Cana", duration: "1 Hour", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$75")
        ]

        static let staticActivities2 = [
            Activity(title: "BIRD WATCHING", imageName: "birdwatching", address: "Galápagos Islands, Ecuador", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "SNORKLING", imageName: "snorkiling2", address: "Tortuga Bay, Ecuador", duration: "8 Hours", occupancy: "2 People", needBooking: true, price: "$49", previousPrice: "$79"),
            Activity(title: "KAYAKING", imageName: "kayaking", address: "Isabela Island, Galápagos", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$50")
        ]
        static let staticActivities3 = [
            Activity(title: "SCUBA DIVING", imageName: "snorkling", address: "Maldives Dive Club, Maldives", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$89", previousPrice: "$109"),
            Activity(title: "SNORKELING", imageName: "snorkiling2", address: "Maldives Coral Reef, Maldives", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "WATER SPORTS", imageName: "watersports", address: "Maldives Beach, Maldives", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$79", previousPrice: "$99")
        ]

        static let staticActivities4 = [
            Activity(title: "SUNSET CRUISE", imageName: "sunsetcruise", address: "Santorini Caldera, Santorini", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$59", previousPrice: "$79"),
            Activity(title: "WINE TASTING", imageName: "winetasting", address: "Santorini Winery, Santorini", duration: "1 Hour", occupancy: "2 People", needBooking: true, price: "$29", previousPrice: "$39"),
            Activity(title: "HISTORICAL TOUR", imageName: "santoriniwindmills", address: "Ancient Santorini Windmills, Santorini", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$49", previousPrice: "$59")
        ]

        static let staticActivities5 = [
            Activity(title: "TEMPLE VISIT", imageName: "templevisit", address: "Kinkaku-ji, Kyoto", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "SUSHI MAKING", imageName: "sushimaking", address: "Kyoto Sushi School, Kyoto", duration: "1.5 Hours", occupancy: "2 People", needBooking: true, price: "$39", previousPrice: "$49"),
            Activity(title: "BAMBOO FOREST", imageName: "bambooforest", address: "Arashiyama Bamboo Grove, Kyoto", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0")
        ]

        static let staticActivities6 = [
            Activity(title: "EIFFEL TOWER", imageName: "Tour_eiffel_paris-eiffel_tower", address: "Eiffel Tower, Paris", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$29", previousPrice: "$39"),
            Activity(title: "LOUVRE MUSEUM", imageName: "louvremuseum", address: "Louvre Museum, Paris", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$39", previousPrice: "$49"),
            Activity(title: "SEINE CRUISE", imageName: "seinecruiseparis", address: "Seine River, Paris", duration: "1.5 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$35")
        ]

        static let staticActivities7 = [
            Activity(title: "MACHU PICCHU TOUR", imageName: "machupichutour", address: "Machu Picchu, Peru", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$79", previousPrice: "$99"),
            Activity(title: "INCA TRAIL HIKE", imageName: "inca-trail", address: "Inca Trail, Peru", duration: "8 Hours", occupancy: "2 People", needBooking: true, price: "$89", previousPrice: "$109"),
            Activity(title: "LLAMA FARM VISIT", imageName: "llamas2", address: "Sacred Valley, Peru", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$45", previousPrice: "$55")
        ]

        static let staticActivities8 = [
            Activity(title: "GOLDEN CIRCLE TOUR", imageName: "golden-circle", address: "Golden Circle, Iceland", duration: "6 Hours", occupancy: "2 People", needBooking: true, price: "$69", previousPrice: "$89"),
            Activity(title: "BLUE LAGOON SPA", imageName: "blue-lagoon", address: "Blue Lagoon, Iceland", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$49", previousPrice: "$59"),
            Activity(title: "NORTHERN LIGHTS TOUR", imageName: "northern-lights", address: "Iceland Wilderness", duration: "5 Hours", occupancy: "2 People", needBooking: true, price: "$79", previousPrice: "$99")
        ]

        static let staticActivities9 = [
            Activity(title: "TSUKIJI FISH MARKET", imageName: "fishmarket", address: "Tsukiji Market, Tokyo", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0"),
            Activity(title: "SUMO MATCH", imageName: "sumo wrestling", address: "Ryogoku Kokugikan, Tokyo", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$59", previousPrice: "$69"),
            Activity(title: "MEIJI SHRINE VISIT", imageName: "Meiji-Shrine", address: "Meiji Shrine, Tokyo", duration: "2 Hours", occupancy: "2 People", needBooking: false, price: "$0", previousPrice: "$0")
        ]
        
        static let staticActivities11 = [
            Activity(title: "Sagrada Família Tour", imageName: "parasailing", address: "Barcelona, Spain", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$45"),
            Activity(title: "Park Güell Visit", imageName: "blue-lagoon", address: "Barcelona, Spain", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "Barcelona Gothic Quarter Walk", imageName: "santoriniwindmills", address: "Barcelona, Spain", duration: "2.5 Hours", occupancy: "2 People", needBooking: true, price: "$20", previousPrice: "$25")
        ]

        static let staticActivities12 = [
            Activity(title: "Table Mountain Hike", imageName: "llamas2", address: "Cape Town, South Africa", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$50"),
            Activity(title: "Robben Island Tour", imageName: "snorkling", address: "Cape Town, South Africa", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
            Activity(title: "Cape Winelands Tour", imageName: "fishmarket", address: "Cape Town, South Africa", duration: "5 Hours", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$60")
        ]

        static let staticActivities13 = [
            Activity(title: "Corcovado Mountain Visit", imageName: "Meiji-Shrine", address: "Rio de Janeiro, Brazil", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$50"),
            Activity(title: "Rio Night Market Tour", imageName: "zipline", address: "Rio de Janeiro, Brazil", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "Botanical Garden Walk", imageName: "templevisit", address: "Rio de Janeiro, Brazil", duration: "1.5 Hours", occupancy: "2 People", needBooking: true, price: "$20", previousPrice: "$25")
        ]

        static let staticActivities14 = [
            Activity(title: "Sydney Opera House Tour", imageName: "golden-circle", address: "Sydney, Australia", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$60"),
            Activity(title: "Bondi Beach Surfing Lesson", imageName: "northern-lights", address: "Sydney, Australia", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$55", previousPrice: "$65"),
            Activity(title: "Blue Mountains Hiking", imageName: "machupichutour", address: "Sydney, Australia", duration: "5 Hours", occupancy: "2 People", needBooking: true, price: "$70", previousPrice: "$80")
        ]

        static let staticActivities15 = [
            Activity(title: "Jardin Majorelle Tour", imageName: "sunsetcruise", address: "Marrakech, Morocco", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "Medina Shopping Experience", imageName: "sushimaking", address: "Marrakech, Morocco", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$20", previousPrice: "$25"),
            Activity(title: "Traditional Moroccan Cooking Class", imageName: "snorkling", address: "Marrakech, Morocco", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$50")
        ]

        static let staticActivities16 = [
            Activity(title: "Grand Palace Tour", imageName: "parasailing", address: "Bangkok, Thailand", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$40"),
            Activity(title: "Chao Phraya River Cruise", imageName: "santoriniwindmills", address: "Bangkok, Thailand", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
            Activity(title: "Wat Arun Temple Visit", imageName: "seinecruiseparis", address: "Bangkok, Thailand", duration: "2.5 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30")
        ]

        static let staticActivities17 = [
            Activity(title: "Van Gogh Museum Tour", imageName: "llamas2", address: "Amsterdam, Netherlands", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
            Activity(title: "Anne Frank House Visit", imageName: "zipline", address: "Amsterdam, Netherlands", duration: "1.5 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "Canal Cruise", imageName: "blue-lagoon", address: "Amsterdam, Netherlands", duration: "1 Hour", occupancy: "2 People", needBooking: true, price: "$20", previousPrice: "$25"),
        ]

        static let staticActivities18 = [
            Activity(title: "Hiking at Waimea Canyon", imageName: "sumo wrestling", address: "Kauai, Hawaii", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$50"),
            Activity(title: "Surfing Lessons at Waikiki Beach", imageName: "Meiji-Shrine", address: "Oahu, Hawaii", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$60"),
            Activity(title: "Snorkeling at Molokini Crater", imageName: "blue_mountains", address: "Maui, Hawaii", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$45", previousPrice: "$55"),
        ]

        static let staticActivities19 = [
            Activity(title: "Prague Castle Guided Tour", imageName: "northern-lights", address: "Prague, Czech Republic", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$45"),
            Activity(title: "Charles Bridge Exploration", imageName: "santoriniwindmills", address: "Prague, Czech Republic", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "Old Town Square Visit", imageName: "zipline", address: "Prague, Czech Republic", duration: "1.5 Hours", occupancy: "2 People", needBooking: true, price: "$20", previousPrice: "$25"),
        ]

        static let staticActivities20 = [
            Activity(title: "Burj Khalifa Observation Deck", imageName: "templevisit", address: "Dubai, UAE", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$60"),
            Activity(title: "Desert Safari Adventure", imageName: "snorkiling2", address: "Dubai, UAE", duration: "5 Hours", occupancy: "2 People", needBooking: true, price: "$80", previousPrice: "$90"),
            Activity(title: "Dubai Mall Shopping Spree", imageName: "seinecruiseparis", address: "Dubai, UAE", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$45", previousPrice: "$55"),
        ]

            
        static let staticActivities21 = [
            Activity(title: "Schönbrunn Palace Tour", imageName: "seinecruiseparis", address: "Vienna, Austria", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$40"),
            Activity(title: "Vienna State Opera House Visit", imageName: "zipline", address: "Vienna, Austria", duration: "2.5 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
            Activity(title: "St. Stephen's Cathedral Exploration", imageName: "santoriniwindmills", address: "Vienna, Austria", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
        ]

        static let staticActivities22 = [
            Activity(title: "Gyeongbokgung Palace Tour", imageName: "sydney_opera_house", address: "Seoul, South Korea", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$45"),
            Activity(title: "N Seoul Tower Visit", imageName: "golden-circle", address: "Seoul, South Korea", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$40"),
            Activity(title: "Bukchon Hanok Village Walk", imageName: "parasailing", address: "Seoul, South Korea", duration: "2.5 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
        ]

        static let staticActivities23 = [
            Activity(title: "Chichen Itza Tour", imageName: "blue_mountains", address: "Cancun, Mexico", duration: "6 Hours", occupancy: "2 People", needBooking: true, price: "$60", previousPrice: "$70"),
            Activity(title: "Snorkeling at Isla Mujeres", imageName: "templevisit", address: "Cancun, Mexico", duration: "4 Hours", occupancy: "2 People", needBooking: true, price: "$45", previousPrice: "$50"),
            Activity(title: "Cancun Underwater Museum Dive", imageName: "snorkling", address: "Cancun, Mexico", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$50", previousPrice: "$55"),
        ]

        static let staticActivities24 = [
            Activity(title: "Phi Phi Islands Tour", imageName: "machupichutour", address: "Phuket, Thailand", duration: "8 Hours", occupancy: "2 People", needBooking: true, price: "$70", previousPrice: "$80"),
            Activity(title: "Big Buddha Visit", imageName: "james_bond_island", address: "Phuket, Thailand", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$25", previousPrice: "$30"),
            Activity(title: "James Bond Island Excursion", imageName: "sunsetcruise", address: "Phuket, Thailand", duration: "6 Hours", occupancy: "2 People", needBooking: true, price: "$60", previousPrice: "$70"),
        ]

        static let staticActivities25 = [
            Activity(title: "French Quarter Stroll", imageName: "northern-lights", address: "New Orleans, USA", duration: "3 Hours", occupancy: "2 People", needBooking: true, price: "$40", previousPrice: "$45"),
            Activity(title: "Steamboat Natchez Jazz Cruise", imageName: "sydney_opera_house", address: "New Orleans, USA", duration: "2.5 Hours", occupancy: "2 People", needBooking: true, price: "$35", previousPrice: "$40"),
            Activity(title: "Mardi Gras World Tour", imageName: "Meiji-Shrine", address: "New Orleans, USA", duration: "2 Hours", occupancy: "2 People", needBooking: true, price: "$30", previousPrice: "$35"),
        ]


        
     
        

        // Static data for flights
        static let staticFlights: [Flight] = [
            Flight(
                from: "New York",
                to: "Boracay",
                startTime: "10:00 AM",
                landingTime: "03:00 PM",
                flightNumber: "BA456",
                duration: "14 Hours",
                boardingTime: "08:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Dominican Republic",
                startTime: "08:00 AM",
                landingTime: "04:30 PM",
                flightNumber: "DL789",
                duration: "10 Hours",
                boardingTime: "06:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Ecuador",
                startTime: "12:30 PM",
                landingTime: "09:00 PM",
                flightNumber: "EJ321",
                duration: "15 Hours",
                boardingTime: "11:00 AM"
            ),
            Flight(
                    from: "New York",
                    to: "Maldives",
                    startTime: "09:30 AM",
                    landingTime: "06:30 PM",
                    flightNumber: "ML432",
                    duration: "16 Hours",
                    boardingTime: "08:00 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Santorini",
                    startTime: "11:00 AM",
                    landingTime: "06:30 PM",
                    flightNumber: "SA567",
                    duration: "12 Hours",
                    boardingTime: "09:30 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Kyoto",
                    startTime: "08:30 AM",
                    landingTime: "04:00 PM",
                    flightNumber: "KA345",
                    duration: "14 Hours",
                    boardingTime: "07:00 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Paris",
                    startTime: "07:00 AM",
                    landingTime: "03:30 PM",
                    flightNumber: "PA789",
                    duration: "9 Hours",
                    boardingTime: "05:30 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Machu Picchu",
                    startTime: "10:30 AM",
                    landingTime: "06:30 PM",
                    flightNumber: "MP456",
                    duration: "12 Hours",
                    boardingTime: "09:00 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Iceland",
                    startTime: "12:00 PM",
                    landingTime: "07:30 PM",
                    flightNumber: "IC789",
                    duration: "9 Hours",
                    boardingTime: "10:30 AM"
                ),
                Flight(
                    from: "New York",
                    to: "Tokyo",
                    startTime: "10:00 AM",
                    landingTime: "03:00 PM",
                    flightNumber: "TO123",
                    duration: "14 Hours",
                    boardingTime: "08:30 AM"
                ),
            Flight(
                from: "New York",
                to: "Barecolena",
                startTime: "10:00 AM",
                landingTime: "03:00 PM",
                flightNumber: "BO123",
                duration: "14 Hours",
                boardingTime: "08:30 AM"
            ),
            
           Flight(
                from: "New York",
                to: "Cape Town",
                startTime: "08:00 AM",
                landingTime: "09:00 PM",
                flightNumber: "CT789",
                duration: "20 Hours",
                boardingTime: "06:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Rio de Janeiro",
                startTime: "09:30 AM",
                landingTime: "08:00 PM",
                flightNumber: "RJ321",
                duration: "16.5 Hours",
                boardingTime: "08:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Sydney",
                startTime: "11:00 AM",
                landingTime: "09:30 PM",
                flightNumber: "SD456",
                duration: "18.5 Hours",
                boardingTime: "09:30 AM"
            )
            ,Flight(
                from: "New York",
                to: "Marrakech",
                startTime: "10:30 AM",
                landingTime: "09:00 PM",
                flightNumber: "MR987",
                duration: "14.5 Hours",
                boardingTime: "09:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Bangkok",
                startTime: "12:00 PM",
                landingTime: "01:30 AM",
                flightNumber: "BK567",
                duration: "17.5 Hours",
                boardingTime: "10:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Amsterdam",
                startTime: "11:30 AM",
                landingTime: "04:30 AM",
                flightNumber: "AM678",
                duration: "15 Hours",
                boardingTime: "10:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Hawaii",
                startTime: "09:00 AM",
                landingTime: "03:30 PM",
                flightNumber: "HW789",
                duration: "12.5 Hours",
                boardingTime: "07:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Prague",
                startTime: "08:30 AM",
                landingTime: "02:00 PM",
                flightNumber: "PR432",
                duration: "11.5 Hours",
                boardingTime: "07:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Dubai",
                startTime: "10:30 AM",
                landingTime: "09:00 PM",
                flightNumber: "DB876",
                duration: "14.5 Hours",
                boardingTime: "09:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Vienna",
                startTime: "07:00 AM",
                landingTime: "01:30 PM",
                flightNumber: "VN654",
                duration: "11.5 Hours",
                boardingTime: "06:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Seoul",
                startTime: "08:00 AM",
                landingTime: "05:00 PM",
                flightNumber: "SL321",
                duration: "14 Hours",
                boardingTime: "06:30 AM"
            ),
            Flight(
                from: "New York",
                to: "Cancun",
                startTime: "11:30 AM",
                landingTime: "06:30 PM",
                flightNumber: "CC543",
                duration: "14 Hours",
                boardingTime: "10:00 AM"
            ),
            Flight(
                from: "New York",
                to: "Phuket",
                startTime: "09:00 AM",
                landingTime: "09:00 PM",
                flightNumber: "PT876",
                duration: "17.5 Hours",
                boardingTime: "07:30 AM"
            ),
            Flight(
                from: "New York",
                to: "New Orleans",
                startTime: "10:30 AM",
                landingTime: "03:00 PM",
                flightNumber: "NO987",
                duration: "13.5 Hours",
                boardingTime: "09:00 AM"
            )


        ]

        // Static data for hotels
        static let staticHotels: [Hotel] = [
            Hotel(
                hotelName: "Luxury Beach Resort",
                occupancyNumber: 2,
                numberOfNights: 7,
                numberOfDays: 8
            ),
            Hotel(
                hotelName: "Tropical Paradise Hotel",
                occupancyNumber: 3,
                numberOfNights: 26,
                numberOfDays: 27
            ),
            Hotel(
                hotelName: "Galápagos Luxury Lodge",
                occupancyNumber: 4,
                numberOfNights: 6,
                numberOfDays: 7
            ),
                Hotel(
                    hotelName: "Oceanfront Villa",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                ),
                Hotel(
                    hotelName: "Santorini Cliffside",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                ),
                Hotel(
                    hotelName: "Traditional Ryokan",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                ),
                Hotel(
                    hotelName: "Elegant Parisian Hotel",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                ),
                Hotel(
                    hotelName: "Machu Lodge",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                ),
                Hotel(
                    hotelName: "Icelandic Cabin",
                    occupancyNumber: 2,
                    numberOfNights: 5,
                    numberOfDays: 6
                    ),
            Hotel(
                hotelName: "Wilderness Resort",
                occupancyNumber: 4,
                numberOfNights: 7,
                numberOfDays: 8
            ),
            Hotel(
                hotelName: "Barcelona Beach Resort",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Cape Town Luxury Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Rio de Janeiro Beach Resort",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Sydney Harbor Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Marrakech Oasis Resort",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Bangkok Riverside Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Amsterdam City Center Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Hawaii Beachfront Resort",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Prague Old Town Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Dubai Luxury Oasis",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Vienna City Center Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Seoul Downtown Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Cancun Beach Resort",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "Phuket Oceanfront Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            ),
            Hotel(
                hotelName: "New Orleans French Quarter Hotel",
                occupancyNumber: 2,
                numberOfNights: 5,
                numberOfDays: 6
            )

        ]
}

extension FViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    @objc func bookNowButtonTapped(_ sender: UIButton) {
        let index = sender.tag
        if index < places.count {
            let place = places[index]
            if let encodedData = try? JSONEncoder().encode(place) {
                UserDefaults.standard.set(encodedData, forKey: "myDataKey")
            }
            
            let sViewController = storyboard?.instantiateViewController(withIdentifier: "Sview") as? SViewController
            
            if let sViewController = sViewController {
                sViewController.selectedPlace = place
                navigationController?.pushViewController(sViewController, animated: true)
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = REView.dequeueReusableCell(withIdentifier: "cells") as! CustomCell
        cell.layer.cornerRadius = 10  // Set corner radius to make the cell rounded
        cell.layer.masksToBounds = true  // Clip subviews to the rounded shape
        
        //-----------
        cell.backgroundColor = UIColor.clear

        let place = places[indexPath.row]
            cell.deal1.text = "\(place.occupancy)$"
            cell.logo1.image = UIImage(named: place.imageName)
            cell.city.text = place.name
            cell.dates.text = place.date
     
        



                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd.MM.yyyy"

                // Assuming place.date is a string in the format "15.12.2020 - 20.12.2020"
            let placeDateString = place.date

                // Extract the first date from the place.date string
                if let firstDateString = placeDateString.components(separatedBy: " - ").first {
                    if let firstDate = dateFormatter.date(from: firstDateString) {
                        let today = Date()
                        let calendar = Calendar.current

                        // Calculate the difference between today's date and the first date
                        let difference = calendar.dateComponents([.day, .month], from: today, to: firstDate)

                        if let daysLeft = difference.day, let monthsLeft = difference.month {
                            if monthsLeft == 0 && daysLeft > 0 {
                                if daysLeft <= 31 {
                                    cell.deptdays.text = "\(daysLeft) Days left until departure"
                                } else {
                                    cell.deptdays.text = "1 month until departure"
                                }
                            } else if monthsLeft > 0 {
                                cell.deptdays.text = "\(monthsLeft) Months until departure"
                            } else {
                                cell.deptdays.text = "Departure date passed"
                            }
                        } else {
                            print("Date error")
                        }
                    } else {
                        print("Invalid date")
                    }
                } else {
                    print("Date format error")
                }

        
        
//            cell.deptdays.text = place.departureDayLeft
            cell.bookNow.tag = indexPath.row
            cell.bookNow.addTarget(self, action: #selector(bookNowButtonTapped(_:)), for: .touchUpInside)

            cell.accessoryType = .none

            // Resize the label dynamically based on the content
            cell.city.sizeToFit()

        
        //cell.accessoryType = .none
        ////dddfborder/
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.borderWidth = 0.5

        

        // Add spacing by setting the cell's top margin
        cell.frame = cell.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10))

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }
    

}

extension FViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Filter the places based on the search text
        let filteredPlaces = searchText.isEmpty ? FViewController.staticPlaces : FViewController.staticPlaces.filter { place in
            return place.name.lowercased().contains(searchText.lowercased())
        }
        
        // Update the table view with the filtered data
        places = filteredPlaces
        REView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
