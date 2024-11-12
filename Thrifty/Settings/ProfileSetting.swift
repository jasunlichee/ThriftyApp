//
//  ProfileSetting.swift
//  Thrifty
//
//  Created by Jason Li on 11/6/24.
//

import SwiftUI

struct ProfileSetting: View {
    @ObservedObject var vm: ProfileVM
    var body: some View {
        if let user = vm.user {
            Text("\(user.email ?? "No email found")")
                .padding(.top, 15)
        } else {
            Text("No email found")
                .padding(.top, 15)
        }
    }
}

struct ProfileSetting_Previews: PreviewProvider {
    static var previews: some View {
        let vmPreview = ProfileVM()
        ProfileSetting(vm: vmPreview)
    }
}
