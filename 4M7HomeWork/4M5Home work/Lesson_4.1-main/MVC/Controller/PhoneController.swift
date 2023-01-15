import UIKit

class PhoneController {
    
    private var view: MainViewController!
    private var model: PhoneModel?
    var productsTableView: UITableView?
    
    init(view: MainViewController!) {
        self.view = view
        model = PhoneModel(controller: self)
    }
    
    var phones: [Phone]?
    func getPhonesData () {
        model?.getPhoneData()
        print("get phones data in controller")
        phones = model?.phones
    }
    func returnToViewPhones() -> [Phone]? {
        return phones
    }
}



