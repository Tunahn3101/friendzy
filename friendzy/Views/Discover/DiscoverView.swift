//
//  DiscoverView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI

struct DiscoverView: View {
    @State private var showSheet = false
    @State private var selectedCountry: Country? = Country(name: "Germany", code: "DE")

    var body: some View {
        VStack {
            DiscoverHeader(selected: $selectedCountry, showSheet: $showSheet)
            Spacer()

        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.appBackground)
        .navigationBarBackButtonHidden(true)
      
        .sheet(isPresented: $showSheet) {
            if #available(iOS 16.0, *) {
                ChooseLocation(selected: $selectedCountry)
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            } else {
                ChooseLocation(selected: $selectedCountry)
            }
        }
        .onAppear {
            // restore saved selection if present
            let saved = UserDefaults.standard.string(forKey: "selected_country_code")
            if let code = saved {
                let all = CountryLoader.load()
                if let found = all.first(where: { $0.code.uppercased() == code.uppercased() }) {
                    selectedCountry = found
                }
            }
        }
    }
}

struct DiscoverHeader: View {
    @Binding var selected: Country?
    @Binding var showSheet: Bool

    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 8) {
//                    Image("location")
                    // Make the location label tappable (opens sheet) but keep the clear button separate
                    Button(action: { showSheet = true }) {
                        HStack(spacing: 6) {
                            Text("\(selected?.flagEmoji ?? "") \(selected?.name ?? "Germany")")
                                .foregroundColor(.primary)
                            Image(systemName: "chevron.down")
                                .foregroundColor(Color.appPrimary)
                        }
                    }
                    .buttonStyle(.plain)

                  
                }

                Text("Discover")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "0xFF4B164C"))

            }
            Spacer()
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "0xFF4B164C"), lineWidth: 1)
                )
            Spacer()
                .frame(width: 16)

            Image(systemName: "ellipsis")
                .font(.system(size: 22))
                .frame(width: 48, height: 48)
                .clipShape(Circle())
                .overlay(
                    Circle().stroke(Color(hex: "0xFF4B164C"), lineWidth: 1)
                )

        }
        .padding(.horizontal, 16)

    }
}
struct ChooseLocation: View {
    @Binding var selected: Country?
    @Environment(\.dismiss) private var dismiss
    
    @State private var countries: [Country] = CountryLoader.load()
    @State private var searchText: String = ""
    @State private var keyboardHeight: CGFloat = 0
    
    private var filtered: [Country] {
        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return countries
        }
        let q = searchText.lowercased()
        return countries.filter {
            $0.name.lowercased().contains(q) || $0.code.lowercased().contains(q)
        }
    }
    
    private var grouped: [String: [Country]] {
        Dictionary(grouping: filtered) { country in
            String(country.name.prefix(1)).uppercased()
        }
    }
    
    private var sectionTitles: [String] {
        grouped.keys.sorted()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search countries", text: $searchText)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider()

            ScrollViewReader { proxy in
                ZStack(alignment: .topTrailing) {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0, pinnedViews: []) {
                            ForEach(sectionTitles, id: \.self) { key in
                                Section(header:
                                            Text(key)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)
                                    .padding(.top, 12)
                                    .padding(.bottom, 4)
                                    .id(key)
                                ) {
                                    ForEach(grouped[key] ?? []) { country in
                                        Button {
                                            selected = country
                                            UserDefaults.standard.set(country.code, forKey: "selected_country_code")
                                            dismiss()
                                        } label: {
                                            HStack {
                                                Text(country.flagEmoji)
                                                    .frame(width: 28)
                                                Text(country.name)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                if selected?.id == country.id {
                                                    Image(systemName: "checkmark")
                                                        .foregroundColor(.white)
                                                        .padding(6)
                                                        .background(Color.appPrimary)
                                                        .clipShape(Circle())
                                                }
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 32)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .fill(selected?.id == country.id ? Color.appPrimary.opacity(0.1) : Color.clear)
                                            )
                                        }
                                        .buttonStyle(.plain)
                                        Divider().padding(.leading, 52)
                                    }
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }

                  
                    VStack(spacing: 6) {
                        ForEach(sectionTitles, id: \.self) { letter in
                            Button(action: {
                                withAnimation {
                                    proxy.scrollTo(letter, anchor: .top)
                                }
                            }) {
                                Text(letter)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(minWidth: 20)
                            }
                        }
                    }
                    .padding(.trailing, 6)
                }
                .frame(maxHeight: .infinity)
            }

            Button(action: { dismiss() }) {
                Text("Close")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color.appPrimary)
                    .cornerRadius(12)
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 30)
        }
        .background(Color(UIColor.systemBackground))
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillChangeFrameNotification)) { notif in
            guard let info = notif.userInfo,
                  let frame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
            keyboardHeight = max(0, frame.height)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            keyboardHeight = 0
        }
    }
    
}

#Preview {
    DiscoverView()
}

