import UIKit


class ViewController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 1)
        // 커스텀 탭바 설정
        let customTabBar = CustomTabBar()
        setValue(customTabBar, forKey: "tabBar")
        self.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTabbar()
        self.selectedIndex = 0
    }
    
    func setTabbar() {
        let vc1 = UINavigationController(rootViewController: MainViewController())
        let vc2 = UINavigationController(rootViewController: SeparateTaskViewController())
        let vc3 = CalendarViewController()
        
        self.viewControllers = [vc1, vc2, vc3]
        
        // 탭바 아이템 색상 설정
        self.tabBar.tintColor = .white  // 선택된 아이템 색상
        self.tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템 색상
        
        guard let tabBarItem = self.tabBar.items else { return }
        
        // 탭바 아이템 설정
        tabBarItem[0].image = UIImage(named: "home")
        tabBarItem[1].image = UIImage(named: "plus")
        tabBarItem[2].image = UIImage(named: "calender")
        
        tabBarItem[0].title = "홈"
        tabBarItem[1].title = "추가"
        tabBarItem[2].title = "캘린더"
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
      
           // 가운데 탭(인덱스 1)이 선택되었을 때
           if viewControllers?.firstIndex(of: viewController) == 1 {
               // 모달 표시
               let modalVC = SeparateTaskViewController()  // 여기에 실제 모달 뷰컨트롤러를 생성
               let navigationController = UINavigationController(rootViewController: modalVC)
               
               navigationController.modalPresentationStyle = .pageSheet

               
               if let sheet = navigationController.sheetPresentationController {
                   sheet.detents = [.medium()]
                   sheet.prefersGrabberVisible = true
               }

               present(navigationController, animated: true, completion: nil)
               return false  // 탭 선택을 막음
           }
           
           return true  // 다른 탭은 정상적으로 선택
       }
}
