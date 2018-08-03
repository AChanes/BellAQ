const acl = require('express-acl');

acl.config({
    baseUrl  : "backend",
    filename : "nacl.json",
    roleSearchPath: 'session.role',
    decodedObjectName: 'session'
})

module.exports = acl;


