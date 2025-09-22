CREATE DATABASE youth_app;

USE youth_app;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    age INT,
    region VARCHAR(50),
    disability BOOLEAN,
    chronicDisease BOOLEAN
);
