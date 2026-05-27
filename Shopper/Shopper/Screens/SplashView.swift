//
//  SplashView.swift
//  Shopper
//
//  Created by Mohit  on 27/05/26.
//

import SwiftUI

struct SplashView: View {
    @State private var navigateToOnboarding = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("Shopper")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Button {
                        navigateToOnboarding = true
                    } label: {
                        Text("Get Started")
                            .font(.headline)
                            .foregroundColor(.green)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.white)
                            .clipShape(Rectangle())
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 0)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(isPresented: $navigateToOnboarding) {
                OnBoardingView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}

#Preview {
    SplashView()
}
