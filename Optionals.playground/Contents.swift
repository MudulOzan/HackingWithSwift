import UIKit

func getHaterStatus(weather: String) -> String? {
    if weather == "sunny" {
        return nil
    } else {
        return "Hate"
    }
}

var status = getHaterStatus(weather: "rainy")

func takeHaterAction(status: String) {
    if status == "Hate" {
        print("Hating")
    }
}

if let haterStatus = getHaterStatus(weather: "sa") {
    takeHaterAction(status: haterStatus)
}


enum WeatherType {
        case sun
    case cloud
    case rain
    case wind
    case snow
}

func getHaterStatus(weather: WeatherType) -> String? {
    if weather == .sun
    {
        return nil
    }
    else {
        return "Hate"
    }
}

getHaterStatus(weather: .cloud)
