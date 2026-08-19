const { MongoClient } = require('mongodb');
require('dotenv').config();

const url = process.env.MONGO_URI || 'mongodb://127.0.0.1:27017';
const client = new MongoClient(url);
let db;

async function connectMongo() {
  if (!db) {
    await client.connect();
    db = client.db(process.env.MONGO_DB_NAME || 'campusfix_nosql');
    console.log(' Conectado exitosamente a MongoDB');
  }
  return db;
}

module.exports = { connectMongo };
