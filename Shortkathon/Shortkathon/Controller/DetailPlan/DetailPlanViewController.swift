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
        
        let backButton = UIBarButtonItem(
            title: "생성",
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem = backButton
        
        // 오른쪽 버튼 설정 (완료)
        let doneButton = UIBarButtonItem(
            title: "완료",
            style: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
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
