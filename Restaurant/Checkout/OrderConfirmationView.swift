//
//  OrderConfirmationView.swift
//  Restaurant
//
//  Created by Zaid Jamil on 9/9/26.
//

import SwiftUI
import MapKit

struct OrderConfirmationView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(Router.self) private var router
    let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 40.575231867319545, longitude: -111.94367006139085)
    let name: String = "Test Location"
    
    private var position: MapCameraPosition {
       .region(MKCoordinateRegion(
           center: coordinate,
           span: MKCoordinateSpan(latitudeDelta: 0.004, longitudeDelta: 0.004)
       ))
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 16) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 56, height: 56)
                        .padding(10)
                        .foregroundStyle(.brandPrimary)
                        .overlay {
                            Circle()
                                .fill(.clear)
                                .strokeBorder(.brandPrimary, lineWidth: 2)
                        }
                    VStack(spacing: 6) {
                        Text("Order Confirmed!")
                            .font(.inter(26, weight: .heavy))
                        Text("Your meal is being prepared. Swing by the restaurant to pick it up")
                            .font(.inter(15))
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.placeholder)
                    }
                    
                    HStack {
                        Text("ORDER#:")
                            .font(.inter(13, weight: .medium))
                            .foregroundStyle(.placeholder.secondary)
                        Text("LB-123")
                            .font(.inter(14, weight: .bold))
                            
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal)
                    .background(.surfaceElevated, in: Capsule())
                }
                .padding(.vertical, 12)
                
                VStack(alignment: .leading) {
                    Text("PICKUP LOCATION")
                        .font(.inter(14, weight: .semibold))
                        .foregroundStyle(.placeholder)
                    
                    Map(initialPosition: position, interactionModes: []) {
                            Marker(name, systemImage: "fork.knife", coordinate: coordinate)
                                .tint(.red)
                        }
                        .frame(height: 220)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .allowsHitTesting(false)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(name)
                                .font(.inter(18, weight: .bold))
                            Text("1961 Santorini Dr, South Jordan, Utah 84124")
                                .font(.inter(14))
                                .foregroundStyle(.placeholder)
                        }
                        Spacer()
                        Button {
                            let placemark = MKPlacemark(coordinate: coordinate)
                            let item = MKMapItem(placemark: placemark)
                            item.name = name
                            item.openInMaps(launchOptions: [
                                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
                            ])
                        } label: {
                            Image(systemName: "location")
                                .padding(8)
                                .background(.surface, in: RoundedRectangle(cornerRadius: 8))
                        }
                        .buttonStyle(.plain)
                    }
                    
                    Divider()
                    
                    HStack{
                        Image(systemName: "clock")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundStyle(.primary)
                        Text("Pickup Time")
                        Spacer()
                        Text("ASAP")
                            .font(.inter(15, weight: .bold))
                    }
                }
                .padding(18)
                .background(.surfaceElevated, in: RoundedRectangle(cornerRadius: 12))
                
                Button("BACK TO HOME") {
                    dismiss()
                    router.popToRoot()
                }
                .buttonStyle(.primary)
            }
            .safeAreaPadding(20)
        }
    }
}

#Preview {
    @Previewable @State var router = Router()
    NavigationStack {
        ZStack {
            Color.BG.ignoresSafeArea()
            OrderConfirmationView()
                .environment(router)
        }
    }
}
