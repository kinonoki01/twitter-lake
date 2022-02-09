User.create(name: '111', email: '111@111.com', password: '111')
User.create(name: '222', email: '222@222.com', password: '222')

Folder.create(name: 'お気に入り1', position: 1, user_id: 1)
Folder.create(name: 'お気に入り2', position: 2, user_id: 1)
Folder.create(name: 'お気に入り3', position: 3, user_id: 1)
