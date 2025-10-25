const oracledb = require('oracledb');
const loadEnvFile = require('./utils/envUtil');
const fs = require("fs");
const path = require('path');

const envVariables = loadEnvFile('./.env');

// Database configuration setup. Ensure your .env file has the required database credentials.
const dbConfig = {
    user: envVariables.ORACLE_USER,
    password: envVariables.ORACLE_PASS,
    connectString: `${envVariables.ORACLE_HOST}:${envVariables.ORACLE_PORT}/${envVariables.ORACLE_DBNAME}`,
    poolMin: 1,
    poolMax: 3,
    poolIncrement: 1,
    poolTimeout: 60
};

// initialize connection pool
async function initializeConnectionPool() {
    try {
        await oracledb.createPool(dbConfig);
        console.log('Connection pool started');
    } catch (err) {
        console.error('Initialization error: ' + err.message);
    }
}

async function closePoolAndExit() {
    console.log('\nTerminating');
    try {
        await oracledb.getPool().close(10); // 10 seconds grace period for connections to finish
        console.log('Pool closed');
        process.exit(0);
    } catch (err) {
        console.error(err.message);
        process.exit(1);
    }
}

initializeConnectionPool();

process
    .once('SIGTERM', closePoolAndExit)
    .once('SIGINT', closePoolAndExit);


// ----------------------------------------------------------
// Wrapper to manage OracleDB actions, simplifying connection handling.
async function withOracleDB(action) {
    let connection;
    try {
        connection = await oracledb.getConnection(); // Gets a connection from the default pool 
        return await action(connection);
    } catch (err) {
        console.error(err);
        throw err;
    } finally {
        if (connection) {
            try {
                await connection.close();
            } catch (err) {
                console.error(err);
            }
        }
    }
}

// ----------------------------------------------------------
// Core functions for database operations
// Modify these functions, especially the SQL queries, based on your project's requirements and design.
async function testOracleConnection() {
    return await withOracleDB(async (connection) => {
        return true;
    }).catch(() => {
        return false;
    });
}

// Obtain all Pokemon for display
async function fetchPokemonTableFromDb() {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute('SELECT * FROM POKEMON');
        return result.rows;
    }).catch(() => {
        return [];
    });
}

// Reset Database each time
async function resetDatabase() {
    return await withOracleDB(async (connection) => {
        const filePathway = path.join(__dirname, 'sql', 'allTables.sql');
        const sqlScript = fs.readFileSync(filePathway, 'utf8');

        const statements = sqlScript
            .split(";")
            .map(stmt => stmt.trim())
            .filter(stmt => stmt.length > 0);

        for (const statement of statements) {
            try {
                console.log("Running SQL:", statement);
                await connection.execute(statement);
            } catch (err) {
                console.error("Error running statement:", statement);
                console.error(err.message);
            }
        }
        return true;
    }).catch(() => {
        return false;
    });
}

// 1. INSERT for Pokemon
async function insertPokemon(pokemonID, pokemonName, ivs){
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO POKEMON (pokemonid, pokemonname, ivs) VALUES (:pokemonid, :pokemonname, :ivs)`,
            [pokemonID, pokemonName, ivs],
            { autoCommit: true }
        );

        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => {
        return false;
    });
}

// 1. INSERT for PokemonStats
async function insertPokemonBaseStats(pokemonName, baseStats){
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `INSERT INTO PokemonStats (PokemonName, BaseStats) VALUES (:pokemonName, :baseStats)`,
            [pokemonName, baseStats],
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => false);
}

// 2. UPDATE
async function updateGym(gymID, newCityName, newNPCID, newTypeID) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `UPDATE GYM 
            SET CityName=:cityName, 
                NPCID=:npcID, 
                TypeID=:typeID 
            WHERE GymID=:gymID`,
            {
                cityName: newCityName,
                npcID: newNPCID,
                typeID: newTypeID,
                gymID: gymID
            },
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => false);
}

// 3. Deletion
async function deleteMove(moveID) {
    return await withOracleDB(async (connection) => {

        const result = await connection.execute(
            `DELETE FROM Moves WHERE MoveID=:moveID`,
            [moveID],
            { autoCommit: true }
        );
        return result.rowsAffected && result.rowsAffected > 0;
    }).catch(() => false);
}

// 4. Selection
async function obtainMoves(moveType, minAccuracy) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            'SELECT * FROM MoveInfo WHERE TypeID = :moveType AND Accuracy >= :minAccuracy',
            [moveType, minAccuracy],
            { outFormat: oracledb.OUT_FORMAT_OBJECT }
        );

        return result.rows;
    }).catch(() => {
        return [];
    });
}

// 5. Projection
async function getProjectedPokemon(cols){
    if(!cols || !cols.length) return [];

    const allCols = ['PokemonID', 'PokemonName', 'IVs']
    const colsToSelect = cols.filter(col => allCols.includes(col)).join(', ');

    const query = `SELECT ${colsToSelect} FROM Pokemon`;

    return await withOracleDB(async (connection) => {
        const result = await connection.execute(query);
        return result.rows;
    }).catch(()=>{
        return [];
    });
}

// 6. JOIN
async function getPokemonTypes(typeID) {
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
            `SELECT p.PokemonName, t.TypeName
            FROM Pokemon p
            JOIN PokemonType pt ON p.PokemonID = pt.PokemonID
            JOIN Type t ON t.TypeID = pt.TypeID
            WHERE t.TypeID = :typeID`,
            [typeID]
        );
        return result.rows;
    }).catch(()=>{
        return [];
    });
}

// 7. Aggregation with GROUP BY
async function pokemonCountByType(){
    return await withOracleDB(async (connection) => {
        const result = await connection.execute(
        `SELECT t.TypeName, COUNT(*) AS PokemonCount
        FROM PokemonType pt
        JOIN Type t ON pt.TypeID = t.TypeID
        GROUP BY t.TypeName`
        );
        return result.rows;
    }).catch(()=>{
        return [];
    });
}

// 8. Aggregation with HAVING (returns moves with accuracy less than 90, sorted asc)
async function aggregationHaving() {
    return await withOracleDB(async (connection) => {
        const query = `
            SELECT m.MoveName, m.Accuracy
            FROM MoveInfo m
            GROUP BY m.MoveName, m.Accuracy
            HAVING m.Accuracy < 90
            ORDER BY m.Accuracy ASC
        `;

        const result = await connection.execute(query);
        return result.rows;
    }).catch((err) => {
        console.error("Has error:", err);
        return [];
    });
}

// 9. Nested Aggregation with GROUP BY (finds most common type among pokemon)
async function aggregationNested() {
    return await withOracleDB(async (connection) => {
        const query = `
            SELECT t.TypeName, COUNT(pt.PokemonID) AS TypeCount
            FROM PokemonType pt
            JOIN Type t ON pt.TypeID = t.TypeID
            GROUP BY t.TypeName
            HAVING COUNT(pt.PokemonID) = (
                SELECT MAX(TypeCount)
                FROM (
                    SELECT COUNT(pt.PokemonID) AS TypeCount
                    FROM PokemonType pt
                    GROUP BY pt.TypeID
                )
            )
        `;
        const result = await connection.execute(query);
        return result.rows;
    }).catch((err) => {
        console.error("Has error:", err);
        return [];
    });
}

// 10. Division (check for NPCs who have all items, expected is Cynthia)
async function divisionSQL() {
    return await withOracleDB(async (connection) => {
        const query = `
            SELECT np.NPCID, np.NPCName
            FROM NPC np
            WHERE NOT EXISTS (
                SELECT i.ItemName
                FROM Item i
                WHERE NOT EXISTS (
                    SELECT 1
                    FROM NPCItem ni
                    WHERE ni.NPCID = np.NPCID
                    AND ni.ItemName = i.ItemName
                )
            )
        `;
        const result = await connection.execute(query);
        return result.rows;
    }).catch((err) => {
        console.error("Has error:", err);
        return [];
    });
}

module.exports = {
    testOracleConnection,
  
    resetDatabase,
    insertPokemon,
    insertPokemonBaseStats,
    updateGym,

    fetchPokemonTableFromDb,

    deleteMove,
    obtainMoves,
    getProjectedPokemon,
    getPokemonTypes,
    pokemonCountByType,
    aggregationHaving,
    aggregationNested,
    divisionSQL
};


