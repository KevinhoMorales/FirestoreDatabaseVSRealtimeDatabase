//
//  RealtimeViewModel.swift
//  FirestoreDatabaseVSRealtimeDatabase
//
//  Created by Kevinho Morales on 15/10/25.
//

import Foundation
import Combine
import FirebaseDatabase

struct RealtimeItem: Identifiable {
    let id: String
    var name: String
    var phoneNumber: String
}

@MainActor
class RealtimeViewModel: ObservableObject {
    @Published var items: [RealtimeItem] = []
    private let ref = Database.database().reference(withPath: "items")
    private var handle: DatabaseHandle?

    init() {
        startListening()
    }
    
    deinit {
        if let handle = handle {
            ref.removeObserver(withHandle: handle)
        }
    }

    private func startListening() {
        handle = ref.observe(.value) { snapshot in
            var temp: [RealtimeItem] = []
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any],
                   let name = value["name"] as? String {
                    let phoneNumber = value["phoneNumber"] as? String ?? ""
                    temp.append(RealtimeItem(id: snap.key, name: name, phoneNumber: phoneNumber))
                }
            }
            
            print("📄 Realtime Database: Loaded \(temp.count) items")
            DispatchQueue.main.async {
                self.items = temp
            }
        }
    }

    func fetchItems() {
        // Ya no es necesario llamar fetchItems manualmente
        // La observación en tiempo real se encarga de actualizar automáticamente
    }

    func addItem(name: String, phoneNumber: String) {
        let newRef = ref.childByAutoId()
        newRef.setValue(["name": name, "phoneNumber": phoneNumber]) { error, _ in
            if let error = error {
                print("❌ Realtime Database Add Error: \(error.localizedDescription)")
            } else {
                print("✅ Realtime Database: Added contact '\(name)'")
            }
        }
    }

    func updateItem(_ item: RealtimeItem) {
        ref.child(item.id).updateChildValues([
            "name": item.name,
            "phoneNumber": item.phoneNumber
        ]) { error, _ in
            if let error = error {
                print("❌ Realtime Database Update Error: \(error.localizedDescription)")
            } else {
                print("✅ Realtime Database: Updated contact '\(item.name)'")
            }
        }
    }

    func deleteItem(_ item: RealtimeItem) {
        ref.child(item.id).removeValue { error, _ in
            if let error = error {
                print("❌ Realtime Database Delete Error: \(error.localizedDescription)")
            } else {
                print("✅ Realtime Database: Deleted contact '\(item.name)'")
            }
        }
    }
}

