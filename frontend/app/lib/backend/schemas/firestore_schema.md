# Firestore Backend Schema

## users

stores researcher profile data.

fields:
- uid
- name
- email
- university
- department
- bio
- location
- lookingFor
- researchInterests
- skills
- publications
- projects
- googleScholar
- github
- linkedIn
- profileImageUrl
- createdAt
- updatedAt

---

## posts

stores research feed posts.

fields:
- postId
- authorId
- authorName
- university
- content
- type
- tags
- likes
- commentCount
- createdAt
- updatedAt

---

## comments

stores comments under research posts.

fields:
- commentId
- postId
- authorId
- authorName
- comment
- createdAt

---

## connections

stores researcher connection requests.

fields:
- connectionId
- senderId
- receiverId
- senderName
- receiverName
- status
- createdAt
- updatedAt

status:
- pending
- accepted
- rejected

---

## matches

stores swipe-based research matches.

fields:
- matchId
- userId
- matchedUserId
- matchedName
- university
- matchScore
- status
- createdAt

status:
- interested
- mutual
- skipped

---

## messages

stores research chat messages.

fields:
- messageId
- threadId
- senderId
- receiverId
- message
- createdAt
- isRead

---

## chatThreads

stores chat inbox threads.

fields:
- threadId
- participants
- researcherName
- university
- lastMessage
- lastMessageTime
- createdAt
- updatedAt

---

## notifications

stores user activity alerts.

fields:
- notificationId
- userId
- title
- body
- type
- isRead
- createdAt

types:
- match
- message
- connection
- comment
- post