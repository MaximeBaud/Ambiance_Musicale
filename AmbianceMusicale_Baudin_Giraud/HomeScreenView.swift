//
//  HomeScreenView.swift
//  AmbianceMusicale_Baudin_Giraud
//
//  Created by Maxime Baudin on 09/01/2021.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct HomeScreenView: View {
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    @ObservedObject var datas = observer()
    
    @State var afficheJeu: Bool = false
    @State var titre: String = ""
    @State var couleur: String = ""
    @State var id: String = ""
    
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.afficheJeu{
                    JeuAmbianceView(titre: self.$titre, couleur: self.$couleur, id: self.$id)
                    
                }
                else {
                        
                    ScreenBase(afficheJeu: self.$afficheJeu, titre: self.$titre, couleur: self.$couleur,idJeu: self.$id)
                        
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
    }
}

/**struct HomeScreenView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreenView()
    }
}**/

class observer : ObservableObject{
    
    @Published var data = [datatype]()
    
    init() {
        
        let db = Firestore.firestore().collection("ambiance")
        
        db.addSnapshotListener { (snap,err) in
            
            if err != nil{
                
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documents{
                
                let ambianceData = datatype(id: i.documentID, titre: i.get("titre")as! String, couleur: i.get("couleur")as! String)
                
                self.data.append(ambianceData)
            }
        }
    }
}

struct datatype : Identifiable {
    
    var id : String
    var titre : String
    var couleur : String
}

struct ScreenBase : View {
    @ObservedObject var datas = observer()
    @Binding var afficheJeu: Bool
    @Binding var titre: String
    @Binding var couleur: String
    @Binding var idJeu: String
    
    var body: some View{
        
        VStack {
            
            VStack{
                
            
            NavigationView  {
                List{
                    
                    ForEach(datas.data){i in
                        
                        /**Text(i.titre)
                        NavigationLink(destination: JeuAmbianceView()) {
                                            Text("Show Detail View")
                                        }**/
                        Button(action: {
                            self.montreScreenWithValue(title: i.titre,color: i.couleur,id: i.id)
                        }) {
                            
                            Text(i.titre)
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                    }
                }
                .navigationTitle("Votre Liste")
                .foregroundColor(.white)
            }
            .navigationBarTitle("Votre liste")
            
            Button(action: {
                self.montreScreen()
            }) {
                
                Text("Créer Nouveau Jeu")
                    .foregroundColor(.black)
                    .padding(.vertical)
                    .frame(width: UIScreen.main.bounds.width - 50)
            }
            .background(Color.white)
            .cornerRadius(10)
            .padding(.top, 5)
            
            VStack{
                
                Button(action: {
                    
                    try! Auth.auth().signOut()
                    UserDefaults.standard.set(false, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                }) {
                    
                    Text("Deconnexion")
                        .foregroundColor(.black)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 50)
                }
                .background(Color.white)
                .cornerRadius(10)
                .padding(.top, 5)
                
            }
            
            }

        }
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
    }
    
    
    func montreScreen(){
        
        afficheJeu = true
    }
    
    func montreScreenWithValue(title: String, color: String, id: String){
        
        afficheJeu = true
        titre = title
        couleur = color
        idJeu = id
    }
}