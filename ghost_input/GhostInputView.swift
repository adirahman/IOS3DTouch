//
//  GhostInputView.swift
//  ghost_input
//
//  Created by adira on 09/01/26.
//
import SwiftUI

/// Ghost Input style view : transclucent dim + bottom sheet + quick note editor
struct GhostInputView: View{
    // Persist note (simple version). If you need App Group Later, I can adjust
    @AppStorage("quick_note") private var quickNote: String = ""
    
    @Environment(\.dismiss) private var dismiss
    @FocusState private var isFocused: Bool
    
    @State private var draft:String = ""
    @State private var appear: Bool = false
    @State private var isSaving: Bool = false
    
    //Optional: callback to notify parent after save/clear
    var onSaved: ((String)->Void)? = nil
    var onClear:(()->Void)? = nil
    
    var body: some View{
        ZStack(alignment: .bottom){
            // Dim background(tap to dismiss)
            Color.black
                .opacity(appear ? 0.55:0)
                .ignoresSafeArea()
                .onTapGesture {
                    close()
                }
            
            //Bottom Sheet
            sheet
                .offset(y: appear ? 0: 420)
                .opacity(appear ? 1: 0.01)
                .animation(.spring(response: 0.28, dampingFraction: 0.92), value: appear)
                .padding(.bottom,12)
        }
        .onAppear{
            draft = quickNote
            withAnimation{ appear = true}
            // focus keyboard after a tick
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                isFocused = true
            }
        }
    }
    
    private var sheet: some View{
        VStack(alignment: .leading, spacing: 12){
            //Grabber
            HStack{
                Spacer()
                Capsule()
                    .fill(Color.white.opacity(0.25))
                    .frame(width:44, height: 5)
                Spacer()
            }
            .padding(.top, 20)
            
            Text("Quick Note")
                .font(.system(size:18, weight:.bold))
                .foregroundStyle(.white)
            
            Text("Type something. Tap Save.")
                .font(.system(size: 13))
                .foregroundStyle(.white.opacity(0.7))
            
            //Text Input(multi line)
            ZStack(alignment: .topLeading){
                if draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty{
                    Text("Notes....")
                        .foregroundStyle(.white.opacity(0.35))
                        .padding(.horizontal,12)
                        .padding(.vertical,12)
                }
                
                TextEditor(text: $draft)
                    .focused($isFocused)
                    .foregroundStyle(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(8)
                    .frame(minHeight:110, maxHeight:160)
                    .submitLabel(.done)
            }
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.08))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(Color.white.opacity(0.10),lineWidth: 1)
            )
            
            HStack(spacing:10){
                Button{
                    close()
                }label:{
                    Text("Cancel")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(GhostButtonStyle(kind:.secondary))
                .disabled(isSaving)
                
                Button{
                    save()
                }label:{
                    if isSaving{
                        ProgressView().tint(.white)
                            .frame(maxWidth: .infinity)
                    }else{
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(GhostButtonStyle(kind: .primary))
                .disabled(isSaving)
                
                Button{
                    clear()
                }label:{
                    Text("Clear")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(GhostButtonStyle(kind:.danger))
                .disabled(isSaving)
            }
            .padding(.horizontal,16)
            .padding(.bottom,14)
            .background(
                RoundedRectangle(cornerRadius: 22, style:.continuous)
                    .fill(Color(white:0.08))//dark card
                    .shadow(color: .black.opacity(0.35), radius: 18, x:0, y:10)
            )
            .padding(.horizontal,14)
            //drag down to dismiss
            .gesture(
                DragGesture(minimumDistance: 12)
                    .onEnded{ value in
                        if value.translation.height > 90 {close()}
                    }
            )
        }
    }

    private func save(){
        isSaving = true
        let trimmed = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //Haptic (optional)
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        
        //Persist
        quickNote = trimmed
        onSaved?(trimmed)
        
        //close with animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06){
            isSaving = false
            close()
        }
    }
    private func clear(){
        isSaving = true
        UIImpactFeedbackGenerator(style:.light).impactOccurred()
        
        quickNote = ""
        draft = ""
        onClear?()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06){
            isSaving = false
            close()
        }
    }
    private func close(){
        isFocused = false
        withAnimation(.spring(response: 0.26,dampingFraction:0.95)){
            appear = false
        }
        //dismiss after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.06){
            dismiss()
        }
    }
}


// MARK : - Button Style

private struct GhostButtonStyle: ButtonStyle {
    enum Kind {case primary, secondary, danger }
    let kind: Kind
    
    func makeBody(configuration: Configuration)-> some View{
        configuration.label
            .font(.system(size: 15, weight: .semibold))
            .foregroundStyle(fg)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(bg(configuration.isPressed))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .stroke(border,lineWidth: 1)
            )
            .opacity(configuration.isPressed ? 0.92 : 1)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
    
    private var fg:Color{
        switch kind {
        case .primary: return .white
        case .secondary: return .white
        case .danger: return .white
        }
    }
    
    private func bg (_ pressed:Bool) -> Color{
        switch kind{
        case .primary:
            return Color.blue.opacity(pressed ? 0.70 : 0.85)
        case .secondary:
            return Color.white.opacity(pressed ? 0.10: 0.14)
        case .danger:
            return Color.red.opacity(pressed ? 0.55 : 0.70)
        }
    }
    
    private var border: Color{
        switch kind{
        case .primary: return Color.white.opacity(0.10)
        case .secondary: return Color.white.opacity(0.14)
        case .danger: return Color.white.opacity(0.10)
        }
    }
}

#Preview {
    ZStack{
        Color.black.ignoresSafeArea()
        Text("Underlying App")
            .foregroundStyle(.white)
    }
    .fullScreenCover(isPresented: .constant(true)){
        GhostInputView()
    }
}
