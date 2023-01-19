//
//  Copyright  All rights reserved.
//

import SwiftUI

struct ColorScreen: View {
    let color: Color
    
    var body: some View {
        color
    }
}

struct ColorScreen_Previews: PreviewProvider {
    static var previews: some View {
        ColorScreen(color: .red)
    }
}
