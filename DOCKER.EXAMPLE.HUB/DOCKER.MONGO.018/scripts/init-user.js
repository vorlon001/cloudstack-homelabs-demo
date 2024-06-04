db.auth('admin', 'admin');
db = db.getSiblingDB('my_database');
db.createUser({
  user: 'servicelogin',
  pwd: 'servicepassword',
  roles: [
    {
      role: 'dbOwner',
      db: 'my_database',
    },
  ],
});
db.createUser({
  user: 'adminservicelogin',
  pwd: 'adminservicepassword',
  roles: [
    {
      role: 'dbOwner',
      db: 'my_database',
    },
  ],
});
