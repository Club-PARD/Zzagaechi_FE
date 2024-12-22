import UIKit
import AuthenticationServices

class AppleLoginViewController: UIViewController {
    var user : String?
    private let signInButton: ASAuthorizationAppleIDButton = {
        let button = ASAuthorizationAppleIDButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - main
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 로그인 상태 확인
        checkLoginStatus()
        
        // UI 설정
        setUI()
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
    }
    
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
        view.addSubview(signInButton)
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    // 메인 화면으로 이동
    private func navigateToMainPage(with userIdentifier: String?) {
        let mainVC = MainPageViewController()
        mainVC.modalPresentationStyle = .fullScreen
        guard let userIdentifier = userIdentifier else { return }
        mainVC.uid = userIdentifier
        
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
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if let authorizationCode = appleIDCredential.authorizationCode,
               let identityToken = appleIDCredential.identityToken,
               let authCodeString = String(data: authorizationCode, encoding: .utf8),
               let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("----------")
                print("identityToken: \(identityToken)")
                print("----------\n")
                print("authCodeString: \(authCodeString)")
                print("----------\n")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("✅userIdentifier: \(userIdentifier)")
            print("----------\n")
            
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            // UserDefaults에 userIdentifier 저장
            saveUserIdentifier(user: userIdentifier)
//            UserDefaults.standard.set(user, forKey: "userIdentifier")
//            UserDefaults.standard.synchronize()
            // 메인 화면으로 이동
            navigateToMainPage(with: userIdentifier)
            
        case let passwordCredential as ASPasswordCredential:
            let username = passwordCredential.user
            let password = passwordCredential.password
            print("username: \(username)")
            print("password: \(password)")
            
        default:
            break
        }
    }
    
    //로그인 성공시 user 저장
    func saveUserIdentifier(user: String) {
        UserDefaults.standard.set(user, forKey: "userIdentifier")
        UserDefaults.standard.synchronize()
    }
    //
    //로그인 실패시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("login failed - \(error.localizedDescription)")
    }
}
