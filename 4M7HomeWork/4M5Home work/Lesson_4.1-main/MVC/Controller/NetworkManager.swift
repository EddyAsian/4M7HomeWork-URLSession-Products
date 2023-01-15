import Foundation


class NetworkManager {
    
    func fetchData (completion: @escaping (Result<Phones, Error>) -> Void) {
        let urlPath: String = "https://dummyjson.com/products"
        guard let url = URL(string: urlPath) else {
            print("nil while creating a url!")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: urlRequest) { data, response, error in
            
            guard let data = data else {
                print("Data is nil!!")
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    print("Success. Status code: 200")
                } else {
                    print("Got unexpected status code. Status code: \(httpResponse.statusCode)")
                }
            }
            guard error == nil else {
                print("Error occured! Description: \(error!.localizedDescription)")
                return
            }
            let decoder = JSONDecoder()
            
            do {
                let phonesData = try decoder.decode(Phones.self, from: data)
                completion(.success(phonesData))
            } catch {
                print("Error occured while trying to fetch data: \(error.localizedDescription).")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

