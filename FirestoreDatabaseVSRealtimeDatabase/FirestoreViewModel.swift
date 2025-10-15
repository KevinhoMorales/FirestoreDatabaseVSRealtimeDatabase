//
//  FirestoreViewModel.swift
//  FirestoreDatabaseVSRealtimeDatabase
//
//  Created by Kevinho Morales on 15/10/25.
//

import Foundation
import Combine
import FirebaseFirestore

struct FirestoreItem: Identifiable {
    let id: String
    var name: String
    var phoneNumber: String
}

@MainActor
class FirestoreViewModel: ObservableObject {
    @Published var items: [FirestoreItem] = []
    private let db = Firestore.firestore().collection("items")
    private var listener: ListenerRegistration?

    init() {
        startListening()
    }
    
    deinit {
        listener?.remove()
    }

    private func startListening() {
        listener = db.addSnapshotListener { snapshot, error in
            if let error = error {
                print("❌ Firestore Error: \(error.localizedDescription)")
                return
            }
            
            guard let snapshot = snapshot else {
                print("⚠️ Firestore: No snapshot available")
                return
            }
            
                let newItems = snapshot.documents.map {
                    FirestoreItem(
                        id: $0.documentID, 
                        name: $0["name"] as? String ?? "",
                        phoneNumber: $0["phoneNumber"] as? String ?? ""
                    )
                }
            
            print("📄 Firestore: Loaded \(newItems.count) items")
            DispatchQueue.main.async {
                self.items = newItems
            }
        }
    }

    func fetchItems() {
        // Ya no es necesario llamar fetchItems manualmente
        // La observación en tiempo real se encarga de actualizar automáticamente
    }

    func addItem(name: String, phoneNumber: String) {
        db.addDocument(data: ["name": name, "phoneNumber": phoneNumber]) { error in
            if let error = error {
                print("❌ Firestore Add Error: \(error.localizedDescription)")
            } else {
                print("✅ Firestore: Added contact '\(name)'")
            }
        }
    }

    func updateItem(_ item: FirestoreItem) {
        db.document(item.id).updateData([
            "name": item.name,
            "phoneNumber": item.phoneNumber
        ]) { error in
            if let error = error {
                print("❌ Firestore Update Error: \(error.localizedDescription)")
            } else {
                print("✅ Firestore: Updated contact '\(item.name)'")
            }
        }
    }

    func deleteItem(_ item: FirestoreItem) {
        db.document(item.id).delete { error in
            if let error = error {
                print("❌ Firestore Delete Error: \(error.localizedDescription)")
            } else {
                print("✅ Firestore: Deleted contact '\(item.name)'")
            }
        }
    }
}

