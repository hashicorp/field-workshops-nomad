/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

const express = require('express');
const router = express.Router();
const Pool = require('pg').Pool;

//  Create a connection pool for Postgres
const pool = new Pool({
    host: process.env.DB_HOST || '127.0.0.1',
    database: process.env.DB_DATABASE || 'demo',
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    port: process.env.DB_PORT || 5432
});

//  List the Hashistack
router.get('/', function(req, res, next) {
    pool.query('SELECT * FROM hashistack ORDER BY id ASC', (error, results) => {
        if (error) 
            res.status(500).send(error.message + '\n');
        else
            res.status(200).json(results.rows);
    });
});

//  List the Hashistack Member
router.get('/:id', function(req, res, next) {
    pool.query('SELECT * FROM users WHERE id = $1', [request.params.id], (error, results) => {
        if (error) 
            res.status(500).send(error.message + '\n');
        else
            res.status(200).json(results.rows);
    });
});

//  Create a Hashistack Member
router.post('/', function(req, res, next) {
    pool.query('INSERT INTO hashistack (name, description, image_link, doc_link) VALUES ($1, $2, $3, $4)', [req.body.name, req.body.description, req.body.image_link, req.body.doc_link], (error, results) => {
        if (error) 
            res.status(500).send(error.message + '\n');
        else
            res.status(201).send('member added with id: ' + results.insertId);
    });
});

//  Update a Hashistack Member
router.put('/:id', function(req, res, next) {
    pool.query('UPDATE hashistack SET name = "$1", description = "$2", image_link = "$3", doc_link = "$4"', [req.body.name, req.body.description, req.body.image_link, req.body.doc_link], (error, results) => {
        if (error) 
            res.status(500).send(error.message + '\n');
        else
            res.status(200).send('member modified with id: ' + request.params.id);
    });
});

//  Delete a Hashistack Member
router.delete('/:id', function(req, res, next) {
    pool.query('DELETE FROM hashistack WHERE id = $1', [req.params.id], (error, results) => {
        if (error) 
            res.status(500).send(error.message + '\n');
        else
            res.status(200).send('member deleted with id: ' + request.params.id);
    });
});

module.exports = router;