import UIKit
import AuthenticationServices
import Network

class AppleLoginViewController: UIViewController {
    //MARK: - Property
    var user : String?
    
    let mainImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "nano")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        return image
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "할 일을 미루지 말고, 나노로 나눠봐!"
        label.font = UIFont(name: "Pretendard-Regular", size: 17)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let signInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton(authorizationButtonType: .signIn, authorizationButtonStyle: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.tintColor = .black
        button.layer.cornerRadius = 22.5
        button.clipsToBounds = true
        return button
    }()
    
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2128768861, green: 0.2128768861, blue: 0.2128768861, alpha: 1)
    
        if #available(iOS 14.0, *) {
            let monitor = NWPathMonitor()
            monitor.pathUpdateHandler = { path in
                if path.status == .satisfied {
                    print("로컬 네트워크 접근 가능")
                } else {
                    print("로컬 네트워크 접근 불가")
                }
            }
            let queue = DispatchQueue(label: "LocalNetworkMonitor")
            monitor.start(queue: queue)
        }
        
        
        checkLoginStatus()
        print("1번")
        postLoginRequest(with: "1" )
        setUI()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
    
    //MARK: - Functions
    // 로그인 상태 확인
    private func checkLoginStatus() {
        if let  savedUser = UserDefaults.standard.string(forKey: "userIdentifier") {
            // 저장된 userIdentifier가 있다면 메인 화면으로 이동
            navigateToMainPage(with: savedUser)
        }
    }
    
    // 애플 로그인 버튼 클릭
    @objc func didTapSignIn() {
        print("애플 로그인 실행")
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email] // 사용자 이름 및 이메일 요청
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
    // UI 설정
    private func setUI() {
        view.addSubview(mainImage)
        view.addSubview(titleLabel)
        view.addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            mainImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            mainImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
            mainImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 353),
            
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.topAnchor.constraint(equalTo: mainImage.bottomAnchor, constant: 26.1),
            
            signInButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 178),
            signInButton.widthAnchor.constraint(equalToConstant: 271),
            signInButton.heightAnchor.constraint(equalToConstant: 45),
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
    }
    
    // 메인 화면으로 이동
    private func navigateToMainPage(with userIdentifier: String?) {
        let mainVC = ViewController()
        mainVC.modalPresentationStyle = .fullScreen
        guard let userIdentifier = userIdentifier else { return }
//        mainVC.uid = userIdentifier
        
        self.present(mainVC, animated: true, completion: nil)
        
    }
}

//MARK: - AppleLogin extension
extension AppleLoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            let userIdentifier = appleIDCredential.user
            print("✅userIdentifier: \(userIdentifier)")
            print("2번")
            
            postLoginRequest(with: userIdentifier)
            saveUserIdentifier(user: userIdentifier)
            navigateToMainPage(with: userIdentifier)
            
      
        default:
            break
        }
    }
    
    //로그인 성공시 user 저장
    func saveUserIdentifier(user: String) {
        UserDefaults.standard.set(user, forKey: "userIdentifier")
        UserDefaults.standard.synchronize()
    }
    
    //로그인 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
    }
    
}


//MARK: - 서버 통신
extension AppleLoginViewController{
    func postLoginRequest(with uid: String) {
        let parameters = ["uid": uid]
        
        APIService.shared.post(endpoint: "/auth/login", parameters: parameters) { (result: Result<APIResponse, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                   
                        print("✅ 로그인 성공")
                        UserDefaults.standard.set(uid, forKey: "userIdentifier")
                        // 메인 페이지로 이동하는 코드는 별도의 메서드로 분리하여 처리
//                        NotificationCenter.default.post(name: NSNotification.Name("LoginSuccess"), object: nil)
//                        print("⚠️ 로그인 실패")
                    
                case .failure(let error):
                    print("❌ 로그인 요청 실패: \(error.localizedDescription)")
                }
            }
        }
        
    }
}
