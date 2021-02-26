//
//  File.swift
//  TestDiscDB
//
//  Created by Benjamin Tincher on 2/25/21.
//
import FirebaseAuth
import UIKit

class RegistrationViewController: UIViewController {
    
    struct  Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.placeholder = "Email..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let confirmPasswordField: UITextField = {
        let field = UITextField()
        field.placeholder = "Confirm Password..."
        field.returnKeyType = .continue
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.layer.masksToBounds = true
        field.layer.cornerRadius = Constants.cornerRadius
        field.backgroundColor = .secondarySystemBackground
        field.layer.borderWidth = 1.0
        field.layer.borderColor = UIColor.secondaryLabel.cgColor
        field.isSecureTextEntry = true
        
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Sign Up", for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = Constants.cornerRadius
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        
        return  button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailField.delegate = self
        passwordField.delegate = self
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(confirmPasswordField)
        view.addSubview(registerButton)
        
        view.backgroundColor = .systemBackground
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emailField.frame = CGRect(x: 20, y: view.safeAreaInsets.top+64, width: view.width-40, height: 48)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom+10, width: view.width-40, height: 48)
        confirmPasswordField.frame = CGRect(x: 20, y: passwordField.bottom+10, width: view.width-40, height: 48)
        registerButton.frame = CGRect(x: 20, y: confirmPasswordField.bottom+10, width: view.width-40, height: 48)
    }
    
    @objc func didTapRegisterButton() {
        guard let email = emailField.text, !email.isEmpty,
              let password = passwordField.text, !password.isEmpty,
              let confirm = confirmPasswordField.text, !confirm.isEmpty,
              password == confirm else { return }
        
        AuthManager.shared.registerNewUserWith(email: email, password: password) { (success) in
            DispatchQueue.main.async {
                if success {
                    print("successfully registered user.")
                    
                    AuthManager.shared.loginUserWith(email: email, password: password) { (loggedIn) in
                        if loggedIn {
                            print("New firebase user logged in.")
                            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                        }
                    }
                    
                } else {
                    print("there was an error registering new firebase user.")
                }
            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            confirmPasswordField.becomeFirstResponder()
        } else if textField == confirmPasswordField {
            didTapRegisterButton()
        }
        return true
    }
}
