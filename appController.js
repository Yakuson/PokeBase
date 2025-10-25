const express = require('express');
const appService = require('./appService');

const router = express.Router();

// ----------------------------------------------------------
// API endpoints
// Modify or extend these routes based on your project's needs.

router.get('/pokemonTable', async (req, res) => {
    const tableContent = await appService.fetchPokemonTableFromDb();
    res.json({data: tableContent});
});

router.get('/aggregationHaving', async (req, res) => {
    const tableContent = await appService.aggregationHaving();
    res.json({data: tableContent});
});

router.get('/aggregationNested', async (req, res) => {
    const tableContent = await appService.aggregationNested();
    res.json({data: tableContent});
});

router.get('/divisionSQL', async (req, res) => {
    const tableContent = await appService.divisionSQL();
    res.json({data: tableContent});
});


router.get('/check-db-connection', async (req, res) => {
    const isConnect = await appService.testOracleConnection();
    if (isConnect) {
        res.send('connected');
    } else {
        res.send('unable to connect');
    }
});

router.post('/reset-database', async (req, res) => {
   const resetSuccessful = await appService.resetDatabase();
   if (resetSuccessful) {
       res.json({ success: true });
   } else {
       res.status(500).json({ success: false });
   }
});

router.post('/insert-pokemon', async (req, res) => {
    const { pokemonID, pokemonName, ivs } = req.body;
    const insertResult = await appService.insertPokemon(pokemonID, pokemonName, ivs);
    if (insertResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post('/insert-pokemon-base-stats', async (req, res) => {
    const {pokemonName, baseStats} = req.body;
    const results = await appService.insertPokemonBaseStats(pokemonName, baseStats);
    if (results) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post('/update-gym', async (req, res) => {
    const {gymID, newCityName, newNPCID, newTypeID} = req.body;
    const updateResult = await appService.updateGym(gymID, newCityName, newNPCID, newTypeID);
    if(updateResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post('/delete-move', async (req, res) => {
    const {moveID} = req.body;
    const deleteResult = await appService.deleteMove(moveID);
    if(deleteResult) {
        res.json({ success: true });
    } else {
        res.status(500).json({ success: false });
    }
});

router.post('/obtain-moves', async (req, res) => {
    const {moveType, minAccuracy} = req.body;
    const moves = await appService.obtainMoves(moveType, minAccuracy);
    res.json({success: true, data: moves});
});

router.post('/get-projected-pokemon', async (req, res) => {
    const {columns} = req.body;
    const projectedPokemon = await appService.getProjectedPokemon(columns);
    res.json({success: true, data: projectedPokemon});
});

router.post('/get-pokemon-types', async (req, res) => {
    const {typeID} = req.body;
    const pokemonTypes = await appService.getPokemonTypes(typeID);
    res.json({success: true, data: pokemonTypes});
});

router.get('/pokemon-count-by-type', async (req, res) => {
    const pokemonCountByType = await appService.pokemonCountByType();
    res.json({success: true, data: pokemonCountByType});
});

module.exports = router;