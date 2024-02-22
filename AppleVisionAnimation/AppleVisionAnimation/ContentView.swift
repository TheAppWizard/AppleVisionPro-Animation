//
//  ContentView.swift
//  AppleVisionAnimation
//
//  Created by Shreyas Vilaschandra Bhike on 21/02/24.
//


//  MARK: Instagram
//  TheAppWizard
//  MARK: theappwizard2408


import SwiftUI

struct ContentView: View {
    var body: some View {
        VisionProAnimate()
    }
}

#Preview {
    ContentView()
}



















struct VisionProAnimate: View {
    @State private var frameIndex: Int = 0

    
    var images: [URL] = {
        var urls: [URL] = []
        for i in 0..<200 {
            let urlString = "https://www.apple.com/105/media/us/apple-vision-pro/2023/7e268c13-eb22-493d-a860-f0637bacb569/anim/360/large/\(String(format: "%04d", i)).jpg"
            if let url = URL(string: urlString) {
                urls.append(url)
            }
        }
        return urls
    }()
    
    var body: some View {
        ZStack {
            
            Color.gray.opacity(0.1).edgesIgnoringSafeArea(.all)
            
           
            
          
            ForEach(22...55, id: \.self) { index in
                let imageName = String(format: "%04d.jpg", index)
                if images[frameIndex].lastPathComponent == imageName {
                    TextView(boldName: "Front. ",para: "A singular piece of three-dimensionally formed laminated glass flows into an aluminum alloy frame that curves to wrap around your face.")

                }
            }
                
      
      
              ForEach(56...93, id: \.self) { index in
                       let imageName = String(format: "%04d.jpg", index)
                       if images[frameIndex].lastPathComponent == imageName {
                           TextView(boldName: "Light Seal. ",para: "The Light Seal gently flexes to conform to your face, delivering a precise fit while blocking out stray light.")
                       }
                   }
      
              ForEach(94...139, id: \.self) { index in
                       let imageName = String(format: "%04d.jpg", index)
                       if images[frameIndex].lastPathComponent == imageName {
                           TextView(boldName: "Head bands. ",para: "The Solo Knit Band provides cushioning, breathability, and stretch, and a Fit Dial lets you adjust Apple Vision Pro precisely to your head.")
                       }
                   }
      
              ForEach(140...173, id: \.self) { index in
                       let imageName = String(format: "%04d.jpg", index)
                       if images[frameIndex].lastPathComponent == imageName {
                           TextView(boldName: "Power. ",para: "The external battery supports up to 2 hours of general use and up to 2.5 hours of video playback.")
                       }
                   }
      
      
              ForEach(174...198, id: \.self) { index in
                       let imageName = String(format: "%04d.jpg", index)
                       if images[frameIndex].lastPathComponent == imageName {
                           TextView(boldName: "Sound. ",para: "Speakers positioned close to your ears deliver rich Spatial Audio while keeping you aware of your surroundings.")
                       }
                   }
            
            
            ForEach(198...199, id: \.self) { index in
                     let imageName = String(format: "%04d.jpg", index)
                     if images[frameIndex].lastPathComponent == imageName {
                         TextView(boldName: "EyeSight. ",para: "An outward display reveals your eyes while wearing Apple Vision Pro, letting others know when you are using apps or fully immersed.")
                     }
                 }
            
            ForEach(10...20, id: \.self) { index in
                let imageName = String(format: "%04d.jpg", index)
                if images[frameIndex].lastPathComponent == imageName {
                    HStack{
                        Text("Vision Pro").fontWeight(.semibold)
                            .font(.system(size: 60))
                            .offset(y:-200)
                    }
                }
            }
            
            AnimationSequence(frameIndex: $frameIndex, imageURLs: images)
                .offset(x:10,y:100)
           

//MARK: For Debugging : Show Frame Number
            VStack{
                HStack{
                    Spacer()
                    Text("\(images[frameIndex].lastPathComponent)")
                        .foregroundStyle(.black.opacity(0.1))
                                 .cornerRadius(10)
                                 .offset(y: -50)
                                 .padding()
                }
                Spacer()
            }
//MARK: For Debugging
            
    
                 
            
           
            
          
        }
    }
}

struct AnimationSequence: UIViewRepresentable {
    @Binding var frameIndex: Int
    let imageURLs: [URL]
    
    var selectedImageName: String {
         guard frameIndex >= 0 && frameIndex < imageURLs.count else { return "" }
         return imageURLs[frameIndex].lastPathComponent
     }
    
    func makeUIView(context: Context) -> UIView {
        let seqAnimview = UIView(frame: CGRect(x: 0, y: 0, width: 600, height: 600))
        let seqImage = UIImageView(frame: CGRect(x: -150, y: 150, width: 700, height: 700))
        seqImage.clipsToBounds = true
        seqImage.layer.cornerRadius = 20
        seqImage.autoresizesSubviews = true
        seqImage.contentMode = UIView.ContentMode.scaleAspectFill
        loadImage(for: seqImage, at: frameIndex) // Load initial image
        seqAnimview.addSubview(seqImage)
        
        let slider = UISlider(frame: CGRect(x: 110, y: 700, width: 200, height: 20))
        slider.minimumValue = 0
        slider.maximumValue = Float(imageURLs.count - 1)
        slider.value = Float(frameIndex)
        slider.minimumTrackTintColor = .systemBlue
        slider.maximumTrackTintColor = .darkGray
        slider.addTarget(context.coordinator, action: #selector(Coordinator.onSliderChange(_:)), for: .valueChanged)
        seqAnimview.addSubview(slider)
        return seqAnimview
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<AnimationSequence>) {
        loadImage(for: uiView.subviews.compactMap { $0 as? UIImageView }.first, at: frameIndex)
    }
    
    func loadImage(for imageView: UIImageView?, at index: Int) {
        guard let imageView = imageView else { return }
        guard index >= 0 && index < imageURLs.count else { return }
        
        let url = imageURLs[index]
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image from \(url.absoluteString):", error?.localizedDescription ?? "Unknown error")
                return
            }
            DispatchQueue.main.async {
                imageView.image = image
            }
        }.resume()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: AnimationSequence

        init(_ parent: AnimationSequence) {
            self.parent = parent
        }
        
        @objc func onSliderChange(_ sender: UISlider) {
            let selectedIndex = Int(sender.value)
//            print("Selected image URL:", parent.imageURLs[selectedIndex])
            parent.frameIndex = selectedIndex
        }
    }
}


struct TextView: View {
    @State var boldName = ""
    @State var para = ""
    
    var body: some View {
        VStack {
            
            Text(boldName).fontWeight(.bold)
                .font(.system(size: 30))
              + (Text(para)
                .foregroundStyle(.gray))
                .font(.system(size: 30))
              
            Spacer()
        }.padding(20)
    }
}
