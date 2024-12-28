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
    
    let toDoLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Pretendard-Regular", size: 24)
        label.text = "오늘의 할 일"
        return label
    }()
    
    
    let image1 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "N1")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let image2 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "O")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    let image3 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "N2")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let image4 : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "A")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        setUI()
    }
    
    //MARK: - function
    func setUI(){
        [titleLabel, toDoLabel,image1,image2,image3,image4].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        view.bringSubviewToFront(titleLabel) // titleLabel을 항상 위로

        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor ,constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 29),
            
            toDoLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 140 ),
            toDoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant:   26),
            
            image1.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            image1.topAnchor.constraint(equalTo: view.topAnchor, constant: 207),
            image1.widthAnchor.constraint(equalToConstant: 109),
            image1.heightAnchor.constraint(equalToConstant: 147),
            
            image2.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 132),
            image2.topAnchor.constraint(equalTo: view.topAnchor, constant: 336),
            image2.widthAnchor.constraint(equalToConstant: 98),
            image2.heightAnchor.constraint(equalToConstant: 71),

            
            image3.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -13),
            image3.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 197),
            image3.widthAnchor.constraint(equalToConstant: 99),
            image3.heightAnchor.constraint(equalToConstant: 96),
            
            image4.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -26),
            image4.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            image4.widthAnchor.constraint(equalToConstant: 100),
            image4.heightAnchor.constraint(equalToConstant: 101),
            
        ])
    }
}

