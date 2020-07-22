//
//  ProfileAdminViewController.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/22/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit
import Firebase
import SDWebImage

class ProfileAdminViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    
    var imagePicker = UIImagePickerController()
    let userInfo = Userdata()
    var cont = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        Database.database().reference().child("usuarios").child((Auth.auth().currentUser?.uid)!).observeSingleEvent(of: .value, with: {
            (snapshot) in
            let value = snapshot.value as? NSDictionary
            //let userInfo = Userdata()
            self.userInfo.id = snapshot.key
            self.userInfo.name = value?["name"] as? String ?? ""
            self.userInfo.type = value?["type"] as? String ?? ""
            self.userInfo.imageURL = value?["image"] as? String ?? ""
            print(self.userInfo.type)
            print(self.userInfo.id)
            self.imageProfile.sd_setImage(with: URL(string: self.userInfo.imageURL), completed: nil)
            self.nameField.text = self.userInfo.name
            
            
        })
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectImage(_ sender: Any) {
        cont = 1
        imagePicker.sourceType = .savedPhotosAlbum
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageProfile.image = image
        imageProfile.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateProfile(_ sender: Any) {
        if cont == 1{
            
            let imagenesFolder = Storage.storage().reference().child("userdata").child(userInfo.id)
            let imagenData = UIImageJPEGRepresentation((imageProfile?.image)!, 0.50)
            let cargarImagen = imagenesFolder.child("user-image.jpg")
            cargarImagen.putData(imagenData!, metadata: nil){
                (metada, error) in
                if error != nil {
                    self.mostrarAlerta(titulo: "Error", mensaje: "Seprodujo un erro al subvir la image. Verifique su conexion de internet y vuelva a intentarlo", accion: "Aceptar")
                    print("Ocurrio un errore al subir imagen: \(error!) ")
                    return
                }else{
                    cargarImagen.downloadURL(completion: {(url, error) in
                        guard let enlaceURL = url else {
                            self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                            
                            print("Ocurrio un error al obtener informacion de imagen \(error!)")
                            return
                        }
                        //let user = ["name": nameField.text, "descripc": descrip, "imagenURL": imagenURL]
                        Database.database().reference().child("usuarios").child(self.userInfo.id).updateChildValues(["name": self.nameField.text!, "image": url?.absoluteString])
                    })
                    
                }
            }
            
        }else{
            Database.database().reference().child("usuarios").child(self.userInfo.id).updateChildValues(["name": self.nameField.text!])
        }
        
    }
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let brnCANCELOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(brnCANCELOK)
        present(alerta, animated: true, completion: nil)
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
