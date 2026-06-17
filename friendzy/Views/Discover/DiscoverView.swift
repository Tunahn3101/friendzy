//
//  DiscoverView.swift
//  friendzy
//
//  Created by Phạm Tuấn Anh on 1/5/26.
//

import SwiftUI
import MapKit

struct DiscoverView: View {
    @State private var showSheet = false
    @State private var selectedCountry: Country? = Country(
        name: "Germany",
        code: "DE"
    )
    @State private var selectedInterest: String? = nil  // Track selected interest

    var body: some View {
        VStack(spacing: 0) {
            DiscoverHeader(selected: $selectedCountry, showSheet: $showSheet)
            
            ScrollView {
                VStack(spacing: 0) {
                    DiscoverUserList()
                    Interest(selectedInterest: $selectedInterest)
                    MapDiscoverView(selectedInterest: selectedInterest)
                        .frame(height: 400)
                        .padding(.top, 16)
                        .padding(.bottom, 40)
                }
            }
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
            let saved = UserDefaults.standard.string(
                forKey: "selected_country_code"
            )
            if let code = saved {
                let all = CountryLoader.load()
                if let found = all.first(where: {
                    $0.code.uppercased() == code.uppercased()
                }) {
                    selectedCountry = found
                }
            }
        }
    }
}


struct Interest: View {
    @State private var interests: [InterestModel] = sampleInterests
    @State private var showAllInterests: Bool = false
    @Binding var selectedInterest: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Interest")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                Button("View All") {
                    showAllInterests = true
                }
                .foregroundColor(Color.appPrimary)
            }
            
            InterestGridView(interests: Array(interests.prefix(8)), selectedInterest: $selectedInterest)
        }
        .padding(.horizontal, 16)
        .sheet(isPresented: $showAllInterests) {
            InterestDetailView(interests: $interests, selectedInterest: $selectedInterest)
        }
    }
}


struct InterestGridView: View {
    let interests: [InterestModel]
    @Binding var selectedInterest: String?
    
    var body: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
        
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: columns, spacing: 8) {
                ForEach(interests) { interest in
                    InterestCard(
                        interest: interest,
                        isActive: selectedInterest == interest.name
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3)) {
                            if selectedInterest == interest.name {
                                selectedInterest = nil  // Toggle off
                            } else {
                                selectedInterest = interest.name  // Select new
                            }
                        }
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
}


struct InterestCard: View {
    let interest: InterestModel
    var isActive: Bool = false
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: interest.icon)
                .font(.system(size: 16))
                .foregroundColor(isActive ? .white : interest.color)
                .frame(width: 32, height: 32)
                .background(isActive ? interest.color : interest.color.opacity(0.15))
                .clipShape(Circle())
            
            Text(interest.name)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(isActive ? .white : .primary)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(minWidth: 130, alignment: .leading)
        .background(isActive ? interest.color : Color(UIColor.secondarySystemBackground))
        .cornerRadius(20)
    }
}


struct InterestDetailView: View {
    @Binding var interests: [InterestModel]
    @Binding var selectedInterest: String?
    @Environment(\.dismiss) private var dismiss
    
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(interests) { interest in
                        let isActive = selectedInterest == interest.name
                        
                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                if isActive {
                                    selectedInterest = nil
                                } else {
                                    selectedInterest = interest.name
                                }
                            }
                        } label: {
                            VStack(spacing: 12) {
                                Image(systemName: interest.icon)
                                    .font(.system(size: 32))
                                    .foregroundColor(isActive ? .white : interest.color)
                                    .frame(width: 64, height: 64)
                                    .background(isActive ? interest.color : interest.color.opacity(0.15))
                                    .clipShape(Circle())
                                
                                Text(interest.name)
                                    .font(.system(size: 15, weight: .semibold))
                                    .foregroundColor(isActive ? .white : .primary)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                
                                // Checkmark indicator
                                ZStack {
                                    if isActive {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.white)
                                            .font(.system(size: 20))
                                    }
                                }
                                .frame(height: 20)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .padding(.horizontal, 12)
                            .background(isActive ? interest.color : Color(UIColor.secondarySystemBackground))
                            .cornerRadius(20)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 20)
                .padding(.bottom, 40)
            }
            .navigationTitle("Interests")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.appPrimary)
                }
            }
        }
    }
}



struct DiscoverUserList: View {
    let listUserDiscover: [UserModel] = sampleDiscoverUsers
    var body: some View {
        GeometryReader { geometry in
            let screenWidth = geometry.size.width
            let cardWidth = max(96, min(160, screenWidth * 0.28))
            let cardHeight = cardWidth * (181.0 / 120.0)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 12) {
                    ForEach(listUserDiscover) { user in
                        ZStack {
                            Image(user.avatarURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: cardWidth, height: cardHeight)
                                .clipped()
                                .cornerRadius(12)

                            Text("NEW")
                                .foregroundColor(.white)
                                .font(.system(size: 15, weight: .semibold))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(hex: "0xFF3A0D3B"))
                                .cornerRadius(6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(
                                            Color(hex: "0xFFD36FC4"),
                                            lineWidth: 1.5
                                        )
                                )
                                .frame(
                                    width: cardWidth,
                                    height: cardHeight,
                                    alignment: .topLeading
                                )
                                .offset(
                                    x: cardWidth * 0.06,
                                    y: cardHeight * 0.05
                                )

                            VStack(spacing: 6) {
                                Text("\(user.distance) km away")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .semibold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 5)
                                    .background(
                                        .ultraThinMaterial.opacity(0.28)
                                    )
                                    .clipShape(
                                        RoundedRectangle(cornerRadius: 10)
                                    )
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .stroke(
                                                Color.white.opacity(0.35),
                                                lineWidth: 1
                                            )
                                    )
                                    .shadow(
                                        color: Color.black.opacity(0.05),
                                        radius: 2,
                                        x: 0,
                                        y: 1
                                    )

                                Text("\(user.name), \(user.age)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .semibold))

                                Text("\(user.location)")
                                    .foregroundColor(.white.opacity(0.85))
                                    .font(.system(size: 12))
                            }
                            .frame(
                                width: cardWidth,
                                height: cardHeight,
                                alignment: .bottom
                            )
                            .padding(.bottom, 10)

                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .frame(height: cardHeight + 40)
            .padding(.top, 16)
        }
        .frame(height: 220)
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
                            Text(
                                "\(selected?.flagEmoji ?? "") \(selected?.name ?? "Germany")"
                            )
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
                        LazyVStack(
                            alignment: .leading,
                            spacing: 0,
                            pinnedViews: []
                        ) {
                            ForEach(sectionTitles, id: \.self) { key in
                                Section(
                                    header:
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
                                            UserDefaults.standard.set(
                                                country.code,
                                                forKey: "selected_country_code"
                                            )
                                            dismiss()
                                        } label: {
                                            HStack {
                                                Text(country.flagEmoji)
                                                    .frame(width: 28)
                                                Text(country.name)
                                                    .foregroundColor(.primary)
                                                Spacer()
                                                if selected?.id == country.id {
                                                    Image(
                                                        systemName: "checkmark"
                                                    )
                                                    .foregroundColor(.white)
                                                    .padding(6)
                                                    .background(
                                                        Color.appPrimary
                                                    )
                                                    .clipShape(Circle())
                                                }
                                            }
                                            .padding(.leading, 16)
                                            .padding(.trailing, 32)
                                            .padding(.vertical, 12)
                                            .background(
                                                RoundedRectangle(
                                                    cornerRadius: 8
                                                )
                                                .fill(
                                                    selected?.id == country.id
                                                        ? Color.appPrimary
                                                            .opacity(0.1)
                                                        : Color.clear
                                                )
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
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillChangeFrameNotification
            )
        ) { notif in
            guard let info = notif.userInfo,
                let frame = info[UIResponder.keyboardFrameEndUserInfoKey]
                    as? CGRect
            else { return }
            keyboardHeight = max(0, frame.height)
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification
            )
        ) { _ in
            keyboardHeight = 0
        }
    }

}

// Map View Component
struct MapDiscoverView: View {
    var selectedInterest: String?
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 52.5200, longitude: 13.4050),  // Berlin
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    private var filteredUsers: [MapUserModel] {
        if let interest = selectedInterest {
            return sampleMapUsers.filter { $0.interests.contains(interest) }
        }
        return sampleMapUsers
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Nearby")
                    .font(.system(size: 18, weight: .bold))
                
                if let interest = selectedInterest {
                    Text("· \(interest)")
                        .font(.system(size: 14))
                        .foregroundColor(Color.appPrimary)
                }
                
                Spacer()
                
                Text("\(filteredUsers.count) people")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)
            
            if #available(iOS 17.0, *) {
                Map {
                    ForEach(filteredUsers) { user in
                        Annotation(user.name, coordinate: user.coordinate) {
                            UserMapPin(user: user)
                        }
                    }
                }
                .cornerRadius(16)
                .padding(.horizontal, 16)
            } else {
                Map(coordinateRegion: $region, annotationItems: filteredUsers) { user in
                    MapAnnotation(coordinate: user.coordinate) {
                        UserMapPin(user: user)
                    }
                }
                .cornerRadius(16)
                .padding(.horizontal, 16)
            }
        }
    }
}

// Custom Map Pin
struct UserMapPin: View {
    let user: MapUserModel
    @State private var showDetail = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Avatar
            Image(user.avatarURL)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
                .onTapGesture {
                    withAnimation {
                        showDetail.toggle()
                    }
                }
            
            // Info card khi tap
            if showDetail {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(user.name), \(user.age)")
                        .font(.system(size: 14, weight: .semibold))
                    Text("\(user.distance) km away")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                .padding(8)
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 4)
                .transition(.scale.combined(with: .opacity))
            }
        }
    }
}

#Preview {
    DiscoverView()
}
