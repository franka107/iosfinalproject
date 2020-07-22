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

class LoginViewController: UIViewController {

    @IBOutlet weak var correoField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
   
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        Auth.auth().signIn(withEmail: correoField.text!, password: passwordField.text!) { (user, error) in
            print("Intentando Iniciar Sesion")
            if error != nil{
                print("Se presento el siguiente error: \(error!)")
                let alerta = UIAlertController(title: "Iniciando Sesion", message: "El usuario no existe. Intente registrarse o introduzca bien sus credenciales.", preferredStyle: .alert)
                let btnCrear = UIAlertAction(title: "Crear", style: .default, handler: {(UIAlertAction) in
//                    self.performSegue(withIdentifier: "registrarSegue", sender: nil)
                })
                let btnCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
                alerta.addAction(btnCrear)
                alerta.addAction(btnCancelar)
                self.present(alerta, animated: true, completion: nil)
            }else{
                print("Inicio de sesion exitoso")
//                self.performSegue(withIdentifier: "iniciarsesionsegue", sender: nil)
                let alerta = UIAlertController(title: "Iniciando Sesion", message: "Te loguearste con Exito", preferredStyle: .alert)

                //                    self.performSegue(withIdentifier: "registrarSegue", sender: nil)

                let btnOK = UIAlertAction(title: "OK", style: .default, handler: nil)
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
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

}
