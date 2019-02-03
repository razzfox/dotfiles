# Setup MongoDB
echo 'use razz

db.createCollection("entries", { capped : true, autoIndexID : true, size : 6142800, max : 10000 } )
db.createCollection("devicestatus", { capped : true, autoIndexID : true, size : 6142800, max : 10000 } )

db.createUser({user: "razz",pwd: "7299",roles:[{ role: "readWrite", db: "razz" }]})
db.createUser(
   {
     user: "razz",
     pwd: "7299",
     roles:
       [
         { role: "readWrite", db: "razz" }
       ]
   }
)
'

####


echo 'MONGO_CONNECTION="mongodb://razz:7299@localhost:27017/razz"'
KUDU_SYNC_CMD=node_modules/kudusync/bin/kudusync
MONGO_COLLECTION=entries' >> mongo.env


cd web/cgm-remote-monitor

echo '{
    "url": "mongodb://razz:7299@localhost:27017/razz",
    "collection": "entries"
}' > database_configuration.json

npm install
npm install kudusync
./setup.sh
make
ln -s . npm


env $(cat ~/nightscout.env) node server.js
