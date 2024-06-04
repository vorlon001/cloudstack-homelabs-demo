rs.initiate({
  "_id": "rs1",
  "version": 1,
  "writeConcernMajorityJournalDefault": true,
  "members": [
    {
      "_id": 0,
      "host": "172.21.0.10:27017",
    },
    {
      "_id": 1,
      "host": "172.21.0.20:27017",
    },
    {
      "_id": 2,
      "host": "172.21.0.30:27017",
      arbiterOnly: true
    }
  ]
});
