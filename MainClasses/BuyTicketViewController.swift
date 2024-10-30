import UIKit

class BuyTicketViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var tableviewnew: UITableView!
    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var countLable: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    var counterValues = [Int]()
    var totalTicketCost = 0.0
    var selectedProducts = [Int: List]()
    var anotherArray : [BuyTicket] = []
    static var productData: BuyTicket?
    var successHandler: ((Bool, [String: Any]?) -> Void)?
    var failureHandler: ((Bool, [String: Any]?) -> Void)?
    var window: UIWindow?

    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        selectedProducts.removeAll()
        totalTicketCost = 0.0
        purchaseBtn.layer.cornerRadius = purchaseBtn.frame.height / 2
        self.purchaseBtn.isHidden = true
        tableviewnew.register(UINib(nibName: "BottomSheetProductCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "BottomSheetProductCell")
        if let productCount = BuyTicketViewController.productData?.list.count {
            counterValues = Array(repeating: 0, count: productCount)
        }
        print("ZIG-SDK===>", BuyTicketViewController.productData as Any)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.tableviewnew.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BuyTicketViewController.productData?.list.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BottomSheetProductCell", for: indexPath) as? BottomSheetProductCell else {
            return UITableViewCell()
        }

        guard let data = BuyTicketViewController.productData?.list[indexPath.row] else {
            return cell
        }

        cell.fareAmount.text = "$\(data.ProductCost ?? 0.0)0"
        cell.ticketName.text = data.RouteName
        cell.ticketDescription.text = data.ProductDescription
        cell.amountLable.text = "\(counterValues[indexPath.row])"

        loadImage(from: data.BannerImage ?? "") { [weak self] image in
            guard let self = self else { return }
            cell.ticketImage.image = image ?? UIImage(named: "defaultImage")
        }

        loadImage(from: data.ProductImageURL ?? "") { [weak self] image in
            guard let self = self else { return }
            cell.ticketIcon.image = image ?? UIImage(named: "defaultIcon")
        }

        cell.decAction = {
            if self.counterValues[indexPath.row] > 0 {
                self.counterValues[indexPath.row] -= 1
                cell.amountLable.text = "\(self.counterValues[indexPath.row])"
                self.totalTicketCost -= data.ProductCost ?? 0.0
                self.countLable.text = "$\(self.totalTicketCost)"
                self.purchaseBtn.isHidden = self.totalTicketCost <= 0

                if self.counterValues[indexPath.row] == 0 {
                    self.selectedProducts.removeValue(forKey: indexPath.row)
                }
            }
        }

        cell.incAction = {
            self.counterValues[indexPath.row] += 1
            cell.amountLable.text = "\(self.counterValues[indexPath.row])"

            self.totalTicketCost += data.ProductCost ?? 0.0
            self.countLable.text = "$\(self.totalTicketCost)"
            self.purchaseBtn.isHidden = self.totalTicketCost <= 0

            
            if self.counterValues[indexPath.row] == 1 {
                self.selectedProducts[indexPath.row] = data // Store the product data
            }
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    @IBAction func BackAction(_ sender: Any) {
        self.dismiss(animated: true)
    }

    @IBAction func purchaseAction(_ sender: Any) {
      //  AddTicketClasee().addTicketMethod(TicketObject: selectedProducts, TotalTicketCost: <#T##String#>, completion: <#T##(Bool, String) -> Void#>)
        print("Selected Products: \(selectedProducts)")
        print("Total Ticket Cost: \(totalTicketCost)")
    }

    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            completion(nil)
            return
        }

        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image)
                }
            } else {
                print("Error loading image: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }.resume()
    }
}
