//
//  CreationCameraPickerView.swift
//  MyDailyLog
//
//  Created by Steve Shi on 5/19/22.
//

import SwiftUI


struct CreationCameraPickerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    let onTakePicture: (UIImage) -> Void
    
    func makeCoordinator() -> CameraPickerViewCoordinator {
        return CameraPickerViewCoordinator(isPresented: _isPresented, onTakePicture: onTakePicture)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let controller = UIImagePickerController()
        controller.sourceType = .camera
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
    
}

final class CameraPickerViewCoordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @Binding var isPresented: Bool
    let onTakePicture: (UIImage) -> Void
    
    init(isPresented: Binding<Bool>, onTakePicture: @escaping (UIImage) -> Void) {
        self._isPresented = isPresented
        self.onTakePicture = onTakePicture
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            DispatchQueue.main.async { [weak self] in
                self?.onTakePicture(image)
            }
        }
        isPresented = false
    }
}
