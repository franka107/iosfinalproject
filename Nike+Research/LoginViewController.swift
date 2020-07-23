//
//  LoginViewController.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/21/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import TextFieldFloatingPlaceholder
import TransitionButton

class LoginViewController: UIViewController {

    @IBOutlet weak var correoField: TextFieldFloatingPlaceholder!
    @IBOutlet weak var passwordField: TextFieldFloatingPlaceholder!
    @IBOutlet var viewtap: UITapGestureRecognizer!
    @IBOutlet weak var button: TransitionButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.assignbackground()
        
        self.passwordField.floatingPlaceholderColor = UIColor.blue.withAlphaComponent(0.3)
        self.passwordField.floatingPlaceholderMinFontSize = 16
        self.passwordField.validation = { $0.count > 1 }
        self.passwordField.validationFalseLineEditingColor = .white
        self.passwordField.validationTrueLineEditingColor = .white
        self.passwordField.validationFalseLineColor = .lightGray
        self.passwordField.validationTrueLineColor = .lightGray
        
        self.correoField.floatingPlaceholderColor = UIColor.blue.withAlphaComponent(0.3)
        self.correoField.floatingPlaceholderMinFontSize = 16
        self.correoField.validation = { $0.count > 1 }
        self.correoField.validationFalseLineEditingColor = .white
        self.correoField.validationTrueLineEditingColor = .white
        self.correoField.validationFalseLineColor = .lightGray
        self.correoField.validationTrueLineColor = .lightGray
        
        self.view.addSubview(button)
        
        
        self.button.cornerRadius = 20
        self.button.layer.borderWidth = 1
        self.button.layer.borderColor = UIColor.white.cgColor
        self.button.spinnerColor = .white
        self.button.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
        
        self.viewtap.addTarget(self, action: #selector(LoginViewController.tap))
    }
    @objc func tap() {
        self.correoField.endEditing(true)
        self.passwordField.endEditing(true)
    }

    func assignbackground(){
        let background = UIImage(named: "background")

        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: correoField.text!, password: passwordField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error!)")
                self.button.startAnimation()
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    
                    sleep(3)
                    
                    DispatchQueue.main.async(execute: { () -> Void in

                        self.button.stopAnimation(animationStyle: .shake, completion: {
                            let alerta = UIAlertController(title: "Iniciando Sesion", message: "El usuario no existe. Intente registrarse o introduzca bien sus credenciales.", preferredStyle: .alert)
                                            let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: {(UIAlertAction) in
                            //                    self.performSegue(withIdentifier: "registrarSegue", sender: nil)
                                            })
                                            let btnCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                                            alerta.addAction(btnCrear)
                                            alerta.addAction(btnCancelar)
                                            self.present(alerta, animated: true, completion: nil)
                        })
                    })
                })
                
            }else{
                print("Inicio de sesion exitoso")

                self.button.startAnimation()
                let qualityOfServiceClass = DispatchQoS.QoSClass.background
                let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
                backgroundQueue.async(execute: {
                    
                    sleep(3)
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        
            
                        self.button.stopAnimation(animationStyle: .expand, completion: {
                            Database.database().reference().child("usuarios").child(user!.user.uid).observeSingleEvent(of: .value, with: {
                                (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                let userInfo = Userdata()
                                userInfo.id = user!.user.uid
                                userInfo.name = value?["name"] as? String ?? ""
                                userInfo.type = value?["type"] as? String ?? ""
                                userInfo.imageURL = value?["image"] as? String ?? ""
                                print(userInfo.type)
                                //print(snapshot)
                                if userInfo.type == "user" {
                                    self.performSegue(withIdentifier: "userViewSegue", sender: nil)
                                }else{
                                    self.performSegue(withIdentifier: "adminViewSegue", sender: nil)
                                }
                                
                            })
                        })
                    })
                })
                
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "userViewSegue" {
//            let siguienteVC = segue.destination as! AdminViewController
//            siguienteVC.userInfo = sender as! Userdata
//        }
//        if segue.identifier == "adminViewSegue" {
//            let siguienteVC = segue.destination as! AdminViewController
//            siguienteVC.userInfo = sender as! Userdata
//        }
    }

}
