//
//  HTCardView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/6/24.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTCardView: View {
    @Binding var event: HTEvent
    
    var body: some View {
        VStack {
            Text(event.detail)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct HTCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        GeometryReader { geo in
            HTCardView(event: .constant(HTEvent()))
                .padding(.all, 10)
        }
    }
}
