//
//  TestPrint.swift
//  Flavor
//
//  Created by Emilio Martinez on 2024-08-15.
//

import SwiftUI

struct TestPrint: View {
    var body: some View {
        Button(action: {
            button()
        }) {
            Text("Tapp")
        }
    }
    
    
    func button() {
        var string = "hello" + "24"
        print(string)
    }
}

#Preview {
    TestPrint()
        .environment(\.locale, .init(identifier: "fr"))
}
