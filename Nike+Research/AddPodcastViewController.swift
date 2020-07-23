//
//  AddPodcastViewController.swift
//  Nike+Research
//
//  Created by Mathi03 on 7/22/20.
//  Copyright © 2020 Developers Academy. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase
import SDWebImage
import FirebaseStorage
import FirebaseDatabase

class AddPodcastViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Variables Audio
    var grabarAudio:AVAudioRecorder?
    var reproducirAudio:AVAudioPlayer?
    var audioURL:URL?
    var actionbutton = false
    var reproducirAudioEdit:AVPlayer?

    
    // Variables Imagen
    var imagePicker = UIImagePickerController()
    
    // Variable Clase Podcast
    var pod = Podcast1()
    
    // Variables Rutas
    var imagenesFolder = Storage.storage().reference().child("podcasts")
    
    // Variables ID's
    var imagenID = NSUUID().uuidString
    var audioID = NSUUID().uuidString
    
    // Variables Segue
    var podEdit:Podcast1? = nil
    
    // Varibles Normales
    var audioEdit = false
    var imagenEdit = false
    
    // Oulets
    @IBOutlet weak var imagePodField: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var addPodcastButton: UIButton!
    @IBOutlet weak var namePodField: UITextField!
    @IBOutlet weak var detailPodField: UITextField!
    @IBOutlet weak var largeDetailPodField: UITextField!
    @IBOutlet weak var pricePodField: UITextField!

    
    // Actions
    @IBAction func selectImage(_ sender: Any) {
        self.imagenEdit = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func recordAudio(_ sender: Any) {
        self.audioEdit = false
        if grabarAudio!.isRecording {
            grabarAudio?.pause()
            grabarAudio?.stop()
            playButton.isEnabled = true
        }else{
            grabarAudio?.record()
            recordButton.setTitle("Stop", for: .normal)
            playButton.isEnabled = false
        }
    }
    @IBAction func playAudio(_ sender: Any) {
        
        if self.audioEdit {
            let url = URL(string: (self.podEdit?.complete_audio_url)! )
            let playerItem = AVPlayerItem(url: url!)
            reproducirAudioEdit = AVPlayer(playerItem: playerItem)
            reproducirAudioEdit?.play()
        } else {
            do {
                try reproducirAudio = AVAudioPlayer(contentsOf: audioURL!)
                reproducirAudio!.play()
                //reproducirAudio!.volume = 5
                if #available(iOS 13.0, *) {
                    playButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
                } else {
                    // Fallback on earlier versions
                }
                playButton.setTitle("Playing", for: .normal)
                print("Reproduciendo")
                
            } catch {}
        }
    }
    @IBAction func AddPodcast(_ sender: Any) {
        self.camera()
    }
    
    // Override's
    override func viewDidLoad() {
        super.viewDidLoad()
        configurarGrabacion()
        imagePicker.delegate = self
        if podEdit != nil{
            self.namePodField.text = self.podEdit?.name
            self.detailPodField.text = self.podEdit?.detail
            self.largeDetailPodField.text = self.podEdit?.large_detail
            self.pricePodField.text = "\(Double((self.podEdit?.price)!))"
            self.imagePodField.sd_setImage(with: URL(string: (self.podEdit?.image_url)!), completed: nil)
            self.audioEdit = true
            self.imagenEdit = true
            print(self.podEdit?.imageID)
            print(String((podEdit?.imageID)!))
        } else {
            
        }
    }
    
    // Funciones
    func configurarGrabacion() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, mode: AVAudioSessionModeDefault, options: [])
            try session.overrideOutputAudioPort(.speaker)
            try session .setActive(true)
            
            let basePath:String = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            let pathComponents = [basePath, "audio.m4a"]
            audioURL = NSURL.fileURL(withPathComponents: pathComponents)!
            
            print("*******************")
            print(audioURL!)
            print("*******************")
            
            var settings:[String:AnyObject] = [:]
            settings[AVFormatIDKey] = Int(kAudioFormatMPEG4AAC) as AnyObject?
            settings[AVSampleRateKey] = 44100.0 as AnyObject?
            settings[AVNumberOfChannelsKey] = 2 as AnyObject?
            
            grabarAudio = try AVAudioRecorder(url: audioURL!, settings:settings)
            grabarAudio!.prepareToRecord()
            
            
        } catch let error as NSError {
            print(error)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imagePodField.image = image
        imagePodField.backgroundColor = UIColor.clear
        imagePicker.dismiss(animated: true, completion: nil)
    }
    func camera() {
        
        if podEdit != nil {
            if self.imagenEdit{
                self.audio()
            }else{
                let imagenData = UIImageJPEGRepresentation((imagePodField?.image)!, 0.50)
                let cargarImagen = imagenesFolder.child("\(String(((self.podEdit?.imageID)!))).jpg").putData(imagenData!, metadata: nil){
                    (metada, error) in
                    if error != nil {
                        print("Ocurrio un errore al subir imagen: \(error!) ")
                        return
                    }else{
                        self.imagenesFolder.child("\(String((self.podEdit?.imageID)!)).jpg").downloadURL(completion: {(url, error) in
                            guard let enlaceURL = url else {
                                print("Ocurrio un error al obtener informacion de imagen \(error!)")
                                return
                            }
                            self.pod.image_url = url?.absoluteString
                            print("imagen listo \(self.pod.image_url!)")
                            self.audio()
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
                present(alertaCarga, animated: true, completion: nil)
            }
        } else {
            let imagenData = UIImageJPEGRepresentation((imagePodField?.image)!, 0.50)
            let cargarImagen = self.imagenesFolder.child("\(self.imagenID).jpg").putData(imagenData!, metadata: nil){
                (metada, error) in
                if error != nil {
                    print("Ocurrio un errore al subir imagen: \(error!) ")
                    return
                }else{
                    self.imagenesFolder.child("\(self.imagenID).jpg").downloadURL(completion: {(url, error) in
                        guard let enlaceURL = url else {
                            print("Ocurrio un error al obtener informacion de imagen \(error!)")
                            return
                        }
                        self.pod.image_url = url?.absoluteString
                        print("imagen listo \(self.pod.image_url!)")
                        self.audio()
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
            present(alertaCarga, animated: true, completion: nil)
        }
    }
    func audio() {
        if podEdit != nil {
            if audioEdit{
                self.upload()
            }else{
                let audioData = NSData(contentsOf: audioURL!)! as Data
                let cargarAudio = self.imagenesFolder.child("\(String((self.podEdit?.audioID)!)).m4a").putData(audioData, metadata: nil){
                    (metada, error) in
                    if error != nil {
                        // self.mostrarAlerta(titulo: "Error", mensaje: "Seprodujo un erro al subvir la image. Verifique su conexion de internet y vuelva a intentarlo", accion: "Aceptar")
                        print("Ocurrio un errore al subir audio: \(error!) ")
                        return
                    }else{
                        self.imagenesFolder.child("\(String((self.podEdit?.audioID)!)).m4a").downloadURL(completion: {(url, error) in
                            guard let enlaceURL = url else {
                                //self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                                print("Ocurrio un error al obtener informacion de imagen \(error!)")
                                return
                            }
                            self.pod.complete_audio_url = url?.absoluteString
                            self.pod.short_audio_url = url?.absoluteString
                            print("audio listo \(self.pod.complete_audio_url!)")
                            self.upload()
                        })

                    }
                }
                let alertaCarga = UIAlertController(title: "Cargando Audio ...", message: "0%", preferredStyle: .alert)
                let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)

                cargarAudio.observe(.progress){(snapshot) in
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
                present(alertaCarga, animated: true, completion: nil)
            }
        } else {
            let audioData = NSData(contentsOf: audioURL!)! as Data
            let cargarAudio = self.imagenesFolder.child("\(self.audioID).m4a").putData(audioData, metadata: nil){
                (metada, error) in
                if error != nil {
                    // self.mostrarAlerta(titulo: "Error", mensaje: "Seprodujo un erro al subvir la image. Verifique su conexion de internet y vuelva a intentarlo", accion: "Aceptar")
                    print("Ocurrio un errore al subir audio: \(error!) ")
                    return
                }else{
                    self.imagenesFolder.child("\(self.audioID).m4a").downloadURL(completion: {(url, error) in
                        guard let enlaceURL = url else {
                            //self.mostrarAlerta(titulo: "Error", mensaje: "Se produjo un error al obtener informacion de imagen", accion: "Cancelar")
                            print("Ocurrio un error al obtener informacion de imagen \(error!)")
                            return
                        }
                        self.pod.complete_audio_url = url?.absoluteString
                        self.pod.short_audio_url = url?.absoluteString
                        print("audio listo \(self.pod.complete_audio_url!)")
                        self.upload()
                    })

                }
            }
            let alertaCarga = UIAlertController(title: "Cargando Audio ...", message: "0%", preferredStyle: .alert)
            let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)

            cargarAudio.observe(.progress){(snapshot) in
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
            present(alertaCarga, animated: true, completion: nil)
        }
    }
    func upload() {
        self.pod.name = namePodField.text!
        self.pod.detail = detailPodField.text!
        self.pod.large_detail = largeDetailPodField.text!
        self.pod.price = Double(pricePodField.text!)
        if self.podEdit != nil {
            self.pod.audioID = self.podEdit?.audioID
            self.pod.imageID = self.podEdit?.imageID
            
            // Actualizacion Audio
            if self.audioEdit && self.imagenEdit {
                let podCast = ["name": self.pod.name, "detail": self.pod.detail, "large_detail": self.pod.large_detail, "price": self.pod.price] as [String : Any]
                Database.database().reference().child("podcasts").child((self.podEdit?.uid)!).updateChildValues(podCast)
            }
            
            // Actualizacion Audio
            if !self.audioEdit && self.imagenEdit {
                let podCast = ["name": self.pod.name, "detail": self.pod.detail, "large_detail": self.pod.large_detail, "price": self.pod.price, "complete_audio_url": self.pod.complete_audio_url, "short_audio_url": self.pod.short_audio_url ] as [String : Any]
                Database.database().reference().child("podcasts").child((self.podEdit?.uid)!).updateChildValues(podCast)
            }
            
            // Actualizacion Imagen
            if self.audioEdit && !self.imagenEdit {
                let podCast = ["name": self.pod.name, "detail": self.pod.detail, "large_detail": self.pod.large_detail, "price": self.pod.price, "image_url": self.pod.image_url] as [String : Any]
                Database.database().reference().child("podcasts").child((self.podEdit?.uid)!).updateChildValues(podCast)
            }
            // Actualizacion Imagen Audio
            if !self.audioEdit && !self.imagenEdit {
                let podCast = ["name": self.pod.name, "detail": self.pod.detail, "large_detail": self.pod.large_detail, "price": self.pod.price, "image_url": self.pod.image_url, "complete_audio_url": self.pod.complete_audio_url, "short_audio_url": self.pod.short_audio_url] as [String : Any]
                Database.database().reference().child("podcasts").child((self.podEdit?.uid)!).updateChildValues(podCast)
            }
            
        } else {
            let podCast = ["name": self.pod.name, "detail": self.pod.detail, "large_detail": self.pod.large_detail, "price": self.pod.price, "image_url": self.pod.image_url, "complete_audio_url": self.pod.complete_audio_url, "short_audio_url": self.pod.short_audio_url, "imageID": self.imagenID, "audioID": self.audioID  ] as [String : Any]
            Database.database().reference().child("podcasts").childByAutoId().setValue(podCast)
        }
        
        navigationController!.popViewController(animated: true)
    }
}

//let alertaCarga = UIAlertController(title: "Cargando Archivos ...", message: "0%", preferredStyle: .alert)
//       let progresoCarga:UIProgressView = UIProgressView(progressViewStyle: .default)
//
//       cargarImagen.observe(.progress){(snapshot) in
//           let porcentaje = Double(snapshot.progress!.completedUnitCount) / Double(snapshot.progress!.totalUnitCount)
//           progresoCarga.setProgress(Float(porcentaje), animated: true)
//           progresoCarga.frame = CGRect(x:10, y:70, width:250, height:0)
//           alertaCarga.message = String(round(porcentaje*100.0)) + "%"
//           if porcentaje>=1.0{
//               alertaCarga.dismiss(animated: true, completion: nil)
//           }
//       }
//       let btnOk = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
//       alertaCarga.addAction(btnOk)
//       alertaCarga.view.addSubview(progresoCarga)
//       present(alertaCarga, animated: true, completion: nil)
