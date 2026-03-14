import SwiftUI

struct GlowingOrb: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var scale: CGFloat
    var opacity: Double
    var speed: Double
}

struct BuddhaView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State private var lotusOffset: CGSize = .zero
    @State private var isEnlightened = false
    @State private var moonOffset: CGFloat = 200
    @State private var skyBrightness: Double = 0.2
    @State private var orbs: [GlowingOrb] = []
    
   
    let orbTimer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                colors: [
                    Color(red: 0.0, green: 0.1, blue: 0.2)
                        .opacity(skyBrightness),
                    Color(red: 0.0, green: 0.2, blue: 0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .animation(.easeInOut(duration: 4.0), value: skyBrightness)
            
            Circle()
                .fill(
                    LinearGradient(
                        colors: [
                            .white,
                            .yellow.opacity(0.8)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: 250, height: 250)
                .shadow(
                    color: .white.opacity(0.8),
                    radius: isEnlightened ? 40 : 0
                )
                .offset(y: moonOffset)
                .opacity(isEnlightened ? 1.0 : 0.0)
            
            ForEach(orbs) { orb in
                Circle()
                    .fill(Color.yellow.opacity(orb.opacity))
                    .frame(width: 6, height: 6)
                    .scaleEffect(orb.scale)
                    .position(x: orb.x, y: orb.y)
                    .shadow(color: .yellow, radius: 5)
            }
            
            VStack {
                Text(
                    isEnlightened
                    ? "Peace comes from within."
                    : "Mindfully drag the lotus upward"
                )
                .font(.title2)
                .fontWeight(.light)
                .foregroundStyle(
                    isEnlightened
                    ? .white
                    : .white.opacity(0.6)
                )
                .multilineTextAlignment(.center)
                .padding(.top, 50)
                .animation(
                    .easeInOut(duration: 2.0),
                    value: isEnlightened
                )
                
                Spacer()
                
                ZStack {
                    if UIImage(named: "buddha_silhouette") != nil {
                        Image("buddha_silhouette")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 280)
                            .colorMultiply(
                                Color(
                                    white: isEnlightened
                                    ? 0.1
                                    : 0.4
                                )
                            )
                    } else {
                        Image(systemName: "figure.mind.and.body")
                            .font(.system(size: 180))
                            .foregroundStyle(
                                Color(
                                    white: isEnlightened
                                    ? 0.1
                                    : 0.5
                                )
                            )
                    }
                }
                .offset(y: 40)
                
                Spacer()
                
                ZStack {
                    Color.clear.frame(height: 120)
                    
                    if !isEnlightened {
                        Text("🪷")
                            .font(.system(size: 80))
                            .shadow(
                                color: .pink.opacity(0.8),
                                radius: 15
                            )
                            .offset(lotusOffset)
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        let resistantY =
                                        value.translation.height / 1.5
                                        let resistantX =
                                        value.translation.width / 3
                                        
                                        lotusOffset = CGSize(
                                            width: resistantX,
                                            height: resistantY
                                        )
                                    }
                                    .onEnded { value in
                                        if value.translation.height < -120 {
                                            achieveNirvana()
                                        } else {
                                            withAnimation(
                                                .easeInOut(duration: 1.0)
                                            ) {
                                                lotusOffset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                }
                .padding(.bottom, 60)
            }
            
            VStack {
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(
                                .white.opacity(0.5)
                            )
                            .padding()
                    }
                }
                Spacer()
            }
        }
                .onReceive(orbTimer) { _ in
            if isEnlightened {
                spawnOrb()
            }
        }
    }
    
    func achieveNirvana() {
        UIImpactFeedbackGenerator(style: .soft)
            .impactOccurred()
        
        DispatchQueue.main.asyncAfter(
            deadline: .now() + 0.3
        ) {
            UIImpactFeedbackGenerator(style: .rigid)
                .impactOccurred()
        }
        
        SoundManager.instance.playSound(
            named: "singing_bowl"
        )
        
        withAnimation(.easeOut(duration: 1.0)) {
            isEnlightened = true
        }
        
        withAnimation(.easeInOut(duration: 4.0)) {
            moonOffset = -40
            skyBrightness = 1.0
        }
    }
    
        func spawnOrb() {
        let startX = CGFloat.random(in: 0...UIScreen.main.bounds.width)
        
        let newOrb = GlowingOrb(
            x: startX,
            y: UIScreen.main.bounds.height,
            scale: CGFloat.random(in: 0.5...1.5),
            opacity: Double.random(in: 0.3...0.8),
            speed: Double.random(in: 6.0...12.0)
        )
        
        withAnimation {
            orbs.append(newOrb)
        }
        
        let index = orbs.count - 1
        
        if index >= 0 {
            withAnimation(.linear(duration: newOrb.speed)) {
                orbs[index].y = -100
            }
        }
        
        if orbs.count > 30 {
            orbs.removeFirst()
        }
    }
}
