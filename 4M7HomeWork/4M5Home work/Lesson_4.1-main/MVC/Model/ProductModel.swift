import Foundation

struct Phones: Codable {
    var products: [Phone]
}

struct Phone: Codable {
    let title: String
    let thumbnail: String
    let category: String
    let brand: String
    let price: Int
    let stock: Int
    let rating: Double
    let discountPercentage: Double
    let description: String
}

class PhoneModel {
    private weak var controller: PhoneController?
    
    init(controller: PhoneController?) {
        self.controller = controller
    }
    
    var phones: [Phone]?
    private let networkManager = NetworkManager()
    
    func getPhoneData() {
        networkManager.fetchData { result in
            print("completion handler in model nm")
            switch result {
            case .success(let phonesData):
                print(phonesData)
                self.phones = phonesData.products
                print("Got \(self.phones?.count ?? 0) data")
            case .failure(let error):
                print("Error in completion handler in model: \(error.localizedDescription).")
            }
        }
       print("Model print")
    }
}
