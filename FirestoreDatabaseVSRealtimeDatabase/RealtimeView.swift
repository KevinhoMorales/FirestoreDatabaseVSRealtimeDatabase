//
//  RealtimeView.swift
//  FirestoreDatabaseVSRealtimeDatabase
//
//  Created by Kevinho Morales on 15/10/25.
//

import SwiftUI

struct RealtimeView: View {
    @StateObject private var viewModel = RealtimeViewModel()
    @State private var newItem = ""
    @State private var showingAddSheet = false
    @State private var showingDeleteAlert = false
    @State private var showingEditAlert = false
    @State private var itemToDelete: RealtimeItem?
    @State private var itemToEdit: RealtimeItem?

    var body: some View {
        ZStack {
            // Fondo degradado
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.05), Color.mint.opacity(0.05)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header personalizado
                RealtimeHeader()
                
                // Lista de elementos
                if viewModel.items.isEmpty {
                    EmptyStateView(
                        icon: "person.3.fill",
                        title: "No hay contactos",
                        subtitle: "Los contactos existentes se cargarán automáticamente desde Realtime Database",
                        actionTitle: "Agregar Primer Contacto",
                        action: { showingAddSheet = true }
                    )
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(viewModel.items, id: \.id) { item in
                                RealtimeItemRow(
                                    item: item, 
                                    onEdit: {
                                        itemToEdit = item
                                        showingEditAlert = true
                                    },
                                    onDelete: {
                                        itemToDelete = item
                                        showingDeleteAlert = true
                                    }
                                )
                                .transition(.asymmetric(
                                    insertion: .scale.combined(with: .opacity),
                                    removal: .scale.combined(with: .opacity)
                                ))
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 16)
                    }
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundColor(.green)
                }
            }
        }
        .sheet(isPresented: $showingAddSheet) {
            AddContactSheet(
                title: "Agregar Contacto a Realtime Database",
                action: { name, phoneNumber in
                    viewModel.addItem(name: name, phoneNumber: phoneNumber)
                }
            )
        }
        .sheet(item: $itemToEdit) { item in
            EditContactSheet(
                title: "Editar Contacto",
                contact: item,
                action: { updatedItem in
                    viewModel.updateItem(updatedItem)
                }
            )
        }
        .alert("¿Eliminar contacto?", isPresented: $showingDeleteAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Eliminar", role: .destructive) {
                if let item = itemToDelete {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        viewModel.deleteItem(item)
                    }
                }
            }
        } message: {
            if let item = itemToDelete {
                Text("¿Estás seguro de que quieres eliminar el contacto '\(item.name)'? Esta acción no se puede deshacer.")
            }
        }
        .alert("¿Editar contacto?", isPresented: $showingEditAlert) {
            Button("Cancelar", role: .cancel) { }
            Button("Editar") {
                // La edición se maneja en el sheet
            }
        } message: {
            if let item = itemToEdit {
                Text("¿Quieres editar el contacto '\(item.name)'?")
            }
        }
    }
}

struct RealtimeHeader: View {
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Contactos en Realtime")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Sincronización en tiempo real")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Indicador de estado
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 8, height: 8)
                    Text("Conectado")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color(.systemBackground))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color(.separator))
                    .opacity(0.3),
                alignment: .bottom
            )
        }
    }
}

struct RealtimeItemRow: View {
    let item: RealtimeItem
    let onEdit: () -> Void
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar del contacto
            Image(systemName: "person.circle.fill")
                .font(.title2)
                .foregroundColor(.green)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color.green.opacity(0.1))
                )
            
            // Información del contacto
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                HStack(spacing: 4) {
                    Image(systemName: "phone.fill")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(item.phoneNumber.isEmpty ? "Sin teléfono" : item.phoneNumber)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
            
            // Botones de acción
            HStack(spacing: 8) {
                Button(action: onEdit) {
                    Image(systemName: "pencil.circle.fill")
                        .font(.title3)
                        .foregroundColor(.orange)
                }
                
                Button(action: onDelete) {
                    Image(systemName: "trash.circle.fill")
                        .font(.title3)
                        .foregroundColor(.red)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        )
    }
}

struct EmptyStateView: View {
    let icon: String
    let title: String
    let subtitle: String
    let actionTitle: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 64))
                .foregroundColor(.green.opacity(0.3))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Button(action: action) {
                HStack(spacing: 8) {
                    Image(systemName: "plus.circle.fill")
                    Text(actionTitle)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.green)
                )
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct AddContactSheet: View {
    let title: String
    let action: (String, String) -> Void
    
    @State private var name = ""
    @State private var phoneNumber = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre del contacto")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Ej: Juan Pérez", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Número de teléfono")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Ej: +1 234 567 8900", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .keyboardType(.phonePad)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Agregar") {
                        if !name.isEmpty {
                            action(name, phoneNumber)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty)
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

struct EditContactSheet: View {
    let title: String
    let contact: RealtimeItem
    let action: (RealtimeItem) -> Void
    
    @State private var name: String
    @State private var phoneNumber: String
    @Environment(\.dismiss) private var dismiss
    
    init(title: String, contact: RealtimeItem, action: @escaping (RealtimeItem) -> Void) {
        self.title = title
        self.contact = contact
        self.action = action
        self._name = State(initialValue: contact.name)
        self._phoneNumber = State(initialValue: contact.phoneNumber)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Nombre del contacto")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Ej: Juan Pérez", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Número de teléfono")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    TextField("Ej: +1 234 567 8900", text: $phoneNumber)
                        .textFieldStyle(.roundedBorder)
                        .font(.body)
                        .keyboardType(.phonePad)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancelar") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Guardar") {
                        if !name.isEmpty {
                            let updatedContact = RealtimeItem(
                                id: contact.id,
                                name: name,
                                phoneNumber: phoneNumber
                            )
                            action(updatedContact)
                            dismiss()
                        }
                    }
                    .disabled(name.isEmpty || (name == contact.name && phoneNumber == contact.phoneNumber))
                    .fontWeight(.semibold)
                }
            }
        }
    }
}

#Preview {
    RealtimeView()
}


