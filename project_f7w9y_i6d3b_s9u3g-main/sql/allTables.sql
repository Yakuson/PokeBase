-- Drop tables initially
DROP TABLE NPCPokemonInfo CASCADE CONSTRAINTS;
DROP TABLE NPCPokemon CASCADE CONSTRAINTS;
DROP TABLE NPCItem CASCADE CONSTRAINTS;
DROP TABLE NPCLocation CASCADE CONSTRAINTS;

DROP TABLE Elite4MemberInfo CASCADE CONSTRAINTS;
DROP TABLE Evolution CASCADE CONSTRAINTS;

DROP TABLE GymLeader CASCADE CONSTRAINTS;
DROP TABLE GymBadge CASCADE CONSTRAINTS;
DROP TABLE PokemonType CASCADE CONSTRAINTS;
DROP TABLE Trainer CASCADE CONSTRAINTS;
DROP TABLE Champion CASCADE CONSTRAINTS;
DROP TABLE Elite4 CASCADE CONSTRAINTS;
DROP TABLE Gym CASCADE CONSTRAINTS;

DROP TABLE StatusMoves CASCADE CONSTRAINTS;
DROP TABLE SpecialMoves CASCADE CONSTRAINTS;
DROP TABLE PhysicalMoves CASCADE CONSTRAINTS;
DROP TABLE MoveInfo CASCADE CONSTRAINTS;
DROP TABLE Moves CASCADE CONSTRAINTS;
DROP TABLE Pokemon CASCADE CONSTRAINTS;

DROP TABLE PokemonStats CASCADE CONSTRAINTS;
DROP TABLE Item CASCADE CONSTRAINTS;
DROP TABLE Type CASCADE CONSTRAINTS;
DROP TABLE Location CASCADE CONSTRAINTS;
DROP TABLE NPC CASCADE CONSTRAINTS;

-- Create tables in order of dependency
CREATE TABLE Type (
    TypeID INT PRIMARY KEY,
    TypeName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE Location (
	LocationID INT PRIMARY KEY,
	LocationName VARCHAR(255) NOT NULL
);

CREATE TABLE PokemonStats(
    PokemonName VARCHAR(20) PRIMARY KEY,
    BaseStats VARCHAR(30) NOT NULL
);

CREATE TABLE NPC (
	NPCID INT PRIMARY KEY,
	NPCName VARCHAR(20) NOT NULL
);

CREATE TABLE Item (
	ItemName VARCHAR(20) PRIMARY KEY,
	Price INT NOT NULL,
	Description VARCHAR(255) NOT NULL
);

CREATE TABLE Moves (
	MoveID INT PRIMARY KEY,
	MoveName VARCHAR(20) NOT NULL UNIQUE
);

CREATE TABLE GymBadge (
	BadgeName VARCHAR(20) PRIMARY KEY,
	NPCName VARCHAR(20) NOT NULL
);

CREATE TABLE Pokemon (
    PokemonID INT PRIMARY KEY,
    PokemonName VARCHAR(20) NOT NULL,
    IVs VARCHAR(20) NOT NULL,
    FOREIGN KEY (PokemonName) REFERENCES PokemonStats(PokemonName) ON DELETE CASCADE
);

CREATE TABLE PokemonType (
    PokemonID INT,
    TypeID INT,
    PRIMARY KEY (PokemonID, TypeID),
    FOREIGN KEY (PokemonID) REFERENCES Pokemon(PokemonID),
    FOREIGN KEY (TypeID) REFERENCES Type(TypeID)
);

CREATE TABLE MoveInfo (
    MoveName VARCHAR(20) PRIMARY KEY,
    TypeID INT NOT NULL,
    Accuracy INT NOT NULL,
    FOREIGN KEY (MoveName) REFERENCES Moves(MoveName) ON DELETE CASCADE,
    FOREIGN KEY (TypeID) REFERENCES Type(TypeID) ON DELETE CASCADE
);

CREATE TABLE PhysicalMoves (
	MoveID INT PRIMARY KEY,
	PhysicalDamage INT NOT NULL,
	FOREIGN KEY (MoveID) REFERENCES Moves(MoveID) ON DELETE CASCADE
);

CREATE TABLE SpecialMoves(
	MoveID INT PRIMARY KEY,
	SpecialDamage INT NOT NULL,
	FOREIGN KEY (MoveID) REFERENCES Moves(MoveID) ON DELETE CASCADE
);

CREATE TABLE StatusMoves(
	MoveID INT PRIMARY KEY,
	Effect VARCHAR(255) NOT NULL,
	FOREIGN KEY (MoveID) REFERENCES Moves(MoveID) ON DELETE CASCADE
);

CREATE TABLE Gym (
	GymID INT PRIMARY KEY,
	CityName VARCHAR(20) NOT NULL UNIQUE,
	NPCID INT NOT NULL UNIQUE,
	TypeID INT NOT NULL,
	FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE,
	FOREIGN KEY (TypeID) REFERENCES Type(TypeID) ON DELETE CASCADE
);

CREATE TABLE GymLeader (
    NPCID INT PRIMARY KEY,
    BadgeName VARCHAR(20) NOT NULL UNIQUE,
    FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE,
    FOREIGN KEY (BadgeName) REFERENCES GymBadge(BadgeName) ON DELETE CASCADE
);

CREATE TABLE Trainer (
    NPCID INT PRIMARY KEY,
    Class VARCHAR(20) NOT NULL,
    FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE
);

CREATE TABLE Champion (
	NPCID INT PRIMARY KEY,
	League VARCHAR(20) NOT NULL,
	FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE
);

CREATE TABLE Elite4 (
	NPCID INT PRIMARY KEY,
	League VARCHAR(20) NOT NULL,
	Standing VARCHAR(20) NOT NULL,
	FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE
);

CREATE TABLE Elite4MemberInfo (
	NPCName VARCHAR(20),
	League VARCHAR(20) NOT NULL,
	Standing VARCHAR(20) NOT NULL,
	NPCID INT NOT NULL,
	PRIMARY KEY (NPCName, League, Standing),
	FOREIGN KEY (NPCID) REFERENCES Elite4(NPCID) ON DELETE CASCADE
);

CREATE TABLE Evolution (
	PreEvolutionID INT,
	EvolvedID INT,
	PRIMARY KEY (PreEvolutionID, EvolvedID),
	FOREIGN KEY (PreEvolutionID) REFERENCES Pokemon(PokemonID) ON DELETE CASCADE,
	FOREIGN KEY (EvolvedID) REFERENCES Pokemon(PokemonID) ON DELETE CASCADE
);

CREATE TABLE NPCLocation (
	NPCID INT,
    NPCName VARCHAR(255) NOT NULL,
    LocationID INT NOT NULL,
    LocationName VARCHAR(255) NOT NULL,
    PRIMARY KEY (NPCID, LocationID),
    FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE,
    FOREIGN KEY (LocationID) REFERENCES Location(LocationID) ON DELETE CASCADE
);

CREATE TABLE NPCPokemon (
    NPCID INT,
    PokemonID INT,
    PRIMARY KEY (NPCID, PokemonID),
    FOREIGN KEY (NPCID) REFERENCES NPC(NPCID) ON DELETE CASCADE,
    FOREIGN KEY (PokemonID) REFERENCES Pokemon(PokemonID) ON DELETE CASCADE
);

CREATE TABLE NPCPokemonInfo (
    NPCID INT PRIMARY KEY,
    PokemonID INT NOT NULL,
    PokemonName VARCHAR(20) NOT NULL,
    FOREIGN KEY (NPCID) REFERENCES Trainer(NPCID) ON DELETE CASCADE,
    FOREIGN KEY (PokemonID) REFERENCES Pokemon(PokemonID)
);


CREATE TABLE NPCItem (
    NPCID INT,
    ItemName VARCHAR(20),
    Price INT,
    Description VARCHAR(255),
    PRIMARY KEY (NPCID, ItemName),
    FOREIGN KEY (NPCID) REFERENCES NPC(NPCID),
    FOREIGN KEY (ItemName) REFERENCES Item(ItemName)
);

-- Insertion of values
-- Type
INSERT INTO Type (TypeID, TypeName) VALUES (1, 'Normal');
INSERT INTO Type (TypeID, TypeName) VALUES (2, 'Fire');
INSERT INTO Type (TypeID, TypeName) VALUES (3, 'Water');
INSERT INTO Type (TypeID, TypeName) VALUES (4, 'Electric');
INSERT INTO Type (TypeID, TypeName) VALUES (5, 'Grass');
INSERT INTO Type (TypeID, TypeName) VALUES (6, 'Ice');
INSERT INTO Type (TypeID, TypeName) VALUES (7, 'Fighting');
INSERT INTO Type (TypeID, TypeName) VALUES (8, 'Poison');
INSERT INTO Type (TypeID, TypeName) VALUES (9, 'Ground');
INSERT INTO Type (TypeID, TypeName) VALUES (10, 'Flying');
INSERT INTO Type (TypeID, TypeName) VALUES (11, 'Psychic');
INSERT INTO Type (TypeID, TypeName) VALUES (12, 'Bug');
INSERT INTO Type (TypeID, TypeName) VALUES (13, 'Rock');
INSERT INTO Type (TypeID, TypeName) VALUES (14, 'Ghost');
INSERT INTO Type (TypeID, TypeName) VALUES (15, 'Dragon');
INSERT INTO Type (TypeID, TypeName) VALUES (16, 'Dark');
INSERT INTO Type (TypeID, TypeName) VALUES (17, 'Steel');
INSERT INTO Type (TypeID, TypeName) VALUES (18, 'Fairy');

-- Location
INSERT INTO Location (LocationID, LocationName) VALUES (1, 'Pallet Town');
INSERT INTO Location (LocationID, LocationName) VALUES (2, 'Route 1');
INSERT INTO Location (LocationID, LocationName) VALUES (3, 'Cerulean Cave');
INSERT INTO Location (LocationID, LocationName) VALUES (4, 'Indigo Plateau');
INSERT INTO Location (LocationID, LocationName) VALUES (5, 'Mt. Moon');

-- PokemonStats
INSERT INTO PokemonStats (PokemonName, BaseStats) VALUES ('Bulbasaur', '45/49/49/65/65/45');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Ivysaur', '60/62/63/80/80/60');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Venusaur', '80/82/83/100/100/80');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Charmander', '39/52/43/60/50/65');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Charmeleon', '58/64/58/80/65/80');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Charizard', '78/84/78/109/85/100');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Squirtle', '44/48/65/50/64/43');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Wartortle', '59/63/80/65/80/58');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Blastoise', '79/83/100/85/105/78');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Pidgeot', '83/80/75/70/70/101');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Mewtwo', '106/110/90/154/90/130');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Metagross', '80/135/130/95/90/70');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Garchomp', '108/130/95/80/85/102');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Lucario', '70/110/70/115/70/90');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Arceus', '120/120/120/120/120/120');
INSERT INTO PokemonStats (PokemonName, BaseStats)VALUES ('Volcarona', '85/60/65/135/105/100');

-- Pokemon
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (1, 'Bulbasaur', '0/0/0/0/0/0');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (2, 'Ivysaur', '1/5/3/31/31/31');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (3, 'Venusaur', '1/5/3/0/26/14');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (4, 'Charmander', '14/3/24/31/11/0');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (5, 'Charmeleon', '26/9/5/30/14/19');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (6, 'Charizard', '18/11/0/31/29/15');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (7, 'Squirtle', '21/5/4/13/5/31');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (8, 'Wartortle', '3/29/30/12/2/9');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (9, 'Blastoise', '9/31/6/25/18/20');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (18, 'Pidgeot', '13/24/28/17/19/30');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (150, 'Mewtwo', '31/31/31/31/31/31');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (376, 'Metagross', '18/29/31/12/6/13');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs) VALUES (445, 'Garchomp', '21/25/14/29/18/31');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (448, 'Lucario', '12/30/22/20/31/25');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (493, 'Arceus', '31/31/31/31/31/31');
INSERT INTO Pokemon (PokemonID, PokemonName, IVs)VALUES (637, 'Volcarona', '17/3/20/31/29/16');

-- NPC
INSERT INTO NPC (NPCID, NPCName) VALUES (1, 'Red');
INSERT INTO NPC (NPCID, NPCName) VALUES (2, 'Blue');
INSERT INTO NPC (NPCID, NPCName) VALUES (3, 'Steven');
INSERT INTO NPC (NPCID, NPCName) VALUES (4, 'Cynthia');
INSERT INTO NPC (NPCID, NPCName) VALUES (5, 'Alder');

INSERT INTO NPC (NPCID, NPCName) VALUES (6, 'PokeManiac Joe');
INSERT INTO NPC (NPCID, NPCName) VALUES (7, 'Lass Lily');
INSERT INTO NPC (NPCID, NPCName) VALUES (8, 'Youngster Tim');
INSERT INTO NPC (NPCID, NPCName) VALUES (9, 'Hiker Bob');
INSERT INTO NPC (NPCID, NPCName) VALUES (10, 'Blackbelt Ken');

INSERT INTO NPC (NPCID, NPCName) VALUES (11, 'Brock');
INSERT INTO NPC (NPCID, NPCName) VALUES (12, 'Misty');
INSERT INTO NPC (NPCID, NPCName) VALUES (13, 'Lt. Surge');
INSERT INTO NPC (NPCID, NPCName) VALUES (14, 'Erika');
INSERT INTO NPC (NPCID, NPCName) VALUES (15, 'Koga');

INSERT INTO NPC (NPCID, NPCName) VALUES (16, 'Lorelei');
INSERT INTO NPC (NPCID, NPCName) VALUES (17, 'Bruno');
INSERT INTO NPC (NPCID, NPCName) VALUES (18, 'Agatha');
INSERT INTO NPC (NPCID, NPCName) VALUES (19, 'Lance');
INSERT INTO NPC (NPCID, NPCName) VALUES (20, 'Sidney');
INSERT INTO NPC (NPCID, NPCName) VALUES (21, 'Phoebe');
INSERT INTO NPC (NPCID, NPCName) VALUES (22, 'Glacia');
INSERT INTO NPC (NPCID, NPCName) VALUES (23, 'Drake');

-- Trainer
INSERT INTO Trainer (NPCID, Class) VALUES (6, 'PokeManiac');
INSERT INTO Trainer (NPCID, Class) VALUES (7, 'Lass');
INSERT INTO Trainer (NPCID, Class) VALUES (8, 'Youngster');
INSERT INTO Trainer (NPCID, Class) VALUES (9, 'Hiker');
INSERT INTO Trainer (NPCID, Class) VALUES (10, 'Blackbelt');

-- Gym Badge
INSERT INTO GymBadge (BadgeName, NPCName) VALUES ('Boulder Badge', 'Brock');
INSERT INTO GymBadge (BadgeName, NPCName) VALUES ('Cascade Badge', 'Misty');
INSERT INTO GymBadge (BadgeName, NPCName) VALUES ('Thunder Badge', 'Lt. Surge');
INSERT INTO GymBadge (BadgeName, NPCName) VALUES ('Rainbow Badge', 'Erika');
INSERT INTO GymBadge (BadgeName, NPCName) VALUES ('Soul Badge', 'Koga');

-- Gym Leader
INSERT INTO GymLeader (NPCID, BadgeName) VALUES (11, 'Boulder Badge');
INSERT INTO GymLeader (NPCID, BadgeName) VALUES (12, 'Cascade Badge');
INSERT INTO GymLeader (NPCID, BadgeName) VALUES (13, 'Thunder Badge');
INSERT INTO GymLeader (NPCID, BadgeName) VALUES (14, 'Rainbow Badge');
INSERT INTO GymLeader (NPCID, BadgeName) VALUES (15, 'Soul Badge');

-- Champion
INSERT INTO Champion (NPCID, League) VALUES (1, 'Kanto');
INSERT INTO Champion (NPCID, League) VALUES (2, 'Johto');
INSERT INTO Champion (NPCID, League) VALUES (3, 'Hoenn');
INSERT INTO Champion (NPCID, League) VALUES (4, 'Sinnoh');
INSERT INTO Champion (NPCID, League) VALUES (5, 'Unova');

-- Elite 4
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (16, 'Kanto', 1);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (17, 'Kanto', 2);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (18, 'Kanto', 3);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (19, 'Kanto', 4);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (20, 'Hoenn', 1);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (21, 'Hoenn', 2);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (22, 'Hoenn', 3);
INSERT INTO Elite4 (NPCID, League, Standing) VALUES (23, 'Hoenn', 4);

-- Elite 4 Member Info
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Lorelei', 1, 'Kanto', 16);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Bruno', 2, 'Kanto', 17);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Agatha', 3, 'Kanto', 18);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Lance', 4, 'Kanto', 19);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Sidney', 1, 'Hoenn', 20);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Phoebe', 2, 'Hoenn', 21);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Glacia', 3, 'Hoenn', 22);
INSERT INTO Elite4MemberInfo (NPCName, Standing, League, NPCID) VALUES ('Drake', 4, 'Hoenn', 23);

-- Moves
INSERT INTO Moves (MoveID, MoveName) VALUES (1, 'Pound');
INSERT INTO Moves (MoveID, MoveName) VALUES (89, 'Earthquake');
INSERT INTO Moves (MoveID, MoveName) VALUES (40, 'Poison Sting');
INSERT INTO Moves (MoveID, MoveName) VALUES (66, 'Submission');
INSERT INTO Moves (MoveID, MoveName) VALUES (98, 'Quick Attack');
INSERT INTO Moves (MoveID, MoveName) VALUES (53, 'Flamethrower');
INSERT INTO Moves (MoveID, MoveName) VALUES (56, 'Hydro Pump');
INSERT INTO Moves (MoveID, MoveName) VALUES (58, 'Ice Beam');
INSERT INTO Moves (MoveID, MoveName) VALUES (85, 'Thunderbolt');
INSERT INTO Moves (MoveID, MoveName) VALUES (122, 'Lick');
INSERT INTO Moves (MoveID, MoveName) VALUES (14, 'Swords Dance');
INSERT INTO Moves (MoveID, MoveName) VALUES (77, 'Poison Powder');
INSERT INTO Moves (MoveID, MoveName) VALUES (78, 'Stun Spore');
INSERT INTO Moves (MoveID, MoveName) VALUES (86, 'Thunder Wave');
INSERT INTO Moves (MoveID, MoveName) VALUES (100, 'Teleport');

-- MoveInfo
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Pound', 1, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Earthquake', 9, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Poison Sting', 8, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Submission', 7, 80);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Quick Attack', 1, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Flamethrower', 2, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Hydro Pump', 3, 80);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Ice Beam', 6, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Thunderbolt', 4, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Lick', 14, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Swords Dance', 1, 100);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Poison Powder', 8, 75);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Stun Spore', 5, 75);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Thunder Wave', 4, 90);
INSERT INTO MoveInfo (MoveName, TypeID, Accuracy) VALUES ('Teleport', 11, 100);

-- Physical Moves
INSERT INTO PhysicalMoves (MoveID, PhysicalDamage) VALUES (1, 40);
INSERT INTO PhysicalMoves (MoveID, PhysicalDamage) VALUES (89, 100);
INSERT INTO PhysicalMoves (MoveID, PhysicalDamage) VALUES (40, 15);
INSERT INTO PhysicalMoves (MoveID, PhysicalDamage) VALUES (66, 80);
INSERT INTO PhysicalMoves (MoveID, PhysicalDamage) VALUES (98, 40);

-- Special Moves
INSERT INTO SpecialMoves (MoveID, SpecialDamage) VALUES (53, 90);
INSERT INTO SpecialMoves (MoveID, SpecialDamage) VALUES (56, 110);
INSERT INTO SpecialMoves (MoveID, SpecialDamage) VALUES (58, 90);
INSERT INTO SpecialMoves (MoveID, SpecialDamage) VALUES (85, 90);
INSERT INTO SpecialMoves (MoveID, SpecialDamage) VALUES (122, 30);

-- Status Moves
INSERT INTO StatusMoves (MoveID, Effect) VALUES (14, 'Increases the user''s attack two stages.');
INSERT INTO StatusMoves (MoveID, Effect) VALUES (78, 'Paralyzes the target.');
INSERT INTO StatusMoves (MoveID, Effect) VALUES (77, 'Poisons the target.');
INSERT INTO StatusMoves (MoveID, Effect) VALUES (86, 'Paralyzes the target.');
INSERT INTO StatusMoves (MoveID, Effect) VALUES (100, 'In wild battles, the user flees and the battle ends. In Trainer battles, Teleport always fails.');

-- Gym
INSERT INTO Gym (GymID, CityName, NPCID, TypeID) VALUES (1, 'Pewter City', 11, 13);
INSERT INTO Gym (GymID, CityName, NPCID, TypeID) VALUES (2, 'Cerulean City', 12, 3);
INSERT INTO Gym (GymID, CityName, NPCID, TypeID) VALUES (3, 'Vermillion City', 13, 4);
INSERT INTO Gym (GymID, CityName, NPCID, TypeID) VALUES (4, 'Celadon City', 14, 5);
INSERT INTO Gym (GymID, CityName, NPCID, TypeID) VALUES (5, 'Fuschia City', 15, 8);

-- Item
INSERT INTO Item (ItemName, Description, Price) VALUES ('Poke Ball', 'The most basic form of Poke Ball, used to catch wild Pokemon', 200);
INSERT INTO Item (ItemName, Description, Price) VALUES ('Great Ball', 'It is an improved variant of the regular Poke Ball that can be used to catch wild Pokemon.', 600);
INSERT INTO Item (ItemName, Description, Price) VALUES ('Ultra Ball', 'It is an improved variant of the Great Ball that can be used to catch wild Pokemon.', 1200);
INSERT INTO Item (ItemName, Description, Price) VALUES ('Potion', 'It can be used to restore a Pokemon''s HP.', 300);
INSERT INTO Item (ItemName, Description, Price) VALUES ('Revive', 'It revives a fainted Pokemon and restores half of its maximum HP.', 1500);

-- Evolution
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (1, 2);
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (2, 3);
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (4, 5);
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (5, 6);
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (7, 8);
INSERT INTO Evolution (PreEvolutionID, EvolvedID) VALUES (8, 9);

-- NPC Location
INSERT INTO NPCLocation (NPCID, NPCName, LocationID, LocationName) VALUES (1, 'Red', 1, 'Pallet Town');
INSERT INTO NPCLocation (NPCID, NPCName, LocationID, LocationName) VALUES (2, 'Blue', 2, 'Route 1');
INSERT INTO NPCLocation (NPCID, NPCName, LocationID, LocationName) VALUES (3, 'Steven', 3, 'Cerulean Cave');
INSERT INTO NPCLocation (NPCID, NPCName, LocationID, LocationName) VALUES (4, 'Cynthia', 4, 'Indigo Plateau');
INSERT INTO NPCLocation (NPCID, NPCName, LocationID, LocationName) VALUES (5, 'Alder', 5, 'Mt. Moon');

-- NPC Item
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (1, 'Potion', 300, 'It can be used to restore a Pokemon''s HP.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (2, 'Great Ball', 600, 'Improved variant of the regular Poke Ball.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (3, 'Ultra Ball', 1200, 'Improved variant of the Great Ball.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (4, 'Revive', 1500, 'Revives a fainted Pokemon and restores half of its max HP.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (5, 'Poke Ball', 200, 'Basic Poke Ball used to catch wild Pokemon.');

-- NPC Items for Division
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (4, 'Potion', 300, 'It can be used to restore a Pokemon''s HP.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (4, 'Great Ball', 600, 'Improved variant of the regular Poke Ball.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (4, 'Ultra Ball', 1200, 'Improved variant of the Great Ball.');
INSERT INTO NPCItem (NPCID, ItemName, Price, Description) VALUES (4, 'Poke Ball', 200, 'Basic Poke Ball used to catch wild Pokemon.');

-- NPC Pokemon
-- Red with Charizard
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (1, 6);
-- Blue with Pidgeot
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (2, 18);
-- Steven with Metagross
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (3, 376);
-- Cynthia with Garchomp and Lucario, respectively
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (4, 445);
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (4, 448);
-- Alder with Volcarona
INSERT INTO NPCPokemon (NPCID, PokemonID) VALUES (5, 637);

-- NPC Pokemon Info
INSERT INTO NPCPokemonInfo (NPCID, PokemonID, PokemonName) VALUES (6, 5, 'Charmeleon');
INSERT INTO NPCPokemonInfo (NPCID, PokemonID, PokemonName) VALUES (7, 8, 'Wartortle');
INSERT INTO NPCPokemonInfo (NPCID, PokemonID, PokemonName) VALUES (8, 7, 'Squirtle');
INSERT INTO NPCPokemonInfo (NPCID, PokemonID, PokemonName) VALUES (9, 9, 'Blastoise');
INSERT INTO NPCPokemonInfo (NPCID, PokemonID, PokemonName) VALUES (10, 448, 'Lucario');

-- Pokemon Type
-- Bulbasaur, Ivysaur, Venusaur
INSERT INTO PokemonType VALUES (1, 5);
INSERT INTO PokemonType VALUES (1, 8);
INSERT INTO PokemonType VALUES (2, 5);
INSERT INTO PokemonType VALUES (2, 8);
INSERT INTO PokemonType VALUES (3, 5);
INSERT INTO PokemonType VALUES (3, 8);

-- Charmander, Charmeleon, Charizard (+ Flying)
INSERT INTO PokemonType VALUES (4, 2);
INSERT INTO PokemonType VALUES (5, 2);
INSERT INTO PokemonType VALUES (6, 2);
INSERT INTO PokemonType VALUES (6, 10);

-- Squirtle, Wartortle, Blastoise
INSERT INTO PokemonType VALUES (7, 3);
INSERT INTO PokemonType VALUES (8, 3);
INSERT INTO PokemonType VALUES (9, 3);

-- Pidgeot
INSERT INTO PokemonType VALUES (18, 1);
INSERT INTO PokemonType VALUES (18, 10);

-- Mewtwo
INSERT INTO PokemonType VALUES (150, 11);

-- Metagross
INSERT INTO PokemonType VALUES (376, 17);
INSERT INTO PokemonType VALUES (376, 11);

-- Garchomp
INSERT INTO PokemonType VALUES (445, 15);
INSERT INTO PokemonType VALUES (445, 9);

-- Lucario
INSERT INTO PokemonType VALUES (448, 7);
INSERT INTO PokemonType VALUES (448, 17);

-- Arceus
INSERT INTO PokemonType VALUES (493, 1);

-- Volcarona
INSERT INTO PokemonType VALUES (637, 12);
INSERT INTO PokemonType VALUES (637, 2);

COMMIT;