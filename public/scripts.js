/*
 * These functions below are for various webpage functionalities. 
 * Each function serves to process data on the frontend:
 *      - Before sending requests to the backend.
 *      - After receiving responses from the backend.
 * 
 * To tailor them to your specific needs,
 * adjust or expand these functions to match both your 
 *   backend endpoints 
 * and 
 *   HTML structure.
 * 
 */

function fetchTableData() {
    fetchAndDisplayPokemon();
    fetchAggregationNested();
    fetchAggregationHaving();
    fetchDivisionSQL();
}

async function fetchDivisionSQL() {
    const tableElement = document.getElementById('divSQLTable');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/divisionSQL', {
        method: 'GET'
    });

    const responseData = await response.json();
    const demotableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    demotableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

function showDivSQLTable() {
    var x = document.getElementById("divSQLTable");
    if (window.getComputedStyle(x).display === "none"){
        x.style.display = "table";
    } else {
        x.style.display = "none";
    }
}

async function fetchAggregationNested() {
    const tableElement = document.getElementById('aggregationNestedTable');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/aggregationNested', {
        method: 'GET'
    });

    const responseData = await response.json();
    const demotableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    demotableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

function showAggNestedTable() {
    var x = document.getElementById("aggregationNestedTable");
    if (window.getComputedStyle(x).display === "none"){
        x.style.display = "table";
    } else {
        x.style.display = "none";
    }
}

async function fetchAggregationHaving() {
    const tableElement = document.getElementById('aggregationHavingTable');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/aggregationHaving', {
        method: 'GET'
    });

    const responseData = await response.json();
    const demotableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    demotableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

function showAggHavingTable() {
    var x = document.getElementById("aggregationHavingTable");
    if (window.getComputedStyle(x).display === "none"){
        x.style.display = "table";
    } else {
        x.style.display = "none";
    }
}

async function fetchAndDisplayPokemon() {
    const tableElement = document.getElementById('pokemonTable');
    const tableBody = tableElement.querySelector('tbody');

    const response = await fetch('/pokemonTable', {
        method: 'GET'
    });

    const responseData = await response.json();
    const demotableContent = responseData.data;

    // Always clear old, already fetched data before new fetching process.
    if (tableBody) {
        tableBody.innerHTML = '';
    }

    demotableContent.forEach(user => {
        const row = tableBody.insertRow();
        user.forEach((field, index) => {
            const cell = row.insertCell(index);
            cell.textContent = field;
        });
    });
}

function showPkmnTable() {
    var x = document.getElementById("pokemonTable");
    if (window.getComputedStyle(x).display === "none"){
        x.style.display = "table";
    } else {
        x.style.display = "none";
    }
}


// This function checks the database connection and updates its status on the frontend.
async function checkDbConnection() {
    const statusElem = document.getElementById('dbStatus');
    const loadingGifElem = document.getElementById('loadingGif');

    const response = await fetch('/check-db-connection', {
        method: "GET"
    });

    // Hide the loading GIF once the response is received.
    loadingGifElem.style.display = 'none';
    // Display the statusElem's text in the placeholder.
    statusElem.style.display = 'inline';

    response.text()
    .then((text) => {
        statusElem.textContent = text;
    })
    .catch((error) => {
        statusElem.textContent = 'connection timed out';  // Adjust error handling if required.
    });
}

async function resetDatabase() {
    const response = await fetch("/reset-database", {
        method: 'POST'
    });
    const responseData = await response.json();
    const messageElement = document.getElementById('resetMessage');

    // Blank text so that each reset gives visual cue.
    messageElement.TextContent = "";
    messageElement.style.color = "black";

    if (responseData.success) {
        messageElement.textContent = "Database reset successfully!";
        messageElement.style.color = "green";
        fetchTableData();
    } else{
        messageElement.textContent = "Error resetting database!";
        messageElement.style.color = "red";
    }
}

async function loadDatabase() {
    const response = await fetch("/reset-database", {
        method: 'POST'
    });
    const responseData = await response.json();
    const messageElement = document.getElementById('loadMessage');

    // Blank text so that each reset gives visual cue.
    messageElement.TextContent = "";
    messageElement.style.color = "black";

    if (responseData.success) {
        messageElement.textContent = "Database loaded!";
        messageElement.style.color = "green";
        fetchTableData();
    } else{
        messageElement.textContent = "Error loading database!";
        messageElement.style.color = "red";
    }
}

async function addNewPokemon() {
    const PokemonID = document.getElementById('newPokemonID').value;
    const PokemonName = document.getElementById('newPokemonName').value;
    const rawIVs = [
        document.getElementById('iv1').value,
        document.getElementById('iv2').value,
        document.getElementById('iv3').value,
        document.getElementById('iv4').value,
        document.getElementById('iv5').value,
        document.getElementById('iv6').value,
    ];
    const PokemonIVs = rawIVs.join('/');
    const rawBaseStats = [
        document.getElementById('baseStat1').value,
        document.getElementById('baseStat2').value,
        document.getElementById('baseStat3').value,
        document.getElementById('baseStat4').value,
        document.getElementById('baseStat5').value,
        document.getElementById('baseStat6').value,
    ]
    const baseStats = rawBaseStats.join('/');

    await fetch( '/insert-pokemon-base-stats', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            pokemonName: PokemonName,
            baseStats: baseStats
        })
    });

    const response = await fetch('/insert-pokemon', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            pokemonID: PokemonID,
            pokemonName: PokemonName,
            ivs: PokemonIVs})
    });

    const result = await response.json();
    const messageElement = document.getElementById('pokemonInsertResultMsg');

    if (result.success) {
        messageElement.style.color = "green";
        messageElement.textContent = "Pokemon added successfully!";
        fetchTableData();
    } else {
        messageElement.style.color = "red";
        messageElement.textContent = "Error inserting Pokemon!";
    }
}

async function updateGym(){
    const gymID = document.getElementById('gymID').value;
    const newCityName = document.getElementById('newCityName').value;
    const newNPCID = document.getElementById('newNPCID').value;
    const newTypeID = document.getElementById('newTypeID').value;

    const response = await fetch('/update-gym', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            gymID: gymID,
            newCityName: newCityName,
            newNPCID: newNPCID,
            newTypeID: newTypeID
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('updateGymResultMsg');

    if (responseData.success) {
        messageElement.style.color = "green";
        messageElement.textContent = "Gym updated successfully!";
    } else {
        messageElement.style.color = "red";
        messageElement.textContent = "Error updating gym!";
    }

}

async function deleteMove(){
    const moveID = document.getElementById('deleteMoveID').value;

    const response = await fetch('/delete-move', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            moveID: moveID
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('deleteMoveResultMsg');

    if(responseData.success){
        messageElement.style.color = "green";
        messageElement.textContent = "Move deleted successfully!";
    } else {
        messageElement.style.color = "red";
        messageElement.textContent = "Error deleting move!";
    }
}

async function obtainMoves(){
    const moveType = document.getElementById('typeSelect').value;
    const minAccuracy = document.getElementById('accuracyThreshold').value;

    const response = await fetch('/obtain-moves', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            moveType: moveType,
            minAccuracy: minAccuracy
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('obtainedMovesMsg');
    const movesTable = document.getElementById('moveResultsTable');
    const movesTableBody = movesTable.querySelector('tbody');
    movesTableBody.innerHTML = "";

    if(responseData.success){
        messageElement.textContent = "Moves obtained successfully!";
        movesTable.style.display = "table";

        responseData.data.forEach(row => {
            const newRow = document.createElement('tr');
            newRow.innerHTML = `
                <td>${row.MOVENAME}</td>
                <td>${row.ACCURACY}</td>`;
            movesTableBody.appendChild(newRow);
        });
    } else{
        movesTable.style.display = "none";
        messageElement.textContent = "Error obtaining moves!";
    }
}

async function getProjectedPokemon(){
    const checked = document.querySelectorAll('input[name="columns"]:checked');
    const columns = Array.from(checked).map(el => el.value);

    const response = await fetch('/get-projected-pokemon', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            columns: columns
        })
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('projectionMessage');
    const projectedTable = document.getElementById('projectionTable');
    const projectedTableBody = document.getElementById('projectionBody');
    const projectedTableHeader = document.getElementById('projectionHeader');

    // Ensure table is empty to prevent it from overwriting.
    projectedTableHeader.innerHTML = '';
    projectedTableBody.innerHTML = '';

    // Cycles through the table to populate with the projected Pokemon
    if(responseData.success){
        columns.forEach(col => {
            const newHeader = document.createElement('th');
            newHeader.textContent = col;
            projectedTableHeader.appendChild(newHeader);
        });

        responseData.data.forEach(row => {
            const newRow = document.createElement('tr');
            row.forEach(cell => {
                const newCell = document.createElement('td');
                newCell.textContent = cell;
                newRow.appendChild(newCell);
            })
            projectedTableBody.appendChild(newRow);
        });

        projectedTable.style.display = "table";
        messageElement.textContent = "Projection successful!";
    } else{
        projectedTable.style.display = "none";
        messageElement.textContent = "Error obtaining projected Pokemon!";
    }
}

function hideProjectedPokemon(){
    document.getElementById("projectionTable").style.display = "none";
}

async function getPokemonType(){
    const typeID = document.getElementById('pokemonTypeSelect').value;

    const response = await fetch('/get-pokemon-types', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            typeID: typeID
            })
        });

    const responseData = await response.json();
    const messageElement = document.getElementById('pokemonTypeMessage');
    const pokemonTypeTable = document.getElementById('pokemonTypeTable');
    const pokemonTypeTableBody = pokemonTypeTable.querySelector('tbody');

    // Reset table each time
    pokemonTypeTableBody.innerHTML = "";

    if(responseData.success){
        messageElement.textContent = "Pokemon types obtained successfully!";
        responseData.data.forEach(row => {
            const newRow = document.createElement('tr');
            newRow.innerHTML = `<td>${row[0]}</td><td>${row[1]}</td>`;
            pokemonTypeTableBody.appendChild(newRow);
        });
        pokemonTypeTable.style.display = "table";
    } else {
        pokemonTypeTable.style.display = "none";
        messageElement.textContent = "Error obtaining Pokemon types!";
    }
}

function hidePokemonType(){
    document.getElementById("pokemonTypeTable").style.display = "none";
}

async function getPokemonCountByType(){
    const response = await fetch('/pokemon-count-by-type', {
        method: 'GET'
    });

    const responseData = await response.json();
    const messageElement = document.getElementById('pokemonTypeCountMessage');
    const pokemonTypeCountTable = document.getElementById('pokemonTypeCountTable');
    const pokemonTypeCountTableBody = pokemonTypeCountTable.querySelector('tbody');

    // Clear table each time
    pokemonTypeCountTableBody.innerHTML = "";

    if(responseData.success){
        responseData.data.forEach(row => {
            const newRow = document.createElement('tr');
            newRow.innerHTML = `<td>${row[0]}</td><td>${row[1]}</td>`;
            pokemonTypeCountTableBody.appendChild(newRow);
        });
        messageElement.textContent = "Pokemon types obtained successfully!";
        pokemonTypeCountTable.style.display = "table";
    } else{
        pokemonTypeCountTable.style.display = "none";
        messageElement.textContent = "Error obtaining Pokemon types!";
    }
}

function hidePokemonCountByType(){
    document.getElementById("pokemonTypeCountTable").style.display = "none";
}

// ---------------------------------------------------------------
// Initializes the webpage functionalities.
// Add or remove event listeners based on the desired functionalities.
window.onload = function() {
    checkDbConnection();
    populateIVDropdowns();
    //fetchTableData();
    loadDatabase();
    document.getElementById("insertPokemonButton").addEventListener("click", addNewPokemon);
};

// General function to refresh the displayed table data. 
// You can invoke this after any table-modifying operation to keep consistency.
// function fetchTableData() {
//     fetchAndDisplayUsers();
// }

function populateIVDropdowns() {
    for (let i = 1; i <= 6; i++) {
        const select = document.getElementById(`iv${i}`);
        for (let val = 0; val <= 31; val++) {
            const option = document.createElement('option');
            option.value = val;
            option.textContent = val;
            select.appendChild(option);
        }
    }
}

