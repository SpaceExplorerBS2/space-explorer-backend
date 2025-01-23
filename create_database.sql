CREATE TABLE planets (
    planet_id VARCHAR(50) PRIMARY KEY, -- Eindeutige Planeten-ID
    name VARCHAR(100) NOT NULL,        -- Name des Planeten
    hazards TEXT[] DEFAULT '{}',       -- Liste der Gefahren auf dem Planeten
    silver INT DEFAULT 0,              -- Menge an Silber auf dem Planeten
    platinum INT DEFAULT 0,            -- Menge an Platin auf dem Planeten
    iron INT DEFAULT 0 NOT NULL,                -- Menge an Eisen auf dem Planeten
    gold INT DEFAULT 0 NOT NULL,                 -- Menge an Gold auf dem Planeten
    x INT DEFAULT 0 NOT NULL,
    y INT DEFAULT 0 NOT NULL,
    rad INT DEFAULT 0 NOT NULL
);


CREATE TABLE players (
    player_id VARCHAR(50) PRIMARY KEY, -- Eindeutige Spieler-ID
    name VARCHAR(100) NOT NULL,       -- Spielername
    fuel INT DEFAULT 100 NOT NULL,             -- Treibstoffbestand
    current_planet_id VARCHAR(50),    -- Aktueller Planet des Spielers (FK)
    FOREIGN KEY (current_planet_id) REFERENCES planets(planet_id)
);

CREATE TABLE inventory (
    inventory_id SERIAL PRIMARY KEY,  -- Eindeutige ID für das Inventar
    player_id VARCHAR(50) NOT NULL,  -- Referenz auf den Spieler (FK)
    resource_type VARCHAR(50) NOT NULL, -- Ressourcentyp (z. B. "iron", "gold")
    amount INT DEFAULT 0,            -- Menge der Ressource
    FOREIGN KEY (player_id) REFERENCES players(player_id)
);

CREATE TABLE planet_resources (
    planet_resource_id SERIAL PRIMARY KEY, -- Eindeutige ID für die Ressource
    planet_id VARCHAR(50) NOT NULL,       -- Referenz auf den Planeten (FK)
    resource_type VARCHAR(50) NOT NULL,   -- Ressourcentyp (z. B. "silver")
    amount INT DEFAULT 0,                 -- Verfügbare Menge auf dem Planeten
    FOREIGN KEY (planet_id) REFERENCES planets(planet_id)
);

CREATE TABLE gather_logs (
    log_id SERIAL PRIMARY KEY,        -- Eindeutige ID für den Log
    player_id VARCHAR(50) NOT NULL,  -- Referenz auf den Spieler (FK)
    planet_id VARCHAR(50) NOT NULL,  -- Referenz auf den Planeten (FK)
    resource_type VARCHAR(50) NOT NULL, -- Ressourcentyp (z. B. "silver")
    amount_collected INT NOT NULL,   -- Gesammelte Menge
    timestamp TIMESTAMP DEFAULT NOW(), -- Zeit des Sammelns
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (planet_id) REFERENCES planets(planet_id)
);

CREATE TABLE travel_logs (
    log_id SERIAL PRIMARY KEY,        -- Eindeutige ID für den Log
    player_id VARCHAR(50) NOT NULL,  -- Referenz auf den Spieler (FK)
    origin_planet_id VARCHAR(50) NOT NULL, -- Startplanet (FK)
    destination_planet_id VARCHAR(50) NOT NULL, -- Zielplanet (FK)
    fuel_used INT NOT NULL,           -- Verwendeter Treibstoff
    timestamp TIMESTAMP DEFAULT NOW(), -- Zeit des Reisens
    FOREIGN KEY (player_id) REFERENCES players(player_id),
    FOREIGN KEY (origin_planet_id) REFERENCES planets(planet_id),
    FOREIGN KEY (destination_planet_id) REFERENCES planets(planet_id)
);



