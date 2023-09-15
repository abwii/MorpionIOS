import SwiftUI

struct ContentView: View {

	//declarations des elements utilises dans le code
    @State private var grid = ["", "", "", "", "", "", "", "", ""]
    @State private var currentPlayer = "X"
    @State private var showingpopover = false
    @State private var showingpopoverselect = true
    @State private var phrase = ""
    @State private var playing = true
    @State private var winningCells: [Int] = []

    var body: some View {
        VStack {
            Text("Morpion")
                .font(.largeTitle)
                .padding(.top, 30)

            Text("C'est au tour de : " + currentPlayer)

            Spacer()

            VStack(spacing: 1) {
                ForEach(0..<3) { row in
                    HStack(spacing: 1) {
                        ForEach(0..<3) { col in
                            Button(action: {
                                if playing {
					// verifier si la case dans la table de morpion est vide, si oui, changer la case en fonction du joueur en cours, verifie a chaque fois si
					// un joueur a gagne ou si la partie ne s'est pas termine par un egalite, sans ces deux conditions, le jeu continue et on change de joueur
                                    if grid[row * 3 + col].isEmpty {
                                        grid[row * 3 + col] = currentPlayer
                                        winVerif()
                                        drawVerif()
                                        togglePlayer()
                                    }
                                }
                            }) {
                                Text(grid[row * 3 + col])
                                    .font(.largeTitle)
                                    .frame(width: 100, height: 100)
                                    .background(
					// si un joeur gagne, colories les cases qui ont menees a la victoire du joueur
                                        winningCells.contains(row * 3 + col) ? Color.red : Color.black
                                    )
                                    .foregroundColor(.white)
                                    .cornerRadius(0)
                            }
                        }
                    }
                }
            }
            .cornerRadius(15)

            Spacer()

		// le bouton recommencer fait recommencer toute la partie, on devra a nouveau choisir quel joueur commence ('X' ou 'O'), on reinitialise le tabbleau 
		// des resultats a vide et on donne la permission de jouer, les cases precedement colores dans le cas d'une victoire d'un joueur redevienne normales
            Button("Recommencer") {
                showingpopoverselect = true
                grid = ["", "", "", "", "", "", "", "", ""]
                playing = true
                winningCells = []
            }
            .foregroundColor(.black)
        }

		
        .popover(isPresented: $showingpopover) {
            Text(phrase)
                .font(.headline)
                .padding()
        }
        
        	//popover permettant de choisir le joueur qui commence, celui-ci se lance au lancement de l'application ainsi qu'au moment ou on choisit de recommencer
        .popover(isPresented: $showingpopoverselect) {
            Text("Qui commence ?")
                .font(.headline)
                .padding()
            
            HStack{
                Button("X"){
                    currentPlayer = "X"
                    showingpopoverselect = false
                }
                .buttonStyle(.bordered)
                Button("O"){
                    currentPlayer = "O"
                    showingpopoverselect = false
                }
                .buttonStyle(.bordered)
            }
            
        }
        
        
    }

	//fonction permettant de passer d'un joueur a l'autre
    private func togglePlayer() {
        currentPlayer = (currentPlayer == "X") ? "O" : "X"
    }

	//fonction permettant de verifier si un joeur a gagne
    private func winVerif() {
        print("vérif joueur " + currentPlayer + "...")
		// dans ce tableau on retrouve toutes les conditions de victoire dans un morpion classique
        let win = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
		// on boucle dans le tableau des valeurs pour gagner, si la valeur de l'indexe indiquant le joeur actuel ('X' ou 'O') dans la liste grid est different 
		// des valeurs situes aux indexes gagnates, alors le joueur actuel n'a pas gagne. Dans le cas ou celui-ci gagne, la partie est termineet on fait un affichage
		// d'une partie gagnee
        for sequence in win {
            var playerWon = true

            for index in sequence {
                if grid[index] != currentPlayer {
                    playerWon = false
                    break
                }
            }

            if playerWon {
                print("gagné")
                phrase = ("Joueur " + currentPlayer + " à gagné !")
                showingpopover = true
                playing = false
                winningCells = sequence // Marquer les cellules gagnantes en rouge
                break
            }
        }
    }

		// cette fonction permet de verifier s'il n'y a pas une egalite (aucun joeur gagne et toutes les cases sont remplies)
    private func drawVerif() {
        let allNonEmpty = grid.allSatisfy { element in
            return !element.isEmpty
        }

        if allNonEmpty && playing {
            print("full")
            phrase = "Égalité"
            playing = false
            showingpopover = true
        } else {
            print("not full")
        }
    }
}
