import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var serviceCollectionView: UICollectionView!
    @IBOutlet private weak var orderCollectionView: UICollectionView!
    @IBOutlet private weak var productTableView: UITableView!
    private var serivceDataCellIndex: IndexPath? = nil
    private var controller: PhoneController?
    private var phones: [Phone]?
    
    @IBAction func refreshDataButtonTapped(_ sender: Any) {
        controller?.getPhonesData()
        phones = controller?.returnToViewPhones()
        print(phones?.count as Any)
        productTableView.reloadData()
    }
    
    let dataJSService = GetServiceData()
    let dataJSOrder = GetOrderData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureServiceCV()
        dataJSService.getData()
        dataJSOrder.getData()
        controller = PhoneController(view: self)
        controller?.getPhonesData()
    }
    
    private func configureServiceCV() {
        serviceCollectionView.dataSource = self
        serviceCollectionView.delegate = self
        serviceCollectionView.register(
            UINib(nibName: String(describing: ServiceCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: ServiceCollectionViewCell.reusedID
        )
        
        orderCollectionView.dataSource = self
        orderCollectionView.delegate = self
        orderCollectionView.register(
            UINib(nibName: String(describing: OrderCollectionViewCell.self), bundle: nil),
            forCellWithReuseIdentifier: OrderCollectionViewCell.reusedID
        )
        
        productTableView.dataSource = self
        productTableView.delegate = self
        productTableView.register(
            UINib(nibName: String(describing: ProductTableViewCell.self), bundle: nil),
            forCellReuseIdentifier: ProductTableViewCell.reusedID
        )
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == serviceCollectionView {
            return dataJSService.serviceJSData.count
        } else {
            return dataJSOrder.orderJSData.count
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == serviceCollectionView {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: ServiceCollectionViewCell.reusedID,
                for: indexPath
            ) as? ServiceCollectionViewCell else {
                fatalError()
            }
            let product = dataJSService.serviceJSData[indexPath.row]
            cell.display(item: product)
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: OrderCollectionViewCell.reusedID,
                for: indexPath
            ) as? OrderCollectionViewCell else {
                fatalError()
            }
            let category = dataJSOrder.orderJSData[indexPath.row]
            cell.display(item: category)
            return cell
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == serviceCollectionView {
            return CGSize(width: 105, height: 40)
        } else {
            return CGSize(width: 100, height: 90)
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath) {
            if collectionView == serviceCollectionView {
                guard let cell = collectionView.cellForItem(
                    at: indexPath
                ) else {
                    return
                }
                if indexPath != serivceDataCellIndex && serivceDataCellIndex != nil {
                    guard let cell = collectionView.cellForItem(
                        at: serivceDataCellIndex!
                    ) else {
                        return
                    }
                    cell.backgroundColor = .white
                }
                cell.backgroundColor = UIColor(
                    red: 0.99, green: 1.00, blue: 0.76, alpha: 1.00
                )
                serivceDataCellIndex = indexPath
            }
        }
}

extension MainViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        guard let phones = phones else {
            print("000000")
            return 0
        }
        print("Table view ds:\(phones.count)")
        return phones.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ProductTableViewCell.reusedID,
            for: indexPath
        ) as? ProductTableViewCell else {
            fatalError()
        }
        guard let phone = phones?[indexPath.row] else {
            print("Phone is nil!!")
            fatalError()
        }
        cell.display(phone: phone)
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}

//extension MainViewController: ProductCellImageDelegate {
//    func openNewImageViewController(_ item: PhoneModel) {
//        let imageVC = storyboard?.instantiateViewController(
//            withIdentifier: "productimagevc"
//        ) as! ProductImageViewController
//        imageVC.imageAtOpeningVC = UIImage(named: item.productImage)!
//        navigationController?.pushViewController(imageVC, animated: true)
//    }
//}


