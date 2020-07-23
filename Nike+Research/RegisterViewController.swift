//
//  RegisterViewController.swift
//  Nike+Research
//
//  Created by Emerson on 7/23/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit
import TextFieldFloatingPlaceholder
import TransitionButton
import Firebase
import UIKit
import Firebase
import SDWebImage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var email: TextFieldFloatingPlaceholder!
    @IBOutlet weak var password: TextFieldFloatingPlaceholder!
    @IBOutlet weak var nombre: TextFieldFloatingPlaceholder!
    @IBOutlet weak var btnCheck: TransitionButton!
    @IBOutlet weak var btnImage: UIButton!
    
    var tipoUser = String("user")
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imagePicker.delegate = self

        self.assignbackground()
        self.email.floatingPlaceholderColor = UIColor.blue.withAlphaComponent(0.3)
        self.email.floatingPlaceholderMinFontSize = 16
        self.email.validation = { $0.count > 1 }
        self.email.validationFalseLineEditingColor = .white
        self.email.validationTrueLineEditingColor = .white
        self.email.validationFalseLineColor = .lightGray
        self.email.validationTrueLineColor = .lightGray
        
        self.password.floatingPlaceholderColor = UIColor.blue.withAlphaComponent(0.3)
        self.password.floatingPlaceholderMinFontSize = 16
        self.password.validation = { $0.count > 1 }
        self.password.validationFalseLineEditingColor = .white
        self.password.validationTrueLineEditingColor = .white
        self.password.validationFalseLineColor = .lightGray
        self.password.validationTrueLineColor = .lightGray
        
        self.nombre.floatingPlaceholderColor = UIColor.blue.withAlphaComponent(0.3)
        self.nombre.floatingPlaceholderMinFontSize = 16
        self.nombre.validation = { $0.count > 1 }
        self.nombre.validationFalseLineEditingColor = .white
        self.nombre.validationTrueLineEditingColor = .white
        self.nombre.validationFalseLineColor = .lightGray
        self.nombre.validationTrueLineColor = .lightGray
        
        self.view.addSubview(btnCheck)
        
        self.btnCheck.cornerRadius = 20
        self.btnCheck.layer.borderWidth = 1
        self.btnCheck.layer.borderColor = UIColor.white.cgColor
        self.btnCheck.spinnerColor = .white
        self.btnCheck.addTarget(self, action: #selector(registerAction(_:)), for: .touchUpInside)
    }
    
    @IBAction func registerAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: self.email.text!, password: self.password.text!, completion: {(user, error) in
            print("Intentando crear un usuario")
            if error != nil {
                print("Se presento el sisguiente error al crear el usuario: \(error)" )
                let alerta = UIAlertController(title: "Creacion de Usuario", message: "No se pudo crear el usuario", preferredStyle: .alert)
                let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "registerbacksegue", sender: nil)
                })
                alerta.addAction(btnOK)
                self.present(alerta, animated: true, completion: nil)
            } else {
                print("El suario fue creado exitosamente")
                let imagenesFolder = Storage.storage().reference().child("userdata").child(user!.user.uid)
                let imagenData = UIImageJPEGRepresentation((self.imageView?.image)!, 0.50)
                let cargarImagen = imagenesFolder.child("user-image.jpg").putData(imagenData!, metadata: nil){
                    (metada, error) in
                    if error != nil {
                        return
                    }else{
                        Storage.storage().reference().child("userdata").child(user!.user.uid).child("user-image.jpg").downloadURL(completion: {(url, error) in
                            guard let enlaceURL = url else {
                                print("Ocurrio un error al obtener informacion de imagen \(error!)")
                                return
                            }
                            let post = ["name": self.nombre.text, "type": self.tipoUser,"image": url?.absoluteString] as [String : Any]
                            Database.database().reference().child("usuarios").child(user!.user.uid).setValue(post)
                            let alerta = UIAlertController(title: "Creacion de Usuario", message: "Usuario", preferredStyle: .alert)
                            let btnOK = UIAlertAction(title: "Aceptar", style: .default, handler: {(UIAlertAction) in self.performSegue(withIdentifier: "registerbacksegue", sender: nil)
                            })
                            alerta.addAction(btnOK)
                        })
                        
                    }
                }
                let alertaCarga = UIAlertController(title: "Cargando Imagen ...", message: "0%", preferredStyle: .alert)
                let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)

                cargarImagen.observe(.progress){(snapshot) in
                   let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
                   progresoCarga.setProgress(Float(porcentaje), animated: true)
                   progresoCarga.frame = CGRect(x:10, y:70, width:250, height:0)
                   alertaCarga.message = String(round(porcentaje*100.0)) + "%"
                   if porcentaje>=1.0{
                       alertaCarga.dismiss(animated: true, completion: nil)
                   }
                }
                let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
                alertaCarga.addAction(btnOk)
                alertaCarga.view.addSubview(progresoCarga)
                self.present(alertaCarga, animated: true, completion: nil)
            }
        })	
    }
    @IBAction func buttonAction(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    
    func assignbackground(){
        let background = UIImage(named: "register")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode =  UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = image
        imageView.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func uploadImage(){
        
    }

}
