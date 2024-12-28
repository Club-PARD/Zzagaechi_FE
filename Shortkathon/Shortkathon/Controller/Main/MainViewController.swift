import UIKit

class MainViewController : UIViewController {
    //MARK: - property
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Medium", size: 35)
        label.text = "작은 한 걸음이\n큰 변화를 만듭니다,\n오늘도 파이팅!"
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        setUI()
    }
    
    //MARK: - function
    func setUI(){
        [titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ,constant: 75),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29),
        ])
    }
}

