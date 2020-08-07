//
//  PagedTableView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/7/31.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTPagedTableView<T: Any, Content: View>: UIViewRepresentable {
    
    @Binding var items: [T]
    let content: (T) -> Content
    
    func makeUIView(context: Context) -> UITableView {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.isPagingEnabled = true
        tableView.delegate = context.coordinator
        tableView.dataSource = context.coordinator
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.register(HostingCell.self, forCellReuseIdentifier: "HostingCell")
        return tableView
    }
    
    func updateUIView(_ uiView: UITableView, context: Context) {
        DispatchQueue.main.async {
            uiView.reloadData()
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($items, content: self.content)
    }
    
    class HostingCell: UITableViewCell {
        var host: UIHostingController<AnyView>?
    }
    
    class Coordinator: NSObject, UITableViewDelegate, UITableViewDataSource {
        
        @Binding var items: [T]
        let content: (T) -> Content
        
        init(_ items: Binding<[T]>, @ViewBuilder content: @escaping (T) -> Content) {
            _items = items
            self.content = content
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HostingCell", for: indexPath) as! HostingCell
            let item = self.items[indexPath.row]
            let view = self.content(item)
            if cell.host == nil {
                cell.host = UIHostingController(rootView: AnyView(view))
            } else {
                cell.host?.rootView = AnyView(view)
            }
            
            if let host = cell.host, let content = host.view {
                content.translatesAutoresizingMaskIntoConstraints = false
                cell.contentView.addSubview(content)
                NSLayoutConstraint.activate([
                    content.topAnchor.constraint(equalTo: cell.contentView.topAnchor),
                    content.leftAnchor.constraint(equalTo: cell.contentView.leftAnchor),
                    content.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                    content.rightAnchor.constraint(equalTo: cell.contentView.rightAnchor)
                ])
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
            return screenHeight
        }
        
    }
}
