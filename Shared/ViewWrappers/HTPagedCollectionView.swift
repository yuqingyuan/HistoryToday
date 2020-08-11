//
//  HTPagedCollectionView.swift
//  iOS
//
//  Created by yuqingyuan on 2020/8/4.
//  Copyright © 2020 yuqingyuan. All rights reserved.
//

import SwiftUI

struct HTPagedCollectionView<T: Any, Content: View>: UIViewRepresentable where T : Equatable {
    
    @Binding var items: [T]
    var direction: UICollectionView.ScrollDirection
    var content: (T) -> Content
    let willDisplay: ((Int) -> Void)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: .init())
    
    init(items: Binding<[T]>, direction: UICollectionView.ScrollDirection = .horizontal, content: @escaping (T) -> Content, willDisplay: @escaping (Int) -> Void) {
        _items = items
        self.direction = direction
        self.content = content
        self.willDisplay = willDisplay
    }
    
    func makeUIView(context: Context) -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = self.direction
        
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.delegate = context.coordinator
        collectionView.dataSource = context.coordinator
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(HostingCell.self, forCellWithReuseIdentifier: "HostingCell")
        return collectionView
    }
    
    func updateUIView(_ uiView: UICollectionView, context: Context) {
        DispatchQueue.main.async {
            if context.coordinator.items != self.items {
                context.coordinator.items = self.items
                uiView.reloadData()
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(items, content: self.content, willDisplay: self.willDisplay)
    }
    
    class HostingCell: UICollectionViewCell {
        var host: UIHostingController<AnyView>?
    }
    
    class Coordinator: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        var items: [T]
        let content: (T) -> Content
        let willDisplay: (Int) -> Void

        init(_ items: [T], @ViewBuilder content: @escaping (T) -> Content, willDisplay: @escaping (Int) -> Void) {
            self.items = items
            self.content = content
            self.willDisplay = willDisplay
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.items.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HostingCell", for: indexPath) as! HostingCell
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
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return collectionView.frame.size
        }
            
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            self.willDisplay(indexPath.row)
        }
    }
    
}
