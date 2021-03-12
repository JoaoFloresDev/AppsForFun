/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import UIKit
import Photos
import Firebase
import MessageKit
import FirebaseFirestore
import InputBarAccessoryView

final class ChatViewController: MessagesViewController {
    
    let outgoingAvatarOverlap: CGFloat = 17.5
    private var messageDM: MessageDM!
    private var messages: [Message] = []
    private let user: User
    private let channel: Channel
    private var userFirstTimeIn = false
    
    
    init(user: User, channel: Channel, firstTimeIn: Bool = false) {
        self.user = user
        self.channel = channel
        super.init(nibName: nil, bundle: nil)
        self.title = channel.name
        self.userFirstTimeIn = firstTimeIn
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let id = channel.id else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        messageDM = MessageDM(channelID: id, completion: { (change) in
            self.handleDocumentChange(change)
        })
        
        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
            
        }
        if #available(iOS 13.0, *) {
            messageInputBar.sendButton.setImage(UIImage(systemName: "paperplane.fill")?.resizeImage(targetSize: CGSize(width: 30, height: 30)), for: .normal)
            messageInputBar.sendButton.tintColor = .black
            messageInputBar.sendButton.setTitle("", for: .normal)
        }else {
            messageInputBar.sendButton.setTitle("Enviar", for: .normal)
        }
        
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .black
        messageInputBar.sendButton.setTitleColor(.black, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        let infoButton = UIBarButtonItem(title: "info", style: .plain, target: self, action: Selector(("openGroupInfo")))
        self.navigationItem.rightBarButtonItem = infoButton
        
        if userFirstTimeIn {
            messageInputBar.inputTextView.text = "Olá! Gostaria de me candidatar à vaga de \(channel.name)"
            
        }else {
            messageInputBar.inputTextView.text = ""
        }
    }
    
    
    @objc func openGroupInfo() {
        let storyboard = UIStoryboard(name: "Channels", bundle: nil)
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ChannelInfoSBID") as? ChannelInfoViewController else {return}
        viewController.channel = channel
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: - Helpers
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return indexPath.section % 3 == 0 && !isPreviousMessageSameSender(at: indexPath)
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return messages[indexPath.section].user == messages[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < messages.count else { return false }
        return messages[indexPath.section].user == messages[indexPath.section + 1].user
    }
    
    private func insertNewMessage(_ message: Message) {
        guard !messages.contains(message) else {
            return
        }
        
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(document: change.document) else {
            return
        }
        
        switch change.type {
        case .added:
            self.insertNewMessage(message)
            
        case .removed:
            guard let index = self.messages.firstIndex(of: message) else { return }
            self.messages.remove(at: index)
        default:
            break
        }
    }
    
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return UIColor.black
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return true
    }
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isFromCurrentSender(message: message) {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        } else {
            return !isPreviousMessageSameSender(at: indexPath) ? 20 : 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return (!isNextMessageSameSender(at: indexPath) && isFromCurrentSender(message: message)) ? 16 : 0
    }
    
    func avatarSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return .zero
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        
        avatarView.set(avatar: Avatar(image: nil, initials: message.sender.initials))
        avatarView.isHidden = isNextMessageSameSender(at: indexPath)
        avatarView.layer.borderWidth = 2
        if isFromCurrentSender(message: message){
            avatarView.layer.borderColor = UIColor.primary.cgColor
        }
        
        
    }
    
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func currentSender() -> SenderType {
        return Sender(id: user.id, displayName: user.displayName)
    }
    
    func numberOfMessages(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isPreviousMessageSameSender(at: indexPath) {
            let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }
        return nil
    }
}



// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        
        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                let message = Message(user: self.user, content: str)
                messageDM.save(message) {
                    self.messagesCollectionView.scrollToBottom(animated: true)
                }
            }
        }
    }
}




