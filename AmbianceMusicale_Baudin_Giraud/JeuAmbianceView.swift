//
//  HomeScreenView.swift
//  AmbianceMusicale_Baudin_Giraud
//
//  Created by Maxime Baudin on 09/01/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct JeuAmbianceView: View {
    @Binding var titre: String
    @Binding var couleur: String
    @Binding var id:String
    
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @ObservedObject var datas = observer()
    @State var afficheMenu: Bool = false
    
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.afficheMenu{
                    HomeScreenView()
                }
                else {
                    
                    if (titre != ""){
                        AfficheJeu(titleAmbient: self.$titre, idJeu: self.$id,colorJeu: self.$couleur, afficheMenu: self.$afficheMenu)
                    } else{
                        CreerJeu(afficheMenu: self.$afficheMenu)
                    }
                        
                    
                        
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

struct test {
    
    @State var title: String = ""
    
}

/**struct JeuAmbianceView_Previews: PreviewProvider {
    static var previews: some View {
        JeuAmbianceView(titre: , couleur: "")
    }
}**/


struct CreerJeu: View {
    @State var backgroundColor = Color(.systemBackground)
    @State var titleAmbient = ""
    @State private var selectedColor = Color.red
    @Binding var afficheMenu: Bool
    var color = ["Bleu", "Rouge", "Vert", "Jaune"]
    @State private var selectedCol = 0
    
    var body: some View{
        
        VStack{
            
            Button(action: {
                
                self.retourMenu()
            }) {
                
                Text("Retour Menu")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
            Text("Nom de l'ambiance")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.white)
                .padding(.top, 35)
            
            TextField("Titre", text: self.$titleAmbient)
                .autocapitalization(.none)
                .padding()
                .background(RoundedRectangle(cornerRadius: 4).stroke(self.titleAmbient != "" ? Color("Color") : Color.white, lineWidth: 2))
                .padding(.top, 25)
        
            
            Text("Choix de la couleur")
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .foregroundColor(Color.white)
                .padding(.top, 35)
            
            Picker(selection: $selectedCol, label: Text("Color")) {
                                    ForEach(0 ..< color.count) {
                                        Text(self.color[$0])

                                    }
            }
            
            Button(action: {
                self.addData()
            }) {
                
                Text("Création Jeu")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 25)
            
        }
    }
    
    func addData(){
        
        let db = Firestore.firestore()
        let ambiance = db.collection("ambiance").document()
        
        ambiance.setData(["id":ambiance.documentID,"titre": self.titleAmbient,"couleur":self.color[selectedCol]]) { (err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            print("success")
            
        }
        
        afficheMenu = true
        
    }
    
    func retourMenu(){
        
        afficheMenu = true
    }
    
}


struct AfficheJeu: View {
    @State var backgroundColor = Color(.systemBackground)
    @Binding var titleAmbient:String
    @Binding var idJeu:String
    @Binding var colorJeu: String
    
    @State private var selectedColor = Color.red
    @Binding var afficheMenu: Bool
    var color = ["Bleu", "Rouge", "Vert", "Jaune"]
    @State private var selectedCol = 0
    
    var body: some View{
        
        VStack{
            
            VStack{
                
                Button(action: {
                    
                    self.retourMenu()
                }) {
                    
                    Text("Retour Menu")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 10)
                
                Text("Nom de l'ambiance")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                    .padding(.top, 15)
                
                TextField("Titre", text: self.$titleAmbient)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.titleAmbient != "" ? Color("Color") : Color.white, lineWidth: 2))
                    .padding(.top, 25)
                
                Text("Nom de la couleur choisie")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                    .padding(.top, 15)
                
                Text(self.colorJeu)
                    .autocapitalization(.none)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.colorJeu != "" ? Color("Color") : Color.white, lineWidth: 2))
                    .padding(.top, 25)
                
                /**NavigationView {
                    VStack(spacing: 20) {
                        // 2.
                        Rectangle()
                            .fill(selectedColor)
                            .frame(width: 100, height: 100)
                        // 3.
                        ColorPicker("Couleur choisie", selection: $selectedColor)
                            .padding()
                        
                        Spacer()
                    
                    }.navigationTitle("Choix de la couleur")
                }*/
                
                Text("Nouvelle couleur")
                    .font(.title2)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundColor(Color.white)
                    .padding(.top, 15)
                
                Picker(selection: $selectedCol, label: Text("Color")) {
                                        ForEach(0 ..< color.count) {
                                            Text(self.color[$0])

                                        }
                }
                
            
            
            HStack{
                
                Button(action: {

                    updateItem()
                    
                }) {
                    
                    Text("Mise à jour")
                        .foregroundColor(.black)
                        .padding(.vertical)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 25)
             
                
                Button(action: {

                    deleteJeu()
                }) {
                    
                    Text("Supprimer le jeu")
                        .foregroundColor(.black)
                        .padding(.vertical)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 25)
             
                Button(action: {

                }) {
                    
                    Text("Activer ")
                        .foregroundColor(.black)
                        .padding(.vertical)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            
            }
            
        }
    }
    
    
    func deleteJeu(){
        
        let db = Firestore.firestore().collection("ambiance")
        
        db.document(idJeu).delete() { (err) in
            
            if(err != nil){
                
                print((err?.localizedDescription)!)
                return
            }
            print("item deleted")
            
        }
        
        afficheMenu = true
    }
    
    func updateItem(){
        
        let db = Firestore.firestore().collection("ambiance")
        
        db.document(idJeu).updateData(["titre": self.titleAmbient,"couleur":self.color[selectedCol]])
    }
    
    func retourMenu(){
        
        afficheMenu = true
    }
    
}
