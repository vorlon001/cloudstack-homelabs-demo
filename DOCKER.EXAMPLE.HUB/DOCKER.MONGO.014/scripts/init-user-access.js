use admin;
db.createUser({
  user: "mdb_admin",
  pwd: "mdb_pass",
  roles: [
    {role: "root", db: "admin"},
    { role: "userAdminAnyDatabase", db: "admin" },
    { role: "dbAdminAnyDatabase", db: "admin" },
    { role: "readWriteAnyDatabase", db:"admin" },
    { role: "clusterAdmin",  db: "admin" }
  ]
});
