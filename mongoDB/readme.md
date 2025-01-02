

 install gnupg and curl if they are not already available:

sudo apt-get install gnupg curl


import the MongoDB public GPG key, run the following command:

curl -fsSL https://www.mongodb.org/static/pgp/server-8.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-8.0.gpg \
   --dearmor


Create the list file /etc/apt/sources.list.d/mongodb-org-8.0.list for your version of Ubuntu.
Create the list file for Ubuntu 24.04 (Noble):

echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-8.0.gpg ] https://repo.mongodb.org/apt/ubuntu noble/mongodb-org/8.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-8.0.list



Issue the following command to reload the local package database:

sudo apt-get update


To install a specific release, you must specify each component package individually along with the version number, as in the following example:

sudo apt-get install -y mongodb-org=8.0.4 mongodb-org-database=8.0.4 mongodb-org-server=8.0.4 mongodb-mongosh mongodb-org-mongos=8.0.4 mongodb-org-tools=8.0.4


+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Configure MongoDB for Replica Set
On each MongoDB server (mongo0, mongo1, mongo2), update the MongoDB configuration file (/etc/mongod.conf) to enable replica sets.

Add the following under the replication section:
replication:
  replSetName: "rs0"

After modifying the configuration, restart the MongoDB service on each node:
sudo systemctl restart mongod

Log into the mongo0 server and start the MongoDB shell:
mongo

initiate the replica set with the following command:
rs.initiate(
  {
    _id: "rs0",
    members: [
      { _id: 0, host: "mongo0:27017" },
      { _id: 1, host: "mongo1:27017" },
      { _id: 2, host: "mongo2:27017" }
    ]
  }
)



Verify Replica Set Status ('After initiating the replica set, check the status to ensure that the replica set has been successfully configured and mongo0')

rs.status()


Enable Authentication (Optional)
configure users for the replica set. You can create an admin user on the primary node (mongo0) using the following commands:
use admin
db.createUser({
  user: "admin",
  pwd: "password", // Choose a strong password
  roles: [{ role: "root", db: "admin" }]
})


After creating the user, restart all nodes with authentication enabled and configure your applications to connect using the admin credentials.


Monitor the Replica Set
rs.status()
It will show the current state of the nodes 


7. Testing the Replica Set

To verify the replication is working, you can insert data into the primary (mongo0) and check if it replicates to the secondary nodes (mongo1, mongo2).
For example, insert a document into a collection:
use testdb
db.testcollection.insert({ name: "test" })
Then, check if the data appears in the secondary nodes by connecting to them and running:
  use testdb
db.testcollection.find()



