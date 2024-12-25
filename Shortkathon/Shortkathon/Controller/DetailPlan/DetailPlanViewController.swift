import UIKit

class DetailPlanViewController : UIViewController {
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2128768861, green: 0.2128768861, blue: 0.2128768861, alpha: 1)
        
        configureNavigationBar()
        
        setUI()
    }
    
    func configureNavigationBar(){
        navigationItem.title = "새로운 일 분류"
        
        let customButton = UIButton(type: .system)
        customButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        customButton.setTitle(" 생성", for: .normal)
        customButton.tintColor = #colorLiteral(red: 1, green: 0.3735775948, blue: 0.3423727155, alpha: 1)
        customButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)

        let backButton = UIBarButtonItem(customView: customButton)
        navigationItem.leftBarButtonItem = backButton
        
        
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
        doneButton.tintColor = #colorLiteral(red: 0.6817840338, green: 0.6817839742, blue: 0.6817840338, alpha: 1)
        navigationItem.rightBarButtonItem = doneButton
    }

    func setUI(){
        
    }
    
    
    @objc func backButtonTapped(){
        print("뒤로가기")
        navigationController?.popViewController(animated: true)
    }
    
    
    @objc func doneButtonTapped(){
       print("완료")
        
    }
}
